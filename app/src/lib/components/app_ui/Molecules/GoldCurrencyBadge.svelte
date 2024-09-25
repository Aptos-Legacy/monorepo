<script lang="ts">
	import BalanceBadge from '../Atoms/BalanceBadge.svelte';
	import GoldLogo from '$lib/assets/icons/currencies/gold.png';
	import { useFormatter } from '$lib/utils';

	let { balance }: { balance: number } = $props();
	const goldFormatter = useFormatter('gold');
</script>

<BalanceBadge logo={GoldLogo} value={goldFormatter.format(balance)}></BalanceBadge>
