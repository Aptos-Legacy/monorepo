export const Character_ABI = {
  "address": "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171",
  "name": "Character",
  "friends": [
    "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Account",
    "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::GameManager"
  ],
  "exposed_functions": [
    {
      "name": "create_new_character",
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
      "name": "create_tracker",
      "visibility": "friend",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer"
      ],
      "return": [
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Character::CharacterCreationTrackerV1>"
      ]
    },
    {
      "name": "deconstruct_character",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Character::Character"
      ],
      "return": [
        "0x1::string::String",
        "u64",
        "u8"
      ]
    },
    {
      "name": "get_all_characters",
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
      "name": "get_all_characters_from_object_v1",
      "visibility": "friend",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "address",
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Character::CharacterCreationTrackerV1>"
      ],
      "return": [
        "vector<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Character::Character>"
      ]
    },
    {
      "name": "get_all_characters_names",
      "visibility": "friend",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Character::CharacterCreationTrackerV1>"
      ],
      "return": [
        "vector<0x1::string::String>"
      ]
    },
    {
      "name": "get_all_characters_v1",
      "visibility": "friend",
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
      "name": "get_character",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "address",
        "0x1::string::String"
      ],
      "return": [
        "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Character::Character"
      ]
    }
  ],
  "structs": [
    {
      "name": "Character",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "copy",
        "drop",
        "store",
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "name",
          "type": "0x1::string::String"
        },
        {
          "name": "level",
          "type": "u8"
        },
        {
          "name": "experience",
          "type": "u64"
        }
      ]
    },
    {
      "name": "CharacterCreationEvent",
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
          "name": "user",
          "type": "address"
        }
      ]
    },
    {
      "name": "CharacterCreationTracker",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "characters",
          "type": "0x1::smart_table::SmartTable<address, vector<0x1::string::String>>"
        }
      ]
    },
    {
      "name": "CharacterCreationTrackerV1",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "characters",
          "type": "vector<0x1::string::String>"
        }
      ]
    }
  ]
} as const;