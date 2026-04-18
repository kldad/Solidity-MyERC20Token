// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

import "remix_tests.sol"; 

import "remix_accounts.sol";
import "../contracts/8_MyERC20Token.sol";

contract testSuite1 {

    MyERC20Token mt;

    address acc0 = TestsAccounts.getAccount(0);
    address acc1 = TestsAccounts.getAccount(1);
    address acc2 = TestsAccounts.getAccount(2);

    function beforeAll() public {
        mt = new MyERC20Token();
    }

    function testInitialisation() public {
        Assert.equal(mt.name(), "kirillium", "name is not correct");
        Assert.equal(mt.symbol(), "KLD", "symbol is not correct");
        Assert.equal(mt.decimals(), 2, "decimals is not correct");
        Assert.equal(mt.totalSupply(), 1000, "initial totalSupply is not correct");
    }

    function testTransfer() public {
        mt.transfer(acc0, 100);
        mt.transfer(acc1, 200);
        mt.transfer(acc2, 300);

        Assert.equal(mt.balanceOf(address(this)), 400, "balance of this is not correct");
        Assert.equal(mt.balanceOf(acc0), 100, "balance of acc0 is not correct");
        Assert.equal(mt.balanceOf(acc1), 200, "balance of acc1 is not correct");
        Assert.equal(mt.balanceOf(acc2), 300, "balance of acc2 is not correct");
    }

    function testTransferFrom() public {
        try mt.transfer(acc1, 1000) returns (bool) {
            Assert.ok(false, "method execution should fail");
        } catch Error(string memory reason) {
            Assert.equal(
                keccak256(abi.encodePacked(reason)), 
                keccak256(abi.encodePacked("ERC20InsufficientBalance")), 
                "failed with unexpected reason"
            );
        } catch (bytes memory) {
            Assert.ok(false, "failed unexpected");
        }
    }
}
    