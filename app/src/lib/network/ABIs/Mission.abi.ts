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
        "vector<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Monster::Monster>>",
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>",
        "u64"
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
        "vector<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>>"
      ]
    },
    {
      "name": "get_all_mission_rewards_for_display",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "u64"
      ],
      "return": [
        "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Mission::MissionRewardDisplay"
      ]
    },
    {
      "name": "get_gold_reward_for",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "u64"
      ],
      "return": [
        "u64"
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
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>"
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
        "vector<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>>"
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
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>"
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
        },
        {
          "name": "rewards",
          "type": "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>"
        }
      ]
    },
    {
      "name": "MissionDefinition",
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
          "type": "vector<0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Monster::Monster>>"
        },
        {
          "name": "rewards",
          "type": "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::RewardTable>"
        },
        {
          "name": "gold",
          "type": "u64"
        }
      ]
    },
    {
      "name": "MissionRewardDisplay",
      "is_native": false,
      "is_event": false,
      "abilities": [],
      "generic_type_params": [],
      "fields": [
        {
          "name": "monster_rewards",
          "type": "vector<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::GetDisplayReturn>"
        },
        {
          "name": "mission_rewards",
          "type": "vector<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::GetDisplayReturn>"
        },
        {
          "name": "gold",
          "type": "u64"
        }
      ]
    },
    {
      "name": "MissionsHolder",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "missions",
          "type": "0x1::table::Table<u64, 0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Mission::MissionDefinition>"
        }
      ]
    }
  ]
} as const;