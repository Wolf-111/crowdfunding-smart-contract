//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

contract CrowdfundingEscrow {
    string public title;
    string public description;
    uint public endDate;
    uint public goalAmount;
    bool public goalAmountAchieved;
    address payable public creator;
    mapping(address => uint) public commitmentAmounts;

    constructor(string memory _title, string memory _description, uint _endDate, uint _goalAmount){
        title = _title;
        description = _description;
        endDate = _endDate;
        goalAmount = _goalAmount;
        creator = payable(msg.sender);
    }

    function commitFunds() public payable {
        require(block.timestamp < endDate, "Error: Escrow is closed");
        require(msg.sender.balance > 0, "Error: No funds");
        require(msg.value > 0, "Error: Amount committed must be greater than 0");
        commitmentAmounts[msg.sender] += msg.value;
        if(address(this).balance >= goalAmount){
            goalAmountAchieved = true;
        }
    }

    // Allow the funds committer to change their mind
    function cancelCommitment(uint _amount) public {
        require(block.timestamp < endDate, "Error: Escrow is closed");
        require(commitmentAmounts[msg.sender] > 0, "Error: No commitment amount found");
        commitmentAmounts[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);

        // The goalAmount can be true but then change to false if
        // someone cancels their commitment
        if(address(this).balance < goalAmount){
            goalAmountAchieved = false;
        }
    }

    // Once endDate is reached, send the funds held in escrow
    // to the owner of the contract
    function closeEscrow() public {
        require(block.timestamp >= endDate, "Error: endDate has not been reached");
        require(address(this).balance > 0, "Error: No funds were raised");
        creator.transfer(address(this).balance);
    }
}