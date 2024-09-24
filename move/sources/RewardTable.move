/// Stores and gives out rewards for completing something, be it a quest or fight
module my_addr::RewardTable {
    friend my_addr::GameManager;

    use std::signer;
    use std::string::{ String  };
    use std::vector::{ Self };
    use aptos_framework::event;
    use aptos_framework::object;
    use aptos_framework::object::Object;
    use my_addr::Equipment::{Self, Token};

    struct RewardTable has key {
        items: vector<Item>,
        // TODO: implement gold
    }

    struct RewardTableV1 has key {
        items: vector<ItemV1>,
    }

    struct Item has store {
        name: String,
        chance: u8,
    }


    struct ItemV1 has store, copy {
        name: String,
        chance: u8,
        token: Object<Equipment::Token>,
    }


    #[event]
    struct TableCreationEvent has drop, store {
        monster: String,
        table_address: address,
        items: vector<String>,
    }

    #[event]
    struct TableCreationEventv1 has drop, store {
        table_address: address,
        items: vector<String>,
    }

    #[event]
    struct DroppedItemsEvent has drop, store {
        names: vector<String>,
    }


    const E_CHANCES_REWARDS_LENGTH_NOT_MATCHIN: u64 = 1;

    public fun create_reward_table_v1(
        user: &signer,
        names: vector<String>,
        tokens: vector<Object<Token>>,
        chances: vector<u8>
    ): Object<RewardTableV1> {
        assert!(vector::length(&tokens) == vector::length(&chances), E_CHANCES_REWARDS_LENGTH_NOT_MATCHIN);

        let zipped: vector<ItemV1> = vector::empty();

        for (i in 0.. vector::length(&tokens)) {
            /*
            vector::push_back(&mut zipped,ItemV1{
                //name: *vector::borrow(&names,i),
                name: names[i],

            })*/
            let name = *vector::borrow(&names, i);
            let chance = *vector::borrow(&chances, i);
            let token = *vector::borrow(&tokens, i);

            vector::push_back(&mut zipped, ItemV1 {
                name,
                chance,
                token
            });
        };


        let table = RewardTableV1 { items: zipped };

        // NOTE: we're creating a simple object here. Do we want to give in a seed? I don't think so
        let constructor_ref = object::create_object(signer::address_of(user));
        let object_signer = object::generate_signer(&constructor_ref);
        move_to(&object_signer, table);

        let table_address = object::address_from_constructor_ref(&constructor_ref);

        let table_creation_event = TableCreationEventv1 {
            table_address,
            items: names
        };
        event::emit(table_creation_event);


        object::object_from_constructor_ref<RewardTableV1>(&constructor_ref)
    }


    // ================================= GUARDS ================================== //

    // ================================= UTILS ================================== //


    // NOTE: required workaround as for_each_ref to actually get types working
    inline fun use_item(_value: &Item) {}


    // NOTE: required workaround as for_each_ref to actually get types working
    inline fun use_item_v1(_value: &ItemV1) {}


    public(friend) fun roll_for_drops_v1(
        reward_obj: Object<RewardTableV1>
    ): vector<Object<Equipment::Token>> acquires RewardTableV1 {
        let addr = object::object_address(&reward_obj);
        let droppable_items = &borrow_global<RewardTableV1>(addr).items;

        let dropped_names = vector::empty<String>();
        let dropped_tokens = vector::empty<Object<Equipment::Token>>();

        vector::for_each_ref<ItemV1>(droppable_items, |item| {
            use_item_v1(item);

            let has_dropped = decide_drops_internal(item.chance);
            if (has_dropped) {
                vector::push_back(&mut dropped_names, item.name);
                vector::push_back(&mut dropped_tokens, item.token);
            };
        });


        let drop_event = DroppedItemsEvent { names: dropped_names };
        event::emit(drop_event);


        dropped_tokens
    }


    #[randomness]
    public(friend) entry fun roll_for_drops(reward_obj: Object<RewardTable>) acquires RewardTable {
        let addr = object::object_address(&reward_obj);
        let droppable_items = &borrow_global<RewardTable>(addr).items;
        let actual_drops = vector::empty<String>();

        vector::for_each_ref(droppable_items, |item| {
            use_item(item);

            let has_dropped = decide_drops_internal(item.chance);
            if (has_dropped) {
                vector::push_back(&mut actual_drops, item.name);
            };
        });

        let drop_event = DroppedItemsEvent { names: actual_drops };
        event::emit(drop_event);
    }

    // Instead of using the object address, maybe we could use the object's name? That or maybe we'd want all this data to be stored elsewhere, maybe in a drop manager that can be called after a fight is won
    #[randomness]
    entry fun try_and_drop(addr: address) acquires RewardTable {
        let droppable_items = &borrow_global<RewardTable>(addr).items;
        let actual_drops = vector::empty<String>();

        vector::for_each_ref(droppable_items, |item| {
            use_item(item);

            let has_dropped = decide_drops_internal(item.chance);
            if (has_dropped) {
                vector::push_back(&mut actual_drops, item.name);
            };
        });

        let drop_event = DroppedItemsEvent { names: actual_drops };
        event::emit(drop_event);
    }

    fun decide_drops_internal(chance: u8): bool {
        if (chance == 100) {
            true
        } else {
            let random_value = aptos_framework::randomness::u8_range(0, 100);
            (100 - random_value) >= chance
        }
    }
}
