// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.24;

import {ERC721URIStorage, ERC721} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

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

    // buying the NFTs
    function buyNFT(uint256 tokenID) public payable {
        // checking if nft is listed for sale
        NFTListing memory listing = _listings[tokenID];
        require(listing.price > 0, "NFTMarket: NFT not for sale.");

        // checking if price sent to this func is correct
        require(msg.value == listing.price, "NFTMarket: Incorrect price.");

        transferFrom(address(this), msg.sender, tokenID);
        // 5% cut to the market
        payable(listing.seller).transfer(Math.mulDiv(listing.price, 95, 100));
    }

}