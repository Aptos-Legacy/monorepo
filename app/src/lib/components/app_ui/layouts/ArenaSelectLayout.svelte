<script lang="ts">
	/**
	 * Component has a blurred bg, allows for selecting a given arena and its difficulty
	 */
	import B_BUTTON from '$lib/assets/icons/buttons/b.png';
	import A_BUTTON from '$lib/assets/icons/buttons/a.png';
	import SandySandsIcon from '$lib/assets/icons/levels/sandy_sands.png';

	import { ARENAS } from '$lib/data/game/arenas';
	import { Button } from '$lib/components/ui/button';
	import { SURF } from '$lib/network/surf';
	import FullScreenLayout from './FullScreenLayout.svelte';
	let { onExit }: { onExit: VoidFunction } = $props();

	const arenas = ARENAS;

	let selectedArena = $state(arenas[0]);

	import * as ABIs from '$lib/network/ABIs';
	import EntityCard from '../Molecules/EntityCard.svelte';
	import CurrencyEntityCard from '../Molecules/CurrencyEntityCard.svelte';
	import { useGameState } from '$lib/state/gamestate.svelte';
	import { getAptosQueryContext } from '$lib/network/aptos';
	import { onMount } from 'svelte';
	import { createSurfClient } from '@thalalabs/surf';
	import { SvelteMap } from 'svelte/reactivity';
	import Spinner from '../Atoms/Spinner.svelte';
	import { getWalletContext } from '../wallet/context';

	const aptosQueryClient = getAptosQueryContext();
	const gameState = useGameState();

	type Reward = {
		chance: number;
		icon: string;
		name: string;
	};

	let missionRewards = new SvelteMap<
		number,
		Promise<[{ monster_rewards: Reward[]; mission_rewards: Reward[]; gold: string }]>
	>();
	const surf = createSurfClient(aptosQueryClient).useABI(ABIs.Mission_ABI);


	function selectNewArena(id: number) {
		if (!missionRewards.has(id)) {
			let rewardsPromise = surf.view.get_all_mission_rewards_for_display({
				typeArguments: [],
				functionArguments: [id]
			});
			// @ts-expect-error surf returns unknown but we're typing in the missionRewards declaration
			missionRewards.set(id, rewardsPromise);
		}

		selectedArena.id = id;
	}

	let wallet = getWalletContext();
	onMount(() => {
		missionRewards.set(
			1,
			// @ts-expect-error surf returns unknown but we're typing in the missionRewards declaration
			surf.view.get_all_mission_rewards_for_display({
				typeArguments: [],
				functionArguments: [1]
			})
		);
	});
</script>

