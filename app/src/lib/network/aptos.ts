import { Aptos, AptosConfig, Network } from '@aptos-labs/ts-sdk';
import { PUBLIC_NETWORK } from '$env/static/public';

const network = (() => {
	switch (PUBLIC_NETWORK) {
		case 'devnet':
			return Network.DEVNET;
		case 'mainnet':
			return Network.MAINNET;
		case 'testnet':
			return Network.TESTNET;
		default:
			throw 'No network defined in environment files';
	}
})();

const config = new AptosConfig({
	network: network
});

export const APTOS = new Aptos(config);
