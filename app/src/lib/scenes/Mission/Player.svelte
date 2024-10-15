<script lang="ts">
	import { CapsuleGeometry, Euler, Object3D, Vector3 } from 'three';
	import { T, useTask, useThrelte } from '@threlte/core';
	import { RigidBody, CollisionGroups, Collider } from '@threlte/rapier';
	import { createEventDispatcher } from 'svelte';
	import Controller from '$lib/components/app/ThirdPersonControls.svelte';
	import { RigidBody as RapierRigidBody } from '@dimforge/rapier3d-compat';
	import { getUserData, type UserDataContext } from '$lib/types/Context';
	import Knight from '$lib/assets/models/Knight.svelte';
	import { MONSTER_COLLISION_GROUP, PLAYER_COLLISION_GROUP } from '$lib/constants/game';
	import { SvelteSet } from 'svelte/reactivity';

	let {
		position = $bindable(),
		radius = 0.5,
		height = 1,
		speed = 6,
		onHit
	}: {
		position: [x: number, y: number, z: number];
		radius: number;
		speed: number;
		height: number;
		onHit: (tags: string[]) => Promise<void>;
	} = $props();

	let capsule: Object3D = $state(null!);
	let capRef: Object3D = $state(null!);
	$effect(() => {
		if (capsule) {
			capRef = capsule;
		}
	});
	let rigidBody = $state<RapierRigidBody>(null!);
	let hitCollider = $state<Collider>(null!);
	let hitColliderRef = $state<Object3D>(null!);

	let forward = 0;
	let backward = 0;
	let left = 0;
	let right = 0;

	const temp = new Vector3();
	const dispatch = createEventDispatcher();

	let modelRef = $state<Object3D>(null!);
	let grounded = false;
	$effect(() => {
		grounded ? dispatch('groundenter') : dispatch('groundexit');
	});

	// const speed = 5;

	let hitColliderPosition = $state<[x: number, y: number, z: number]>([0, 0, 0]);
	let hitColliderOffset = [0, 0, 0];

	useTask((delta) => {
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

		// FIXME: we need to get the "forward vector" from the model, maybe camera?

		hitColliderPosition = [
			pos.x + hitColliderOffset[0],
			pos.y + hitColliderOffset[1],
			pos.z + hitColliderOffset[2]
		];

		let hitColliderPositionVector = new Vector3(
			hitColliderPosition[0],
			hitColliderPosition[1],
			hitColliderPosition[2]
		);

		//hitColliderPositionVector = hitColliderPositionVector.add(velVec);
		//hitCollider.setTranslation(hitColliderPositionVector);
		//hitColliderRef.setRotationFromQuaternion(capsule.quaternion);

		modelRef.setRotationFromQuaternion(capsule.quaternion);
	});

	let onAttack: VoidFunction = $state(null!);

	function onKeyDown(e: KeyboardEvent) {
		switch (e.code) {
			case 'KeyS':
			case 'ArrowDown':
				backward = 1;
				break;
			case 'ArrowUp':
			case 'KeyW':
				forward = 1;
				break;
			case 'ArrowLeft':
			case 'KeyA':
				left = 1;
				break;
			case 'ArrowRight':
			case 'KeyD':
				right = 1;
				break;
			case ' ':
			case 'Space':
				onAttack();
				if (onHit) {
					onHit([...inRange]);
				}
				break;
			default:
				break;
		}
	}

	function onKeyUp(e: KeyboardEvent) {
		switch (e.code) {
			case 'KeyS':
			case 'ArrowDown':
				backward = 0;
				break;
			case 'ArrowUp':
			case 'KeyW':
				forward = 0;
				break;
			case 'ArrowLeft':
			case 'KeyA':
				left = 0;
				break;
			case 'ArrowRight':
			case 'KeyD':
				right = 0;
				break;
			default:
				break;
		}
	}

	const userData: UserDataContext = {
		tag: 'Player'
	};

	let inRange = new SvelteSet<string>();
</script>

<svelte:window on:keydown|preventDefault={onKeyDown} on:keyup={onKeyUp} />

<T.PerspectiveCamera makeDefault fov={90}>
	<Controller bind:object={capRef} />
</T.PerspectiveCamera>

<T.Group bind:ref={capsule} {position} rotation.y={Math.PI}>
	<RigidBody bind:rigidBody enabledRotations={[false, false, false]} type="dynamic" {userData}>
		<T.Group bind:ref={hitColliderRef}>
			<CollisionGroups groups={[MONSTER_COLLISION_GROUP]}>
				<Collider
					bind:collider={hitCollider}
					sensor
					shape="cuboid"
					args={[1, 0.2, 1]}
					onsensorenter={(e) => {
						const data = getUserData(e.targetRigidBody);
						if (data && data.tag) {
							if (data.tag.startsWith('Monster')) {
								inRange.add(data.tag);
							}
						}
					}}
					onsensorexit={(e) => {
						const data = getUserData(e.targetRigidBody);

						if (data && data.tag) {
							if (data.tag.startsWith('Monster')) {
								inRange.delete(data.tag);
							}
						}
					}}
				/>
			</CollisionGroups>
		</T.Group>
		<CollisionGroups groups={[PLAYER_COLLISION_GROUP]}>
			<Collider shape={'capsule'} args={[height / 2 - radius, radius]} />

			<Knight bind:onAttack bind:ref={modelRef}></Knight>
		</CollisionGroups>
	</RigidBody>
</T.Group>
