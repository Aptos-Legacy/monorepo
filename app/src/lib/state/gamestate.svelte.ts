import type { BasePrompt } from '$lib/game/prompts/prompts';
import { getContext } from 'svelte';
import { SvelteMap } from 'svelte/reactivity';
import { AvailableLayouts } from '$lib/types/Layouts';
import type { Character } from './user.svelte';
import type { AptosWalletAdapter } from '$lib/components/app_ui/wallet/wallet.svelte';
import { createEntryPayload } from '@thalalabs/surf';
import * as ABIs from '$lib/network/ABIs';
import { APTOS } from '$lib/network/aptos';
import { sleep, type GetEventsResponse } from '@aptos-labs/ts-sdk';

interface Mission {
	id: number;
	status: 'ongoing' | 'success' | 'failure';
	content: unknown[];
}

export class GameState {
	prompts = new SvelteMap<string, BasePrompt>();
	currentLayout = $state(AvailableLayouts.Explore);
	character = $state<Character | null>(null);

	currentMission = $state<Mission | null>(null);

	/**
	 * Add a prompt to the game state's prompt map. This will allow the UI to display the prompt.
	 * @param id The unique id of the prompt
	 * @param prompt The prompt object
	 */
	addPrompt(id: string, prompt: BasePrompt) {
		this.prompts.set(id, prompt);
	}

	removePrompt(id: string) {
		this.prompts.delete(id);
	}

	navigateTo(layout: AvailableLayouts) {
		this.currentLayout = layout;
	}

	async startNewMission(wallet: AptosWalletAdapter, id: number) {
		// TODO: set in contract
		const payload = createEntryPayload(ABIs.GameManager_ABI, {
			function: 'start_mission',
			functionArguments: [id],
			typeArguments: []
		});
		const resp = await wallet.signAndSubmitTransaction({
			data: payload
		});

		// TODO: Get the mission's content

		this.cleanPrompts();
		this.navigateTo(AvailableLayouts.Explore);
		this.currentMission = {
			content: [],
			id: id,
			status: 'ongoing'
		};
	}

	async endMission(wallet: AptosWalletAdapter) {
		this.cleanPrompts();
		this.navigateTo(AvailableLayouts.MissionResult);
		/*
		const end_mission_payload = createEntryPayload(ABIs.GameManager_ABI, {
			function: 'end_mission',
			typeArguments: [],
			functionArguments: [true]
		});

		const end_mission_response = await wallet.signAndSubmitTransaction({
			data: end_mission_payload
		});

		await APTOS.waitForTransaction({
			transactionHash: end_mission_response.hash
		});

		await sleep(1_000);

		const userAddress = wallet.account!.address as `0x${string}`;
		const distribute_rewards_payload = createEntryPayload(ABIs.GameManager_ABI, {
			function: 'distribute_rewards',
			typeArguments: [],
			functionArguments: [userAddress]
		});

		const distribute_rewards_response = await wallet.signAndSubmitTransaction({
			data: distribute_rewards_payload
		});
		const awaited_distribute = await APTOS.waitForTransaction({
			transactionHash: distribute_rewards_response.hash
		});

		console.log('sender is in');
		const tx = await APTOS.getTransactionByHash({
			transactionHash: awaited_distribute.hash
		});
		await sleep(1_000);

		if ('version' in tx) {
			console.log(awaited_distribute.version, tx.version);
			const events = await APTOS.getEvents({
				options: {
					where: {
						transaction_version: {
							_eq: awaited_distribute.version
						}
					}
				}
			});
			console.dir(tx.events as GetEventsResponse);

			const eventsWeCareAbout = events.filter((e) =>
				e.indexed_type.startsWith(ABIs.GameManager_ABI.address)
			);

			console.dir(events);
			console.dir(eventsWeCareAbout);
		}
		*/
	}

	private cleanPrompts() {
		this.prompts.clear();
		console.log(this.prompts);
	}
}

export const CONTEXT_KEY = 'gamestate';

export function useGameState() {
	return getContext<GameState>(CONTEXT_KEY);
}

export const GAME_STATE = new GameState();
