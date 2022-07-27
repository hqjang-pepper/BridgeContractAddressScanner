// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeContractScanner is Ownable {

    mapping(string => address) private _ParentBridgeAddress;
    mapping(string => address) private _ChildBridgeAddress;
    // example - AAA : 0x96DDf6268439475B518D29ee0B925a4428849a85
    // only address 0x96DDf6268439475B518D29ee0B925a4428849a85 can set bridge address of AAA
    mapping(string => address) private _accessMap;

    //only allowed sender can pass this modifier
    modifier onlyAllowed(string memory symbol) {
        require (_accessMap[symbol] == msg.sender, "caller is not admin of following ServiceChain");
        _;
    }

    function getParentBridgeAddress(string memory symbol) public view returns (address) {
        return _ParentBridgeAddress[symbol];
    }

    function getChildBridgeAddress(string memory symbol) public view returns (address) {
        return _ChildBridgeAddress[symbol];
    }

    //adding address to accessmap can be only conducted by contract owner.
    function addAccessMap(string memory symbol, address admin) public onlyOwner {
        _accessMap[symbol] = admin;
    }

    function setParentBridgeAddress(string memory symbol, address parentBridgeAddr) public onlyAllowed(symbol) {
        _ParentBridgeAddress[symbol] = parentBridgeAddr;
    }

    function setChildBridgeAddress(string memory symbol, address childBridgeAddr) public onlyAllowed(symbol) {
        _ChildBridgeAddress[symbol] = childBridgeAddr;
    }

    function setBridgeAddresses(string memory symbol, address parentBridgeAddr, address childBridgeAddr) public onlyAllowed(symbol) {
        _ParentBridgeAddress[symbol] = parentBridgeAddr;
        _ChildBridgeAddress[symbol] = childBridgeAddr;
    }

    function deleteBridgeAddresses(string memory symbol) public onlyAllowed(symbol) {
        delete _ParentBridgeAddress[symbol];
        delete _ChildBridgeAddress[symbol];
    }

}
