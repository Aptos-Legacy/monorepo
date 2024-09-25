<script lang="ts">
	import BalanceBadge from '../Atoms/BalanceBadge.svelte';
	import AptosLogo from '$lib/assets/icons/currencies/aptos.svg';
	import { useFormatter } from '$lib/utils';

	/// Balance is expected in OCTAS
	let { balance }: { balance: number } = $props();
	const aptosFormatter = useFormatter('aptos');

    const OCTAS_PER_APT = 100_000_000;

    function octas_to_apt(octas: number) {
        return octas / OCTAS_PER_APT
    }
</script>

<BalanceBadge logo={AptosLogo} value={aptosFormatter.format(octas_to_apt(balance))}></BalanceBadge>
