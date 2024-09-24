<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import type { Character } from '$lib/state/user.svelte';

	import {
		Building2Icon,
		ChartBarIcon,
		CopyIcon,
		LogOutIcon,
		PiggyBankIcon,
		StoreIcon,
		UserIcon
	} from 'lucide-svelte';
	import { useGameState } from '$lib/state/gamestate.svelte';
	import { AvailableLayouts } from '$lib/types/Layouts';

	let char: Character = {
		experience: 0,
		level: 1,
		name: 'Frog'
	};

	let gameState = useGameState();
	let openLayout = (layout: AvailableLayouts) => gameState.navigateTo(layout);
</script>

<div class="grid h-full w-full grid-cols-3 grid-rows-6 p-8">
	<div class="col-start-1 flex items-start space-x-2 border">
		<Button size="icon" variant="ghost">
			<LogOutIcon></LogOutIcon>
		</Button>
	</div>
	<div class="col-start-3 flex items-start justify-end space-x-2 border">
		<Button onclick={() => openLayout(AvailableLayouts.Store)} size="icon" variant="ghost">
			<StoreIcon></StoreIcon>
		</Button>
		<Button onclick={() => openLayout(AvailableLayouts.Guild)} size="icon" variant="ghost">
			<Building2Icon></Building2Icon>
		</Button>
		<Button onclick={() => openLayout(AvailableLayouts.ArenaSelect)} size="icon" variant="ghost">
			<CopyIcon></CopyIcon>
		</Button>
		<Button onclick={() => openLayout(AvailableLayouts.Character)} size="icon" variant="ghost">
			<UserIcon></UserIcon>
		</Button>
	</div>
	<div class="col-start-2 row-start-6 flex flex-col items-center justify-center border">
		<div class="mx-auto w-full max-w-[300px]">
			<div class="flex w-full items-center space-x-2">
				<div class="block">Lv. {char.level}</div>
				<div
					class="h-2 flex-grow rounded border"
					style="background: linear-gradient(0.25turn, green 50%, black 50%);"
				></div>
			</div>
		</div>
	</div>

	<div class="col-start-3 row-start-6 space-y-2">
		{#each gameState.prompts as [_, prompt]}
			<Button
				class="flex max-w-[66%] items-center space-x-2"
				variant="secondary"
				onclick={() => prompt.onClick()}
			>
				<prompt.icon></prompt.icon>
				<div>
					{prompt.label}
				</div>
			</Button>
		{/each}
	</div>
</div>

<style>
</style>
