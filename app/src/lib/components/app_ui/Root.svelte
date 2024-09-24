<script lang="ts">
	import type { Snippet } from 'svelte';

	let { children }: { children?: Snippet } = $props();
</script>

<div
	class="absolute inset-0 isolate z-50"
	id="ui-root"
	style="box-shadow: 0 0 200px rgba(0,0,0,0.9) inset;"
	data-disable="false"
	>
	{#if children}
		{@render children()}
	{/if}
</div>

<style lang="postcss">
	#ui-root[data-disable="true"] {
		@apply pointer-events-none;
	}

</style>
