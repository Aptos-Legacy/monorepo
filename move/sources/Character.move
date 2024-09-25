module my_addr::Character {
    friend my_addr::GameManager;
    friend my_addr::Account;

    use std::string::String;
    use aptos_framework::object;
    use aptos_framework::event;
    use std::signer;
    use std::bcs;
    use aptos_std::smart_table::{Self, SmartTable};
    use aptos_std::string_utils;
    use std::vector;
    use aptos_framework::object::{object_from_constructor_ref, Object, create_object_address};
    use my_addr::Gold;

    // ================================= STRUCTS ================================== //
    struct Character has key, store, copy, drop {
        name: String,
        level: u8
    }

    struct CharacterCreationTracker has key {
        characters: vector<String>
    }

    // ================================= EVENTS ================================== //
    #[event]
    struct CharacterCreationEvent has drop, store {
        name: String,
        user: address,
    }


    struct Stats has key, copy, drop {
        attack: u64,
        defense: u64,
        health: u64
    }

    // ================================= CONSTANTS ================================== //
    const CHARACTERS_SEED: vector<u8> = b"CHARACTER";
    const CHARACTERS_TRACKER_SEED: vector<u8> = b"CHARACTER_TRACKER";
    const STATS_SEED: vector<u8> = b"LEVEL_STATS";

    const MAX_LEVEL: u8 = 5;


    // ================================= ERRORS ================================== //
    const E_CHARACTER_NAME_ALREADY_TAKEN: u64 = 1;
    const E_CHARACTER_ALREADY_MAX_LEVEL: u64 = 2;
    const E_CHARACTER_DOESNT_EXIST: u64 = 3;

    // ================================= INIT ================================== //
    fun init_module(admin: &signer) {
        // NOTE: we only want 5 levels for this demo
        let level_stats = vector<Stats>[
            Stats {
                health: 150,
                attack: 40,
                defense: 40
            },
            Stats {
                health: 220,
                attack: 50,
                defense: 48
            },
            Stats {
                health: 240,
                attack: 70,
                defense: 60
            },
            Stats {
                health: 310,
                attack: 78,
                defense: 70
            },
            Stats {
                health: 350,
                attack: 120,
                defense: 100
            }, ];


        for (i in 1..5) {
            let level_seed = make_level_stats_seed(i);

            let constructor_ref = object::create_named_object(admin, level_seed);
            let obj_signer = object::generate_signer(&constructor_ref);

            move_to(&obj_signer, *vector::borrow(&level_stats, i - 1));
        }
    }

    // ================================= ENTRY ================================== //
    public entry fun create_new_character(user: &signer, name: String) acquires CharacterCreationTracker {
        let user_address = signer::address_of(user);

        let char = Character {
            name,
            level: 1
        };

        let constructor_ref = object::create_named_object(user, make_character_name_seed(user_address, name));
        let obj_signer = object::generate_signer(&constructor_ref);
        move_to(&obj_signer, char);


        let tracker_address = object::create_object_address(&user_address, CHARACTERS_TRACKER_SEED);
        if (!object::object_exists<CharacterCreationTracker>(tracker_address)) {
            create_tracker(user);
        };

        ensure_character_name_is_unique(user_address, name);
        let character_tracker = borrow_global_mut<CharacterCreationTracker>(tracker_address);
        vector::push_back(&mut character_tracker.characters, name);

        /*
        if (object::object_exists<CharacterCreationTrackerV1>(tracker_address)) {
            ensure_character_name_is_unique_v1(user_address, name);
            let character_tracker = borrow_global_mut<CharacterCreationTrackerV1>(tracker_address);
            vector::push_back(&mut character_tracker.characters, name);
        } else {
            let characters = vector::empty<String>();
            vector::push_back(&mut characters, name);
            let tracker = CharacterCreationTrackerV1 {
                characters
            };

            let constructor = object::create_named_object(user, CHARACTERS_TRACKER_SEED);
            let signer = object::generate_signer(&constructor);
            move_to(&signer, tracker);
        };*/


        event::emit(
            CharacterCreationEvent {
                name,
                user: user_address
            }
        );
    }

    #[event]
    struct CharacterLevelUpEvent has store, drop {
        player: address,
        character: String,
        level: u8
    }

    public(friend) fun level_up(player: address, character_name: String) acquires Character {
        // Level up costs 100 gold


        let character_addr = get_character_address(player, character_name);
        assert!(exists<Character>(character_addr), E_CHARACTER_DOESNT_EXIST);

        let character = borrow_global_mut<Character>(character_addr);
        // Max level is 5
        assert!(character.level < MAX_LEVEL, E_CHARACTER_ALREADY_MAX_LEVEL);

        // TODO: actually level up
        character.level = character.level + 1;

        // TODO: emit level up event
        event::emit(
            CharacterLevelUpEvent {
                level: character.level,
                character: character_name,
                player
            }
        )
    }

    public(friend) fun create_tracker(user: &signer): Object<CharacterCreationTracker> {
        let tracker = CharacterCreationTracker {
            characters: vector::empty<String>()
        };

        let constructor = object::create_named_object(user, CHARACTERS_TRACKER_SEED);
        let signer = object::generate_signer(&constructor);

        move_to(&signer, tracker);
        object_from_constructor_ref<CharacterCreationTracker>(&constructor)
    }

    // ================================= GUARDS ================================== //
    fun ensure_character_name_is_unique(owner: address, name: String) acquires CharacterCreationTracker {
        let character_tracker_address = object::create_object_address(&owner, CHARACTERS_TRACKER_SEED);
        let tracker = borrow_global<CharacterCreationTracker>(character_tracker_address);
        assert!(!vector::contains(&tracker.characters, &name), E_CHARACTER_NAME_ALREADY_TAKEN);
    }

    // ================================= UTILS ================================== //
    #[view]
    fun make_character_name_seed(owner: address, name: String): vector<u8> {
        bcs::to_bytes(&string_utils::format3(&b"{}::{}::{}", CHARACTERS_SEED, name, owner))
    }


    public fun deconstruct_character(char: Character): (String, u8) {
        (char.name, char.level)
    }

    #[view]
    fun make_level_stats_seed(level: u64): vector<u8> {
        bcs::to_bytes(&string_utils::format2(&b"{}::{}", STATS_SEED, level))
    }

    #[view]
    fun get_stats_object_for_level(level: u64): Object<Stats> {
        let seed = make_level_stats_seed(level);
        let addr = create_object_address(&@my_addr, seed);

        object::address_to_object<Stats>(addr)
    }

    // ================================= VIEW ================================== //

    #[view]
    fun get_character_address(creator: address, name: String): address {
        object::create_object_address(&creator, make_character_name_seed(copy creator, name))
    }

    #[view]
    public fun get_character_level(creator: address, name: String): u8 acquires Character{
        let address = get_character_address(creator, name);
        borrow_global<Character>(address).level
    }

    #[view]
    public fun get_character(creator: address, name: String): Character acquires Character {
        let object_address = object::create_object_address(&creator, make_character_name_seed(copy creator, name));
        *borrow_global<Character>(object_address)
    }


    #[view]
    public(friend) fun get_all_characters(
        creator: address
    ): vector<Character> acquires Character, CharacterCreationTracker {
        let tracker_address = object::create_object_address(&creator, CHARACTERS_TRACKER_SEED);

        let tracker = borrow_global<CharacterCreationTracker>(tracker_address);

        vector::map_ref(&tracker.characters, |char_name| {
            get_character(creator, *char_name)
        })
    }

    #[view]
    public(friend) fun get_all_characters_from_object(
        creator: address,
        tracker_obj: Object<CharacterCreationTracker>
    ): vector<Character> acquires Character, CharacterCreationTracker {
        //let tracker_address = object::create_object_address(&creator, CHARACTERS_TRACKER_SEED);
        let tracker_address = object::object_address(&tracker_obj);
        let tracker = borrow_global<CharacterCreationTracker>(tracker_address);

        vector::map_ref(&tracker.characters, |char_name| {
            get_character(creator, *char_name)
        })
    }

    #[view]
    public(friend) fun get_all_characters_names(
        container: Object<CharacterCreationTracker>
    ): vector<String> acquires CharacterCreationTracker {
        let tracker_address = object::object_address(&container);
        let tracker = borrow_global<CharacterCreationTracker>(tracker_address);
        tracker.characters
    }


    // ================================= TESTS ================================== //
    #[test_only]
    friend my_addr::end_to_end;

    #[test_only]
    public fun init_module_for_test(deployer: &signer) {
        init_module(deployer);
    }
}