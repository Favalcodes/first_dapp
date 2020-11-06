pragma solidity ^0.6.6;

contract Savether {
    address agent;
    address payable public beneficiary;
    uint256 public releaseTime;
    
    mapping(address => uint256) public deposits;
    
    modifier onlyAgent() {
        require(msg.sender == agent);
        _;
    }
    
    constructor(address payable _beneficiary, uint256 _releaseTime) public payable {
        agent = msg.sender;
        require(_releaseTime > block.timestamp);
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
    }
    
    function release() public {
        require(block.timestamp >= releaseTime);
        beneficiary.transfer(address(this).balance);
    }
    
    function withdraw(address payable payee) public onlyAgent {
        uint256 payment = deposits[payee];
        deposits[payee] = 0;
        payee.transfer(payment);
    }
}
