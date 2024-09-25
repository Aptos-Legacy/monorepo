export const Store_ABI = {
  "address": "0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171",
  "name": "Store",
  "friends": [],
  "exposed_functions": [
    {
      "name": "apt_to_octas",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "u64"
      ],
      "return": [
        "u64"
      ]
    },
    {
      "name": "buy_offer",
      "visibility": "public",
      "is_entry": true,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "&signer",
        "u64"
      ],
      "return": []
    },
    {
      "name": "create_and_store_offer",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "0x1::string::String",
        "u64",
        "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::Token>"
      ],
      "return": []
    },
    {
      "name": "get_all_offers_v1",
      "visibility": "public",
      "is_entry": false,
      "is_view": true,
      "generic_type_params": [],
      "params": [],
      "return": [
        "vector<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Store::GetOfferReturn>"
      ]
    },
    {
      "name": "octas_to_apt",
      "visibility": "public",
      "is_entry": false,
      "is_view": false,
      "generic_type_params": [],
      "params": [
        "u64"
      ],
      "return": [
        "u64"
      ]
    }
  ],
  "structs": [
    {
      "name": "GetOfferReturn",
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
          "name": "price",
          "type": "u64"
        },
        {
          "name": "id",
          "type": "u64"
        },
        {
          "name": "icon_uri",
          "type": "0x1::string::String"
        }
      ]
    },
    {
      "name": "NewOfferEvent",
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
          "name": "token",
          "type": "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::Token>"
        },
        {
          "name": "price",
          "type": "u64"
        },
        {
          "name": "id",
          "type": "u64"
        }
      ]
    },
    {
      "name": "Offer",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "copy",
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
          "name": "token",
          "type": "0x1::object::Object<0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::Token>"
        },
        {
          "name": "price",
          "type": "u64"
        }
      ]
    },
    {
      "name": "Offers",
      "is_native": false,
      "is_event": false,
      "abilities": [
        "key"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "offers",
          "type": "0x1::smart_table::SmartTable<u64, 0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Store::Offer>"
        },
        {
          "name": "counter",
          "type": "u64"
        }
      ]
    },
    {
      "name": "UserBuysOfferEvent",
      "is_native": false,
      "is_event": true,
      "abilities": [
        "drop",
        "store"
      ],
      "generic_type_params": [],
      "fields": [
        {
          "name": "buyer",
          "type": "address"
        },
        {
          "name": "offer_id",
          "type": "u64"
        },
        {
          "name": "price",
          "type": "u64"
        }
      ]
    }
  ]
} as const;