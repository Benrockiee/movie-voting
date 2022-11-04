const { ethers } = require("hardhat")

const networkConfig = {
  80001: {
    name: "matic",
    entryFee: ethers.utils.parseEther("0.01"),
  },
  31337: {
    name: "hardhat",
    entryFee: ethers.utils.parseEther("0.01"),
  },
}
const developmentChains = ["hardhat", "localhost"]

module.exports = {
  networkConfig,
  developmentChains,
}
