<!--
Auto-generated by: https://github.com/threlte/threlte/tree/main/packages/gltf
Command: npx @threlte/gltf@3.0.0-next.7 ./knight/Knight.glb -o ./knight --transform --types
-->

<script lang="ts">
	import * as THREE from 'three';
	import { Group } from 'three';
	import { onMount, type Snippet } from 'svelte';
	import { T, useCamera, type Props, useTask } from '@threlte/core';
	import { useDraco, useGltf, useGltfAnimations } from '@threlte/extras';
	let {
		fallback,
		error,
		children,
		ref = $bindable(),
		onAttack = $bindable(),
		...props
	}: Props<THREE.Group> & {
		ref?: THREE.Group;
		children?: Snippet<[{ ref: THREE.Group }]>;
		fallback?: Snippet;
		onAttack?: VoidFunction;
		error?: Snippet<[{ error: Error }]>;
	} = $props();

	ref = new Group();

	type ActionName =
		| '1H_Melee_Attack_Chop'
		| '1H_Melee_Attack_Slice_Diagonal'
		| '1H_Melee_Attack_Slice_Horizontal'
		| '1H_Melee_Attack_Stab'
		| '1H_Ranged_Aiming'
		| '1H_Ranged_Reload'
		| '1H_Ranged_Shoot'
		| '1H_Ranged_Shooting'
		| '2H_Melee_Attack_Chop'
		| '2H_Melee_Attack_Slice'
		| '2H_Melee_Attack_Spin'
		| '2H_Melee_Attack_Spinning'
		| '2H_Melee_Attack_Stab'
		| '2H_Melee_Idle'
		| '2H_Ranged_Aiming'
		| '2H_Ranged_Reload'
		| '2H_Ranged_Shoot'
		| '2H_Ranged_Shooting'
		| 'Block'
		| 'Block_Attack'
		| 'Block_Hit'
		| 'Blocking'
		| 'Cheer'
		| 'Death_A'
		| 'Death_A_Pose'
		| 'Death_B'
		| 'Death_B_Pose'
		| 'Dodge_Backward'
		| 'Dodge_Forward'
		| 'Dodge_Left'
		| 'Dodge_Right'
		| 'Dualwield_Melee_Attack_Chop'
		| 'Dualwield_Melee_Attack_Slice'
		| 'Dualwield_Melee_Attack_Stab'
		| 'Hit_A'
		| 'Hit_B'
		| 'Idle'
		| 'Interact'
		| 'Jump_Full_Long'
		| 'Jump_Full_Short'
		| 'Jump_Idle'
		| 'Jump_Land'
		| 'Jump_Start'
		| 'Lie_Down'
		| 'Lie_Idle'
		| 'Lie_Pose'
		| 'Lie_StandUp'
		| 'PickUp'
		| 'Running_A'
		| 'Running_B'
		| 'Running_Strafe_Left'
		| 'Running_Strafe_Right'
		| 'Sit_Chair_Down'
		| 'Sit_Chair_Idle'
		| 'Sit_Chair_Pose'
		| 'Sit_Chair_StandUp'
		| 'Sit_Floor_Down'
		| 'Sit_Floor_Idle'
		| 'Sit_Floor_Pose'
		| 'Sit_Floor_StandUp'
		| 'Spellcast_Long'
		| 'Spellcast_Raise'
		| 'Spellcast_Shoot'
		| 'Spellcasting'
		| 'T-Pose'
		| 'Throw'
		| 'Unarmed_Idle'
		| 'Unarmed_Melee_Attack_Kick'
		| 'Unarmed_Melee_Attack_Punch_A'
		| 'Unarmed_Melee_Attack_Punch_B'
		| 'Unarmed_Pose'
		| 'Use_Item'
		| 'Walking_A'
		| 'Walking_B'
		| 'Walking_Backwards'
		| 'Walking_C';
	type GLTFResult = {
		nodes: {
			['1H_Sword_Offhand']: THREE.Mesh;
			Badge_Shield: THREE.Mesh;
			Rectangle_Shield: THREE.Mesh;
			Round_Shield: THREE.Mesh;
			Spike_Shield: THREE.Mesh;
			['1H_Sword']: THREE.Mesh;
			['2H_Sword']: THREE.Mesh;
			Knight_Helmet: THREE.Mesh;
			Knight_Cape: THREE.Mesh;
			Knight_ArmLeft: THREE.SkinnedMesh;
			Knight_ArmRight: THREE.SkinnedMesh;
			Knight_Body: THREE.SkinnedMesh;
			Knight_Head: THREE.SkinnedMesh;
			Knight_LegLeft: THREE.SkinnedMesh;
			Knight_LegRight: THREE.SkinnedMesh;
			root: THREE.Bone;
		};
		materials: {
			knight_texture: THREE.MeshStandardMaterial;
			knight_texture: THREE.MeshStandardMaterial;
		};
	};

	import Model from './Knight-transformed.glb?url';

	const draco = useDraco();
	const gltf = useGltf<GLTFResult>(Model, { dracoLoader: draco });

	export const { actions, mixer } = useGltfAnimations<ActionName>(gltf, ref);

	onMount(() => {
		actions.subscribe((v) => {
			if (v) {
				$actions['Idle']?.play();
			}
		});

		gltf.then((g) => {
			g.nodes['1H_Sword_Offhand'].clear();

			//.scale = new Vector3(1,2,1);
			// const myCollider = new Collider()

			// g.nodes["1H_Sword"].
		});
	});

	let allowNext = true;

	onAttack = () => {
		const duration = 0.5;

		const actionManager = $actions['1H_Melee_Attack_Slice_Horizontal']!;
		actionManager.loop = THREE.LoopOnce;

		actionManager.setDuration(duration).play();
		setTimeout(() => {
			actionManager.stop();
			$actions['Idle']!.play();

			allowNext = true;
		}, duration * 1000);

		console.log('stopped');
	};

	// ref.lookAt($camera.)
	import { AutoColliders } from '@threlte/rapier';
	import { Vector3 } from '@dimforge/rapier3d-compat';
	import { RigidBody, CollisionGroups, Collider } from '@threlte/rapier';

	useTask((delta) => {});
