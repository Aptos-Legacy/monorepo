<script lang="ts">
	import Spinner from '$lib/components/app_ui/Atoms/Spinner.svelte';
	import { getWalletContext } from '$lib/components/app_ui/wallet/context';
	import { Button } from '$lib/components/ui/button';
	import { APTOS } from '$lib/network/aptos';
	import { useGameState } from '$lib/state/gamestate.svelte';
	import { AvailableLayouts } from '$lib/types/Layouts';
	import { useFormatter } from '$lib/utils';
	import { onMount } from 'svelte';
	import FullScreenLayout from './FullScreenLayout.svelte';
	import { createEntryPayload } from '@thalalabs/surf';
	import * as ABIs from '$lib/network/ABIs';
	import { sleep, type GetEventsResponse } from '@aptos-labs/ts-sdk';

	type Item = {
		name: string;
		icon: string;
		stats: Stats;
	};

	const STATS = ['health', 'attack', 'defense'] as const;
	type Stat = (typeof STATS)[number];

	type Stats = Record<Stat, number>;
	type Metadata = Awaited<ReturnType<typeof APTOS.getFungibleAssetMetadataByAssetType>>;

	const gameManager = useGameState();
	const statsFormatter = useFormatter('stats');

	const walletContext = getWalletContext();

	// TODO: refactor to a view afterwards
	let events = $state<null | GetEventsResponse>(null);
	/*[
		{
			account_address: '0x0000000000000000000000000000000000000000000000000000000000000000',
			creation_number: 0,
			data: {
				names: ['Frog Armor']
			},
			event_index: 1,
			sequence_number: 0,
			transaction_block_height: 119806,
			transaction_version: 239651,
			type: '0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::DroppedItemsEvent',
			indexed_type:
				'0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::DroppedItemsEvent'
		},
		{
			account_address: '0x0000000000000000000000000000000000000000000000000000000000000000',
			creation_number: 0,
			data: {
				names: ['Frog Armor']
			},
			event_index: 3,
			sequence_number: 0,
			transaction_block_height: 119806,
			transaction_version: 239651,
			type: '0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::DroppedItemsEvent',
			indexed_type:
				'0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::RewardTable::DroppedItemsEvent'
		}
	];
*/

	let status = $state('Registering win...');
	const droppedItems = $derived.by(() => {
		if (events) {
			return events
				.filter((e) => e.indexed_type.endsWith('DroppedItemsEvent'))
				.flatMap((e) => e.data.names);
		} else {
			null;
		}
	});

	let equipmentInfo = $derived.by(() => {
		if (droppedItems) {
			return getEquipmentInfo().then((info) => {
				const relevantInfos = info
					.filter((i) => i.metadata)
					.filter((i) => {
						return droppedItems.includes(i.metadata.name);
					});

				const dropsWithInfo = droppedItems.map(
					(i) => relevantInfos.find((r) => r.metadata.name === i)!
				);
				return dropsWithInfo;
			});
		} else {
			return null;
		}
	});

	async function getEquipmentInfo() {
		const owned = await APTOS.getCurrentFungibleAssetBalances({
			options: {
				where: {
					owner_address: {
						_eq: walletContext.account!.address
					}
				}
			}
		});

		const equipments = owned.filter((o) => o.asset_type !== '0x1::aptos_coin::AptosCoin');

		const assetInfo = (
			await Promise.all(
				equipments.map(async (o) => {
					try {
						let statResource = await APTOS.getAccountResource({
							accountAddress: o.asset_type!,
							resourceType:
								'0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::Stats'
						});

						const metadata = await APTOS.getFungibleAssetMetadataByAssetType({
							assetType: o.asset_type!
						});

						statResource = Object.fromEntries(
							Object.entries(statResource)
								.map((o) => {
									const [key, val] = o;
									return [key, Number(val)];
								})
								.filter((v) => {
									return v[1] !== 0;
								})
						);
						return { [o.asset_type!]: { stats: statResource as Partial<Stats>, metadata } };
					} catch (error) {
						return {};
					}
				})
			)
		).reduce(
			(p, c) => {
				return {
					...p,
					...c
				};
			},
			{} as Record<string, { stats: Stats; metadata: Metadata }>
		);

		return equipments.map((e) => {
			const equipmentStats = assetInfo[e.asset_type!];
			return { ...e, ...equipmentStats };
		});
	}

	onMount(async () => {
		const end_mission_payload = createEntryPayload(ABIs.GameManager_ABI, {
			function: 'end_mission',
			typeArguments: [],
			functionArguments: [true]
		});

		const end_mission_response = await walletContext.signAndSubmitTransaction({
			data: end_mission_payload
		});

		await APTOS.waitForTransaction({
			transactionHash: end_mission_response.hash
		});

		await sleep(1_000);

		const userAddress = walletContext.account!.address as `0x${string}`;
		const distribute_rewards_payload = createEntryPayload(ABIs.GameManager_ABI, {
			function: 'distribute_rewards',
			typeArguments: [],
			functionArguments: [userAddress]
		});

		status = 'Distributing rewards...';

		const distribute_rewards_response = await walletContext.signAndSubmitTransaction({
			data: distribute_rewards_payload
		});

		const awaited_distribute = await APTOS.waitForTransaction({
			transactionHash: distribute_rewards_response.hash
		});

		status = 'Getting rewards info...';

		const tx = await APTOS.getTransactionByHash({
			transactionHash: awaited_distribute.hash
		});
		await sleep(1_000);

		const txEvents = await APTOS.getEvents({
			options: {
				where: {
					transaction_version: {
						_eq: awaited_distribute.version
					}
				}
			}
		});

		const eventsWeCareAbout = txEvents.filter((e) =>
			e.indexed_type.startsWith(ABIs.GameManager_ABI.address)
		);

		events = eventsWeCareAbout;
		allowExit = true;
	});

	let allowExit = $state(false);
