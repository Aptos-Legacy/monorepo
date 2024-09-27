<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import { SURF, type Surf } from '$lib/network/surf';
	import { UserState } from '$lib/state/user.svelte';
	import { getWalletContext } from '../../wallet/context';
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

	enum ScreenStatus {
		Awaiting,
		Connecting,
		AccountCreation,
		CharacterSelection,
		CharacterCreation
	}

	let status = $state<ScreenStatus>(ScreenStatus.Awaiting);

	let userState = new UserState(null, SURF);

	let walletContext = getWalletContext();

	let googleWallet = $derived.by(() => {
		return walletContext.wallets.find((w) => w.name.toLowerCase() === 'continue with google')!;
	});

	$inspect(walletContext.walletCore?.account);

	$effect(() => {
		if (walletContext.account) {
			userState.userAddress = walletContext.account.address as `0x${string}`;
		}
	});

	async function createNewAccount(name: string) {
		const payload = userState.createAccountPayload(name);
		const response = await walletContext.signAndSubmitTransaction({
			data: payload
		});
		console.dir(response);
	}

	async function createNewCharacter(name: string) {
		const payload = userState.createCharacterPayload(name);
		const response = await walletContext.signAndSubmitTransaction({
			data: payload
		});

		userState.characters = userState.getCharacters(userState.userAddress!);
		console.dir(response);
	}

	let accountQuery = $derived(userState.gameAccount);
	let charactersQuery = $derived(userState.characters);
</script>

<main class="flex min-h-screen min-w-full flex-col p-12">
	<div class="mx-auto w-full grid min-w-[66%] flex-1 grid-rows-9 [&>*]:border">
		<div class="row-span-6 flex flex-col items-center justify-center">
			<img src="/icons/Aptos Legacy Logo.png" width="120" alt="Aptos Legacy Logo" />
			<h1>Aptos Legacy</h1>
		</div>

		<!-- TODO: insert content depending on state here -->

		<div class="row-span-3 flex items-center justify-center">
			{#if walletContext.connected}
				{#if status === ScreenStatus.Awaiting}
					<ClickToStart onclick={() => (status = ScreenStatus.Connecting)}></ClickToStart>
				{/if}
				{#if status === ScreenStatus.Connecting}
					<Connected
						onAccountCreation={createNewAccount}
						onCharacterCreation={createNewCharacter}
						{accountQuery}
						{charactersQuery}
					></Connected>
				{/if}
			{:else if googleWallet}
				<Button class="space-x-2" onclick={() => walletContext.connect(googleWallet.name)}>
					<img src={googleWallet.icon} alt="Google Logo" />
					<div>
						{googleWallet.name}
					</div>
				</Button>
			{/if}
		</div>
	</div>
</main>
