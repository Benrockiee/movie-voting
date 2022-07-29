const { ethers } = require("hardhat")
async function main() {
  const votingFactory = await ethers.getContractFactory()
  console.log("deploying, please wait....")
  const voting = await votingFactory.deploy()
  await voting.deployed()
  console.log(`contract deployed to :${voting.address}`)
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
