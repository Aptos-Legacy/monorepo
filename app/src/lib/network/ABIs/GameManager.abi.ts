export const GameManager_ABI = {
  "address": "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171",
  "name": "GameManager",
  "friends": [],
  "exposed_functions": [
    {
      "name": "claim_mission_rewards",
      "visibility": "public",
      "is_entry": true,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer"
      ],
      "return": []
    },
    {
      "name": "create_account",
      "visibility": "public",
      "is_entry": true,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "0x1::string::String"
      ],
      "return": []
    },
    {
      "name": "create_equipment",
      "visibility": "public",
      "is_entry": true,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "0x1::string::String",
        "0x1::string::String",
        "0x1::string::String",
        "0x1::string::String",
        "0x1::string::String",
        "0x1::string::String",
        "u64",
        "u64",
        "u64"
      ],
      "return": []
    },
    {
      "name": "distribute_rewards",
      "visibility": "friend",
      "is_entry": true,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "address"
      ],
      "return": []
    },
    {
      "name": "end_mission",
      "visibility": "public",
      "is_entry": true,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "bool"
      ],
      "return": []
    },
    {
      "name": "get_current_mission",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "address"
      ],
      "return": [
        "u8"
      ]
    },
    {
      "name": "get_player_owned_characters",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "address"
      ],
      "return": [
        "vector<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Character::Character>"
      ]
    },
    {
      "name": "is_mission_successful",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "address"
      ],
      "return": [
        "bool"
      ]
    },
    {
      "name": "is_player_mission_successful",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "address"
      ],
      "return": [
        "bool"
      ]
    },
    {
      "name": "start_mission",
      "visibility": "public",
      "is_entry": true,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "u8"
      ],
      "return": []
    }
  ],
  "structs": [
    {
      "name": "Config",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "admin",
          "type": "address"
        }
      ]
    },
    {
      "name": "EndNewMissionEvent",
      "is_native": false,
      "is_event": true,
      "abilities": [
        "drop",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "id",
          "type": "u8"
        },
        {
          "name": "status",
          "type": "u8"
        }
      ]
    },
    {
      "name": "MissionState",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "id",
          "type": "u8"
        },
        {
          "name": "status",
          "type": "u8"
        },
        {
          "name": "rewards",
          "type": "vector<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::ArmorToken>"
        }
      ]
    },
    {
      "name": "StartNewMissionEvent",
      "is_native": false,
      "is_event": true,
      "abilities": [
        "drop",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "id",
          "type": "u8"
        }
      ]
    }
  ]
} as const;