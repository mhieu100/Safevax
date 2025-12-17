const { Web3 } = require('web3');
const dotenv = require('dotenv');
const path = require('path');

// Load environment variables from .env file
const envPath = path.resolve(__dirname, '../.env');
dotenv.config({ path: envPath });

// Ganache URL
const ganacheUrl = process.env.GANACHE_URL || 'http://127.0.0.1:8545';
const web3 = new Web3(ganacheUrl);

async function main() {
    try {
        console.log(`Connecting to Ganache at ${ganacheUrl}...`);

        // Check connection
        try {
            await web3.eth.net.isListening();
        } catch (e) {
            console.error(`Could not connect to ${ganacheUrl}. Please check if Ganache is running.`);
            process.exit(1);
        }

        const accounts = await web3.eth.getAccounts();

        if (!accounts || accounts.length === 0) {
            console.log("No accounts found.");
            return;
        }

        console.log(`\nFound ${accounts.length} accounts:\n`);

        // Header
        const idxLen = 6;
        const addrLen = 44;
        const balLen = 20;

        console.log(
            "Index".padEnd(idxLen) +
            "Address".padEnd(addrLen) +
            "Balance (ETH)".padEnd(balLen)
        );
        console.log("-".repeat(idxLen + addrLen + balLen));

        for (let i = 0; i < accounts.length; i++) {
            const acc = accounts[i];
            const balanceWei = await web3.eth.getBalance(acc);
            const balanceEth = web3.utils.fromWei(balanceWei, 'ether');

            console.log(
                String(i).padEnd(idxLen) +
                String(acc).padEnd(addrLen) +
                String(balanceEth).padEnd(balLen)
            );
        }

        console.log("\n(Private Keys are not exposed via standard Ganache RPC)");

    } catch (error) {
        console.error("Error:", error.message);
    }
}

main();
