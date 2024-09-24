<script lang="ts">
	import type { Character, GameAccount } from '$lib/state/user.svelte';
	import * as Dialog from '$lib/components/ui/dialog';
	import Spinner from '../../Atoms/Spinner.svelte';

	let {
		accountQuery,
		charactersQuery
	}: { charactersQuery: Promise<Character[]>; accountQuery: Promise<GameAccount> } = $props();
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
	<div>
		<div>
			Connected to account {gameAccount.name}
		</div>

		{#await charactersQuery then characters}
			<div class="mt-4 flex items-center justify-center gap-4">
				{#each characters as char}
					<div class="aspect-square min-w-[100px] rounded-md border">
						<div>
							{char.name}
						</div>

						<div>
							LVL. {char.level}
						</div>
					</div>
				{/each}
				{#if characters.length < 4}
					<Dialog.Root >
						<Dialog.Trigger class="max-w-[100px] rounded-md border aspect-square">Create new Character</Dialog.Trigger>
						<Dialog.Content class="sm:max-w-[425px]">
							<Dialog.Header>
								<Dialog.Title>Edit profile</Dialog.Title>
								<Dialog.Description>
									Make changes to your profile here. Click save when you're done.
								</Dialog.Description>
							</Dialog.Header></Dialog.Content
						>
					</Dialog.Root>
				{/if}
			</div>
		{/await}
	</div>
{/await}
