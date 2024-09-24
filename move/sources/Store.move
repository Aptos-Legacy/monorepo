module my_addr::Store {
    use std::signer;
    use aptos_framework::object::{ExtendRef, Self, create_object_address, Object};
    use my_addr::Equipment::Token;
    use std::string;
    use std::string::String;
    use std::vector;
    use aptos_std::smart_table;
    use aptos_std::smart_table::SmartTable;
    use aptos_framework::event;
    use aptos_framework::fungible_asset;
    use aptos_framework::aptos_coin;
    use aptos_framework::coin;
    use my_addr::Equipment;


    /// Stores track offers, and serves as an entrypoint to buy items
    struct Offers has key {
        offers: SmartTable<u64, Offer>,
        counter: u64
    }

    struct Offer has store, copy, drop {
        name: String,
        token: Object<Token>,
        price: u64
    }

    /// Vault stores both the APT sent by buyers as well as the signing capabilities for items to buy
    struct Vault has key {
        extend_ref: ExtendRef,
        admin: address,
    }


    struct GetOfferReturn {
        name: String,
        price: u64,
        id: u64,
        icon_uri: String
    }


    #[event]
    struct NewOfferEvent has store, drop {
        name: String,
        token: Object<Token>,
        price: u64,
        id: u64
    }

    #[event]
    struct UserBuysOfferEvent has store, drop {
        buyer: address,
        offer_id: u64,
        price: u64
    }

    // ================================= SEEDS ================================== //
    const VAULT_SEED: vector<u8> = b"VAULT";
    const OFFERS_SEED: vector<u8> = b"OFFERS";

    // ================================= ERRORS ================================== //
    const E_NOT_ENOUGH_FUNDS: u64 = 0;


    // ================================= INIT ================================== //
    fun init_module(sender: &signer) {
        let sender_address = signer::address_of(sender);

        // TODO: maybe I could just replace this with a regular payment address
        let vault_constructor_ref = &object::create_named_object(sender, VAULT_SEED);
        let vault_signer = &object::generate_signer(vault_constructor_ref);

        move_to(vault_signer, Vault {
            extend_ref: object::generate_extend_ref(vault_constructor_ref),
            admin: sender_address,
        });

        let offers_constructor_ref = &object::create_named_object(sender, OFFERS_SEED);
        let offers_signer = &object::generate_signer(offers_constructor_ref);


        let offers_table = smart_table::new<u64, Offer>();

        move_to(offers_signer, Offers {
            offers: offers_table,
            counter: 0
        });
    }


    // ================================= ENTRIES ================================== //
    public entry fun buy_offer(user: &signer, id: u64) acquires Offers {
        let user_address = signer::address_of(user);

        // TODO: get offer, ensure it exists
        let offers_address = create_object_address(&@my_addr, OFFERS_SEED);
        let offers = borrow_global_mut<Offers>(offers_address);
        let offer = smart_table::borrow(&offers.offers, id);
        let price = offer.price;

        // TODO: ensure user has enough money
        let user_addr = signer::address_of(user);
        let user_balance = coin::balance<aptos_coin::AptosCoin>(user_addr);
        assert!(user_balance >= price, E_NOT_ENOUGH_FUNDS);

        coin::transfer<aptos_framework::aptos_coin::AptosCoin>(user, @my_addr, price);

        Equipment::mint_from_token(offer.token, user_address, 1);

        event::emit(UserBuysOfferEvent {
            price,
            buyer: user_address,
            offer_id: id
        });
    }

    fun add_offer(offer: Offer) acquires Offers {
        let offers_address = create_object_address(&@my_addr, OFFERS_SEED);
        let offers = borrow_global_mut<Offers>(offers_address);

        smart_table::add<u64, Offer>(&mut offers.offers, offers.counter, copy offer);


        event::emit(NewOfferEvent {
            token: offer.token,
            price: offer.price,
            name: offer.name,
            id: offers.counter
        });

        offers.counter = offers.counter + 1;
    }

    public fun create_and_store_offer(name: String, price: u64, item: Object<Token>) acquires Offers {
        let offer = Offer {
            name,
            price,
            token: item
        };


        add_offer(offer);
    }

    // ================================= UTILS ================================== //
    const OCTAS_PER_APT: u64 = 100_000_000;

    public fun octas_to_apt(amount: u64): u64 {
        amount / OCTAS_PER_APT
    }

    public fun apt_to_octas(amount: u64): u64 {
        amount * OCTAS_PER_APT
    }


    // ================================= VIEWS ================================== //

    #[view]
    public fun get_all_offers_v1(): vector<GetOfferReturn> acquires Offers {
        let offers_address = create_object_address(&@my_addr, OFFERS_SEED);
        let offers_container = borrow_global<Offers>(offers_address);
        let acc = vector<GetOfferReturn>[];

        for (i in 0..offers_container.counter) {
            if (smart_table::contains(&offers_container.offers, i)) {
                let offer = smart_table::borrow(&offers_container.offers, i);

                let icon_uri = fungible_asset::icon_uri(offer.token);

                vector::push_back(&mut acc,
                    GetOfferReturn {
                        name: offer.name,
                        price: offer.price,
                        id: i,
                        icon_uri
                    }
                );
            };
        };

        acc
    }

    // ================================= TESTS ================================== //

    #[test_only]
    public fun init_module_for_test(deployer: &signer) {
        init_module(deployer);
    }

    #[test_only]
    use std::object::address_to_object;

    #[test_only]
    public fun create_test_offer(sender: &signer): Offer {
        Equipment::init_module_for_test(sender);
        Equipment::create_test_token();
        let armor_name = b"Frog Armor";
        let address = Equipment::get_token_address(string::utf8(armor_name));

        let frog_armor_token = address_to_object<Equipment::Token>(address);


        let offer = Offer {
            name: string::utf8(b"Frog Armor"),
            price: 1,
            token: frog_armor_token
        };
        offer
    }


    #[test_only]
    const E_OFFER_DOES_NOT_EXIST: u64 = 2;

    #[test(deployer= @my_addr)]
    public fun test_create_and_store_offer(deployer: &signer) acquires Offers {
        init_module_for_test(deployer);
        let offer = create_test_offer(deployer);
        add_offer(offer);

        let offers_address = create_object_address(&@my_addr, OFFERS_SEED);
        let offers = borrow_global<Offers>(offers_address);
        assert!(smart_table::contains(&offers.offers, 0), E_OFFER_DOES_NOT_EXIST);
    }
}