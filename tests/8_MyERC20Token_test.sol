// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

import "remix_tests.sol"; 

import "remix_accounts.sol";
import "../contracts/8_MyERC20Token.sol";

contract testSuite is MyERC20Token {
    address acc0 = TestsAccounts.getAccount(0); //owner by default
    address acc1 = TestsAccounts.getAccount(1);
    address acc2 = TestsAccounts.getAccount(2);

    function testInitialisation() public returns (bool) {
        return 
            Assert.equal(name, "kirillium", "name is not correct") &&
            Assert.equal(symbol, "KLD", "symbol is not correct") &&
            Assert.equal(decimals, 2, "decimals is not correct") &&
            Assert.equal(totalSupply, 1000, "initial totalSupply is not correct");

    }

    function testTransfer() public returns (bool) {
        transfer(acc1, 100);
        transfer(acc2, 200);
        return 
            Assert.equal(balanceOf[acc0], 700, "balance of acc0 is not correct") &&
            Assert.equal(balanceOf[acc1], 100, "balance of acc1 is not correct") &&
            Assert.equal(balanceOf[acc2], 200, "balance of acc2 is not correct");
    }

    /// #sender: account-1
    function approveAcc0FromAcc1() public returns (bool) {
        approve(acc0, 50);
        return 
            Assert.equal(allowance[acc1][acc0], 50, "allowance for acc0 from acc1 is not correct");

    }

    function testTransferFrom() public returns (bool) {
        transferFrom(acc1, acc2, 25);
        return 
            Assert.equal(balanceOf[acc0], 700, "balance of acc0 is not correct") &&
            Assert.equal(balanceOf[acc1], 75, "balance of acc1 is not correct") &&
            Assert.equal(balanceOf[acc2], 225, "balance of acc2 is not correct") && 
            Assert.equal(allowance[acc1][acc0], 25, "allowance for acc0 from acc1 is not correct");
    }
}
    