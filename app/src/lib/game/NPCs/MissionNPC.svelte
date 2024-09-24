<script lang="ts">
	import { PLAYER_COLLISION_GROUP } from '$lib/constants/game';
	import { useGameState } from '$lib/state/gamestate.svelte';
	import { Collider, CollisionGroups } from '@threlte/rapier';
	import { BookMarked, MessageSquare } from 'lucide-svelte';
	import { UINavigationPrompt } from '../prompts/prompts';
	import BaseNpc from './BaseNPC.svelte';
	import { AvailableLayouts } from '$lib/types/Layouts';
	import { getUserData } from '$lib/types/Context';

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
					console.log('exiting mission npc sensor');

					gameState.removePrompt(promptID);
				}}
			/>
		</CollisionGroups>
	{/snippet}
</BaseNpc>
