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
    use my_addr::RewardTable::RewardTableV1;

    const MISSION_SEED: vector<u8> = b"missions";


    struct MissionDefinitionV1 has store, copy {
        id: u64,
        // TODO: implement mission content
        monsters: vector<Object<Monster>>,
        rewards: Object<RewardTable::RewardTableV1>,
    }


    struct MissionsHolderV1 has key {
        missions: table::Table<u64, MissionDefinitionV1>,
    }

    struct MissionCreationEvent has store, drop {
        ids: vector<u64>,
    }

    struct MissionCreationEventV1 has store, drop {
        ids: vector<u64>,
        rewards: Object<RewardTable::RewardTableV1>
    }


    fun init_module(admin: &signer) {
        let mission_table = table::new<u64, MissionDefinitionV1>();

        let missionsHolder = MissionsHolderV1 {
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
    #[view]
    public fun get_mission_rewards_object(
        id: u64,
    ): Object<RewardTableV1> acquires MissionsHolderV1 {
        let holder = borrow_global<MissionsHolderV1>(@my_addr);

        let definition = table::borrow(&holder.missions, id);
        definition.rewards
    }

    use std::option::Option;

    #[view]
    public fun get_monsters_rewards_tables(
        id: u64,
    ): vector<Object<RewardTableV1>> acquires MissionsHolderV1 {
        let holder = borrow_global<MissionsHolderV1>(@my_addr);

        let definition = table::borrow(&holder.missions, id);
        let monster_objects = definition.monsters;


        let loot_tables_objects = vector::map<Object<Monster>, Object<RewardTableV1>>(monster_objects, |obj| {
            //let addr = object_address(obj);
            //let monster = borrow_global<MonsterV1>(addr);
            Monster::get_loot_table(obj)
        });


        loot_tables_objects
    }

    #[view]
    public fun get_all_mission_rewards_for(id: u64): vector<Object<RewardTableV1>> acquires MissionsHolderV1 {
        let mission_rewards = get_mission_rewards_object(id);
        let monsters_rewards = get_monsters_rewards_tables(id);

        vector::push_back(&mut monsters_rewards, mission_rewards);

        monsters_rewards
    }


    public fun get_mission_rewards_object_v1(
        id: u64,
    ): Object<RewardTableV1> acquires MissionsHolderV1 {
        // FIXME: this is a NAMED object. We need to know the admin's adress in order to get it. It's NOT stored in the @my_addr address
        let holder = borrow_global<MissionsHolderV1>(@my_addr);

        let definition = table::borrow(&holder.missions, id);
        definition.rewards
    }


    public fun create_mission(
        id: u64,
        monsters: vector<Object<Monster>>,
        rewards: Object<RewardTableV1>
    ) acquires MissionsHolderV1 {
        let holder = borrow_global_mut<MissionsHolderV1>(@my_addr);

        table::add(&mut holder.missions, id, MissionDefinitionV1 {
            id,
            monsters,
            rewards
        });
    }

    public fun set_mission_rewards(
        deployer: &signer,
        id: u64,
        rewards: Object<RewardTableV1>
    ) acquires MissionsHolderV1 {
        // FIXME: we really should have something in place to allow admin to be someone else than the actual deployer
        let holder_address = object::create_object_address(&signer::address_of(deployer), MISSION_SEED);
        let holder = borrow_global_mut<MissionsHolderV1>(holder_address);

        let mission = table::borrow_mut(&mut holder.missions, id);
        mission.rewards = rewards;
    }

    // ================================= VIEWS ================================== //


    // public fun get_defined_missions

    // ================================= TESTS ================================== //
    #[test_only]
    friend my_addr::end_to_end;

    #[test_only]
    public fun init_module_for_test(deployer: &signer) {
        init_module(deployer);
    }
}
