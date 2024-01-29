// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Bank.sol";
contract BankTest is Test{
    PiggyBank private bank;

    constructor() {
        bank = new PiggyBank();
    }

    function testDeposit() public {
        // Call the deposit function and assert the result
        uint256 initialBalance = bank.getBalance();
        uint256 amount = 100;
        bank.deposit{value: amount}();
        uint256 finalBalance = bank.getBalance();
        assert(finalBalance == initialBalance + amount);
    }

    function testWithdraw() public {
    // Deposit some funds
    uint256 depositAmount = 100;
    bank.deposit{value: depositAmount}();
    
    // Attempt to withdraw an amount less than the deposited amount after lock duration
    uint256 withdrawalAmount = 50;
    bool success = bank.withdraw(withdrawalAmount);
    require(success, "Partial withdrawal failed");
    uint256 finalBalance = bank.getBalance();
    require(finalBalance == depositAmount - withdrawalAmount, "Partial withdrawal failed");
    // Attempt to withdraw an amount greater than the deposited amount after lock duration
    uint256 invalidWithdrawalAmount = 200;
    (success, ) = address(bank).call{value: invalidWithdrawalAmount}(abi.encodeWithSignature("withdraw(uint256)", invalidWithdrawalAmount));
    require(!success, "Invalid withdrawal should fail");
    
}
fallback() external payable {}


}
