

import { setContext, getContext } from 'svelte';
import { AptosWalletAdapter } from './wallet.svelte';

const CONTEXT_KEY = Symbol('wallet');

export function setWalletContext(wallet: AptosWalletAdapter) {
	setContext(CONTEXT_KEY, wallet);
}

export function getWalletContext(): AptosWalletAdapter {
	return getContext<AptosWalletAdapter>(CONTEXT_KEY);
}
