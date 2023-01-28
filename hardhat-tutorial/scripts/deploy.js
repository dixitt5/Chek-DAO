const { ethers } = require("hardhat");
const { CRYPTODEVS_NFT_CONTRACT_ADDRESS } = require("../constants");

async function main() {
  const fakeNFTMarketplace = await ethers.getContractFactory(
    "fakeNFTMarketplace"
  );
  const FakeNFTMarketplace = await fakeNFTMarketplace.deploy();
  await FakeNFTMarketplace.deployed();

  console.log(`FakeNFTMarketplace deployed to: ${FakeNFTMarketplace.address}`);

  const CryptoDevsDao = await ethers.getContractFactory("CryptoDevsDao");
  const cryptoDevsDao = await CryptoDevsDao.deploy(
    FakeNFTMarketplace.address,
    CRYPTODEVS_NFT_CONTRACT_ADDRESS,
    {
      value: ethers.utils.parseEther("0.01"),
    }
  );
  await cryptoDevsDao.deployed();

  console.log(`CryptoDevsDao deployed to: ${cryptoDevsDao.address}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
