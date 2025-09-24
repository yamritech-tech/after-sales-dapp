const hre = require("hardhat");

async function main() {
  const MyContract = await hre.ethers.getContractFactory("ServiceApresVente");
  const contract = await MyContract.deploy();

  await contract.waitForDeployment();

  console.log("Contract deployed to:", await contract.getAddress());
}

main().catch((error) => {
  console.error("Deployment failed:", error);
  process.exitCode = 1;
});
