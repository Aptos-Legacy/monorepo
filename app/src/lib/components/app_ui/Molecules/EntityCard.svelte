<script lang="ts">
	import { useFormatter } from '$lib/utils';

	let { chance, name, icon }: { chance: number; name: string; icon: string } = $props();

	const percentageformatter = useFormatter('percent');

	const formatPercentage = (val: number) => percentageformatter.format(val / 100);
</script>

<!-- 
@component
EntityCard represents a game entity
-->
<div class="flex flex-col items-center">
	<div class="relative aspect-square w-[48px] rounded bg-black p-1 md:w-[64px]">
		<div
			class="h-full w-full bg-contain bg-center bg-no-repeat"
			style="background-image: url({icon});"
		></div>

		<div class="absolute bottom-0 w-full bg-black/50 py-0.5 text-center text-xs font-bold">
			{formatPercentage(chance)}
		</div>
	</div>
	<div class="text-sm">
		{name}
	</div>
</div>
