<script>
	import { CONTEXT_KEY, GAME_STATE } from '$lib/state/gamestate.svelte';
	import { setContext } from 'svelte';
	import '../app.css';
	import { setAptosQueryContext } from '$lib/network/aptos';
	import WalletProvider from '$lib/components/app_ui/wallet/provider.svelte';

	let {children} = $props();

	setContext(CONTEXT_KEY, GAME_STATE);
	setAptosQueryContext();
</script>

<WalletProvider>
	{@render children()}
</WalletProvider>
