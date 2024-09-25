<script>
	import { CONTEXT_KEY, GAME_STATE } from '$lib/state/gamestate.svelte';
	import { setContext } from 'svelte';
	import '../app.css';
	import { setAptosQueryContext } from '$lib/network/aptos';

	setContext(CONTEXT_KEY, GAME_STATE);
	setAptosQueryContext();

</script>

<slot></slot>
