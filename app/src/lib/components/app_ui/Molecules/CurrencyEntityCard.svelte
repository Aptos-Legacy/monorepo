<script lang="ts">
	let { amount }: { amount: number } = $props();
</script>

<!-- 
@component
EntityCard represents a game entity
-->

<div
	class="relative aspect-square md:w-[64px] w-[48px] rounded bg-gradient-to-br from-[#55698E] via-[#55698E] to-[#4988AE]"
>
	<div class="h-full w-full p-1">
		<div
			class="h-full w-full bg-center"
			style="background-image: url('/textures/icons/rupee.svg');"
		></div>
	</div>

	<div class="absolute bottom-0 py-0.5 font-bold text-center text-xs w-full bg-black/50">
		{amount}
	</div>
</div>
