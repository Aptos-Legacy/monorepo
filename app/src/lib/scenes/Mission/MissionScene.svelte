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

	let playerPosition = $state([0, 3, 14]);

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

	let monsterPosition = $state([0, 9, 8]);

	const gameState = useGameState();

	
</script>

<Monster id={4} position={monsterPosition}></Monster>

{#if $sky}
	<T.Mesh position.y={-10} scale.y={0.5}>
		<T.SphereGeometry args={[300, 8, 8]} />
		<T.MeshBasicMaterial map={$sky} side={BackSide} />
	</T.Mesh>
{/if}
<T.DirectionalLight castShadow position={[8, 20, -3]} />
<T.AmbientLight intensity={0.2} />

<T.GridHelper args={[50]} position.y={0.01} />

<CollisionGroups groups={[PLAYER_COLLISION_GROUP, GROUND_COLLISION_GROUP]}>
	<AutoColliders shape={'cuboid'} position={[0, -0.5, 0]}>
		<T.Mesh
			receiveShadow
			geometry={new BoxGeometry(100, 1, 100)}
			material={new MeshStandardMaterial()}
		/>
	</AutoColliders>
</CollisionGroups>

<Debug />

<T.GridHelper args={[50]} position.y={0.01} />

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

<Player bind:position={playerPosition}></Player>
