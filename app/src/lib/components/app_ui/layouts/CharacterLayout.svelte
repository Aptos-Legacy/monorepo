<script lang="ts">
	import FullScreenLayout from './FullScreenLayout.svelte';
	import AptosLogo from '$lib/assets/icons/currencies/aptos.svg';
	import GoldLogo from '$lib/assets/icons/currencies/gold.png';
	import { useFormatter } from '$lib/utils';
	import { APTOS } from '$lib/network/aptos';
	import { getWalletContext } from '../wallet/context';
	import { onMount } from 'svelte';
	import Spinner from '../Atoms/Spinner.svelte';
	import { Button } from '$lib/components/ui/button';
	import { createEntryPayload } from '@thalalabs/surf';
	import { GameManager_ABI } from '$lib/network/ABIs';
	import { useGameState } from '$lib/state/gamestate.svelte';

	let { onExit }: { onExit: VoidFunction } = $props();

	const STATS = ['health', 'attack', 'defense'] as const;
	type Stat = (typeof STATS)[number];

	type Stats = Record<Stat, number>;

	let characterStats: Stats = {
		health: 100,
		defense: 8,
		attack: 0
	};

	let equipmentStats: Stats = {
		defense: 1,
		attack: 2,
		health: 3
	};

	let item = {
		name: 'Frog Armor',
		icon: '/textures/icons/armor-vest.svg',
		stats: equipmentStats
	};

	let character = $state({
		name: 'Frog Character',
		stats: characterStats,
		equipped: null,
		level: 1,
		experience: 2400
	});

	//const inventory = new Array(10).fill(0).map((_) => item);

	async function equip(equipment: typeof item, slot: 'weapon' | 'armor') {
		console.log('equip', slot);
		// TODO: handle transaction on move side instead tbh
		character.equipped = equipment;
	}

	async function unequip() {}

	const statsFormatter = useFormatter('stats');
	const goldFormatter = useFormatter('gold');
	const aptosFormatter = useFormatter('aptos');

	let totalEquipmentStats: Stats = $state({
		attack: 0,
		defense: 0,
		health: 0
	});

	$effect(() => {
		let acc: Stats = {
			attack: 0,
			defense: 0,
			health: 0
		};

		let equippedWeaponStats = character.equipped?.stats || acc;

		totalEquipmentStats = equippedWeaponStats;
	});
	$inspect(character);

	const walletContext = getWalletContext();

	type Metadata = Awaited<ReturnType<typeof APTOS.getFungibleAssetMetadataByAssetType>>;

	async function dothing() {
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
					let statResource = await APTOS.getAccountResource({
						accountAddress: o.asset_type!,
						resourceType:
							'0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171::Equipment::Stats'
					});

					const metadata = await APTOS.getFungibleAssetMetadataByAssetType({
						assetType: o.asset_type!
					});
					console.dir(statResource);

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
	let inventory = $state<ReturnType<typeof dothing>>(null!);

	onMount(() => {
		inventory = dothing();
	});

	// TODO: Get aptos balance
	// TODO: Get Gold balance
	// TODO: get currently equipped
	// TODO: Allow level upping

	let gameState = useGameState();

	async function levelUp(characterName: string) {
		const payload = createEntryPayload(GameManager_ABI, {
			function: 'level_up',
			functionArguments: [characterName],
			typeArguments: []
		});

		walletContext.signAndSubmitTransaction({
			data: payload
		});
	}
</script>

{#snippet EquipmentIcon(equipment?: typeof item)}
	<!-- TODO: handle equipment type for 'not equipped' placeholder icon -->
	<div>
		<div
			class="icon--container aspect-square w-20 rounded-md border-2 bg-contain bg-center duration-100 {equipment
				? ''
				: 'opacity-40'}"
			style="background-image: url({equipment?.icon || '/textures/icons/armor-vest.svg'});"
		></div>
		{#if equipment}
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
		{/if}
	</div>
{/snippet}

<FullScreenLayout {onExit} title={'Character'}>
	<div class="flex flex-grow items-stretch gap-6">
		<div class=" min-w-[300px] space-y-8">
			<div>
				<div class="text-lg font-medium">{character.name}</div>
				<div>Lvl. {character.level}</div>

				<Button
					class="mt-4"
					onclick={() => {
						levelUp(gameState.character!.name);
					}}>Level Up (100 gold)</Button
				>
			</div>
			<div>
				<h3 class="text-sm">Your Stats</h3>
				<div class="grid grid-cols-2 gap-4 py-2">
					{#each STATS as stat}
						<div>
							<h4 class="text-xs uppercase">{stat}</h4>
							<div>
								{characterStats[stat]} +
								<span
									class={totalEquipmentStats[stat] > 0 ? 'text-green-500' : 'text-muted-foreground'}
									>{totalEquipmentStats[stat] || 0}</span
								>
							</div>
						</div>
					{/each}
				</div>
			</div>
			<div>
				<h3>Current Equipment</h3>
				<div class="grid grid-cols-2 gap-4 py-2">
					{@render EquipmentIcon(character.equipped)}
				</div>
			</div>
		</div>
		<div class="flex flex-1 flex-col gap-6">
			<div class="">
				<h3>Currencies</h3>
				<div class="mt-2 flex items-center space-x-4">
					<div class="flex items-center space-x-2 rounded-3xl border bg-muted px-3 py-1">
						<img src={AptosLogo} width="22" alt="Aptos Icon" />
						<span> {aptosFormatter.format(3)} </span>
					</div>

					<div class="flex items-center space-x-2 rounded-3xl border bg-muted px-3 py-1">
						<img src={GoldLogo} width="22" alt="Gold Icon" />
						<span> {goldFormatter.format(300)} </span>
					</div>
				</div>
			</div>
			<div class="flex-grow">
				<h3>Inventory</h3>
				<div class="mt-2 flex flex-wrap gap-4">
					{#if inventory}
						{#await inventory}
							<Spinner></Spinner>
						{:then resolvedInventory}
							{#each resolvedInventory as item}
								{@const equipment = {
									name: item.metadata.name,
									icon: item.metadata.icon_uri,
									stats: item.stats
								}}
								<button
									onclick={() => equip(equipment, 'weapon')}
									class="[&_.icon--container]:hover:border-white"
								>
									{@render EquipmentIcon(equipment)}
								</button>
							{/each}
						{/await}
					{/if}
				</div>
			</div>
		</div>
	</div>
</FullScreenLayout>

<style lang="postcss">
	h3 {
		@apply text-xs font-bold uppercase text-muted-foreground;
	}
</style>
