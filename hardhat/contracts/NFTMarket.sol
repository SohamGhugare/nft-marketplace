// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.24;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

struct NFTListing {
    uint256 price;
    address seller;
}

contract NFTMarket is ERC721URIStorage {

    uint256 private _tokenID = 0;

    mapping(uint256 => NFTListing) private _listings;

    // token details
    constructor() ERC721("Developer NFTs", "DVFT") {}

    // creating a new NFT
    function createNFT(string calldata tokenURI) public {
        _tokenID++;
        _safeMint(msg.sender, _tokenID);
        _setTokenURI(_tokenID, tokenURI);
    }

    // listing the NFTs
    function listNFT(uint256 tokenID, uint256 price) public {
        require(price > 0, "NFTMarket: price must be greater than 0");
        approve(address(this), tokenID);

        // transfering ownership of the NFT to the market for listing
        transferFrom(msg.sender, address(this), tokenID);
        _listings[tokenID] = NFTListing(price, msg.sender);
    }

}