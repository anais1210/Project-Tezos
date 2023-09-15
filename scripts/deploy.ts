import { InMemorySigner, importKey } from "@taquito/signer";
import { MichelsonMap, TezosToolkit } from "@taquito/taquito";
import * as dotenv from "dotenv";
import code from "../compiled/main.json";
import metadata from "./metadata.json";
import { outputFile } from "fs-extra";
import { char2Bytes } from "@taquito/utils";

dotenv.config({ path: ".env" });
const TezosNodeRPC: string = process.env.TEZOS_NODE_URL;
const privateKey: string = process.env.ALICE_PRIVATE_KEY;
const publicKey: string = process.env.ALICE_PUBLIC_KEY;

const signature = new InMemorySigner(privateKey);
const Tezos = new TezosToolkit(TezosNodeRPC);
Tezos.setProvider({ signer: signature });
// resultat en micro tez --> divise par 1M pour avoir des tez
Tezos.tz
  .getBalance(publicKey)
  .then((balance) =>
    console.log(`Address balance: ${balance.toNumber() / 1000000}`)
  )
  .catch((error) => console.log(JSON.stringify(error)));

const saveContractAddress = (name: string, address: string) => {
  outputFile(`./scripts/deployment/${name}.ts`, `export default "${address}"`);
};
// deployer un contrat

const deploy = async () => {
  try {
    Tezos.setSignerProvider(new InMemorySigner(privateKey));

    const initialStorage = {
      admin: publicKey,
      winner: null,
      numbers: new MichelsonMap(),
      metadata: MichelsonMap.fromLiteral({
        "": char2Bytes("tezos-storage:jsonfile"),
        jsonfile: char2Bytes(JSON.stringify(metadata)),
      }),
    };

    const origination = await Tezos.contract.originate({
      code: code,
      storage: initialStorage,
    });
    await origination.confirmation();
    const contract = await origination.contract();
    // console.log(`Operation Hash: ${origination.hash}`);
    console.log(`Contract Address: ${contract.address}`);
    saveContractAddress("deployed_contract", contract.address);
  } catch (err) {
    console.log(err);
  }
};

deploy();
