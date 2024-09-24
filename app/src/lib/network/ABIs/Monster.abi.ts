export const Monster_ABI = {
  "address": "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171",
  "name": "Monster",
  "friends": [],
  "exposed_functions": [
    {
      "name": "create_monster_v1",
      "visibility": "public",
      "is_entry": true,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "0x1::string::String",
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>"
      ],
      "return": []
    },
    {
      "name": "get_loot_table",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Monster::MonsterV1>"
      ],
      "return": [
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>"
      ]
    },
    {
      "name": "get_monster",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "0x1::string::String"
      ],
      "return": [
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Monster::MonsterV1>"
      ]
    },
    {
      "name": "set_loot_table",
      "visibility": "public",
      "is_entry": true,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "0x1::string::String",
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>"
      ],
      "return": []
    }
  ],
  "structs": [
    {
      "name": "LootTableUpdateEvent",
      "is_native": false,
      "is_event": true,
      "abilities": [
        "drop",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "name",
          "type": "0x1::string::String"
        },
        {
          "name": "loot_table",
          "type": "0x1::option::Option<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>>"
        }
      ]
    },
    {
      "name": "LootTableUpdateEventV1",
      "is_native": false,
      "is_event": true,
      "abilities": [
        "drop",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "name",
          "type": "0x1::string::String"
        },
        {
          "name": "loot_table",
          "type": "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>"
        }
      ]
    },
    {
      "name": "Monster",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "name",
          "type": "0x1::string::String"
        }
      ]
    },
    {
      "name": "MonsterV0",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "name",
          "type": "0x1::string::String"
        },
        {
          "name": "loot_table",
          "type": "0x1::option::Option<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>>"
        }
      ]
    },
    {
      "name": "MonsterV1",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "name",
          "type": "0x1::string::String"
        },
        {
          "name": "loot_table",
          "type": "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>"
        }
      ]
    },
    {
      "name": "NewMonsterCreatedEvent",
      "is_native": false,
      "is_event": true,
      "abilities": [
        "drop",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "name",
          "type": "0x1::string::String"
        },
        {
          "name": "loot_table",
          "type": "0x1::option::Option<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>>"
        }
      ]
    },
    {
      "name": "NewMonsterCreatedEventV1",
      "is_native": false,
      "is_event": true,
      "abilities": [
        "drop",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "name",
          "type": "0x1::string::String"
        },
        {
          "name": "loot_table",
          "type": "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>"
        }
      ]
    }
  ]
} as const;