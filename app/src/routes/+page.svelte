<script lang="ts">
	import { Canvas } from '@threlte/core';
	import { Debug, World } from '@threlte/rapier';

	import Root from '$lib/components/app_ui/Root.svelte';
	import ExploreLayout from '$lib/components/app_ui/layouts/ExploreLayout.svelte';
	import ArenaSelectLayout from '$lib/components/app_ui/layouts/ArenaSelectLayout.svelte';
	import StoreLayout from '$lib/components/app_ui/layouts/StoreLayout.svelte';
	import CharacterLayout from '$lib/components/app_ui/layouts/CharacterLayout.svelte';
	import MissionScene from '$lib/scenes/Mission/MissionScene.svelte';
	import { useGameState } from '$lib/state/gamestate.svelte';
	import HomeScene from '$lib/scenes/HomeScene.svelte';
	import { AvailableLayouts } from '$lib/types/Layouts';

	const gameState = useGameState();
	let currentLayout = $derived(gameState.currentLayout);

	let isInMission = $derived(gameState.currentMission);
</script>

<div class="min-h-screen">
	<Canvas>
		<World>
			<Debug />
			{#if isInMission}
				<MissionScene></MissionScene>
			{:else}
				<HomeScene></HomeScene>
			{/if}
		</World>
	</Canvas>
</div>
<Root>
	{#if currentLayout === AvailableLayouts.Explore}
		<ExploreLayout></ExploreLayout>
	{/if}

	{#if currentLayout === AvailableLayouts.ArenaSelect}
		<ArenaSelectLayout onExit={() => gameState.navigateTo(AvailableLayouts.Explore)}
		></ArenaSelectLayout>
	{/if}

	{#if currentLayout === AvailableLayouts.Store}
		<StoreLayout onExit={() => gameState.navigateTo(AvailableLayouts.Explore)}></StoreLayout>
	{/if}

	{#if currentLayout === AvailableLayouts.Character}
		<CharacterLayout onExit={() => gameState.navigateTo(AvailableLayouts.Explore)}
		></CharacterLayout>
	{/if}
</Root>

<style>
	:global(canvas) {
		@apply min-h-screen;
	}
</style>
