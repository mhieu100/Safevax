const { ethers } = require('ethers');
const path = require('path');
const dotenv = require('dotenv');

// Load environment
const envPath = path.resolve(__dirname, '../.env');
dotenv.config({ path: envPath });

// Target address to match (Account 0 from previous step)
const TARGET_ADDRESS = '0x1A0f61D54aBe6C6e1eF4Aa7995070F6eb34cD776';

// Common mnemonics
const CANDIDATES = [
    process.env.MNEMONIC,
    "candy maple cake sugar pudding cream honey rich smooth crumble sweet treat", // Default Ganache
    "myth like bonus scare over problem client lizard pioneer submit female collect"
];

async function main() {
    console.log("Attempting to find private keys for address:", TARGET_ADDRESS);
    let found = false;

    for (let i = 0; i < CANDIDATES.length; i++) {
        const mnemonic = CANDIDATES[i];
        if (!mnemonic || typeof mnemonic !== 'string') continue;

        try {
            // Support both Ethers v5 And v6
            let wallet;
            // Try v6 approach first (Mnemonic object)
            try {
                const mnemonicObj = ethers.Mnemonic.fromPhrase(mnemonic);
                wallet = ethers.HDNodeWallet.fromMnemonic(mnemonicObj);
            } catch (e) {
                // v5 approach
                wallet = ethers.Wallet.fromMnemonic(mnemonic);
            }

            // Ganache uses standard path "m/44'/60'/0'/0/x"
            // Usually derivation path for first account is index 0

            // Derive first account
            let account0;
            if (wallet.derivePath) {
                account0 = wallet.derivePath("m/44'/60'/0'/0/0");
            } else {
                // helper for v5 if needed? usually wallet.fromMnemonic returns master node?
                // Wait, ethers v5 Wallet.fromMnemonic(phi, path) defaults.
                // Let's assume standard derivation.
            }

            if (!account0 && wallet.address) {
                // Maybe it's already a wallet for a path?
                // Default path in ethers v5 is m/44'/60'/0'/0/0
                account0 = wallet;
            }

            // Check address
            if (account0.address.toLowerCase() === TARGET_ADDRESS.toLowerCase()) {
                console.log("\nSUCCESS! Found matching mnemonic.");
                console.log("Mnemonic:", mnemonic);
                console.log("\nPrivate Keys for first 10 accounts:");

                // Print first 10
                const hdNode = (wallet.derivePath) ? wallet : ethers.Wallet.fromMnemonic(mnemonic); // Re-instantiate if needed

                // Re-logic for HDNode because 'wallet' might be a leaf
                // Ethers v6: HDNodeWallet
                // Ethers v5: utils.HDNode

                // Let's rely on constructing wallets per path to be safe/version-agnostic-ish
                for (let k = 0; k < 10; k++) {
                    const path = `m/44'/60'/0'/0/${k}`;
                    let child;
                    // simple retry logic for version diffs
                    if (ethers.HDNodeWallet) {
                        const m = ethers.Mnemonic.fromPhrase(mnemonic);
                        const root = ethers.HDNodeWallet.fromMnemonic(m);
                        child = root.derivePath(path);
                    } else {
                        // v5
                        child = ethers.Wallet.fromMnemonic(mnemonic, path);
                    }
                    console.log(`(${k}) ${child.address} : ${child.privateKey}`);
                }
                found = true;
                break;
            }
        } catch (e) {
            // console.log("Debug: failed for candidate", i, e.message);
        }
    }

    if (!found) {
        console.log("\nCould NOT derive keys from known mnemonics (including env MNEMONIC and defaults).");
        console.log("Your Ganache instance might have been started with a random mnemonic and saved to DB.");
        console.log("You must check the initial logs where Ganache was started, OR use the mnemonic if you know it.");
    }
}

main();
