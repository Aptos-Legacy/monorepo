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
    use aptos_framework::object::{object_from_constructor_ref, Object};

    // ================================= STRUCTS ================================== //
    struct Character has key, store, copy, drop {
        name: String,
        level: u8,
        experience: u64,
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


    // ================================= CONSTANTS ================================== //

    const CHARACTERS_SEED: vector<u8> = b"CHARACTER";
    const CHARACTERS_TRACKER_SEED: vector<u8> = b"CHARACTER_TRACKER";


    // ================================= ERRORS ================================== //
    const E_CHARACTER_NAME_ALREADY_TAKEN: u64 = 1;

    // ================================= INIT ================================== //
    fun init_module(admin: &signer) {}

    // ================================= ENTRY ================================== //
    public entry fun create_new_character(user: &signer, name: String) acquires CharacterCreationTracker {
        let user_address = signer::address_of(user);

        let char = Character {
            name,
            level: 1,
            experience: 0,
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
    fun make_character_name_seed(owner: address, name: String): vector<u8> {
        bcs::to_bytes(&string_utils::format3(&b"{}::{}::{}", CHARACTERS_SEED, name, owner))
    }


    public fun deconstruct_character(char: Character): (String, u64, u8) {
        (char.name, char.experience, char.level)
    }

    // ================================= VIEW ================================== //
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