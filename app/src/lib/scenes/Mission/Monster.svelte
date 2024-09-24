<script lang="ts">
	import { CapsuleGeometry } from 'three';
	import { T } from '@threlte/core';
	import { RigidBody, CollisionGroups, Collider } from '@threlte/rapier';
	import { RigidBody as RapierRigidBody } from '@dimforge/rapier3d-compat';
	import { GROUND_COLLISION_GROUP, MONSTER_COLLISION_GROUP } from '$lib/constants/game';
	import type { UserDataContext } from '$lib/types/Context';

	let {
		position = $bindable(),
		id,
		radius = 0.3,
		height = 1.7,
		speed = 6
	}: { id: number } = $props();

	let capsule = $state(null!);
	let capRef = $state(null!);

	let rigidBody = $state<RapierRigidBody>(null!);

	let data: UserDataContext = {
		tag: `Monster::${id}`
	};
</script>

<T.Group bind:ref={capsule} {position} rotation.y={Math.PI}>
	<RigidBody bind:rigidBody enabledRotations={[false, false, false]} userData={data}>
		<CollisionGroups groups={[GROUND_COLLISION_GROUP, MONSTER_COLLISION_GROUP]}>
			<Collider shape={'capsule'} args={[height / 2 - radius, radius]} />
			<T.Mesh geometry={new CapsuleGeometry(0.3, 1.8 - 0.3 * 2)}>
				<T.MeshStandardMaterial color="red" />
			</T.Mesh>
		</CollisionGroups>
	</RigidBody>
</T.Group>
