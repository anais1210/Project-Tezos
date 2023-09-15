import { InMemorySigner, importKey } from "@taquito/signer";
import { MichelsonMap, TezosToolkit } from "@taquito/taquito";
import * as dotenv from "dotenv";
import code from "../compiled/main.json";
import { outputFile } from "fs-extra";
import { char2Bytes } from "@taquito/utils";
import networks from "../config";
import accounts from "../accounts";

dotenv.config({ path: ".env" });
const TezosNodeRPC: string = networks.ghostnet.node_url;
const publicKey: string = accounts.sandbox.alice.publicKey;
const privateKey: string = accounts.sandbox.alice.privateKey;

const signature = new InMemorySigner(privateKey);
const Tezos = new TezosToolkit(TezosNodeRPC);
Tezos.setProvider({ signer: signature });
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
      ultime_admin: publicKey,
      admins: new MichelsonMap(),
      //   admins: MichelsonMap.fromLiteral({
      //     publicKey: true,
      //   }),
      blacklist: new MichelsonMap(),
      whitelist: [],
    };

    const origination = await Tezos.contract.originate({
      code: code,
      storage: initialStorage,
    });
    await origination.confirmation();
    const contract = await origination.contract();

    console.log(`Contract Address: ${contract.address}`);
    saveContractAddress("deployed_contract", contract.address);
  } catch (err) {
    console.log(err);
  }
};

deploy();
