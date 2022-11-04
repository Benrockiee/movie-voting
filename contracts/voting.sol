//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

error Vote__EntryFeeNotEnough();
error Vote__UserIsNotEligibleToVote();
error Vote__UserAlreadyVoted();
error Vote__OnlyTheChairpersonHasTheRightToAssignVoters();
error Vote__TimeIsInappropriate();

contract Vote {
  struct Voter {
    uint256 vote;
    uint256 weight;
    bool voted;
  }

  struct Proposal {
    bytes32 title;
    uint256 movieVoteCount;
  }

  /* State variables */
  uint256 public immutable i_entryFee;
  uint256 public immutable i_votingStartTime;
  uint256 public immutable i_thursdayVotingEndTime;
  address payable[] private s_voters;

  address public chairperson;

  /* Events */
  event VoteEntry(address indexed user);

  mapping(address => Voter) public voters;

  modifier votingLinesAreOpen(uint256 currentTime) {
    require(currentTime >= i_votingStartTime);
    require(currentTime <= i_thursdayVotingEndTime);
    _;
  }

  modifier isChairPerson() {
    require(msg.sender == chairperson);
    _;
  }

  Proposal[] public proposals;

  /**
   * @param votingStartTime When the voting process will start
   * @param thursdayVotingEndTime When the voting process will end
   */

  /* Functions */

  constructor(
    bytes32[] memory proposalTitles,
    uint256 entryFee,
    uint256 votingStartTime,
    uint256 thursdayVotingEndTime
  ) {
    i_entryFee = entryFee;
    chairperson = msg.sender;
    i_votingStartTime = votingStartTime;
    i_thursdayVotingEndTime = thursdayVotingEndTime;
    voters[chairperson].weight = 1;
    for (uint256 i = 0; i < proposalTitles.length; i++) {
      proposals.push(Proposal({title: proposalTitles[i], movieVoteCount: 0}));
    }
  }

  function giveRightToVote(address voter) external isChairPerson {
    if (msg.sender != chairperson) {
      revert Vote__OnlyTheChairpersonHasTheRightToAssignVoters();
    }

    // require(
    // msg.sender == chairperson,
    // "Only the chairperson has the right to assign voters");

    require(voters[voter].weight == 0);
    voters[voter].weight = 1;
  }

  function EntryVote(uint256 proposal, uint256 currentTime)
    external
    payable
    votingLinesAreOpen(currentTime)
  {
    Voter storage sender = voters[msg.sender];
    if (msg.value < i_entryFee) {
      revert Vote__EntryFeeNotEnough();
    }
    s_voters.push(payable(msg.sender));
    //Emit an event when we update a dynamic array or mapping
    // Named events with the function name reversed
    emit VoteEntry(msg.sender);

    if (sender.weight != 0) {
      revert Vote__UserIsNotEligibleToVote();
    }

    if (!sender.voted) {
      revert Vote__UserAlreadyVoted();
    }

    sender.voted = true;
    sender.vote = proposal;
    proposals[proposal].movieVoteCount += sender.weight;
  }

  /**
   * @dev used to update the voting start & end times
   * @param votingStartTime Start time that needs to be updated
   * @param currentTime Current time that needs to be updated
   */
  function updateVotingStartTime(uint256 votingStartTime, uint256 currentTime)
    public
    view
    isChairPerson
  {
    if (i_votingStartTime < currentTime) {
      revert Vote__TimeIsInappropriate();
    }
  }

  /**
   * Here we winning vote count is initially assigned to 0
   * So we iterate and count through the movie votes to get the winner
   */
  function winningProposal() public view returns (uint256 winningProposal_) {
    uint256 winningVoteCount = 0;
    for (uint256 p = 0; p < proposals.length; p++) {
      if (proposals[p].movieVoteCount > winningVoteCount) {
        winningVoteCount = proposals[p].movieVoteCount;
        winningProposal_ = p;
      }
    }
  }

  /**
   * Here, the movie that won is returned with its title
   */

  function movieWinnerTitle() external view returns (bytes32 winnerTitle_) {
    winnerTitle_ = proposals[winningProposal()].title;
  }

  /** Getter Functions */
  function getEntryFee() public view returns (uint256) {
    return i_entryFee;
  }

  function getVoter(uint256 index) public view returns (address) {
    return s_voters[index];
  }

  /**
   * @dev Gives ending epoch time of voting
   * @return endTime When the voting ends
   */
  function getVotingEndTime() public view returns (uint256 endTime) {
    endTime = i_thursdayVotingEndTime;
  }

  function getNumberOfVoters() public view returns (uint256) {
    return s_voters.length;
  }
}
