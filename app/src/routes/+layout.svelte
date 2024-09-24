<script>
	import { CONTEXT_KEY, GAME_STATE } from '$lib/state/gamestate.svelte';
	import { setContext } from 'svelte';
	import '../app.css';



	setContext(CONTEXT_KEY, GAME_STATE);
</script>

<slot></slot>
