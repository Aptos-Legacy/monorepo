import { SURF, useABI } from '$lib/network/surf';
import type { LayoutLoad } from './$types';
import * as ABIs from '$lib/network/ABIs';

export const load = (async () => {
	const queryClient = SURF;

	const accountQueryClient = SURF.useABI(ABIs.Account_ABI);
/*
	const [hasAccount] = await accountQueryClient.view.has_account({
		typeArguments: [],
		functionArguments: ['0x15b0ba37d2fc91c1ea881c58b24c45389612f4ea8495bbfda8c899de18e24fa0']
	});
	console.dir(hasAccount);
*/
	return { queryClient };
}) satisfies LayoutLoad;
