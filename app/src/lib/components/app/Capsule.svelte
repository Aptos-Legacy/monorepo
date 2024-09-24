<script lang="ts">
	import { CapsuleGeometry } from 'three';
	import { T } from '@threlte/core';
	import { RigidBody, CollisionGroups, Collider } from '@threlte/rapier';
	import { RigidBody as RapierRigidBody } from '@dimforge/rapier3d-compat';

	let { position, radius = 0.3, height = 1.7, speed = 6 } = $props();

	let capsule = $state(null);

	let rigidBody = $state<RapierRigidBody>(null!);

	/*
	useTask(() => {
		if (!rigidBody || !capsule) return;
		// get direction
		const velVec = temp.fromArray([0, 0, forward - backward]); // left - right

		// sort rotate and multiply by speed
		velVec.applyEuler(new Euler().copy(capsule.rotation)).multiplyScalar(speed);

		// don't override falling velocity
		
		const linVel = rigidBody.linvel();
		temp.y = linVel.y;
		// finally set the velocities and wake up the body
		rigidBody.setLinvel(temp, true);

		// when body position changes update camera position
		const pos = rigidBody.translation();
		position = [pos.x, pos.y, pos.z];
	});
	*/
</script>

<T.Group bind:ref={capsule} {position} rotation.y={Math.PI}>
	<RigidBody bind:rigidBody enabledRotations={[false, false, false]}>
		<CollisionGroups groups={[0]}>
			<Collider shape={'capsule'} args={[height / 2 - radius, radius]} />
			<T.Mesh geometry={new CapsuleGeometry(0.3, 1.8 - 0.3 * 2)} />
		</CollisionGroups>
	</RigidBody>
</T.Group>
