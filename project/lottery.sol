//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

// smart contract for lottery project

contract Lotter {
    //only one centralise authority who is managing to check the winner
    
    address public manager;
    address payable[] public participants;

    constructor()
    {
        manager=msg.sender;
    }
    
    //functon to receive payment from partcipants
    
    receive() external payable
    {
        require(msg.value == 1 ether);
        participants.push(payable(msg.sender));
    }

    //function to check balance
    
    function getBalance() public view returns(uint)
    {
        require(msg.sender == manager);
        return address(this).balance;
    }
    
    //function to select random number
    
    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }
    
    //function to select the winner
    
    function selectWinner() public 
    {
        address winner;
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint r =random();
        uint index = r % participants.length;
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);
    }
}
