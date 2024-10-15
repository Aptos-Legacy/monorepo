<script lang="ts">
	import { T, useTask } from '@threlte/core';
	import { useTexture } from '@threlte/extras';

	import { AutoColliders, Collider, CollisionGroups, Debug } from '@threlte/rapier';
	import {
		BackSide,
		BoxGeometry,
		MeshStandardMaterial,
		NearestFilter,
		RepeatWrapping
	} from 'three';
	import Monster from './Monster.svelte';
	import Player from './Player.svelte';
	import { GROUND_COLLISION_GROUP, PLAYER_COLLISION_GROUP } from '$lib/constants/game';
	import { useGameState } from '$lib/state/gamestate.svelte';

	let playerPosition = $state([2, 3, 18]);

	const grass = useTexture('/textures/sprites/pixel-grass.png', {
		transform: (texture) => {
			texture.wrapS = texture.wrapT = RepeatWrapping;
			texture.repeat.set(50, 50);
			texture.minFilter = NearestFilter;
			texture.magFilter = NearestFilter;
			texture.needsUpdate = true;
			return texture;
		}
	});

	const sky = useTexture('/textures/sprites/pixel-sky.png', {
		transform: (texture) => {
			texture.wrapS = texture.wrapT = RepeatWrapping;
			texture.repeat.set(10, 2);
			texture.minFilter = NearestFilter;
			texture.magFilter = NearestFilter;
			texture.needsUpdate = true;
			return texture;
		}
	});

	/* TODO: we need to get
        - Monsters for this mission
        - Rewards
        - Mission ID
        - User Account

        As well as managing the progress state for this mission, loading all the assets and so on
    */

	let monsterPosition = $state([0.5, 0.5, -2]);

	const gameState = useGameState();
	import { injectLookAtPlugin } from '$lib/plugins/lookAt';
	import { getWalletContext } from '$lib/components/app_ui/wallet/context';
	import Random from '$lib/game/environment/Random.svelte';
	injectLookAtPlugin();

	const monsterID = 1;

	let onMonsterKill;

	let wallet = getWalletContext();

	async function onHit(tags: string[]) {
		if (tags.filter((t) => t === `Monster::${monsterID}`)[0]) {
			onMonsterKill();

			// Monster is dead, so we'll wrap up the mission
			await gameState.endMission(wallet);
		}
	}
</script>

{#if $sky}
	<T.Mesh position.y={-10} scale.y={0.5}>
		<T.SphereGeometry args={[300, 8, 8]} />
		<T.MeshBasicMaterial map={$sky} side={BackSide} />
	</T.Mesh>
{/if}

<T.DirectionalLight castShadow position={[-10, 20, -10]} intensity={1.6} color={0xffff00} />
<T.AmbientLight intensity={0.8} castShadow />

<CollisionGroups groups={[PLAYER_COLLISION_GROUP, GROUND_COLLISION_GROUP]}>
	<AutoColliders shape={'cuboid'} position={[0, -0.5, 0]}>
		<T.Mesh
			receiveShadow
			geometry={new BoxGeometry(100, 1, 100)}
			material={new MeshStandardMaterial()}
		/>
	</AutoColliders>
</CollisionGroups>

{#if $grass}
	<CollisionGroups groups={[PLAYER_COLLISION_GROUP, GROUND_COLLISION_GROUP]}>
		<AutoColliders shape={'cuboid'} position={[0, -0.5, 0]}>
			<T.Mesh
				receiveShadow
				geometry={new BoxGeometry(100, 1, 100)}
				material={new MeshStandardMaterial()}
			>
				<T.MeshLambertMaterial map={$grass} />
			</T.Mesh>
		</AutoColliders>
	</CollisionGroups>
{/if}

<Player bind:position={playerPosition} {onHit}></Player>
<Monster bind:onKill={onMonsterKill} id={monsterID} position={monsterPosition}></Monster>

<T.Group position={[-12, 0, -12]}>
	<Random></Random>
</T.Group>

<T.Group position={[-12, 0, -8]}>
	<Random></Random>
</T.Group>

<T.Group position={[10, 0, -20]}>
	<Random></Random>
</T.Group>
