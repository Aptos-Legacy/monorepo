/// Equipment is a collection including items that can be equipped by players on their character
/// This hackathon version only includes sword, chestpiece and maybe trousers
module my_addr::Equipment {
    #[test_only]
    friend my_addr::end_to_end;

    friend my_addr::GameManager;
    friend my_addr::Store;

    use std::option::{Self, Option};
    use std::signer;
    use std::string::{String, Self};
    use aptos_framework::fungible_asset;
    use aptos_token_objects::collection;
    use aptos_token_objects::royalty::{Royalty, Self};
    use aptos_token_objects::token;
    use aptos_framework::object;
    use aptos_framework::primary_fungible_store;
    use aptos_token_objects::property_map;
    use aptos_framework::object::{Object, ConstructorRef};

    use aptos_framework::fungible_asset::Metadata;
    use aptos_token_objects::token::description;

    use std::error;
    use aptos_framework::account::{create_resource_account, SignerCapability, create_signer_with_capability};


    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct ArmorToken has key, store {
        /// Used to mutate properties
        property_mutator_ref: property_map::MutatorRef,
        /// Used to mint fungible assets.
        fungible_asset_mint_ref: fungible_asset::MintRef,
        /// Used to burn fungible assets.
        fungible_asset_burn_ref: fungible_asset::BurnRef,
    }

    // Can be an armor token or a weapon token
    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct Token has key, store {
        /// Used to mutate properties
        property_mutator_ref: property_map::MutatorRef,
        /// Used to mint fungible assets.
        fungible_asset_mint_ref: fungible_asset::MintRef,
        /// Used to burn fungible assets.
        fungible_asset_burn_ref: fungible_asset::BurnRef,
    }


    struct Stats has key {
        attack: u64,
        defense: u64,
        health: u64
    }


    struct Config has key {
        signer_cap: SignerCapability
    }


    const E_TOKEN_DOES_NOT_EXIST: u64 = 1;
    const E_NOT_CREATOR: u64 = 2;

    const EQUIPMENT_COLLECTION_NAME: vector<u8> = b"Aptos Legacy Equipment";

    const RESOURCE_ACCOUNT_SEED: vector<u8> = b"EQUIPMENT_RESOURCE_ACCOUNT";
    const DEFENSE_VALUE_PROPERTY_NAME: vector<u8> = b"Defense";
    const ATTACK_VALUE_PROPERTY_NAME: vector<u8> = b"Attack";
    const HEALTH_VALUE_PROPERTY_NAME: vector<u8> = b"Health";


    fun init_module(sender: &signer) {
        let (signer, cap) = create_resource_account(sender, RESOURCE_ACCOUNT_SEED);
        let sender_address = signer::address_of(&signer);
        let royalty_config = royalty::create(5, 100, sender_address);

        create_armor_collection(&signer, option::some(royalty_config));

        let config = Config {
            signer_cap: cap
        };

        move_to(sender, config);
    }


    public entry fun create_armor_collection(creator: &signer, royalty: Option<Royalty>) {
        let coll = collection::create_unlimited_collection(
            creator,
            string::utf8(b"Collection containing different types of armors. Each armor type is a separate token"),
            string::utf8(EQUIPMENT_COLLECTION_NAME),
            royalty,
            string::utf8(b"https://myarmor.com")
        );
    }


    fun mint_token_using_sig(armor_name: String, receiver: address) acquires Token, Config {
        let config = borrow_global<Config>(@my_addr);
        let admin_signer = create_signer_with_capability(&config.signer_cap);

        let token = object::address_to_object<Token>(get_token_address(armor_name));

        mint_internal_token(&admin_signer, token, receiver, 1);
    }


    public fun create_stats(attack: u64, defense: u64, health: u64): Stats {
        Stats {
            attack,
            health,
            defense
        }
    }

    public(friend) fun create_equipment_as_fungible_token(
        name: String,
        description: String,
        uri: String,
        symbol: String,
        icon_uri: String,
        project_uri: String,
        stats: Stats
    ) acquires Config {
        let signerCap = get_signer_cap();
        let signer = create_signer_with_capability(signerCap);
        let collection = string::utf8(EQUIPMENT_COLLECTION_NAME);

        let token_constructor_ref = inner_create_fungible_token(&signer,
            collection,
            description,
            name,
            uri,
            symbol,
            icon_uri,
            project_uri
        );


        add_stats_to_token(token_constructor_ref, stats);
    }


