import { Aptos, AptosConfig, Network } from '@aptos-labs/ts-sdk';
import { PUBLIC_NETWORK } from '$env/static/public';
import { getContext, setContext } from 'svelte';

const network = (() => {
	console.log(PUBLIC_NETWORK)
	switch (PUBLIC_NETWORK) {
		case 'localnet':
			return Network.LOCAL;
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

console.log(config)

export const APTOS = new Aptos(config);

const CONTEXT_KEY = 'Aptos_query_client';

export function setAptosQueryContext() {
	return setContext<typeof APTOS>(CONTEXT_KEY, APTOS);
}
export function getAptosQueryContext() {
	return getContext<typeof APTOS>(CONTEXT_KEY);
}
