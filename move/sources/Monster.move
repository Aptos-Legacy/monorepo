module my_addr::Monster {
    use std::string::String;
    use std::bcs;
    use aptos_std::string_utils;
    use aptos_framework::object;
    use aptos_framework::event;
    use aptos_framework::object::{Object, object_address};
    use my_addr::RewardTable::{RewardTable, RewardTableV1};
    use std::option;


    // ================================= STRUCTS ================================== //
    // TODO: we'd want the monster to have actual stats, potentially a description
    struct Monster has key {
        name: String,
        loot_table: Object<RewardTableV1>
    }

    // ================================= EVENTS ================================== //

    #[event]
    struct NewMonsterCreatedEvent has store, drop {
        name: String,
        loot_table: option::Option<Object<RewardTable>>
    }

    #[event]
    struct NewMonsterCreatedEventV1 has store, drop {
        name: String,
        loot_table: Object<RewardTableV1>
    }

    #[event]
    struct LootTableUpdateEvent has store, drop {
        name: String,
        loot_table: option::Option<Object<RewardTable>>
    }


    #[event]
    struct LootTableUpdateEventV1 has store, drop {
        name: String,
        loot_table: Object<RewardTableV1>
    }

    // ================================= CONSTANTS ================================== //
    const MONSTER_SEED: vector<u8> = b"MONSTER";

    // ================================= ERRORS ================================== //

    // ================================= INITIALIZATION ================================== //


    // ================================= ENTRY ================================== //
    public entry fun create_monster_v1(user: &signer, name: String, loot_table: Object<RewardTableV1>) {
        let constructor_ref = object::create_named_object(user, make_monster_name_seed(name));
        let signer_ref = object::generate_signer(&constructor_ref);

        let monster = Monster {
            name,
            loot_table,
        };

        event::emit(NewMonsterCreatedEventV1 { name, loot_table });
        move_to(&signer_ref, monster);
    }

    public entry fun set_loot_table(
        user: &signer,
        name: String,
        loot_table: Object<RewardTableV1>
    ) acquires Monster {
        let seed = make_monster_name_seed(name);
        let address = object::create_object_address(&@my_addr, seed);

        let monster = borrow_global_mut<Monster>(address);
        monster.loot_table = loot_table;

        event::emit(LootTableUpdateEventV1 {
            name, loot_table
        });
    }


    // ================================= GUARDS ================================== //

    // ================================= UTILS ================================== //
    fun make_monster_name_seed(name: String): vector<u8> {
        bcs::to_bytes(&string_utils::format2(&b"{}::{}", MONSTER_SEED, name))
    }

    #[view]
    public fun get_monster(name: String): Object<Monster> {
        let seed = make_monster_name_seed(name);
        let address = object::create_object_address(&@my_addr, seed);
        object::address_to_object<Monster>(address)
    }

    // ================================= VIEWS ================================== //
    #[view]
    public fun get_loot_table(monster: Object<Monster>): Object<RewardTableV1> acquires Monster {
        let monster = borrow_global<Monster>(object_address(&monster));
        monster.loot_table
    }

    // ================================= TESTS ================================== //


    #[test_only]
    use std::string;
    #[test_only]
    use my_addr::Equipment;
    #[test_only]
    use my_addr::Equipment::Token;
    #[test_only]
    use std::signer;
    #[test_only]
    use my_addr::RewardTable::create_reward_table_v1;


    #[test_only]
    const TEST_MONSTER_NAME: vector<u8> = b"Big Frog";

    #[test(deployer= @my_addr)]
    fun create_monster_with_loot_table(deployer: &signer) acquires Monster {
        let deployer_address = signer::address_of(deployer);
        Equipment::init_module_for_test(deployer);
        let armor_name = Equipment::create_test_token();
        let armor_token = object::address_to_object<Token>(Equipment::armor_token_address_v1(armor_name)) ;

        let item_names = vector<String>[string::utf8((b"Divine Hammer"))];
        let tokens = vector<Object<Token>>[armor_token];
        let chances = vector<u8>[50];
        let loot_table = create_reward_table_v1(deployer, item_names, tokens, chances);

        let monster_name = string::utf8(b"Big Frog");
        create_monster_v1(deployer, monster_name, loot_table);

        let created_monster_address = object::create_object_address(
            &deployer_address,
            make_monster_name_seed(monster_name)
        );
        let monster = borrow_global<Monster>(created_monster_address);

        assert!(monster.name == monster_name, 1);
    }


    #[test_only]
    public fun create_test_monster(deployer: &signer) {
        let armor_name = Equipment::create_test_token();
        let armor_token = object::address_to_object<Token>(Equipment::armor_token_address_v1(armor_name)) ;

        let item_names = vector<String>[string::utf8((b"Divine Hammer"))];
        let tokens = vector<Object<Token>>[armor_token];
        let chances = vector<u8>[50];
        let loot_table = create_reward_table_v1(deployer, item_names, tokens, chances);

        let monster_name = string::utf8(TEST_MONSTER_NAME);
        create_monster_v1(deployer, monster_name, loot_table);
    }

    #[test_only]
    public fun create_test_monster_with_equipment(deployer: &signer, armor_name: String) {
        let armor_token = object::address_to_object<Token>(Equipment::armor_token_address_v1(armor_name)) ;

        let item_names = vector<String>[string::utf8((b"Divine Hammer"))];
        let tokens = vector<Object<Token>>[armor_token];
        let chances = vector<u8>[100];
        let loot_table = create_reward_table_v1(deployer, item_names, tokens, chances);

        let monster_name = string::utf8(TEST_MONSTER_NAME);
        create_monster_v1(deployer, monster_name, loot_table);
    }

    #[test_only]
    public fun get_test_monster(deployer: &signer): Object<Monster> {
        let deployer_address = signer::address_of(deployer);
        let monster_name = string::utf8(TEST_MONSTER_NAME);

        let created_monster_address = object::create_object_address(
            &deployer_address,
            make_monster_name_seed(monster_name)
        );

        object::address_to_object<Monster>(created_monster_address)
    }
}