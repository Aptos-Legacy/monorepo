<script lang="ts">
	import Game from '$lib/components/app_ui/Game.svelte';
	import AccountView from '$lib/components/app_ui/Views/Account/AccountView.svelte';
	import { getWalletContext } from '$lib/components/app_ui/wallet/context';

	import { useGameState } from '$lib/state/gamestate.svelte';

	let gameState = useGameState();

	
</script>

{#if gameState.character}
	<Game></Game>
{:else}
	<AccountView></AccountView>
{/if}
