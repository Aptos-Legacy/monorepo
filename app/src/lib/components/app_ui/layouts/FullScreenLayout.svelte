<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import { Undo2Icon } from 'lucide-svelte';
	import type { Snippet } from 'svelte';

	let { children, onExit, title }: { children: Snippet; onExit?: VoidFunction; title: string } =
		$props();
</script>

<div class="flex h-full w-full flex-col bg-black/60 backdrop-blur-md">
	<div class="flex items-center justify-between bg-black p-4 md:p-8">
		<h1 class="text-2xl font-semibold">{title}</h1>

		{#if onExit}
			<Button onclick={onExit} size="icon" variant="default" class="rounded-full">
				<Undo2Icon></Undo2Icon>
			</Button>
		{/if}
	</div>

	<div class="flex flex-grow flex-col overflow-hidden p-8">
		{#if children}
			{@render children()}
		{/if}
	</div>
</div>

<style lang="postcss">
	button[data-selected='true'] {
		@apply text-background scale-105 bg-white;
	}

	button[data-selected='false']:hover {
		@apply border-primary scale-105;
	}

	h3 {
		@apply text-muted-foreground text-sm font-semibold uppercase;
	}
</style>
