<script lang="ts">
	import type { Character, GameAccount, UserState } from '$lib/state/user.svelte';
	import * as Dialog from '$lib/components/ui/dialog';
	import Spinner from '../../Atoms/Spinner.svelte';
	import { PlusIcon } from 'lucide-svelte';
	import { Button } from '$lib/components/ui/button';

	import { Input } from '$lib/components/ui/input/index';
	import { Label } from '$lib/components/ui/label';
	import { getWalletContext } from '../../wallet/context';
	import { getUserData } from '$lib/types/Context';

	import KnightPortait from '$lib/assets/portraits/Knight.png';
	import { getContext } from 'svelte';

	let {
		accountQuery,
		charactersQuery,
		onAccountCreation,
		onCharacterCreation
	}: {
		charactersQuery: Promise<Character[]>;
		accountQuery: Promise<GameAccount | null>;
		onAccountCreation: (name: string) => Promise<void>;
		onCharacterCreation: (name: string) => Promise<void>;
	} = $props();

	let accountNameInput = $state('');

	let isCreatingAccount = $state(false);

	let characterNameInput = $state('');
	let isCreatingCharacter = $state(false);

	let isCreateCharacterDialogOpen = $state(false);

	const userState = getContext('USER') as UserState;
</script>

<!--
@component
 Here the user if connected and may have characters available for selection
-->

{#await accountQuery}
	<div>
		<Spinner></Spinner>
	</div>
{:then gameAccount}
	{#if gameAccount}
		<div class="w-full py-4">
			<div class="text-center text-sm">
				Connected as <span class="block text-2xl font-medium">{gameAccount.name}</span>
			</div>

			{#await charactersQuery then characters}
				<div class="mt-4 grid w-full grid-cols-6 grid-rows-3 gap-4">
					{#each characters as char}
						<button
							onclick={() => (userState.currentCharacter = char.name)}
							class="hover:border-primary col-span-2 flex items-center space-x-4 rounded-md border px-4 duration-150"
						>
							<div>
								<img
									src={KnightPortait}
									alt="Portrait"
									class="aspect-square rounded border-2 border-white"
									width="72"
								/>
							</div>
							<div class="flex flex-col items-start">
								<div class="text-lg font-medium">
									{char.name}
								</div>

								<div>
									LVL. {char.level}
								</div>
							</div>
						</button>
					{/each}
					{#if characters.length < 4}
						<Dialog.Root bind:open={isCreateCharacterDialogOpen}>
							<Dialog.Trigger
								class="hover:border-primary col-span-2 col-start-1 min-h-[100px] text-pretty rounded-md border px-4 duration-150"
								>Create new Character</Dialog.Trigger
							>
							<Dialog.Content>
								<Dialog.Header>
									<Dialog.Title>Create a new Character</Dialog.Title>
								</Dialog.Header>
								<div class="grid w-full max-w-sm items-center gap-1.5 py-4">
									<Label for="character-name">Character Name</Label>
									<Input
										type="text"
										autocomplete="off"
										id="character-name"
										placeholder="MegaKnight"
										bind:value={characterNameInput}
									/>
									<p class="text-muted-foreground text-sm">At least 3 characters long.</p>
								</div>
								<Dialog.Footer>
									<Button
										disabled={characterNameInput.length < 3}
										onclick={() => {
											isCreatingCharacter = true;

											onCharacterCreation(characterNameInput).then((_) => {
												isCreatingCharacter = false;
												isCreateCharacterDialogOpen = false;
											});
										}}>Create</Button
									>
								</Dialog.Footer>
							</Dialog.Content>
						</Dialog.Root>
					{/if}
				</div>
			{/await}
		</div>
	{:else}
		<Dialog.Root>
			<Dialog.Trigger
				class="flex aspect-square flex-col  items-center  justify-center rounded-md border px-4 duration-100 hover:border-white"
			>
				<PlusIcon size="20"></PlusIcon>
				<div class="mt-2">Create new Account</div>
			</Dialog.Trigger>
			<Dialog.Content class="">
				<Dialog.Header>
					<Dialog.Title>Create new Account</Dialog.Title>
				</Dialog.Header>
				<div class="grid w-full max-w-sm items-center gap-1.5 py-4">
					<Label for="account-name">Account Name</Label>
					<Input
						type="text"
						id="account-name"
						placeholder="Gamer123"
						bind:value={accountNameInput}
					/>
					<p class="text-muted-foreground text-sm">At least 3 characters long.</p>
				</div>
				<Dialog.Footer>
					<Button
						disabled={accountNameInput.length < 3}
						onclick={() => {
							isCreatingAccount = true;
							onAccountCreation(accountNameInput).then((_) => {
								isCreatingAccount = false;
							});
						}}>Create</Button
					>
				</Dialog.Footer>
			</Dialog.Content>
		</Dialog.Root>
	{/if}
{/await}
