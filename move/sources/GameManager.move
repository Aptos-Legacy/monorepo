/// Game Manager is responsible for everything in game and is the preferred entrypoint for everything.
/// A player needs to register an account with the game manager in order to be able to play the game
/// The flow of the game itself is based around "missions" that contain one or more combats.
/// As a player starts a mission, we get his active team, given mission id and we lock a status so we can feed loot and rewards into it.
/// We want to be as little in the way as possible.
module my_addr::GameManager {
    #[test_only]
    friend my_addr::end_to_end;

    use aptos_framework::object;

    use std::string::String;
    use std::signer::address_of;
    use std::vector;
    use aptos_framework::object::create_object_address;
    use my_addr::Account;
    use aptos_framework::event;
    use my_addr::Character::{Character, Self};
    use my_addr::RewardTable;
    use std::signer;
    use my_addr::Gold;
    use my_addr::Equipment;
    use my_addr::Mission;


    const E_INVALID_SUCCESS_CODE_FOR_CLAIMING: u64 = 1;
    const E_ONLY_ADMIN: u64 = 2;
    const E_NOT_ENOUGH_GOLD_TO_LEVEL_UP: u64 = 3;



    const USER_MISSION_STATE_SEED: vector<u8> = b"USER_MISSION_STATE";

    //enum Status  has copy, drop, store, key  { Ongoing, Succes, Failure}
    const ONGOING: u8 = 0;
    const SUCCESS: u8 = 1;
    const FAILURE: u8 = 2;
    const CLAIMED: u8 = 3;

    /// Holds the status of a current mission for a player.
    struct MissionState has key {
        id: u8,
        status: u8,
        rewards: vector<Equipment::ArmorToken>
    }

    struct Config has key {
        admin: address
    }

    // ================================= EVENTS ================================== //
    #[event]
    struct StartNewMissionEvent has store, drop {
        id: u8
    }

    #[event]
    struct EndNewMissionEvent has store, drop {
        id: u8,
        status: u8
        // TODO: get reward info in here
    }


    /// Initialize and store within the admin
    fun init_module(admin: &signer) {
        let admin_address = signer::address_of(admin);

        move_to(admin, Config {
            admin: admin_address
        });
    }

    // ================================= ENTRIES ================================== //

    /// Create a new account for the player. We require the player to NOT already have an account.
    public entry fun create_account(player: &signer, name: String) {
        Account::create_account(player, name);
    }


    public entry fun start_mission(player: &signer, mission_id: u8) acquires MissionState {
        let player_address = address_of(player);
        let missions_address = create_object_address(&player_address, USER_MISSION_STATE_SEED);

        if (!exists<MissionState>(missions_address)) {
            let state = MissionState {
                id: 1,
                status: ONGOING,
                rewards: vector::empty<Equipment::ArmorToken>(),
            };

            let constructor_ref = object::create_named_object(player, USER_MISSION_STATE_SEED);
            let signer_ref = object::generate_signer(&constructor_ref);

            move_to(&signer_ref, state);


            event::emit(StartNewMissionEvent { id: 1 });
        } else {
            let state = borrow_global_mut<MissionState>(missions_address);
            state.id = mission_id;
            event::emit(StartNewMissionEvent { id: state.id });
        }
    }

    public entry fun create_equipment(
        admin: &signer,
        name: String,
        description: String,
        uri: String,
        symbol: String,
        icon_uri: String,
        project_uri: String,
        attack: u64,
        defense: u64,
        health: u64,
    ) acquires Config {
        let caller_address = signer::address_of(admin);
        ensure_is_admin(caller_address);
        let stats = Equipment::create_stats(attack, defense, health);

        Equipment::create_equipment_as_fungible_token(name, description, uri, symbol, icon_uri, project_uri, stats);
    }


