<script lang="ts">
	import { GROUND_COLLISION_GROUP, PLAYER_COLLISION_GROUP } from '$lib/constants/game';
	import { useGameState } from '$lib/state/gamestate.svelte';
	import { Collider, CollisionGroups } from '@threlte/rapier';
	import { MessageSquare } from 'lucide-svelte';
	import { AvailableLayouts } from '$lib/types/Layouts';
	import { UINavigationPrompt } from '../prompts/prompts';
	import BaseNpc from './BaseNPC.svelte';
	import { getUserData } from '$lib/types/Context';

	const gameState = useGameState();

	const promptID = 'seller::start_trading';

	const prompt = new UINavigationPrompt('Start Trading', AvailableLayouts.Store, MessageSquare);
</script>

<BaseNpc position={[3, 1.5, 3]}>
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
