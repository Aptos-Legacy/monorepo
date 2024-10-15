<script lang="ts">
	import { PLAYER_COLLISION_GROUP } from '$lib/constants/game';
	import { useGameState } from '$lib/state/gamestate.svelte';
	import { Collider, CollisionGroups } from '@threlte/rapier';
	import { BookMarked, MessageSquare } from 'lucide-svelte';
	import { UINavigationPrompt } from '../prompts/prompts';
	import BaseNpc from './BaseNPC.svelte';
	import { AvailableLayouts } from '$lib/types/Layouts';
	import { getUserData } from '$lib/types/Context';
	import Tavern from '$lib/assets/models/npc/Tavern.svelte';

	const gameState = useGameState();

	const promptID = 'mission::show_missions';

	const prompt = new UINavigationPrompt(
		'See available quests',
		AvailableLayouts.ArenaSelect,
		BookMarked
	);

	let { ...rest } = $props();
</script>

<BaseNpc {...rest}>
	{#snippet mesh()}
		<Tavern />
	{/snippet}
	{#snippet colliders()}
		<CollisionGroups groups={[PLAYER_COLLISION_GROUP]}>
			<Collider
				shape={'cuboid'}
				args={[1, 1.35, 1.5]}
				sensor
				onsensorenter={(e) => {
					const userData = getUserData(e.targetRigidBody);
					if (userData.tag === 'Player') {
						gameState.addPrompt(promptID, prompt);
					}
				}}
				onsensorexit={(e) => {
					gameState.removePrompt(promptID);
				}}
			/>
		</CollisionGroups>
	{/snippet}
</BaseNpc>
