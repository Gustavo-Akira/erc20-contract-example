// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20 {

    //views
    function totalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns(uint256);
    function allowance(address owner, address spender) external view returns(uint256);


    //transfer
    function transfer(address recepient, uint256 amount) external  returns(bool);
    function aprove(address spender, uint256 amount) external  returns (bool);
    function transferFrom(address sender, address recepient, uint256 amount) external returns (bool);
    
    //events
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Aprove(address indexed owner, address indexed  spender, uint256 amount);
}


contract AkiraToken is ERC20{
    string public constant name="AkiraToken";
    string public constant symbol="AKR";
    uint8 public  constant decimals=18;

    mapping (address => uint256) balances;

    mapping (address=> mapping(address=>uint256)) allowed;

    uint256 totalSupply_ = 10 ether;

    constructor(){
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address account) public override view returns(uint256) {
        return balances[account];
    }

    function transfer(address recepient, uint256 amount) public override returns(bool) {
        require(amount<= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-amount;
        balances[recepient] = balances[recepient] + amount;
        emit Transfer(msg.sender, recepient, amount);
        return true;
    }

    function aprove(address delegate, uint256 amount) public override returns (bool){
        allowed[msg.sender][delegate] = amount;
        emit Aprove(msg.sender, delegate, amount);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint){
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }


}