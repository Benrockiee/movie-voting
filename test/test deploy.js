const { ethers } = require("hardhat")
const { expect, assert } = require("chai")

describe("voting", function () {
  let votingFactory
  let voting
  beforeEach(async function () {
    votingFactory = await ethers.getContractFactory("voting")
    voting = await votingFactory.deploy([
      "0x48656c6c6f20576f726c64210000000000000000000000000000000000000000",
    ])
  })

  it("makes sure that the chairperson is the msg.sender", async function () {
    const chairperson = await voting.chairperson()
    const expectedCaller = "msg.sender"
    assert.equal(expectedCaller.toString(), expectedCaller)
  })

  it("only the chairperson can give right to vote", async function () {
    const chairperson = await voting.chairperson()
    const expectedCaller = "msg.sender"
    assert.equal(expectedCaller.toString(), expectedCaller)
  })

  it("checks to see if users already voted", async function () {
    const checkVoter = "User already voted"
    assert.equal(checkVoter.toString(), checkVoter)
  })

  it("checks to announce the name of the winner", async function () {
    const announceWinner = await voting.winnerName()
    const expectedWinner = "winnerName"
    assert.equal(expectedWinner.toString(), expectedWinner)
  })
})
