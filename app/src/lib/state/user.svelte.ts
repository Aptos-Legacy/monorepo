import type { Surf } from '$lib/network/surf';
import * as ABIs from '$lib/network/ABIs';
import { createEntryPayload, createSurfClient, createViewPayload } from '@thalalabs/surf';
import type { Account } from '@aptos-labs/ts-sdk';
import type { AccountInfo } from '@aptos-labs/wallet-adapter-core';

export type GameAccount = {
	name: string;
	progress: number;
	characters: { inner: `0x${string}` };
	//Character[];
};

type Address = `0x${string}`;

export type Character = { name: string; level: number };

export class UserState {
	surf: Surf;
	userAddress = $state<Address | null>(null);
	gameAccount = $state<Promise<GameAccount | null>>();
	characters = $state<Promise<Character[]> | null>(null);
	currentCharacter = $state<string | null>(null);

	aptosBalance = $state(0);
	goldBalance = $state(0);

	// TODO: I guess we'd want the wallet in here? Or just the user's aptos address?
	constructor(userAddress: Address | null, surf: Surf) {
		this.userAddress = userAddress;
		this.surf = surf;

		$effect(() => {
			if (this.userAddress) {
				this.gameAccount = this.getAccount(this.userAddress)!;
			} else {
				this.gameAccount = Promise.resolve(null);
			}
		});

		$effect(() => {
			if (this.gameAccount) {
				this.characters = this.gameAccount.then((_) => {
					return this.getCharacters(this.userAddress!);
				});
			} else {
				this.characters = null;
			}
		});
	}

	async getAccount(userAddress: `0x${string}`) {
		console.log(userAddress);
		try {
			const accountClient = this.surf.useABI(ABIs.Account_ABI);

			const [account] = (await accountClient.view.get_player_account({
				typeArguments: [],
				functionArguments: [userAddress]
			})) as unknown as GameAccount[];

			return account;
		} catch (error) {
			console.error(error);
			return null;
		}
	}

	async getCharacters(player: Address) {
		const [characters] = (await this.surf.useABI(ABIs.Character_ABI).view.get_all_characters({
			typeArguments: [],
			functionArguments: [player]
		})) as unknown as Character[][];

		return characters;
	}

	useCharacter(name: string) {
		this.currentCharacter = name;
	}

	createAccountPayload(name: string) {
		return createEntryPayload(ABIs.GameManager_ABI, {
			function: 'create_account',
			typeArguments: [],
			functionArguments: [name]
		});
	}

	createCharacterPayload(name: string) {
		return createEntryPayload(ABIs.Character_ABI, {
			function: 'create_new_character',
			typeArguments: [],
			functionArguments: [name]
		});
	}
}
