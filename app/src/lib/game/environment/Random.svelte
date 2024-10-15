<script lang="ts">
	import { PoissonDiscSample as Sampler, type Point } from '$lib/game/utils/sampling';
	// The following components started as copies from https://fun-bit.vercel.app/
	//import Trees from '$lib/assets/models/buildings/building_blacksmith_blue.svelte';
	import Trees from '$lib/assets/models/environment/tree_single_A.svelte';
	//import Bushes from '$lib/assets/models/buildings/building_blacksmith_blue.svelte';
	import Bushes from '$lib/assets/models/environment/bush.svelte';
	//import Rocks from '$lib/assets/models/buildings/building_blacksmith_blue.svelte';
	import { writable } from 'svelte/store';

	export const radius = writable(4);
	export const width = 20;
	export const height = 20;

	const pointsMatrix = [
		{ radius: 6, desription: 'large', density: 55 },
		{ radius: 4, desription: 'medium', density: 55 },
		{ radius: 2, desription: 'small', density: 50 }
	];

	let sampler = new Sampler(pointsMatrix, { width, height }, undefined, Math.random);
	let points: Point[] = sampler.generatePoints();
	let smallObjects = $state(
		points
			.filter((obj) => obj.desription == 'small')
			.map((value) => {
				return [value.x, value.y, Math.random(), Math.random()];
			})
	);
	let mediumObjects = $state(
		points
			.filter((obj) => obj.desription == 'medium')
			.map((value) => {
				return [value.x, value.y, Math.random(), Math.random()];
			})
	);
	let largeObjects = $state(
		points
			.filter((obj) => obj.desription == 'large')
			.map((value) => {
				return [value.x, value.y, Math.random(), Math.random()];
			})
	);

	$effect(() => {
		sampler = new Sampler(pointsMatrix, { width, height }, undefined, Math.random);
		points = sampler.generatePoints();
		smallObjects = points
			.filter((obj) => obj.desription == 'small')
			.map((value) => {
				return [value.x, value.y, Math.random(), Math.random()];
			});
		mediumObjects = points
			.filter((obj) => obj.desription == 'medium')
			.map((value) => {
				return [value.x, value.y, Math.random(), Math.random()];
			});
		largeObjects = points
			.filter((obj) => obj.desription == 'large')
			.map((value) => {
				return [value.x, value.y, Math.random(), Math.random()];
			});
	});
</script>

<Bushes transformData={smallObjects} />
<Trees transformData={mediumObjects} />

<Trees transformData={largeObjects} />
