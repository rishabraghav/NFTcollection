const { ethers } = require("hardhat");

async function main() {
    const Collection = await ethers.getContractFactory("Collection");
    const collection = await Collection.deploy();

    await collection.deployed();

    console.log("Your contract named 'Collection' is deployed to address: ", collection.address);

}

main().then(() => process.exit(0)).catch((error) => {
    console.log(error);
    process.exit(1);
});