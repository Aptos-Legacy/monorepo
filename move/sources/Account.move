/// An account holds information about a singular player. It is stored at the owner's address and can't be transfered.
module my_addr::Account {
    use aptos_framework::object;
    use aptos_framework::object::{ObjectCore, Object};
    use aptos_framework::event;
    use std::signer;
    use my_addr::Character::{CharacterCreationTracker, create_tracker};
    use std::string::String;

    const ACCOUNTS_SEED: vector<u8> = b"ACCOUNTS";


    struct PlayerAccount has key, copy {
        name: String,
        progress: u8,
        characters: Object<CharacterCreationTracker>
    }

    #[event]
    struct PlayerAccountCreationEvent has store, drop {
        player: address,
        name: String,
    }


    // ================================= ERRORS ================================== //
    const E_NO_ACCOUNT: u64 = 1;

    // ================================= FUN ================================== //
    public fun create_account(player: &signer, name: String) {
        let constructor_ref = object::create_named_object(player, ACCOUNTS_SEED);
        let signer_ref = object::generate_signer(&constructor_ref);
        let tracker = create_tracker(player);

        move_to(&signer_ref, PlayerAccount {
            characters: tracker,
            name,
            progress: 0,
        });

        event::emit(PlayerAccountCreationEvent {
            player: signer::address_of(player),
            name,
        });
    }

    // ================================= VIEWS ================================== //

    #[view]
    public fun get_player_account_address(player: address): address {
        let object_address = object::create_object_address(&player, ACCOUNTS_SEED);
        object_address
    }


    #[view]
    public fun get_player_account(player: address): PlayerAccount acquires PlayerAccount {
        let account_address = get_player_account_address(player);
        *borrow_global<PlayerAccount>(account_address)
    }


    #[view]
    public fun has_account(player: address): bool {
        //let object_address = object::create_object_address(&player, ACCOUNTS_SEED);

        let object_address = get_player_account_address(player);
        object::object_exists<ObjectCore>(object_address)
    }

    #[view]
    public fun get_owned_characters(player: address): Object<CharacterCreationTracker> acquires PlayerAccount {
        let account_address = get_player_account_address(player);
        let player_account = borrow_global<PlayerAccount>(account_address);
        player_account.characters
    }


    // ================================= TESTS ================================== //
    #[test_only]
    use std::string;


    #[test(player= @0xCAFE)]
    fun can_create_account(player: signer) {
        let account_name = string::utf8(b"test account");
        create_account(&player, account_name);

        assert!(has_account(signer::address_of(&player)), E_NO_ACCOUNT);
    }
}