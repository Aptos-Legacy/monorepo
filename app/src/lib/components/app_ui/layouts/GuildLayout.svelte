<script lang="ts">
	import FullScreenLayout from './FullScreenLayout.svelte';
	let { onExit }: { onExit: VoidFunction } = $props();
</script>

<FullScreenLayout {onExit} title={"Guild"}>
	<div>Store content</div>
</FullScreenLayout>
