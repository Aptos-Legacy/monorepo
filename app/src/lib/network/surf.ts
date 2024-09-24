import { createSurfClient } from '@thalalabs/surf';
import { APTOS } from './aptos';
import * as ABIs from './ABIs';

export const SURF = createSurfClient(APTOS);
type ABI_KEYS = keyof typeof ABIs;

export type Surf = ReturnType<typeof createSurfClient>;
export function useABI(abi: ABI_KEYS, surf?: Surf) {
	if (surf) {
		return surf.useABI(ABIs[abi]);
	} else {
		return SURF.useABI(ABIs[abi]);
	}
}


export function getABI(abi: ABI_KEYS){
	return ABIs[abi] as typeof ABIs[typeof abi];
}

