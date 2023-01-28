// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

interface ICryptoDevsNFT {
    function balanceOf(address owner) external view returns (uint256);

    function tokenOfOwnerByIndex(
        address owner,
        uint256 index
    ) external view returns (uint256);
}

contract ChekDAO is Ownable {
    enum Vote {
        YAY,
        NAY
    }

    struct Proposal {
        string message;
        uint256 deadline;
        uint256 yayvotes;
        uint256 nayvotes;
        bool executed;
        mapping(uint256 => bool) voters;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public numProposals;

    ICryptoDevsNFT cryptoDevsNFT;

    constructor(address _cryptoDevsNFT) payable {
        cryptoDevsNFT = ICryptoDevsNFT(_cryptoDevsNFT);
    }

    modifier nftHolderOnly() {
        require(cryptoDevsNFT.balanceOf(msg.sender) > 0, "Not a DAO member");
        _;
    }

    modifier activeProposalOnly(uint256 proposalId) {
        require(
            proposals[proposalId].deadline > block.timestamp,
            "Proposal Inactive"
        );
        _;
    }

    modifier inactiveProposalOnly(uint256 proposalId) {
        require(
            proposals[proposalId].deadline <= block.timestamp,
            "proposal active"
        );
        require(proposals[proposalId].executed == false, "already executed");
        _;
    }

    function createProposal(
        string memory _message
    ) external nftHolderOnly returns (uint256) {
        Proposal storage proposal = proposals[numProposals];
        proposal.message = _message;
        proposal.deadline = block.timestamp + 5 minutes;

        numProposals++;
        return numProposals - 1;
    }

    function voteOnProposal(
        uint256 proposalId,
        Vote vote
    ) external nftHolderOnly activeProposalOnly(proposalId) {
        Proposal storage proposal = proposals[proposalId];

        uint256 voterNFTBalance = cryptoDevsNFT.balanceOf(msg.sender);

        uint256 numVotes;

        for (uint256 i = 0; i < voterNFTBalance; ++i) {
            uint256 tokenId = cryptoDevsNFT.tokenOfOwnerByIndex(msg.sender, i);
            if (proposal.voters[tokenId] == false) {
                numVotes++;
                proposal.voters[tokenId] = true;
            }
        }

        require(numVotes > 0, "already voted");

        if (vote == Vote.YAY) {
            proposal.yayvotes += numVotes;
        } else {
            proposal.nayvotes += numVotes;
        }
    }

    function executeProposal(
        uint256 proposalId
    ) external nftHolderOnly inactiveProposalOnly(proposalId) {
        Proposal storage proposal = proposals[proposalId];

        if (proposal.yayvotes > proposal.nayvotes) {
            //this is the part where we can execute anything
        }

        proposal.executed = true;
    }

    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    receive() external payable {}

    fallback() external payable {}
}
