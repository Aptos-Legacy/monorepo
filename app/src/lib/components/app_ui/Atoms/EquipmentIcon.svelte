<script lang="ts">
	import { useFormatter } from "$lib/utils";

	const STATS = ['health', 'attack', 'defense'] as const;
	type Stat = (typeof STATS)[number];

	type Stats = Record<Stat, number>;

	let { equipment }: { equipment: { name: string; icon_uri: string; stats?: Stats } } = $props();
    const statsFormatter = useFormatter('stats');

</script>

<!-- TODO: handle equipment type for 'not equipped' placeholder icon -->
<div>
	<div
		class="icon--container bg-center bg-contain aspect-square w-28 rounded-md border-2 duration-100 {equipment
			? ''
			: 'opacity-40'}"
		style="background-image: url({equipment.icon_uri || '/textures/icons/armor-vest.svg'});"
	></div>
	<div class="text-xs uppercase mt-0.5">
		{equipment.name}
	</div>

	{#if equipment.stats}
		{@const nonZeroStats = STATS.map((s) => [s, equipment.stats[s]])
			.filter((v) => v[1] !== 0)
			.map((v) => v[0]) as Stat[]}
		<ul class="mt-1 text-xs">
			{#each nonZeroStats as stat}
				<li>
					{statsFormatter.format(equipmentStats[stat])} <span class="capitalize">{stat}</span>
				</li>
			{/each}
		</ul>
	{/if}
</div>
