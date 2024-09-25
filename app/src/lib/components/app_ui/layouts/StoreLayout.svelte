<script lang="ts">
	import { onMount } from 'svelte';
	import FullScreenLayout from './FullScreenLayout.svelte';
	import { getAptosQueryContext } from '$lib/network/aptos';
	import { createSurfClient } from '@thalalabs/surf';
	import * as ABIs from '$lib/network/ABIs';
	import { number, string } from 'zod';
	import EquipmentIcon from '../Atoms/EquipmentIcon.svelte';
	import AptosCurrencyBadge from '../Molecules/AptosCurrencyBadge.svelte';
	import * as Dialog from '$lib/components/ui/dialog';
	import { Button } from '$lib/components/ui/button';

	let { onExit }: { onExit: VoidFunction } = $props();

	const aptosQueryClient = getAptosQueryContext();

	let store_offers = $state<
		Promise<[{ icon_uri: string; id: number; name: string; price: number }[]]>
	>(null!);

	onMount(() => {
		const surf = createSurfClient(aptosQueryClient).useABI(ABIs.Store_ABI);

		store_offers = surf.view.get_all_offers_v1({
			typeArguments: [],
			functionArguments: []
		});
	});
</script>

<FullScreenLayout {onExit} title={'Store'}>
	<div>
		<h2 class="text-xl font-medium">Premium Store</h2>
		<div class="mt-4 flex flex-wrap items-center">
			{#if store_offers}
				{#await store_offers}
					<div>loading</div>
				{:then resolved}
					{@const [offers] = resolved}
					{#each offers as offer (offer.id)}
						<Dialog.Root>
							<Dialog.Trigger asChild let:builder>
								<div class="flex flex-col items-center space-y-1 rounded-lg p-1 text-center">
									<EquipmentIcon equipment={offer}></EquipmentIcon>
									<button class="[&>*]:hover:border-white [&>*]:duration-150" use:builder.action>
										<AptosCurrencyBadge balance={offer.price}></AptosCurrencyBadge>
									</button>
								</div>
							</Dialog.Trigger>
							<Dialog.Content>
								<Dialog.Header>
									<Dialog.Title>Buy {offer.name}?</Dialog.Title>
								</Dialog.Header>

								<Dialog.Footer>
									<Button>Yep</Button>
								</Dialog.Footer>
							</Dialog.Content>
						</Dialog.Root>
					{/each}
				{/await}
			{/if}
		</div>
	</div>
</FullScreenLayout>