</script>

<T is={ref} dispose={false} {...props} scale={0.5} position.y={-0.5}>
	{#await gltf}
		{@render fallback?.()}
	{:then gltf}
		<T.Group name="Scene" rotation.y={Math.PI}>
			<T.Group name="Rig">
				<T is={gltf.nodes.root} />
				<T.SkinnedMesh
					name="Knight_ArmLeft"
					geometry={gltf.nodes.Knight_ArmLeft.geometry}
					material={gltf.materials.knight_texture}
					skeleton={gltf.nodes.Knight_ArmLeft.skeleton}
				></T.SkinnedMesh>
				<T.SkinnedMesh
					name="Knight_ArmRight"
					geometry={gltf.nodes.Knight_ArmRight.geometry}
					material={gltf.materials.knight_texture}
					skeleton={gltf.nodes.Knight_ArmRight.skeleton}
				></T.SkinnedMesh>
				<T.SkinnedMesh
					name="Knight_Body"
					geometry={gltf.nodes.Knight_Body.geometry}
					material={gltf.materials.knight_texture}
					skeleton={gltf.nodes.Knight_Body.skeleton}
				/>
				<T.SkinnedMesh
					name="Knight_Head"
					geometry={gltf.nodes.Knight_Head.geometry}
					material={gltf.materials.knight_texture}
					skeleton={gltf.nodes.Knight_Head.skeleton}
				/>
				<T.SkinnedMesh
					name="Knight_LegLeft"
					geometry={gltf.nodes.Knight_LegLeft.geometry}
					material={gltf.materials.knight_texture}
					skeleton={gltf.nodes.Knight_LegLeft.skeleton}
				/>
				<T.SkinnedMesh
					name="Knight_LegRight"
					geometry={gltf.nodes.Knight_LegRight.geometry}
					material={gltf.materials.knight_texture}
					skeleton={gltf.nodes.Knight_LegRight.skeleton}
				/>
			</T.Group>
		</T.Group>
	{:catch err}
		{@render error?.({ error: err })}
	{/await}

	{@render children?.({ ref })}
</T>
