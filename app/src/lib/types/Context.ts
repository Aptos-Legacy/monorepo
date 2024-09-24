import type { RigidBody } from '@dimforge/rapier3d-compat';

export type UserDataContext = {
	tag: 'Player' | `Monster::${number}` | null;
};

function makeEmptyUserDataContext(): UserDataContext {
	return {
		tag: null
	};
}

export function getUserData(rigidbody: RigidBody | null): UserDataContext {
	if (rigidbody && rigidbody.userData) {
		return rigidbody.userData as UserDataContext;
	} else {
		return makeEmptyUserDataContext();
	}
}
