// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract Lottery {
    address public owner;
    address payable[] public players;
    uint256 public lotteryId;
    uint256 public sumatotala = 0;

    constructor() {
        owner = msg.sender;
        lotteryId = 0;
    }

    function enter() public payable {
        require(msg.value >= .01 ether, "You don't have enough balance.");
        players.push(payable(msg.sender));
        sumatotala += msg.value;
    }

    function getRandomNumber(uint seed) public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, seed, players)));
    }

    function finalizareTombola() public validEnd{
        uint seed = 0;
        uint index = getRandomNumber(seed) % players.length;
        seed = seed + 1;
        uint index2 = getRandomNumber(seed) % players.length;
        while(index==index2){
            seed = seed + 1;
            index2 = getRandomNumber(seed) % players.length;
        }
        players[index].transfer(address(this).balance * 7 / 10);
        players[index2].transfer(sumatotala / 4);
        lotteryId++;
        
        players = new address payable[](0);
    }

    modifier validEnd(){
        require(msg.sender == owner, "You are not the owner.");
        require(players.length > 1, "Too few participants.");
        _;
    }
}
