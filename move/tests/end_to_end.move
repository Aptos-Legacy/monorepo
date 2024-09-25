#[test_only]
module my_addr::end_to_end {
    use my_addr::GameManager;
    use my_addr::Account;
    use std::string;
    use std::signer;
    use std::vector;
    use my_addr::Character;
    use my_addr::Mission;
    use std::string::String;
    use aptos_framework::object::{Self, address_to_object};
    use aptos_framework::randomness;
    use my_addr::Monster;
    use my_addr::RewardTable;
    use my_addr::Equipment;
    use my_addr::Gold;


    const E_NO_ACCOUNT_FOUND: u64 = 1;
    const E_CHARACTER_COUNT_NOT_MATCHING: u64 = 2;
    const E_CHARACTER_NAME_NOT_MATCHING: u64 = 3;
    const E_MISSION_NOT_MATCHING: u64 = 4;
    const E_MISSION_STATUS_NOT_MATCHING: u64 = 5;


    #[test(deployer= @my_addr, player= @0xCAFEE, framework= @aptos_framework)]
    fun test_happy_path(deployer: &signer, player: &signer, framework: &signer) {
        // ================================= Setup ================================== //
        let account_name = b"hey";
        let character_name = b"Frog";
        let deployer_address = signer::address_of(deployer);
        let player_address = signer::address_of(player);

        let mission_gold_reward = 100;

        GameManager::init_module_for_test(deployer);
        Character::init_module_for_test(deployer);
        Mission::init_module_for_test(deployer);
        Equipment::init_module_for_test(deployer);

        randomness::initialize_for_testing(framework);
        Gold::init_module_for_test(deployer);


        // ================================= Create Missions and rewards ================================== //

        // TODO: name of the armor and it's stats should be fed in! But we know it's Frog Armor
        let armor_name = b"Frog Armor";
        let armor_name_str = string::utf8(armor_name);
        let stats = Equipment::create_stats(0, 10, 0);
        Equipment::create_equipment_as_fungible_token(armor_name_str,
            string::utf8(b"description"),
            string::utf8(b"uri"),
            string::utf8(b"sym"),
            string::utf8(b"icon_uri"),
            string::utf8(b"project_uri"),
            stats
        );

        let address = Equipment::get_token_address(armor_name_str);
        let frog_armor_token = address_to_object<Equipment::Token>(address);

        Monster::create_test_monster_with_equipment(deployer, armor_name_str);

        let item_names = vector::empty<String>();
        vector::push_back(&mut item_names, armor_name_str);

        let chances = vector<u8>[30];
        let tokens = vector[frog_armor_token];


        let test_monster = Monster::get_test_monster(deployer);
        let reward_table = RewardTable::create_reward_table(deployer, item_names, tokens, chances);
        Mission::create_mission(1, vector[test_monster], reward_table, mission_gold_reward);
        Mission::create_mission(2, vector[test_monster], reward_table, mission_gold_reward);

        // ================================= Create account and characters ================================== //
        GameManager::create_account(player, string::utf8(account_name));

        assert!(Account::has_account(player_address), E_NO_ACCOUNT_FOUND);


        // FIXME: Account and characters have nothing in common as Character handles all the character creation and storage logic without at any point referencing the Account resource
        Character::create_new_character(player, string::utf8(character_name));
        let character_container = Account::get_owned_characters(player_address);
        assert!(
            vector::length(&Character::get_all_characters_names(character_container)) == 1,
            E_CHARACTER_COUNT_NOT_MATCHING
        );

        let created_characters = Character::get_all_characters(player_address);
        let names = vector::map(created_characters, |char| {
            let (name, _) = Character::deconstruct_character(char);
            name
        });
        assert!(vector::length(&names) == 1, E_CHARACTER_COUNT_NOT_MATCHING);
        assert!(*vector::borrow(&names, 0) == string::utf8(character_name), E_CHARACTER_COUNT_NOT_MATCHING);


        // ================================= Start Mission ================================== //
        let mission = GameManager::get_current_mission(player_address);


        GameManager::start_mission(player, mission);

        assert!(GameManager::get_current_mission(player_address) == 1, E_MISSION_NOT_MATCHING);

        // ================================= End Mission ================================== //
        GameManager::end_mission(player, true);
        assert!(GameManager::is_mission_successful(player_address), E_MISSION_STATUS_NOT_MATCHING);

        // ================================= Distribute and Claim Rewards ================================== //
        GameManager::distribute_rewards(deployer, player_address);
        assert!(Gold::balance_of(player_address) == mission_gold_reward, 100) ;

        let frog_armor_token = object::address_to_object<Equipment::Token>(
            Equipment::get_token_address(string::utf8(armor_name))
        );
        assert!(Equipment::token_balance(player_address, frog_armor_token) >= 1, 0);

        // ================================= Level up ================================== //
        GameManager::level_up(player, string::utf8(character_name));
        assert!(Character::get_character_level(player_address, string::utf8(character_name)) == 2, 0);
        assert!(Gold::balance_of(player_address) == 0, 0) ;

        // ================================= Start second Mission ================================== //
        let mission = GameManager::get_current_mission(player_address);

        let next_mission = mission + 1;
        GameManager::start_mission(player, next_mission);
        let mission = GameManager::get_current_mission(player_address);


        assert!(mission == 2, E_MISSION_NOT_MATCHING);

        GameManager::end_mission(player, true);
        assert!(GameManager::is_mission_successful(player_address), E_MISSION_STATUS_NOT_MATCHING);
    }
}