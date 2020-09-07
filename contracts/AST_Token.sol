// SPDX-License-Identifier: MIT

pragma solidity >0.6.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract AST_Token is ERC20 {
    address payable public owner;

    constructor() public ERC20("AssetToken", "AST") {
        _mint(msg.sender, 100 * 10**uint256(decimals()));
        owner = msg.sender;
    }

    // function modifies to check if the caller is the contract owner
    modifier _ownerOnly() {
        _;
        require(msg.sender == owner);
    }

    // mint erc20 tokens by the owner
    function mintToken() public _ownerOnly {
        _mint(msg.sender, 1000);
    }

    // buy erc20 tokens upo exchaning ether(1 token = i wei)
    function buyTokens() public payable {
        owner.transfer(msg.value);
        _mint(msg.sender, msg.value);
    }
}
