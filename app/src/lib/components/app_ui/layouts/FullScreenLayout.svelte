<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import { Undo2Icon } from 'lucide-svelte';
	import type { Snippet } from 'svelte';

	let { children, onExit, title }: { children: Snippet; onExit: VoidFunction, title: string } = $props();
</script>

<div class="flex h-full w-full flex-col bg-black/60 backdrop-blur-md">
	<div class="flex items-center justify-between bg-red-500/80 p-4 md:p-8">
		<h1>{title}</h1>

		<Button onclick={onExit} size="icon" variant="default" class="rounded-full">
			<Undo2Icon></Undo2Icon>
		</Button>
	</div>

	<div class="flex-grow p-8 flex flex-col overflow-hidden">
		{#if children}
			{@render children()}
		{/if}
	</div>
</div>

<style lang="postcss">
	button[data-selected='true'] {
		@apply scale-105 bg-white text-background;
	}

	button[data-selected='false']:hover {
		@apply scale-105 border-primary;
	}

	h3 {
		@apply text-sm font-semibold uppercase text-muted-foreground;
	}
</style>
