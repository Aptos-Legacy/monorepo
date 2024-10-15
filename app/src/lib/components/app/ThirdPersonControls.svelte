<script lang="ts">
	import { Camera, Vector2, Vector3, Quaternion, type Object3D } from 'three';
	import { useParent, useTask } from '@threlte/core';

	export let object: Object3D;
	export let rotateSpeed = 1.0;

	export let idealOffset = { x: -0.5, y: 3, z: -4 };
	export let idealLookAt = { x: 0, y: 1, z: 5 };

	const currentPosition = new Vector3();
	const currentLookAt = new Vector3();

	const rotateDelta = new Vector2();

	const axis = new Vector3(0, 1, 0);
	const rotationQuat = new Quaternion();

	const camera = useParent();

	const isCamera = (p: any): p is Camera => {
		return p.isCamera;
	};

	if (!isCamera($camera)) {
		throw new Error('Parent missing: <PointerLockControls> need to be a child of a <Camera>');
	}

	// This is basically your update function
	useTask((delta) => {
		// the object's position is bound to the prop
		if (!object) return;

		// camera is based on character so we rotate the character first
		rotationQuat.setFromAxisAngle(axis, -rotateDelta.x * rotateSpeed * delta);
		object.quaternion.multiply(rotationQuat);

		// then we calculate our ideal's
		const offset = vectorFromObject(idealOffset);
		const lookAt = vectorFromObject(idealLookAt);

		// and how far we should move towards them
		const t = 1.0 - Math.pow(0.001, delta);
		currentPosition.lerp(offset, t);
		currentLookAt.lerp(lookAt, t);

		// then finally set the camera
		$camera.position.copy(currentPosition);
		$camera.quaternion;
		$camera.lookAt(currentLookAt);
	});

	function vectorFromObject(vec: { x: number; y: number; z: number }) {
		const { x, y, z } = vec;
		const ideal = new Vector3(x, y, z);
		ideal.applyQuaternion(object.quaternion);
		ideal.add(new Vector3(object.position.x, object.position.y, object.position.z));
		return ideal;
	}

	function onKeyDown(event: KeyboardEvent) {
		switch (event.code) {
			case 'KeyA':
			case 'ArrowLeft':
				rotateDelta.x = -2 * rotateSpeed;

				break;
			case 'KeyD':
			case 'ArrowRight':
				rotateDelta.x = 2 * rotateSpeed;
				break;
			default:
				break;
		}
	}

	function onKeyUp(event: KeyboardEvent) {
		switch (event.code) {
			case 'KeyA':
			case 'ArrowLeft':
				rotateDelta.x = 0;
				break;
			case 'KeyD':
			case 'ArrowRight':
				rotateDelta.x = 0;
				break;
			default:
				break;
		}
	}
</script>

<svelte:window on:keydown={onKeyDown} on:keyup={onKeyUp} />
