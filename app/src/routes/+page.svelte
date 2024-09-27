<script lang="ts">
	import Game from '$lib/components/app_ui/Game.svelte';
	import AccountView from '$lib/components/app_ui/Views/Account/AccountView.svelte';
	import { getWalletContext } from '$lib/components/app_ui/wallet/context';
	import { useGameState } from '$lib/state/gamestate.svelte';
	import type { Character } from '$lib/state/user.svelte';

	// We'll be showing the Accountview until the user is
	// - Connected to an account
	// - Using a character
	let gameState = useGameState();

	let character: Character | null = $state({
		name: 'MegaKnight',
		experience: 0,
		level: 1
	});

	gameState.character = character;

	const wallet = getWalletContext();
	$effect(() => {
		console.log(wallet.account?.address);
	});
</script>

{#if gameState.character}
	<Game></Game>
{:else}
	<AccountView></AccountView>
{/if}

{#if !wallet.account}
	<button
		class="pointer-events-auto absolute bottom-2 left-2 z-50 border"
		onclick={() => {
			console.log('clicked');
			wallet.connect('Petra');
		}}>Connect to wallet</button
	>
{/if}
