// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

// To-do : do we need multiple admins in single symbol?
contract BridgeContractScanner is Ownable {
    struct chainInfo {
        address parentBridgeAddr;
        address childBridgeAddr;
        string endPointURL;
        uint chainID;
    }

    mapping(string => chainInfo) private _chainInfoMap;

    //since we can't set struct with empty mapping, let's seperate them.
    mapping(address => address[]) private _ParentBridgeRegisteredTokenList;
    mapping(address => address[]) private _ChildBridgeRegisteredTokenList;

    mapping(uint => bool) private _chainIDList;

    // _accessmap example - AAA : 0x96DDf6268439475B518D29ee0B925a4428849a85
    // only address 0x96DDf6268439475B518D29ee0B925a4428849a85 can set bridge address of AAA
    mapping(string => address) private _accessMap;

    // MODIFIERS
    // only allowed sender can pass this modifier
    modifier onlyAllowed(string memory symbol) {
        require (_accessMap[symbol] == msg.sender, "caller is not admin of following ServiceChain");
        _;
    }
    // chainID cannot be overlapped 
    modifier checkChainID(uint id) {
        require (_chainIDList[id] == false, "Following chainID is already registered");
        _;
    }

    // adding address to accessmap can be only conducted by contract owner.
    function addAccessMap(string memory symbol, address admin) public onlyOwner {
        _accessMap[symbol] = admin;
    }

    function setChainInfoMap(string memory _symbol, address _parentBridgeAddr, address _childBridgeAddr, string memory _endPointURL, uint _chainID) 
    public onlyAllowed(_symbol) checkChainID(_chainID) {
        _chainInfoMap[_symbol] = chainInfo(
            {
                parentBridgeAddr : _parentBridgeAddr,
                childBridgeAddr : _childBridgeAddr,
                endPointURL : _endPointURL,
                chainID : _chainID
            }
        );
    }

    function getParentBridgeAddress(string memory symbol) public view returns (address) {
        return _chainInfoMap[symbol].parentBridgeAddr;
    }

    function getChildBridgeAddress(string memory symbol) public view returns (address) {
        return _chainInfoMap[symbol].childBridgeAddr;
    }

    function getEndPointURL(string memory symbol) public view returns (string memory) {
        return _chainInfoMap[symbol].endPointURL;
    }

    function registerToken(string memory symbol, address parentTokenAddress, address childTokenAddress) public onlyAllowed(symbol) {
        address _parentBridgeAddr = _chainInfoMap[symbol].parentBridgeAddr;
        address _childBridgeAddr = _chainInfoMap[symbol].childBridgeAddr;
        _ParentBridgeRegisteredTokenList[_parentBridgeAddr].push(parentTokenAddress);
        _ChildBridgeRegisteredTokenList[_childBridgeAddr].push(childTokenAddress);
    }

    function getParentBridgeTokenList(address _parentBridgeAddr) public view returns (address[] memory) {
        return _ParentBridgeRegisteredTokenList[_parentBridgeAddr];
    }

    function getChildBridgeTokenList(address _childBridgeAddr) public view returns (address[] memory) {
        return _ChildBridgeRegisteredTokenList[_childBridgeAddr];
    }

    function deleteBridgeAddresses(string memory symbol) public onlyAllowed(symbol) {
        delete _chainInfoMap[symbol];
    }

}
