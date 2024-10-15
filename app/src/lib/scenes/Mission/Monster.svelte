<script lang="ts">
	import { CapsuleGeometry } from 'three';
	import { T, useTask } from '@threlte/core';
	import { RigidBody, CollisionGroups, Collider } from '@threlte/rapier';
	import { RigidBody as RapierRigidBody } from '@dimforge/rapier3d-compat';
	import {
		GROUND_COLLISION_GROUP,
		MONSTER_COLLISION_GROUP,
		PLAYER_COLLISION_GROUP
	} from '$lib/constants/game';
	import type { UserDataContext } from '$lib/types/Context';

	let {
		position = $bindable(),
		id,
		radius = 0.3,
		speed = 6,
		onKill = $bindable()
	}: { id: number; onKill: VoidFunction } = $props();

	let capsule = $state(null!);
	let capRef = $state(null!);

	let rigidBody = $state<RapierRigidBody>(null!);

	let data: UserDataContext = {
		tag: `Monster::${id}`
	};

	import SkeletonMinion from '$lib/assets/models/skeleton/Skeleton_Minion.svelte';
	import type { Component } from 'svelte';
	import { get } from 'svelte/store';

	let target = $state<null | { translation: () => number[] }>(null);
	let targetPosition = $state([4, 10, 0]);

	$inspect(targetPosition);

	useTask((delta) => {
		if (target) {
			targetPosition = target.translation();
		}
	});
	let mesh = $state(null!);
	import * as THREE from 'three';

	onKill = () => {
		target = null;
		targetPosition = [0, 10, 0];
		const actions = get(mesh.actions);
		const actionManager = actions['Death_A'] as THREE.AnimationAction;

		actionManager.loop = THREE.LoopOnce;
		actionManager.play();

		setTimeout(() => {
			actions['Death_A_Pose']?.play();
		}, 600);
	};
</script>

<T.Group bind:ref={capsule} {position} rotation.y={Math.PI} scale={5}>
	<RigidBody bind:rigidBody enabledRotations={[false, false, false]} userData={data}>
		<CollisionGroups
			groups={[GROUND_COLLISION_GROUP, MONSTER_COLLISION_GROUP, PLAYER_COLLISION_GROUP]}
		>
			<Collider shape={'capsule'} args={[0.15, radius]} friction={1000} />

			<SkeletonMinion bind:this={mesh} position.y={-0.5} scale={0.5} lookAt={targetPosition}
			></SkeletonMinion>
		</CollisionGroups>

		<Collider
			shape={'ball'}
			args={[3]}
			sensor={true}
			onsensorenter={(e) => {
				target = e.targetCollider;
			}}
			onsensorexit={(e) => {
				target = null;
			}}
		/>
	</RigidBody>
</T.Group>
