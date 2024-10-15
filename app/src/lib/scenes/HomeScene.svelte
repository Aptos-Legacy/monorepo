<script lang="ts">
	import { T, useTask } from '@threlte/core';
	import { interactivity, useTexture } from '@threlte/extras';

	import { AutoColliders, Collider, CollisionGroups, Debug } from '@threlte/rapier';
	import {
		BackSide,
		BoxGeometry,
		MeshStandardMaterial,
		NearestFilter,
		RepeatWrapping
	} from 'three';
	import { GROUND_COLLISION_GROUP, PLAYER_COLLISION_GROUP } from '$lib/constants/game';
	import Player from './Mission/Player.svelte';
	import SellerNpc from '$lib/game/NPCs/SellerNPC.svelte';
	import MissionNpc from '$lib/game/NPCs/MissionNPC.svelte';
	import BuildingBlacksmithBlue from '$lib/assets/models/buildings/building_blacksmith_blue.svelte';
	import BuildingTavern from '$lib/assets/models/buildings/building_tavern_yellow.svelte';

	import { DEG2RAD } from 'three/src/math/MathUtils.js';
	import Random from '$lib/game/environment/Random.svelte';

	let position = $state([0, 3, 5]);

	const grass = useTexture('/textures/sprites/Grass.png', {
		transform: (texture) => {
			texture.wrapS = texture.wrapT = RepeatWrapping;
			texture.repeat.set(120, 120);
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
	let playerPosition = $state([0, 1, 14]);

	let rotation = $state(0);
	$effect(() => {
		setInterval(() => {
			rotation = rotation + 1 / 10000;
		}, 10);
	});
</script>

<Player bind:position={playerPosition}></Player>

<SellerNpc position={[-4, 2, 6]}></SellerNpc>
<MissionNpc position={[4, 2, 6]}></MissionNpc>

<BuildingBlacksmithBlue rotation.y={25 * DEG2RAD} position={[-6, 0.5, 0]} scale={5}
></BuildingBlacksmithBlue>

<BuildingTavern rotation.y={-50 * DEG2RAD} position={[6, 0.5, 0]} scale={5}></BuildingTavern>
{#if $sky}
	<T.Mesh position.y={-10} scale.y={0.5} rotation.y={rotation}>
		<T.SphereGeometry args={[300, 8, 8]} />
		<T.MeshBasicMaterial map={$sky} side={BackSide} />
	</T.Mesh>
{/if}

<T.DirectionalLight castShadow position={[-10, 20, -10]} intensity={1.6} color={0xffff00} />
<T.AmbientLight intensity={0.8} castShadow />


<T.GridHelper args={[50]} position.y={0.01} />
<T.GridHelper args={[50]} position.y={0.01} />

{#if $grass}
	<CollisionGroups groups={[GROUND_COLLISION_GROUP, PLAYER_COLLISION_GROUP]}>
		<AutoColliders shape={'cuboid'} position={[0, -0, 0]}>
			<T.Mesh
				receiveShadow
				geometry={new BoxGeometry(1000, 1, 1000)}
				material={new MeshStandardMaterial()}
			>
				<T.MeshLambertMaterial map={$grass} />
			</T.Mesh>
		</AutoColliders>
	</CollisionGroups>
{/if}

<T.Group position={[-12, 0, -12]}>
	<Random></Random>
</T.Group>

<T.Group position={[-12, 0, -10]}>
	<Random></Random>
</T.Group>

<T.Group position={[10, 0, -4]}>
	<Random></Random>
</T.Group>
