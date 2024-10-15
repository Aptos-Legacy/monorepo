<script lang="ts">
	import { CONTEXT_KEY, GAME_STATE } from '$lib/state/gamestate.svelte';
	import { setContext } from 'svelte';
	import '../app.css';
	import { setAptosQueryContext } from '$lib/network/aptos';
	import WalletProvider from '$lib/components/app_ui/wallet/provider.svelte';
	import { UserState } from '$lib/state/user.svelte';
	import { SURF } from '$lib/network/surf';

	let { children } = $props();

	setContext(CONTEXT_KEY, GAME_STATE);
	const userState = new UserState(null, SURF);

	$effect(() => {
		if (userState.currentCharacter && userState.characters) {
			userState.characters.then((resolved) => {
				GAME_STATE.character = resolved.find((c) => c.name == userState.currentCharacter)!;
			});
		}
	});

	setContext('USER', userState);
	setAptosQueryContext();
</script>

<WalletProvider>
	{@render children()}
</WalletProvider>
