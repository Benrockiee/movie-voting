const { ethers, network, run } = require("hardhat")
async function main() {
  const votingFactory = await ethers.getContractFactory("voting")
  console.log("deploying, please wait....")
  const voting = await votingFactory.deploy([
    "0x48656c6c6f20576f726c64210000000000000000000000000000000000000000",
  ])
  await voting.deployed()

  console.log(`contract deployed to :${voting.address}`)

  if (network.config.chainId === 4 && process.env.ETHERSCAN_API_KEY) {
    console.log("awaiting block confirmation")
    await voting.deployTransaction.wait(3)
    await verify(
      voting.address,
      "0x48656c6c6f20576f726c64210000000000000000000000000000000000000000"
    )
  }
}

const verify = async (contractAddress, bytes32) => {
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: [bytes32],
    })
  } catch (e) {
    if (e.message.toLowerCase().includes("Already verified")) {
      console.log("Already verified")
    } else {
      console.log(e)
    }
  }
}

// main
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
