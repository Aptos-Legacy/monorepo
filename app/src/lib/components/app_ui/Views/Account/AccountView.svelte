<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import { SURF, type Surf } from '$lib/network/surf';
	import { UserState } from '$lib/state/user.svelte';
	import ClickToStart from './ClickToStart.svelte';
	import Connected from './Connected.svelte';

	/// A user can be connected or not upon arriving on this view.
	/// If the user is not connected, we need to prompt him to connect
	/// -> Once that's done, we'll want to check his balance and ask for testnet tokens to be sent so he can play the game

	/// When connected, we'll be showing the user either:
	/// A list of characters he's created with their info (name + level) // NOTE: We've set a "progress" value in the contract that is currently unused

	// If the user chooses to create a new character, we'll take him to a "character creation screen"
	// If the user selects an existing character, we need to store that info somewhere and send him on his way to the actual game

	//let { client }: { client: Surf } = $props();

	let userAddress =
		'0x2dc08391f7cc82cafa028d49854640676afc0e520d62f954bcc349c5d834f590' as `0x${string}`;

	enum ScreenStatus {
		Awaiting,
		Connecting,
		AccountCreation,
		CharacterSelection,
		CharacterCreation
	}

	let status = $state<ScreenStatus>(ScreenStatus.Awaiting);

	let userState = new UserState(userAddress, SURF);
	// TODO: check if user actually has an account. If he doesn't, we'll want to create one
</script>

<main class="flex min-h-screen min-w-full flex-col  p-12">
	<div class="mx-auto grid w-2/3 flex-1 grid-rows-9 [&>*]:border">
		<div class="row-span-6 flex flex-col items-center justify-center">
			<div>Logo</div>
			<h1>Eternal Odyssey</h1>
		</div>

		<!-- TODO: insert content depending on state here -->

		<div class="row-span-3 flex items-center justify-center">
			{#if status === ScreenStatus.Awaiting}
				<ClickToStart onclick={() => (status = ScreenStatus.Connecting)}></ClickToStart>
			{/if}
			{#if status === ScreenStatus.Connecting}
				<Connected accountQuery={userState.gameAccount} charactersQuery={userState.characters}></Connected>
			{/if}
		</div>
	</div>
</main>
