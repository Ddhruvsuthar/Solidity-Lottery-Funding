//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address public manager ; 
    address payable[] public participants ; // payable declared in array because there are many participants

    constructor()
    {
        manager = msg.sender; // global variable
    }
    receive() external payable  // we can use receive function only one time in our program
    {
        participants.push(payable (msg.sender));

    }
    function getBalance() public view returns (uint){
        require(msg.sender == manager, "You're not a manager");
        return  address(this).balance;
    }

    function random () internal  view returns (uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }   

    function pickWinner() public {
        require (msg.sender == manager);
        require(participants.length>=3);

        uint r = random(); 
        address payable winner ; 

        uint index = r % participants.length;

        winner = participants[index];
        winner.transfer(getBalance());

        participants = new address payable [](0);
               
    }
}