</script>

{#snippet EquipmentIcon(equipment: Item)}
	<div>
		<div
			class="icon--container aspect-square w-20 rounded-md border-2 bg-contain bg-center duration-100 {equipment
				? ''
				: 'opacity-40'}"
			style="background-image: url({equipment.icon});"
		></div>
		<div class="text-sm">
			{equipment.name}
		</div>
		<ul class="mt-1 text-xs">
			{#each Object.entries(equipment.stats) as stat}
				<li>
					{statsFormatter.format(stat[1])} <span class="capitalize">{stat[0]}</span>
				</li>
			{/each}
		</ul>
	</div>
{/snippet}

<FullScreenLayout title={'Quest Result'}>
	<div class="flex flex-col items-center justify-center space-y-6">
		<h1 class="text-3xl font-bold uppercase">VICTORY!</h1>

		<div class="flex items-center space-x-4">
			{#if equipmentInfo}
				{#await equipmentInfo}
					<div class="flex h-[120px] flex-col items-center">
						<div>
							<Spinner></Spinner>
						</div>
						<div class="mt-2 animate-pulse text-sm">{status}</div>
					</div>
				{:then resolvedEquipmentInfo}
					{#each resolvedEquipmentInfo as item}
						{@const equipment = {
							name: item.metadata.name,
							icon: item.metadata.icon_uri,
							stats: item.stats
						}}
						{@render EquipmentIcon(equipment)}
					{/each}
				{/await}
			{:else}
				<div class="h-[120px]">
					<Spinner></Spinner>
					<div class="mt-2 animate-pulse text-sm">{status}</div>
				</div>
			{/if}
		</div>
		{#if allowExit}
			<Button
				onclick={() => {
					gameManager.navigateTo(AvailableLayouts.Explore);
					gameManager.currentMission = null;
				}}>Go Back</Button
			>
		{/if}
	</div>
</FullScreenLayout>
