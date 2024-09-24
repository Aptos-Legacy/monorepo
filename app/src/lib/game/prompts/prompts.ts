import type { Component } from 'svelte';
import { AvailableLayouts } from '$lib/types/Layouts';
import { GAME_STATE } from '$lib/state/gamestate.svelte';

export interface BasePrompt {
	label: string;
	icon?: Component;

	onClick: VoidFunction;
}

/// Usecases
/// Open UI layout and navigate to it
/// that's it?

/**
 * Navigates to a given UI Layout when accepted
 */
export class UINavigationPrompt implements BasePrompt {
	label: string;
	icon?: Component;

	target: AvailableLayouts;

	constructor(label: string, target: AvailableLayouts, icon?: Component) {
		this.label = label;
		this.icon = icon;
		this.target = target;
	}

	onClick() {
		GAME_STATE.navigateTo(this.target);
		// console.log('clicked', this.target);
	}
}
