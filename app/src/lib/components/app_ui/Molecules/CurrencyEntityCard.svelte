<script lang="ts">
	import GoldIcon from '$lib/assets/icons/currencies/gold.png';
	let { amount }: { amount: number } = $props();
</script>

<!-- 
@component
EntityCard represents a game entity
-->

<div
	class="relative aspect-square w-[48px] rounded bg-gradient-to-br from-[#55698E] via-[#55698E] to-[#4988AE] md:w-[64px]"
>
	<div class="h-full w-full p-1">
		<div
			class="h-full w-full bg-contain bg-center bg-no-repeat"
			style="background-image: url({GoldIcon});"
		></div>
	</div>

	<div class="absolute bottom-0 w-full bg-black/50 py-0.5 text-center text-xs font-bold">
		{amount}
	</div>
</div>
