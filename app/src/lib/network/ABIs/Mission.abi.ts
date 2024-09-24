export const Mission_ABI = {
  "address": "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171",
  "name": "Mission",
  "friends": [],
  "exposed_functions": [
    {
      "name": "create_mission",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "u64",
        "vector<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Monster::MonsterV1>>",
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>"
      ],
      "return": []
    },
    {
      "name": "get_all_mission_rewards_for",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "u64"
      ],
      "return": [
        "vector<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>>"
      ]
    },
    {
      "name": "get_mission_rewards_object",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "u64"
      ],
      "return": [
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>"
      ]
    },
    {
      "name": "get_mission_rewards_object_v1",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "u64"
      ],
      "return": [
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>"
      ]
    },
    {
      "name": "get_monsters_rewards_tables",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "u64"
      ],
      "return": [
        "vector<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>>"
      ]
    },
    {
      "name": "set_mission_rewards",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "u64",
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>"
      ],
      "return": []
    }
  ],
  "structs": [
    {
      "name": "MissionCreationEvent",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "drop",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "ids",
          "type": "vector<u64>"
        }
      ]
    },
    {
      "name": "MissionCreationEventV1",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "drop",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "ids",
          "type": "vector<u64>"
        },
        {
          "name": "rewards",
          "type": "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>"
        }
      ]
    },
    {
      "name": "MissionDefinitionV1",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "copy",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "id",
          "type": "u64"
        },
        {
          "name": "monsters",
          "type": "vector<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Monster::MonsterV1>>"
        },
        {
          "name": "rewards",
          "type": "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTableV1>"
        }
      ]
    },
    {
      "name": "MissionsHolderV1",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "missions",
          "type": "0x1::table::Table<u64, 0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Mission::MissionDefinitionV1>"
        }
      ]
    }
  ]
} as const;