    fun inner_create_fungible_token(
        creator: &signer,
        collection: String,
        description: String,
        name: String,
        uri: String,
        token_symbol: String,
        token_icon_uri: String,
        project_uri: String
    ): ConstructorRef {
        let royalty_config = royalty::create(5, 100, signer::address_of(creator));

        let token_constructor_ref = token::create_named_token(
            creator,
            collection,
            description,
            name,
            option::some(royalty_config),
            uri,
        );

        let object_signer = object::generate_signer(&token_constructor_ref);
        let property_mutator_ref = property_map::generate_mutator_ref(&token_constructor_ref);


        primary_fungible_store::create_primary_store_enabled_fungible_asset(
            &token_constructor_ref,
            option::none(),
            name,
            token_symbol,
            0,
            token_icon_uri,
            project_uri,
        );

        let fungible_asset_mint_ref = fungible_asset::generate_mint_ref(&token_constructor_ref);
        let fungible_asset_burn_ref = fungible_asset::generate_burn_ref(&token_constructor_ref);

        let token = Token {
            property_mutator_ref,
            fungible_asset_mint_ref,
            fungible_asset_burn_ref,
        };

        move_to(&object_signer, token);
        token_constructor_ref
    }

    fun add_stats_to_token(
        token_constructor_ref: ConstructorRef,
        stats: Stats
    ) {
        let object_signer = object::generate_signer(&token_constructor_ref);
        let property_mutator_ref = property_map::generate_mutator_ref(&token_constructor_ref);

        let properties = property_map::prepare_input(vector[], vector[], vector[]);
        property_map::init(&token_constructor_ref, properties);

        property_map::add_typed(
            &property_mutator_ref,
            string::utf8(DEFENSE_VALUE_PROPERTY_NAME),
            stats.defense
        );
        property_map::add_typed(
            &property_mutator_ref,
            string::utf8(ATTACK_VALUE_PROPERTY_NAME),
            stats.attack
        );
        property_map::add_typed(
            &property_mutator_ref,
            string::utf8(HEALTH_VALUE_PROPERTY_NAME),
            stats.health
        );

        move_to(&object_signer, stats);
    }


    // ================================= UTILS ================================== //
    inline fun get_signer_cap(): &SignerCapability acquires Config {
        let config = borrow_global<Config>(@my_addr);
        &config.signer_cap
    }


    fun mint_internal_token(creator: &signer, token: Object<Token>, receiver: address, amount: u64) acquires Token {
        let token = authorized_borrow_token<Token>(creator, &token);
        let fungible_asset_mint_ref = &token.fungible_asset_mint_ref;
        let fa = fungible_asset::mint(fungible_asset_mint_ref, amount);
        primary_fungible_store::deposit(receiver, fa);
    }


    public(friend) fun mint_from_token(
        token: Object<Token>,
        receiver: address,
        amount: u64
    ) acquires Token, Config {
        let config = borrow_global<Config>(@my_addr);
        let signer = create_signer_with_capability(&config.signer_cap);
        let armor_token = authorized_borrow_token<Token>(&signer, &token);

        let fungible_asset_mint_ref = &armor_token.fungible_asset_mint_ref;
        let fa = fungible_asset::mint(fungible_asset_mint_ref, amount);
        primary_fungible_store::deposit(receiver, fa);
    }


    inline fun authorized_borrow_token<T: key>(creator: &signer, token: &Object<T>): &T {
        let token_address = object::object_address(token);
        assert!(
            exists<T>(token_address),
            error::not_found(E_TOKEN_DOES_NOT_EXIST),
        );

        assert!(
            token::creator(*token) == signer::address_of(creator),
            error::permission_denied(E_NOT_CREATOR),
        );
        borrow_global<T>(token_address)
    }


    // ================================= VIEWS ================================== //
    #[view]
    public fun get_token_address(token_name: String): address acquires Config {
        let config = borrow_global<Config>(@my_addr);
        let addr = signer::address_of(&create_signer_with_capability(&config.signer_cap));
        let token_addr = token::create_token_address(&addr, &string::utf8(EQUIPMENT_COLLECTION_NAME), &token_name);
        token_addr
    }


