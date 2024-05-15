// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.24;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTMarket is ERC721URIStorage {

    uint256 private _tokenID = 0;

    // token details
    constructor() ERC721("Developer NFTs", "DVFT") {}

    // creating a new NFT
    function createNFT(string calldata tokenURI) public returns(uint256) {
        _tokenID++;
        _safeMint(msg.sender, _tokenID);
        _setTokenURI(_tokenID, tokenURI);
        return _tokenID;
    }
}