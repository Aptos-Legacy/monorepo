/// A mission is a succession of battles. We'll be restricting missions to ONE single battle just to limit work as much as we can
module my_addr::Mission {
    use std::option;
    use aptos_std::table;
    use aptos_framework::object;
    use aptos_framework::object::{Object, object_address};
    use my_addr::RewardTable;
    use std::signer;
    use std::vector;
    use my_addr::Monster;
    use my_addr::Monster::Monster;
    use my_addr::RewardTable::RewardTable;

    const MISSION_SEED: vector<u8> = b"missions";


    struct MissionDefinition has store, copy {
        id: u64,
        // TODO: implement mission content
        monsters: vector<Object<Monster>>,
        rewards: Object<RewardTable::RewardTable>,
    }


    struct MissionsHolder has key {
        missions: table::Table<u64, MissionDefinition>,
    }

    struct MissionCreationEvent has store, drop {
        ids: vector<u64>,
        rewards: Object<RewardTable::RewardTable>
    }


    fun init_module(admin: &signer) {
        let mission_table = table::new<u64, MissionDefinition>();

        let missionsHolder = MissionsHolder {
            missions: mission_table
        };
        /*
                let constructor_ref = object::create_named_object(admin, MISSION_SEED);
                let signer_ref = object::generate_signer(&constructor_ref);

                move_to(&signer_ref, missionsHolder);
        */
        move_to(admin, missionsHolder);
    }

    // ================================= UTILS ================================== //


    public fun create_mission(
        id: u64,
        monsters: vector<Object<Monster>>,
        rewards: Object<RewardTable>
    ) acquires MissionsHolder {
        let holder = borrow_global_mut<MissionsHolder>(@my_addr);

        table::add(&mut holder.missions, id, MissionDefinition {
            id,
            monsters,
            rewards
        });
    }

    public fun set_mission_rewards(
        deployer: &signer,
        id: u64,
        rewards: Object<RewardTable>
    ) acquires MissionsHolder {
        // FIXME: we really should have something in place to allow admin to be someone else than the actual deployer
        let holder_address = object::create_object_address(&signer::address_of(deployer), MISSION_SEED);
        let holder = borrow_global_mut<MissionsHolder>(holder_address);

        let mission = table::borrow_mut(&mut holder.missions, id);
        mission.rewards = rewards;
    }

    // ================================= VIEWS ================================== //
    #[view]
    public fun get_mission_rewards_object(
        id: u64,
    ): Object<RewardTable> acquires MissionsHolder {
        let holder = borrow_global<MissionsHolder>(@my_addr);

        let definition = table::borrow(&holder.missions, id);
        definition.rewards
    }


    #[view]
    public fun get_monsters_rewards_tables(
        id: u64,
    ): vector<Object<RewardTable>> acquires MissionsHolder {
        let holder = borrow_global<MissionsHolder>(@my_addr);

        let definition = table::borrow(&holder.missions, id);
        let monster_objects = definition.monsters;


        let loot_tables_objects = vector::map<Object<Monster>, Object<RewardTable>>(monster_objects, |obj| {
            Monster::get_loot_table(obj)
        });


        loot_tables_objects
    }

    #[view]
    public fun get_all_mission_rewards_for(id: u64): vector<Object<RewardTable>> acquires MissionsHolder {
        let mission_rewards = get_mission_rewards_object(id);
        let monsters_rewards = get_monsters_rewards_tables(id);

        vector::push_back(&mut monsters_rewards, mission_rewards);

        monsters_rewards
    }


    // ================================= TESTS ================================== //
    #[test_only]
    friend my_addr::end_to_end;

    #[test_only]
    public fun init_module_for_test(deployer: &signer) {
        init_module(deployer);
    }
}
