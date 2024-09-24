<script lang="ts">
	let { onclick }: { onclick: VoidFunction } = $props();
</script>

<button {onclick} class="animate-pulse"> Click to start playing </button>