    public entry fun end_mission(player: &signer, success: bool) acquires MissionState {
        let player_address = address_of(player);

        let tracker_address = object::create_object_address(&player_address, USER_MISSION_STATE_SEED);
        // We consider that only one mission at a time can be ongoing per player
        let state = borrow_global_mut<MissionState>(tracker_address);

        if (success) {
            state.status = SUCCESS;
        } else {
            state.status = FAILURE;
        };

        event::emit(EndNewMissionEvent {
            id: state.id,
            status: state.status
        });
    }

    const LEVEL_UP_PRICE: u64 = 100;

    public entry fun level_up(player: &signer, character_name: String) {
        let player_address = signer::address_of(player);
        assert!(Gold::balance_of(player_address) >= LEVEL_UP_PRICE, E_NOT_ENOUGH_GOLD_TO_LEVEL_UP);

        Gold::burn(player_address, LEVEL_UP_PRICE);
        Character::level_up(player_address, character_name);
    }


    fun ensure_is_admin(caller: address) acquires Config {
        let config = borrow_global<Config>(@my_addr);
        assert!(config.admin == caller, E_ONLY_ADMIN);
    }


    #[randomness]
    public(friend) entry fun distribute_rewards(
        deployer: &signer,
        player: address
    ) acquires MissionState {
        let missions_address = create_object_address(&player, USER_MISSION_STATE_SEED);
        let state = borrow_global_mut<MissionState>(missions_address);

        // We only want the user to be able to claim if the mission was a success and if he hasn't already claimed
        assert!(state.status == SUCCESS, E_INVALID_SUCCESS_CODE_FOR_CLAIMING);
        state.status = CLAIMED;
        let mission_id = (state.id as u64);

        let gold_rewards = Mission::get_gold_reward_for(mission_id);
        Gold::mint(player, gold_rewards);

        let mission_reward_tables = Mission::get_all_mission_rewards_for(mission_id);

        vector::for_each(mission_reward_tables, |reward_table| {
            let rolled_rewards = RewardTable::roll_for_drops(reward_table); //vector<Object<Token>>
            vector::for_each(rolled_rewards, |reward| {
                Equipment::mint_from_token(reward, player, 1);
            })
        })
    }

    // NOTE: unused
    public entry fun claim_mission_rewards(player: &signer) acquires MissionState {
        let player_address = signer::address_of(player);
        let missions_address = create_object_address(&player_address, USER_MISSION_STATE_SEED);
        let state = borrow_global_mut<MissionState>(missions_address);

        // TODO: need to consume rewards. We need to mint obtained items so they get sent to the player.
        vector::for_each_ref(&state.rewards, |reward| {
            reward;
        });
    }

    // ================================= Utils ================================== //
    public fun is_mission_successful(player: address): bool acquires MissionState {
        let missions_address = create_object_address(&player, USER_MISSION_STATE_SEED);
        let mission = borrow_global<MissionState>(missions_address);

        mission.status == SUCCESS
    }


    // ================================= VIEWS ================================== //
    #[view]
    public fun is_player_mission_successful(player: address): bool acquires MissionState {
        let missions_address = create_object_address(&player, USER_MISSION_STATE_SEED);

        if (object::object_exists<MissionState>(missions_address)) {
            let mission_state = borrow_global<MissionState>(missions_address);
            mission_state.status == SUCCESS
        }else {
            false
        }
    }

    #[view]
    public fun get_current_mission(player: address): u8 acquires MissionState {
        let missions_address = create_object_address(&player, USER_MISSION_STATE_SEED);
        if (object::object_exists<MissionState>(missions_address)) {
            let mission_state = borrow_global<MissionState>(missions_address);
            mission_state.id
        }else {
            0
        }
    }

    #[view]
    public fun get_player_owned_characters(player: address): vector<Character> {
        Character::get_all_characters(player)
    }

    // ================================= TESTS ================================== //
    #[test_only]
    public fun init_module_for_test(sender: &signer) {
        init_module(sender);
    }
}
