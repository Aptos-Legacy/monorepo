script {
    use my_addr::Monster;
    use std::string;
    use aptos_framework::object::address_to_object;
    use my_addr::Mission;
    use my_addr::GameManager;
    use my_addr::RewardTable;
    use my_addr::Equipment;
    use my_addr::Store;

    const OCTAS_PER_APT: u64 = 100_000_000;


    fun main(src: &signer) {
        let equipment_name = string::utf8(b"Frog Armor");

        // Create and seed Items
        GameManager::create_equipment(src,
            equipment_name,
            string::utf8(b"An armor fit for a metal frog"),
            string::utf8(b"description"),
            string::utf8(b"FA"),
            string::utf8(b"description"),
            string::utf8(b"https://aptoslegacyapp.vercel.app/"),
            0,
            10,
            0
        );

        let ref = Equipment::get_token_address(equipment_name);
        let obj = address_to_object<Equipment::Token>(ref);

        // Create and seed Reward Tables
        let mission_reward_table = RewardTable::create_reward_table(
            src,
            vector[equipment_name],
            vector[obj],
            vector<u8>[100],
        );

        let monster_reward_table = RewardTable::create_reward_table(
            src,
            vector[equipment_name],
            vector[obj],
            vector<u8>[20],
        );

        // Create and seed monsters
        let monster_name = string::utf8(b"Terrible Frog");
        Monster::create_monster(src, monster_name, mission_reward_table);

        let monster_object = Monster::get_monster(monster_name);

        // Create and seed missions
        Mission::create_mission(1,
            vector[monster_object],
            mission_reward_table,
            100
        );


        // Create and seed store
        let offer_name = string::utf8(b"Frog Armor");
        let offer_price = (1 * OCTAS_PER_APT / 100 as u64); // 0.01 APT
        // TODO: handle prices in APT
        Store::create_and_store_offer(
            offer_name,
            offer_price,
            obj
        );
    }
}