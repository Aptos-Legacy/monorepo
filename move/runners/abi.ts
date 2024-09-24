export const ABI = {
  address: "0x7b70d7b04458aa291eb9fe077d8b9ccba5a30c6219399adb3eb0c1fc56c8f38e",
  name: "Monster",
  friends: [],
  exposed_functions: [
    {
      name: "create_monster",
      visibility: "public",
      is_entry: true,
      is_view: false,
      generic_type_params: [],
      params: ["&signer", "0x1::string::String"],
      return: [],
    },
  ],
  structs: [
    {
      name: "Monster",
      is_native: false,
      is_event: false,
      abilities: ["key"],
      generic_type_params: [],
      fields: [{ name: "name", type: "0x1::string::String" }],
    },
    {
      name: "NewMonsterCreatedEvent",
      is_native: false,
      is_event: true,
      abilities: ["drop", "store"],
      generic_type_params: [],
      fields: [{ name: "name", type: "0x1::string::String" }],
    },
  ],
} as const;
