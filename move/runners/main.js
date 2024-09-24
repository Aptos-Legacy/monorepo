// @ts-check

import { readFileSync } from "fs";
import {
  Aptos,
  Account,
  AccountAddress,
  parseTypeTag,
  AptosConfig,
  Network,
  Ed25519PrivateKey,
  MoveString,
  Serializer,
} from "@aptos-labs/ts-sdk";
import { parse, stringify } from "yaml";
import path from "node:path";

async function main() {
  const file = readFileSync(
    path.join(process.cwd(), ".aptos/config.yaml"),
    "utf8"
  );
  /**
   * @type { {profiles: {default: import("./types").ProfileInfo}} }
   */
  const parsedAptosYaml = parse(file);
  const pk = parsedAptosYaml.profiles.default.private_key;

  const profile = parsedAptosYaml.profiles.default;
  // Setup client, and account to sign
  const aptosConfig = new AptosConfig({
    network: Network.DEVNET,
  });

  const aptos = new Aptos(aptosConfig);
  const privateKey = new Ed25519PrivateKey(pk);
  const account = Account.fromPrivateKey({
    privateKey,
  });
  // Load script bytecode
  const buffer = readFileSync(
    path.join(process.cwd(), "./scripts/seed_monsters.move")
  );
  //const buffer = readFileSync("./transfer_half.mv", "buffer");
  const bytecode = Uint8Array.from(buffer);

  const stringArray = ["hello", "world"];
  const encodedStringArray = stringArray.map((str) => {
    const bytes = Buffer.from(str, "utf-8");
    return Array.from(bytes);
  });

  const bytes = Buffer.from("ayaya", "utf8");
  //BCS.bcsSerializeBytes(Buffer.from("test", "utf8"))
  // Build a transaction with the bytecode of the script
  const moveString = new MoveString("hello world");
  const serializer = new Serializer();

  let serialized = moveString.serializeForScriptFunction(serializer);

  const transaction = await aptos.transaction.build.simple({
    sender: account.accountAddress,
    data: {
      bytecode,
      //typeArguments: [parseTypeTag("main")],
      //   typeArguments: [parseTypeTag("0x1::string::String")],
      //typeArguments: [parseTypeTag("0x1::string::String")],
      typeArguments: [parseTypeTag("0x1::string::String")],
      functionArguments: [bytes],
      /*
      functionArguments: [
        {
          type: "vector<vector<u8>>",
          value: encodedStringArray,

        },
      ],
      */
    },
  });

  // Submit and wait for the transaction to complete
  const pendingTxn = await aptos.signAndSubmitTransaction({
    signer: account,
    transaction,
  });

  console.dir(pendingTxn.payload);
  const committed = await aptos.waitForTransaction({
    transactionHash: pendingTxn.hash,
  });

  console.dir(committed);
}

main()
  .catch((e) => console.error(e))
  .finally(() => process.exit(0));
