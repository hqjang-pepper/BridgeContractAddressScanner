// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BridgeContractScanner is Ownable {

    mapping(string => address) private _ParentBridgeAddress;
    mapping(string => address) private _ChildBridgeAddress;

    function getParentBridgeAddress(string memory symbol) public view returns (address) {
        return _ParentBridgeAddress[symbol];
    }

    function getChildBridgeAddress(string memory symbol) public view returns (address) {
        return _ChildBridgeAddress[symbol];
    }

    function setParentBridgeAddress(string memory symbol, address addr) public onlyOwner {
        _ParentBridgeAddress[symbol] = addr;
    }

    function setChildBridgeAddress(string memory symbol, address addr) public onlyOwner {
        _ChildBridgeAddress[symbol] = addr;
    }
    
    function setBridgeAddresses(string memory symbol, address parentBridgeAddr, address childBridgeAddr) public onlyOwner {
        _ParentBridgeAddress[symbol] = parentBridgeAddr;
        _ChildBridgeAddress[symbol] = childBridgeAddr;
    }

    function deleteBridgeAddresses(string memory symbol) public onlyOwner {
        delete _ParentBridgeAddress[symbol];
        delete _ChildBridgeAddress[symbol];
    }

}
