import type { Surf } from '$lib/network/surf';
import * as ABIs from '$lib/network/ABIs';

export type GameAccount = {
	name: string;
	progress: number;
	characters: { inner: `0x${string}` };
	//Character[];
};

type Address = `0x${string}`;

export type Character = { name: string; level: number; experience: number };

export class UserState {
	surf: Surf;
	userAddress = $state<Address>(null!);
	gameAccount = $state<Promise<GameAccount>>();
	characters = $derived.by(() => {
		if (this.gameAccount) {
			return this.gameAccount.then((a) => {
				return this.getCharacters(this.userAddress)
			});
		} else {
			return [];
		}
	}); // $state();

	// TODO: I guess we'd want the wallet in here? Or just the user's aptos address?
	constructor(userAddress: Address, surf: Surf) {
		this.userAddress = userAddress;
		this.surf = surf;


		$effect(() => {
			this.gameAccount = this.getAccount(this.userAddress)!
		})
	}

	async getAccount(userAddress: `0x${string}`) {
		try {
			const accountClient = this.surf.useABI(ABIs.Account_ABI);

			const [account] = (await accountClient.view.get_player_account_v1({
				typeArguments: [],
				functionArguments: [userAddress]
			})) as unknown as GameAccount[];

			return account;
		} catch (error) {
			console.error(error);
		}
	}

	async getCharacters(player: Address) {
		const [characters] = (await this.surf.useABI(ABIs.Character_ABI).view.get_all_characters_v1({
			typeArguments: [],
			functionArguments: [player]
		})) as unknown as Character[][];

		return characters;
	}
}
