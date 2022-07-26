
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction{
    
    address public holder;
    string public item;
    uint public Cost;
    address public potentialBuyer;
    bool public Trade;

    modifier onlyHolder() {
        require(msg.sender == holder, "Auction: Only the owner of the item can stop the auction");
        _;
    }

    constructor (address _holder, string memory _item, uint  _startCost) {
        holder = _holder;
        item = _item;
        Cost = _startCost;
    }

    function makeRate (uint _rate) public {
        require(Trade == true, "Auction: Auction ended or not started");
        require(_rate > Cost, "Auction: Your bid is less than the current one");
        Cost = _rate;
        potentialBuyer = msg.sender;
    }
    
    function stateAuction(bool _trade) public onlyHolder{

        if (_trade == false) {
            Trade = false;
        }
        else {
            Trade = true;
        }
    }

    function payItem() public payable {
        require(Trade == false, "Auction: Auction not over yet");
        require(potentialBuyer == msg.sender, "Auction: You are not a potential buyer");
        require(Cost*10**18 == msg.value, "Auction: Insufficient funds");
    }
    
    function takeMoney() public onlyHolder{
        require(Trade == false, "Auction: Auction not over yet");
        require(address(this).balance == Cost*10**18, "Auction: Haven't paid for the item yet.");
        address payable _to = payable(holder);
        _to.transfer(address(this).balance);
    }
}
