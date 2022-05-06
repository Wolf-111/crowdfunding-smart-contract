# Crowdfunding Smart Contract

## What is it?
This is a simple smart contract that acts as an escrow-like account for crowdfunding projects.

## Deploying the smart contract
- Anyone, let's say Bob, deploys the smart contract with the following constructor arguments - `(_title, _description, _endDate, _goalAmount)`
- Title
  - Title/name of the crowdfunding project
- Description
  - Description of the project
- End Date
  - The date when the escrow ends and the raised funds are transferred to the project creator (same as the deployer of the smart contract)
- Goal Amount
  - How much the project creator is trying to raise (in ETH)

## Features
- `commitFunds()`
  - A public, payable function that anyone can send ETH to. Once sent, it will be locked in until either the `endDate` is reached or they cancel their commitment
- `cancelCommitment(uint _amount)`
  - A public function that allows anyone to revoke their commitment or a portion of it (must already have a commitment greater than 0)
- `closeEscrow()`
  - A public function that can only be called when `block.timestamp >= endDate` (aka when the escrow period ends). Once successfully called, any funds held in escrow will get transferred to the deployer of the smart contract
- `goalAmountAchieved`
  - A public boolean that tells you if the fundraising goal has been achieved
- `commitmentAmounts`
  - A public (address => uint) mapping that allows you to check how much any given address has committed to the project
