<script lang="ts">
	import { CapsuleGeometry, Euler, Vector3 } from 'three';
	import { T, useTask, useThrelte } from '@threlte/core';
	import { RigidBody, CollisionGroups, Collider } from '@threlte/rapier';
	import { RigidBody as RapierRigidBody } from '@dimforge/rapier3d-compat';
	import type { Snippet } from 'svelte';
	import { PLAYER_COLLISION_GROUP } from '$lib/constants/game';

	let {
		position,
		radius = 0.3,
		height = 1.7,
		speed = 6,
		children,
		colliders,
		mesh
	}: {
		children?: Snippet;
		position: number[];
		radius?: number;
		height?: number;
		speed?: number;
		colliders?: Snippet;
		mesh?: Snippet;
	} = $props();

	let capsule = $state(null!);

	let rigidBody = $state<RapierRigidBody>(null!);
</script>

<T.Group bind:ref={capsule} {position} rotation.y={Math.PI}>
	<RigidBody bind:rigidBody enabledRotations={[false, false, false]}>
		<CollisionGroups memberships={[0]} filter={[0]}>
			<Collider shape={'capsule'} args={[height / 2 - radius, radius]} />
			{#if mesh}
				{@render mesh()}
			{:else}
				<T.Mesh geometry={new CapsuleGeometry(0.3, 1.8 - 0.3 * 2)}>
					<T.MeshStandardMaterial color="blue" />
				</T.Mesh>
			{/if}
		</CollisionGroups>
		{#if colliders}
			{@render colliders()}
		{/if}
	</RigidBody>

	{#if children}
		{@render children()}
	{/if}
</T.Group>