<FullScreenLayout {onExit} title={'Quests'}>
	<div class="grid flex-grow grid-cols-3 gap-4 overflow-hidden p-2 md:gap-8 md:p-4 lg:p-8">
		<div class="space-y-3 overflow-y-auto px-4">
			{#each arenas as arena (arena.id)}
				{@const selected = selectedArena.id === arena.id}
				<button
					data-selected={selected}
					class="w-full rounded border p-4 text-left duration-200"
					onclick={() => selectNewArena(arena.id)}
				>
					<div class="font-semibold md:text-xl">
						{arena.name}
					</div>
					<div class="text-xs">
						Recommended level: {arena.levelRecommendation}
					</div>
				</button>
			{/each}
		</div>
		<div class="col-span-2 flex flex-col space-y-4 overflow-y-auto">
			<div>
				<div class="flex items-center space-x-3">
					<img src={SandySandsIcon} alt="Sandy Sands logo" width="84" />
					<div>
						<h2 class="text-lg md:text-xl lg:text-2xl">
							{selectedArena.name}
						</h2>
						<p>{selectedArena.description}</p>
					</div>
				</div>
				<div class="mt-8 py-2 md:py-4">
					{#if missionRewards.has(selectedArena.id)}
						{#await missionRewards.get(selectedArena.id)}
							<Spinner></Spinner>
						{:then resolved}
							{@const [rewards] = resolved!}
							{@const gold = Number(rewards.gold)}
							<div>
								<h3>Mission Rewards</h3>

								<div class="mt-2 flex items-start space-x-2 overflow-x-auto">
									{#if gold !== 0}
										<CurrencyEntityCard amount={gold}></CurrencyEntityCard>
									{/if}
									{#each rewards.mission_rewards as reward}
										<EntityCard chance={reward.chance} name={reward.name} icon={reward.icon}
										></EntityCard>
									{/each}
								</div>
							</div>

							<div class="mt-4 md:mt-8">
								<h3>Monster Loot</h3>
								<div class="mt-2 flex items-start space-x-2 overflow-x-auto">
									{#each rewards.monster_rewards as reward}
										<EntityCard chance={reward.chance} name={reward.name} icon={reward.icon}
										></EntityCard>
									{/each}
								</div>
							</div>
						{/await}
					{/if}
				</div>
			</div>
			<div class="absolute bottom-0 right-2 flex items-center justify-end space-x-4 py-4">
				<Button onclick={onExit} class="flex items-center bg-transparent" variant="ghost">
					<img src={B_BUTTON} alt="B button prompt" width="24" class="mr-2 rounded-full bg-white" />
					Back
				</Button>
				<Button
					onclick={() => gameState.startNewMission(wallet, selectedArena.id)}
					class="flex items-center bg-transparent"
					variant="ghost"
				>
					<img src={A_BUTTON} alt="A button prompt" width="24" class="mr-2 rounded-full bg-white" />
					Start
				</Button>
			</div>
		</div>
	</div>
</FullScreenLayout>

<!-- 

<div class="flex h-full w-full flex-col bg-black/60 backdrop-blur-md">
	<div class="bg-red-500/80 p-4 md:p-8">Select an arena</div>

	<div class="grid flex-grow grid-cols-3 gap-4 md:gap-8 overflow-hidden md:p-8">
		<div class="space-y-3 overflow-y-auto p-4">
			{#each arenas as arena (arena.id)}
				{@const selected = selectedArena.id === arena.id}
				<button
					data-selected={selected}
					class="w-full rounded border p-4 text-left duration-200"
					onclick={() => (selectedArena = arena)}
				>
					<div class="md:text-xl font-semibold">
						{arena.name}
					</div>
					<div class="text-xs">
						Recommended level: {arena.levelRecommendation}
					</div>
				</button>
			{/each}
		</div>
		<div class="col-span-2 flex flex-col justify-between overflow-y-auto">
			<div>
				<div class="py-4">
					<h2 class="text-lg md:text-xl">
						{selectedArena.name}
					</h2>
					<p>{selectedArena.description}</p>
				</div>
				<Separator></Separator>
				<div class="py-2 md:py-4">
					<div>
						<h3>Mission Rewards</h3>
						<div class="mt-2 flex space-x-2 overflow-x-auto">
							{#each selectedArena.rewards as reward}
								<CurrencyEntityCard amount={100}></CurrencyEntityCard>
							{/each}
						</div>
					</div>

					<div class="mt-4 md:mt-8">
						<h3>Monsters</h3>
						<div class="mt-2 flex space-x-2 overflow-x-auto">
							{#each selectedArena.monsters as monster}
								<EntityCard></EntityCard>
							{/each}
						</div>
					</div>
				</div>
			</div>
			<div class="flex items-center justify-end space-x-4 absolute bottom-0 right-0 py-4">
				<Button onclick={onExit} class="flex items-center bg-transparent" variant="ghost">
					<img src={B_BUTTON} alt="B button prompt" width="24" class="mr-2 rounded-full bg-white" />
					Back
				</Button>
				<Button class="flex items-center bg-transparent" variant="ghost">
					<img src={A_BUTTON} alt="A button prompt" width="24" class="mr-2 rounded-full bg-white" />
					Start
				</Button>
			</div>
		</div>
	</div>
</div>
 -->
<style lang="postcss">
	button[data-selected='true'] {
		@apply text-background scale-105 bg-white;
	}

	button[data-selected='false']:hover {
		@apply border-primary scale-105;
	}

	h3 {
		@apply text-muted-foreground text-sm font-semibold uppercase;
	}
</style>
