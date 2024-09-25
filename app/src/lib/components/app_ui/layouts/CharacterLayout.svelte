<script lang="ts">
	import FullScreenLayout from './FullScreenLayout.svelte';
	import AptosLogo from '$lib/assets/icons/currencies/aptos.svg';
	import GoldLogo from '$lib/assets/icons/currencies/gold.png';
	import { useFormatter } from '$lib/utils';

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

	let equipped = $state({
		weapon: null,
		armor: null
	});

	let character = $state({
		name: 'Frog Character',
		stats: characterStats,
		equipped,
		level: 1,
		experience: 2400
	});

	const inventory = new Array(10).fill(0).map((_) => item);

	async function equip(equipment: typeof item, slot: 'weapon' | 'armor') {
		console.log('equip', slot);
		character.equipped[slot] = equipment;
		// TODO: handle transaction on move side
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

		let equippedWeaponStats = character.equipped.weapon?.stats || acc;
		let equippedArmorStats = character.equipped.armor?.stats || acc;

		acc.attack = equippedWeaponStats.attack || 0 + equippedArmorStats.attack || 0;
		acc.defense = equippedWeaponStats.defense || 0 + equippedArmorStats.defense || 0;
		acc.health = equippedWeaponStats.health || 0 + equippedArmorStats.health || 0;
		
		totalEquipmentStats = acc;
	});
	$inspect(character);
</script>

{#snippet EquipmentIcon(equipment?: typeof item)}
	<!-- TODO: handle equipment type for 'not equipped' placeholder icon -->
	<div>
		<div
			class="icon--container aspect-square w-20 rounded-md border-2 duration-100 {equipment
				? ''
				: 'opacity-40'}"
			style="background-image: url({equipment?.icon || '/textures/icons/armor-vest.svg'});"
		></div>
		{#if equipment}
			<div class="text-sm">
				{equipment.name}
			</div>

			{@const nonZeroStats = STATS.map((s) => [s, equipmentStats[s]])
				.filter((v) => v[1] !== 0)
				.map((v) => v[0]) as Stat[]}
			<ul class="mt-1 text-xs">
				{#each nonZeroStats as stat}
					<li>
						{statsFormatter.format(equipmentStats[stat])} <span class="capitalize">{stat}</span>
					</li>
				{/each}
			</ul>
		{/if}
	</div>
{/snippet}

<FullScreenLayout {onExit} title={'Character'}>
	<div class="flex flex-grow items-stretch gap-6">
		<div class=" min-w-[300px] space-y-8">
			<div class="text-lg font-medium">{character.name}</div>

			<div>
				<h3 class="text-sm">Your Stats</h3>
				<div class="grid grid-cols-2 gap-4 py-2">
					{#each STATS as stat}
						<div>
							<h4 class="text-xs uppercase">{stat}</h4>
							<div>
								{characterStats[stat]} + {totalEquipmentStats[stat]}
							</div>
						</div>
					{/each}
				</div>
			</div>
			<div>
				<h3>Current Equipment</h3>
				<div class="grid grid-cols-2 gap-4 py-2">
					<div class="space-y-1">
						<div class="text-xs font-medium uppercase">Weapon</div>

						{@render EquipmentIcon(character.equipped.weapon)}
					</div>
					<div class="space-y-1">
						<div class="text-xs font-medium uppercase">Armor</div>
						{@render EquipmentIcon(character.equipped.armor)}
					</div>
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
					{#each inventory as item}
						<button
							onclick={() => equip(item, 'weapon')}
							class="[&_.icon--container]:hover:border-white"
						>
							{@render EquipmentIcon(item)}
						</button>
					{/each}
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
