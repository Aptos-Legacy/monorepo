export const Account_ABI = {
  "address": "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171",
  "name": "Account",
  "friends": [],
  "exposed_functions": [
    {
      "name": "create_account",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "0x1::string::String"
      ],
      "return": []
    },
    {
      "name": "get_owned_characters",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "address"
      ],
      "return": [
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Character::CharacterCreationTrackerV1>"
      ]
    },
    {
      "name": "get_player_account",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "address"
      ],
      "return": [
        "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Account::PlayerAccount"
      ]
    },
    {
      "name": "get_player_account_address",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "address"
      ],
      "return": [
        "address"
      ]
    },
    {
      "name": "has_account",
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
    }
  ],
  "structs": [
    {
      "name": "PlayerAccount",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "copy",
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "name",
          "type": "0x1::string::String"
        },
        {
          "name": "progress",
          "type": "u8"
        },
        {
          "name": "characters",
          "type": "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Character::CharacterCreationTrackerV1>"
        }
      ]
    },
    {
      "name": "PlayerAccountCreationEvent",
      "is_native": false,
      "is_event": true,
      "abilities": [
        "drop",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "player",
          "type": "address"
        },
        {
          "name": "name",
          "type": "0x1::string::String"
        }
      ]
    }
  ]
} as const;