    #[view]
    public fun get_stats(container: Object<Token>): Stats {
        Stats {
            attack: property_map::read_u64(&container, &string::utf8(ATTACK_VALUE_PROPERTY_NAME)),
            defense: property_map::read_u64(&container, &string::utf8(DEFENSE_VALUE_PROPERTY_NAME)),
            health: property_map::read_u64(&container, &string::utf8(HEALTH_VALUE_PROPERTY_NAME))
        }
    }

    #[view]
    public fun armor_balance(owner_addr: address, armor: Object<ArmorToken>): u64 {
        let metadata = object::convert<ArmorToken, Metadata>(armor);
        let store = primary_fungible_store::ensure_primary_store_exists(owner_addr, metadata);
        fungible_asset::balance(store)
    }

    #[view]
    public fun token_balance<T: key>(owner_addr: address, armor: Object<T>): u64 {
        let metadata = object::convert<T, Metadata>(armor);
        let store = primary_fungible_store::ensure_primary_store_exists(owner_addr, metadata);
        fungible_asset::balance(store)
    }

    #[view]
    public fun get_collection_name(): vector<u8> {
        EQUIPMENT_COLLECTION_NAME
    }

    #[view]
    public fun get_icon_for_token(container: Object<Token>): String {
        //let metadata = fungible_asset::metadata(container);
        fungible_asset::icon_uri(container)
    }

    // ================================= TEST ================================== //
    #[test(deployer= @my_addr, user1= @0x123)]
    fun create_and_mint_armor(deployer: &signer, user1: &signer) acquires Token, Stats, Config {
        // This test assumes that the creator's address is equal to @my_addr.
        assert!(signer::address_of(deployer) == @my_addr, 0);

        // ---------- SETUP ----------

        // This creates both Weapon and Armor collections
        init_module(deployer);

        // Now we create a new armor type named Frog Armor
        let collection = string::utf8(EQUIPMENT_COLLECTION_NAME);
        let armor_name = string::utf8(b"Frog Armor");

        let armor_description = string::utf8(b"description");
        let armor_uri = string::utf8(b"armor uri");
        let token_symbol = string::utf8(b"Frog_Armor");
        let token_icon_uri = string::utf8(b"Frog Armor icon uri");
        let project_uri = string::utf8(b"Project uri");

        // TODO: shouldn't be calling inner like this
        let signerCap = get_signer_cap();
        let signer = create_signer_with_capability(signerCap);
        let token_constructor_ref = inner_create_fungible_token(
            &signer,
            collection,
            armor_description,
            armor_name,
            armor_uri,
            token_symbol,
            token_icon_uri,
            project_uri
        );

        let stats = Stats {
            defense: 10,
            health: 0,
            attack: 0,
        };
        //add_stats_to_armor_token(token_constructor_ref, stats);
        add_stats_to_token(token_constructor_ref, stats);

        // Then we mint for another user
        let user1_addr = signer::address_of(user1);
        mint_token_using_sig(armor_name, user1_addr);

        //let frog_armor_token = object::address_to_object<ArmorToken>(armor_token_address_v1(armor_name));
        let frog_armor_token = object::address_to_object<Token>(get_token_address(armor_name));
        assert!(token_balance(user1_addr, frog_armor_token) == 1, 0);

        // assert!(armor_balance(user1_addr, frog_armor_token) == 1, 0);

        let borrowed = borrow_global<Stats>(object::object_address(&frog_armor_token));
        assert!(borrowed.defense == 10, 0);
    }

    #[test_only]
    public fun create_test_token(): String acquires Config {
        let collection = string::utf8(EQUIPMENT_COLLECTION_NAME);
        let armor_name = string::utf8(b"Frog Armor");
        let armor_description = string::utf8(b"description");
        let armor_uri = string::utf8(b"armor uri");
        let token_symbol = string::utf8(b"Frog_Armor");
        let token_icon_uri = string::utf8(b"Frog Armor icon uri");
        let project_uri = string::utf8(b"Project uri");

        // TODO: shouldn't be calling inner like this
        let signerCap = get_signer_cap();
        let signer = create_signer_with_capability(signerCap);
        let token_constructor_ref = inner_create_fungible_token(
            &signer,
            collection,
            armor_description,
            armor_name,
            armor_uri,
            token_symbol,
            token_icon_uri,
            project_uri
        );


        let stats = Stats {
            defense: 10,
            attack: 0,
            health: 0
        };
        add_stats_to_token(token_constructor_ref, stats);

        armor_name
    }

    #[test_only]
    public fun init_module_for_test(deployer: &signer) {
        init_module(deployer);
    }
}