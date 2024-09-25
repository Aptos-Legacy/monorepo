function makeFakeArena(id: number) {
	return {
		id: id,
		name: `Sands of Time ${id}`,
		description: 'So much sand it gets in your boots!',

		levelRecommendation: 1
	};
}

export const ARENAS = new Array(3).fill(0).map((_, i) => makeFakeArena(i+1));
