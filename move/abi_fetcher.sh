#! /bin/bash

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <module_name1> <module_name2> ... <module_nameN>"
  exit 1
fi


# replace it with the network your contract lives on
NETWORK=devnet
# replace it with your contract address
CONTRACT_ADDRESS=0x7b70d7b04458aa291eb9fe077d8b9ccba5a30c6219399adb3eb0c1fc56c8f38e
# replace it with your module name, every .move file except move script has module_address::module_name {}
MODULE_NAME=Monster
 
# save the ABI to a TypeScript file
#echo "export const ABI = $(curl https://fullnode.$NETWORK.aptoslabs.com/v1/accounts/$CONTRACT_ADDRESS/module/$MODULE_NAME | sed -n 's/.*"abi":\({.*}\).*}$/\1/p') as const" > $MODULE_NAME.abi.tsb



# Loop over each provided $MODULE_NAME
for MODULE_NAME in "$@"; do
  # Fetch ABI for the module and store it in a .ts file
  ABI=$(curl -s https://fullnode.$NETWORK.aptoslabs.com/v1/accounts/$CONTRACT_ADDRESS/module/$MODULE_NAME | sed -n 's/.*"abi":\({.*}\).*}$/\1/p')

  # Check if ABI was successfully fetched
  if [ -z "$ABI" ]; then
    echo "Failed to fetch ABI for module: $MODULE_NAME"
    continue
  fi

  # Write the ABI to a TypeScript file
  echo "export const ABI = $ABI as const;" > "$MODULE_NAME.abi.ts"
  echo "ABI for $MODULE_NAME saved to $MODULE_NAME.abi.ts"
done
