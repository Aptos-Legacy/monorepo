export class Monster {
	baseHP: number;
	currentHP: number;

	constructor(baseHP: number, currentHP: number) {
		this.baseHP = baseHP;
		this.currentHP = currentHP;
	}
}
function makeMonster(health: number) {
	let currentHealth = $state(health);
	return new Monster(health, currentHealth);
}


class MissionState {

	

	onHit(target: string){

	}
}
