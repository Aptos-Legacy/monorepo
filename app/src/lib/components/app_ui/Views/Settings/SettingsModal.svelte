<script lang="ts">
	import { Button } from '$lib/components/ui/button';
	import {
		Dialog,
		DialogContent,
		DialogDescription,
		DialogHeader,
		DialogTitle,
		DialogTrigger
	} from '$lib/components/ui/dialog';
	import { Label } from '$lib/components/ui/label';
	import { Slider } from '$lib/components/ui/slider';
	import {
		Select,
		SelectContent,
		SelectItem,
		SelectTrigger,
		SelectValue
	} from '$lib/components/ui/select';
	import type { Snippet } from 'svelte';

	let graphicsQuality = $state('medium');
	let masterVolume = $state(0);
	let musicVolume = $state(0);
	let sfxVolume = $state(0);

	let { children }: { children?: Snippet } = $props();
</script>

<Dialog>
	{#if children}
		{@render children()}
	{/if}
	<DialogContent class="sm:max-w-[425px]">
		<DialogHeader>
			<DialogTitle>Game Settings</DialogTitle>
			<DialogDescription>
				Adjust your game settings here. Changes will be applied immediately.
			</DialogDescription>
		</DialogHeader>
		<div class="grid gap-4 py-4">
			<div class="grid grid-cols-4 items-center gap-4">
				<Label for="graphics" class="text-right">Graphics</Label>
				<Select value={graphicsQuality} onValueChange={(value) => (graphicsQuality = value)}>
					<SelectTrigger class="col-span-3">
						<SelectValue placeholder="Select quality" />
					</SelectTrigger>
					<SelectContent>
						<SelectItem value="low">Low</SelectItem>
						<SelectItem value="medium">Medium</SelectItem>
						<SelectItem value="high">High</SelectItem>
						<SelectItem value="ultra">Ultra</SelectItem>
					</SelectContent>
				</Select>
			</div>
			<div class="grid grid-cols-4 items-center gap-4">
				<Label for="master-volume" class="text-right">Master Volume</Label>
				<Slider
					id="master-volume"
					max={100}
					value={[masterVolume]}
					onValueChange={([value]) => setMasterVolume(value)}
					class="col-span-3"
				/>
			</div>
			<div class="grid grid-cols-4 items-center gap-4">
				<Label for="music-volume" class="text-right">Music Volume</Label>
				<Slider
					id="music-volume"
					max={100}
					value={[musicVolume]}
					onValueChange={([value]) => setMusicVolume(value)}
					class="col-span-3"
				/>
			</div>
			<div class="grid grid-cols-4 items-center gap-4">
				<Label for="sfx-volume" class="text-right">SFX Volume</Label>
				<Slider
					id="sfx-volume"
					max={100}
					value={[sfxVolume]}
					onValueChange={([value]) => setSfxVolume(value)}
					class="col-span-3"
				/>
			</div>
		</div>
		<DialogTrigger asChild>
			<Button class="w-full">Save Changes</Button>
		</DialogTrigger>
	</DialogContent>
</Dialog>
