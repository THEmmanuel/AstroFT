const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const AstroFT = await hre.ethers.getContractFactory("AstroFT");
  const astroFT = await AstroFT.deploy("0x4b48841d4b32C4650E4ABc117A03FE8B51f38F68");

  await astroFT.deployed();

  console.log("astroFT deployed to:", astroFT.address);

  fs.writeFileSync(
    "././astroFT.js", `
    export const astroFT = "${astroFT.address}"`
  )

}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

//npx hardhat verify CONTRACT_ADDR --network mumbai
//npx hardhat verify 0x532C88424404a10A41A1a3bbD6016Aa0b27c909D --network mumbai

//npx hardhat run --network mumbai scripts/deploy.js
