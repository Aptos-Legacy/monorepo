module my_addr::Gold {
    friend my_addr::GameManager;
    friend my_addr::Character;

    #[test_only]
    friend my_addr::end_to_end;

    use aptos_framework::fungible_asset::{Self, MintRef, TransferRef, BurnRef, Metadata, FungibleAsset};
    use aptos_framework::object::{Self, Object};
    use aptos_framework::primary_fungible_store;
    use std::error;
    use std::signer;
    use std::string::utf8;
    use std::option;

    const ASSET_SYMBOL: vector<u8> = b"GLD";


    struct Config has key {
        mint_ref: MintRef,
        burn_ref: BurnRef,
        transfer_ref: TransferRef
    }

    // Make sure the `signer` you pass in is an address you own.
    // Otherwise you will lose access to the Fungible Asset after creation.
    entry fun init_module(admin: &signer) {
        // Creates a non-deletable object with a named address based on our ASSET_SYMBOL
        let constructor_ref = &object::create_named_object(admin, ASSET_SYMBOL);

        // Create the FA's Metadata with your name, symbol, icon, etc.
        primary_fungible_store::create_primary_store_enabled_fungible_asset(
            constructor_ref,
            option::none(),
            utf8(b"Gold"),
            utf8(ASSET_SYMBOL),
            0,
            utf8(b"https://aptoslegacyapp.vercel.app/icons/gold.png"),
            utf8(b"https://aptoslegacyapp.vercel.app"),
        );

        // Generate the MintRef for this object
        // Used by fungible_asset::mint() and fungible_asset::mint_to()
        let mint_ref = fungible_asset::generate_mint_ref(constructor_ref);

        // Generate the TransferRef for this object
        // Used by fungible_asset::set_frozen_flag(), fungible_asset::withdraw_with_ref(),
        // fungible_asset::deposit_with_ref(), and fungible_asset::transfer_with_ref().
        let transfer_ref = fungible_asset::generate_transfer_ref(constructor_ref);

        // Generate the BurnRef for this object
        // Used by fungible_asset::burn() and fungible_asset::burn_from()
        let burn_ref = fungible_asset::generate_burn_ref(constructor_ref);


        let config = Config {
            mint_ref,
            transfer_ref,
            burn_ref
        };
        move_to(admin, config);
    }


    public(friend) fun mint(to: address, amount: u64) acquires Config {
        let config = borrow_global<Config>(@my_addr);

        primary_fungible_store::mint(&config.mint_ref, to, amount);
    }

    public(friend) fun burn(owner: address, amount: u64) acquires Config {
        let config = borrow_global<Config>(@my_addr);

        primary_fungible_store::burn(&config.burn_ref, owner, amount);
    }

    #[view]
    public fun balance_of(user: address): u64 {
        let metadata = metadata();
        primary_fungible_store::balance(user, metadata)
    }

    // ================================= VIEWS ================================== //

    #[view]
    public fun metadata_address(): address {
        object::create_object_address(&@my_addr, ASSET_SYMBOL)
    }

    #[view]
    public fun metadata(): Object<Metadata> {
        object::address_to_object(metadata_address())
    }


    // ================================= TEST ================================== //

    #[test(deployer= @my_addr, user1= @0x123)]
    fun create_and_mint_gold(deployer: &signer, user1: &signer) acquires Config {
        let user1_address = signer::address_of(user1);
        init_module_for_test(deployer);

        let metadata = metadata();

        assert!(primary_fungible_store::balance(user1_address, metadata) == 0, 0);
        mint(user1_address, 10);
        assert!(primary_fungible_store::balance(user1_address, metadata) == 10, 0);

        burn(user1_address, 10);
        assert!(primary_fungible_store::balance(user1_address, metadata) == 0, 0);

    }



    #[test_only]
    public fun init_module_for_test(deployer: &signer) {
        init_module(deployer);
    }
}