// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract PiggyBank {
    struct Deposit {
        address depositor;
        uint amount;
        uint timestamp;
    }

    mapping(address => Deposit) public deposits;
    uint public totalBalance;

    event FundsDeposited(address indexed depositor, uint amount);
    event Withdrawal(address indexed withdrawer, uint amount);

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        
        deposits[msg.sender] = Deposit(msg.sender, msg.value, block.timestamp);
        totalBalance += msg.value;
        
        emit FundsDeposited(msg.sender, msg.value);
    }

    function withdraw(uint amount) public returns (bool) {
    Deposit storage depositInfo = deposits[msg.sender];
    require(depositInfo.amount > 0, "No funds deposited");
    // require(block.timestamp >= depositInfo.timestamp + 1 minutes, "Funds are locked");
    require(amount <= depositInfo.amount, "Withdrawal amount exceeds deposited amount");
    
    uint withdrawAmount = amount;
    depositInfo.amount -= withdrawAmount;
    totalBalance -= withdrawAmount;
    //send to caller
    payable(msg.sender).transfer(withdrawAmount);
    emit Withdrawal(msg.sender, withdrawAmount);
    return true;
}


    function getBalance() public view returns (uint) {
        return totalBalance;
    }
}
