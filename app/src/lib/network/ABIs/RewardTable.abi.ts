export const RewardTable_ABI = {
  "address": "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171",
  "name": "RewardTable",
  "friends": [
    "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::GameManager"
  ],
  "exposed_functions": [
    {
      "name": "create_reward_table",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "vector<0x1::string::String>",
        "vector<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::Token>>",
        "vector<u8>"
      ],
      "return": [
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>"
      ]
    },
    {
      "name": "get_reward_table_display",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>"
      ],
      "return": [
        "vector<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::GetDisplayReturn>"
      ]
    },
    {
      "name": "roll_for_drops",
      "visibility": "friend",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>"
      ],
      "return": [
        "vector<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::Token>>"
      ]
    }
  ],
  "structs": [
    {
      "name": "DroppedItemsEvent",
      "is_native": false,
      "is_event": true,
      "abilities": [
        "drop",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "names",
          "type": "vector<0x1::string::String>"
        }
      ]
    },
    {
      "name": "GetDisplayReturn",
      "is_native": false,
      "is_event": false,
      "abilities": [],
      "generic_type_params": [],
      "fields": [
        {
          "name": "name",
          "type": "0x1::string::String"
        },
        {
          "name": "chance",
          "type": "u8"
        },
        {
          "name": "icon",
          "type": "0x1::string::String"
        }
      ]
    },
    {
      "name": "Item",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "copy",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "name",
          "type": "0x1::string::String"
        },
        {
          "name": "chance",
          "type": "u8"
        },
        {
          "name": "token",
          "type": "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::Token>"
        }
      ]
    },
    {
      "name": "RewardTable",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "items",
          "type": "vector<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::Item>"
        }
      ]
    },
    {
      "name": "TableCreationEvent",
      "is_native": false,
      "is_event": true,
      "abilities": [
        "drop",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "table_address",
          "type": "address"
        },
        {
          "name": "items",
          "type": "vector<0x1::string::String>"
        }
      ]
    }
  ]
} as const;