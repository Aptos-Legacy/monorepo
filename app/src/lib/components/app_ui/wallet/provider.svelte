<script lang="ts">
	import { onMount, type Snippet } from 'svelte';
	import { setWalletContext } from './context';
	import { browser } from '$app/environment';
	import { AptosWalletAdapter } from './wallet.svelte';
	import { Network } from '@aptos-labs/ts-sdk';
	import { getNetwork } from '$lib/network/aptos';
	import { PetraWallet } from 'petra-plugin-wallet-adapter';

	const { children }: { children: Snippet } = $props();

	const wallet = new AptosWalletAdapter(false);
	const petraWallet = new PetraWallet();
	setWalletContext(wallet);

	onMount(() => {
		wallet.initialize({
			plugins: [petraWallet],
			optInWallets: [],
			dappConfig: {
				network: getNetwork(),
				aptosConnectDappId: 'Aptos Legacy'
			}
		});
		
		//wallet.connect("Continue with Google")
	});

	/*
	$effect(() => {
		return () => {
			wallet.disconnect();
		};
	});*/
</script>

{@render children()}
