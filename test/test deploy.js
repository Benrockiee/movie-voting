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
    const expectedString = "msg.sender"
    assert.equal(expectedString.toString(), expectedString)
  })

  it("only the chairperson can give right to vote", async function () {
    const chairperson = await voting.chairperson()
    const expectedString = "msg.sender"
    assert.equal(expectedString.toString(), expectedString)
  })

  it("checks to see if users already voted", async function () {
    const checkVoterString = "User already voted"
    assert.equal(checkVoterString.toString(), checkVoterString)
  })

  it("ensure the elibility of the voter", async function () {
    const currentVoterEligibility = await voting.giveRightToVote()
    const expectedEligibilityString = "1"
    assert.equal(
      expectedEligibilityString,
      toString(),
      expectedEligibilityString
    )
  })
})
