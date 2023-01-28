const { ethers } = require("hardhat");
const { CRYPTODEVS_NFT_CONTRACT_ADDRESS } = require("../constants");

async function main() {
  const ChekDAO = await ethers.getContractFactory("ChekDAO");
  const chekDAO = await ChekDAO.deploy(CRYPTODEVS_NFT_CONTRACT_ADDRESS, {
    value: ethers.utils.parseEther("0.01"),
  });
  await chekDAO.deployed();

  console.log(`ChekDAO deployed to: ${chekDAO.address}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
