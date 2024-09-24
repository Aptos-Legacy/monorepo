<script lang="ts">
	import { CapsuleGeometry, Euler, Vector3 } from 'three';
	import { T, useTask, useThrelte } from '@threlte/core';
	import { RigidBody, CollisionGroups, Collider } from '@threlte/rapier';
	import { RigidBody as RapierRigidBody } from '@dimforge/rapier3d-compat';
	import type { Snippet } from 'svelte';

	let {
		position,
		radius = 0.3,
		height = 1.7,
		speed = 6,
		children
	}: {
		children: Snippet;
		position: number[];
		radius?: number;
		height?: number;
		speed?: number;
	} = $props();

	let capsule = $state(null!);

	let rigidBody = $state<RapierRigidBody>(null!);
</script>

<T.Group bind:ref={capsule} {position} rotation.y={Math.PI}>
	<RigidBody bind:rigidBody enabledRotations={[false, false, false]} type="fixed">
		<CollisionGroups groups={[0]}>
			<Collider shape={'capsule'} args={[height / 2 - radius, radius]} />
			<T.Mesh geometry={new CapsuleGeometry(0.3, 1.8 - 0.3 * 2)}>
				<T.MeshStandardMaterial color="hotpink" />
			</T.Mesh>
		</CollisionGroups>
	</RigidBody>
	{#if children}
		{@render children()}
	{/if}
</T.Group>
