import * as fs from 'fs';
import * as path from 'path';

// Define your network and contract address
const NETWORK: string = 'localnet';
const CONTRACT_ADDRESS = '0x60167390ae3ab5902a45fc9e80dd0040100924fedd23d46b77781bd71c168171';

// Helper function to fetch ABI for a module
async function fetchAbi(moduleName: string): Promise<string | null> {
	try {
		let url: string;
		if(NETWORK === "localnet") {
			url = `http://127.0.0.1:8080/v1/accounts/${CONTRACT_ADDRESS}/module/${moduleName}`;
		} else {
			 url = `https://fullnode.${NETWORK}.aptoslabs.com/v1/accounts/${CONTRACT_ADDRESS}/module/${moduleName}`;

		}
		const response = await fetch(url);

		if (!response.ok) {
			console.error(`Error fetching ABI for module ${moduleName}: HTTP ${response.status}`);
			return null;
		}

		const data = await response.json();
		const abi = data.abi;

		if (!abi) {
			console.error(`ABI not found in the response for module: ${moduleName}`);
			return null;
		}

		return JSON.stringify(abi, null, 2);
	} catch (error) {
		console.error(`Error fetching ABI for module ${moduleName}:`, error.message);
		return null;
	}
}

function saveAbiToFile(moduleName: string, abi: string, outputDir: string): void {
	const outputPath = path.join(outputDir, `${moduleName}.abi.ts`);
	const abiContent = `export const ${moduleName}_ABI = ${abi} as const;`;

	fs.writeFileSync(outputPath, abiContent);
	console.log(`ABI for ${moduleName} saved to ${outputPath}`);
}

async function main() {
	const args = process.argv.slice(2);

	if (args.length < 2) {
		console.error('Usage: fetchAbis.ts <output_directory> <module_name1> <module_name2> ...');
		process.exit(1);
	}

	const outputDir = args[0];
	const moduleNames = args.slice(1);

	// Check if the output directory exists, if not, create it
	if (!fs.existsSync(outputDir)) {
		fs.mkdirSync(outputDir, { recursive: true });
	}

	for (const moduleName of moduleNames) {
		const abi = await fetchAbi(moduleName);
		if (abi) {
			saveAbiToFile(moduleName, abi, outputDir);
		} else {
			console.error(`Failed to fetch ABI for module: ${moduleName}`);
		}
	}
}

// Run the script
main();
