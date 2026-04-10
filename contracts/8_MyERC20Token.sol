// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.34;

import "./7_IERC6093.sol";

contract MyERC20Token is IERC6093 {

    address private owner;

    string public override name;
    string public override symbol;
    uint8 public override decimals;
    mapping (address owner => uint256 balance) public override balanceOf;
    uint256 public override totalSupply;

    mapping (address owner => mapping (address spender => uint256 remaining)) public override allowance;

    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;

        name = "kirillium";
        symbol = "KLD";
        decimals = 2;

        mint(1_0 * (10 ** decimals));
    }

    function _transfer(address from, address to, uint256 amount) internal returns (bool success) {
        if(from == address(0)) {
            revert ERC20InvalidSender(from);
        }
        if(to == address(0) || to == from) {
            revert ERC20InvalidReceiver(to);
        }

        uint256 balance = balanceOf[from];
        if(amount > balance) {
            revert ERC20InsufficientBalance(from, balance, amount);
        }

        unchecked {
            balanceOf[from] -= amount;
        }
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);

        return true;
    }

    function transfer(address to, uint256 amount) public override returns (bool success) {
        return _transfer(msg.sender, to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool success) {
        if(from == msg.sender) {
            revert ERC20InvalidSender(from);
        }

        uint256 _allowance = allowance[from][msg.sender];
        if(amount > _allowance) {
            revert ERC20InsufficientAllowance(msg.sender, _allowance, amount);
        }

        if( _transfer(from, to, amount) ) {
            unchecked {
                allowance[from][msg.sender] -= amount;
            }
            return true;
        } else 
            return false;
    }

    function approve(address spender, uint256 amount) public returns (bool success) {
        if(msg.sender == address(0)) {
            revert ERC20InvalidApprover(msg.sender);
        }
        if(spender == address(0) || spender == msg.sender) {
            revert ERC20InvalidSpender(spender);
        }

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function mint(uint256 amount) public onlyOwner {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);

    }

    function burn(uint256 amount) external onlyOwner {
        uint256 balance = balanceOf[msg.sender];

        if( amount > balance )
            amount = balance;

        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}