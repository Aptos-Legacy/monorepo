export const Equipment_ABI = {
  "address": "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171",
  "name": "Equipment",
  "friends": [
    "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::GameManager"
  ],
  "exposed_functions": [
    {
      "name": "armor_balance",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "address",
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::ArmorToken>"
      ],
      "return": [
        "u64"
      ]
    },
    {
      "name": "armor_token_address",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "0x1::string::String"
      ],
      "return": [
        "address"
      ]
    },
    {
      "name": "armor_token_address_v1",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [
        "0x1::string::String"
      ],
      "return": [
        "address"
      ]
    },
    {
      "name": "create_armor_as_fungible_token",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer"
      ],
      "return": []
    },
    {
      "name": "create_armor_as_fungible_token_v1",
      "visibility": "friend",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer"
      ],
      "return": []
    },
    {
      "name": "create_armor_as_fungible_token_v2",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "0x1::string::String",
        "0x1::string::String"
      ],
      "return": []
    },
    {
      "name": "create_armor_collection",
      "visibility": "public",
      "is_entry": true,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "0x1::option::Option<0x4::royalty::Royalty>"
      ],
      "return": []
    },
    {
      "name": "create_equipment_as_fungible_token",
      "visibility": "friend",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "0x1::string::String",
        "0x1::string::String",
        "0x1::string::String",
        "0x1::string::String",
        "0x1::string::String",
        "0x1::string::String",
        "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::Stats"
      ],
      "return": []
    },
    {
      "name": "create_stats",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "u64",
        "u64",
        "u64"
      ],
      "return": [
        "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::Stats"
      ]
    },
    {
      "name": "get_collection_name",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [],
      "return": [
        "vector<u8>"
      ]
    },
    {
      "name": "mint_from_token",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::Token>",
        "address",
        "u64"
      ],
      "return": []
    },
    {
      "name": "token_balance",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [
        {
          "constraints": [
            "key"
          ]
        }
      ],
      "params": [
        "address",
        "0x1::object::Object<T0>"
      ],
      "return": [
        "u64"
      ]
    }
  ],
  "structs": [
    {
      "name": "ArmorStats",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "defense",
          "type": "u64"
        }
      ]
    },
    {
      "name": "ArmorToken",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "store",
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "property_mutator_ref",
          "type": "0x4::property_map::MutatorRef"
        },
        {
          "name": "fungible_asset_mint_ref",
          "type": "0x1::fungible_asset::MintRef"
        },
        {
          "name": "fungible_asset_burn_ref",
          "type": "0x1::fungible_asset::BurnRef"
        }
      ]
    },
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
          "name": "signer_cap",
          "type": "0x1::account::SignerCapability"
        }
      ]
    },
    {
      "name": "Stats",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "attack",
          "type": "u64"
        },
        {
          "name": "defense",
          "type": "u64"
        },
        {
          "name": "health",
          "type": "u64"
        }
      ]
    },
    {
      "name": "Token",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "store",
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "property_mutator_ref",
          "type": "0x4::property_map::MutatorRef"
        },
        {
          "name": "fungible_asset_mint_ref",
          "type": "0x1::fungible_asset::MintRef"
        },
        {
          "name": "fungible_asset_burn_ref",
          "type": "0x1::fungible_asset::BurnRef"
        }
      ]
    },
    {
      "name": "WeaponStats",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "attack",
          "type": "u64"
        }
      ]
    }
  ]
} as const;