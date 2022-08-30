// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

// To-do : do we need multiple admins in single symbol?
contract BridgeContractScanner is Ownable {
    struct chainInfo {
        address parentBridgeAddr;
        address childBridgeAddr;
        string endPointURL;
        string chainSymbol;
        address[] parentBridgeRegisteredTokenList;
	    address[] childBridgeRegisteredTokenList;
    }

    // change : key is chain id, and value is chainInfo
    mapping(uint => chainInfo) private _chainInfoMap;
    mapping(uint => bool) private _chainIDMap;
    mapping(string => uint) private _chainSymbolIDMap;
    uint[] private _chainIDList;
    string[] chainSymbolList;

    // _accessmap example - 5678 : 0x96DDf6268439475B518D29ee0B925a4428849a85
    // only address 0x96DDf6268439475B518D29ee0B925a4428849a85 can set chaininfo of chainID 5678 chain
    mapping(uint => address) private _accessMap;

    // MODIFIERS
    // only allowed sender can pass this modifier
    modifier onlyAllowed(uint _chainID) {
        require (_accessMap[_chainID] == msg.sender, "caller is not admin of following ServiceChain");
        _;
    }
    // chainID cannot be overlapped 
    modifier checkChainID(uint id) {
        require (_chainIDMap[id]==false , "Following chainID is already registered");
        _;
    }

    // adding address to accessmap can be only conducted by contract owner.
    function addAccessMap(uint _chainID, address admin) public onlyOwner checkChainID(_chainID){
        _accessMap[_chainID] = admin;
        _chainIDMap[_chainID] = true;
    }

    function setChainInfoMap(uint _chainID, address _parentBridgeAddr, address _childBridgeAddr, string memory _endPointURL, string memory _symbol) 
    public onlyAllowed(_chainID){
        address[] memory x;
        address[] memory y;

        _chainInfoMap[_chainID] = chainInfo(
            {
                parentBridgeAddr : _parentBridgeAddr,
                childBridgeAddr : _childBridgeAddr,
                endPointURL : _endPointURL,
                chainSymbol : _symbol,
                parentBridgeRegisteredTokenList : x,
                childBridgeRegisteredTokenList : y
            }
        );
        chainSymbolList.push(_symbol);
        _chainSymbolIDMap[_symbol] = _chainID;
        _chainIDList.push(_chainID);
        
    }

    function getParentBridgeAddress(uint _chainID) public view returns (address) {
        return _chainInfoMap[_chainID].parentBridgeAddr;
    }

    function getChildBridgeAddress(uint _chainID) public view returns (address) {
        return _chainInfoMap[_chainID].childBridgeAddr;
    }

    function getEndPointURL(uint _chainID) public view returns (string memory) {
        return _chainInfoMap[_chainID].endPointURL;
    }

    function getChainList() public view returns (string[] memory){
        return chainSymbolList;
    }

    function getChainIdBySymbol(string memory _symbol) public view returns (uint) {
        return _chainSymbolIDMap[_symbol];
    }

    function getParentBridgeRegisteredTokenList(uint _chainID) public view returns (address[] memory) {
        return _chainInfoMap[_chainID].parentBridgeRegisteredTokenList;
    }

    function getChildBridgeRegisteredTokenList(uint _chainID) public view returns (address[] memory) {
        return _chainInfoMap[_chainID].childBridgeRegisteredTokenList;
    }

    function registerToken(uint _chainID, address parentTokenAddress, address childTokenAddress) public onlyAllowed(_chainID) {
        _chainInfoMap[_chainID].parentBridgeRegisteredTokenList.push(parentTokenAddress);
        _chainInfoMap[_chainID].childBridgeRegisteredTokenList.push(childTokenAddress);
    }


    function deleteBridgeAddresses(uint _chainID) public onlyAllowed(_chainID) {
        delete _chainInfoMap[_chainID];
    }

}
