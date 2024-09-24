function makeFakeArena(id: number) {
	return {
		id: crypto.randomUUID(),
		name: `Sands of Time ${id}`,
		description: 'So much sand it gets in your boots!',
		rewards: ['gold'],
		monsters: ['frog'],
		levelRecommendation: 1
	};
}

export const ARENAS = new Array(50).fill(0).map((_, i) => makeFakeArena(i));
