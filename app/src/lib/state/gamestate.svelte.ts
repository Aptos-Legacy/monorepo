import type { BasePrompt } from '$lib/game/prompts/prompts';
import { getContext } from 'svelte';
import { SvelteMap } from 'svelte/reactivity';
import { AvailableLayouts } from '$lib/types/Layouts';

interface Mission {
	id: number;
	status: 'ongoing' | 'success' | 'failure';
	content: unknown[];
}

export class GameState {
	prompts = new SvelteMap<string, BasePrompt>();
	currentLayout = $state(AvailableLayouts.Explore);

	currentMission = $state<Mission | null>(null);

	addPrompt(id: string, prompt: BasePrompt) {
		this.prompts.set(id, prompt);
	}

	removePrompt(id: string) {
		this.prompts.delete(id);
	}

	navigateTo(layout: AvailableLayouts) {
		this.currentLayout = layout;
	}

	async startNewMission(id: number) {
		// TODO: set in contract

		// TODO: Get the mission's content

		this.cleanPrompts()
		this.navigateTo(AvailableLayouts.Explore);
		this.currentMission = {
			content: [],
			id: id,
			status: 'ongoing'
		};
	}

	async endMission(status: 'success' | 'failure') {
		this.cleanPrompts()

		// TODO: set end state
		// TODO: claim rewards
		// show rewards

		this.currentMission = null;
	}

	private cleanPrompts() {
		this.prompts.clear();
		console.log(this.prompts)
	}
}

export const CONTEXT_KEY = 'gamestate';

export function useGameState() {
	return getContext<GameState>(CONTEXT_KEY);
}

export const GAME_STATE = new GameState();
