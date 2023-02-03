const hre = require("hardhat");

async function main() {
	var abi = require("../build/Lock2.abi.json");
	var bytecode = require("../build/Lock2.bytecode.json");

	const Lock2Contract = await hre.ethers.getContractFactory(abi, bytecode);
	const lock2 = await Lock2Contract.deploy();
	await lock2.deployed();

	console.log(`Lock2 deployed to: ${lock2.address}`)

}

main();