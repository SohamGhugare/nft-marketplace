import hre, { ethers } from 'hardhat';
import { expect } from "chai";

describe("NFTMarket", function () {
    // TODO move to fixtures instead of repeated code
    it("Should transmit Transfer event and have correct tokenId", async function () {
        // fetching the contract
        const NFTMarket = await hre.ethers.getContractFactory("NFTMarket")

        // deploying the contract and waiting for its deployment
        const nftMarket = await NFTMarket.deploy()
        await nftMarket.waitForDeployment()

        // executing the transaction
        const tokenURI = 'https://some-token.uri/'
        const transaction = await nftMarket.createNFT(tokenURI)
        await transaction.wait()

        // checking if Transfer is emitted
        const filter = nftMarket.filters.Transfer
        const events = await nftMarket.queryFilter(filter, -1)
        expect(events[0].fragment.name).to.equal("Transfer")

        // assert if new tokenURI is correct
        const tokenID = events[0].args.tokenId
        const mintedTokenURI = await nftMarket.tokenURI(tokenID)
        
        expect(mintedTokenURI).to.equal(tokenURI)

    })

    it("Should have same owner address", async function () {
        // fetching the contract
        const NFTMarket = await hre.ethers.getContractFactory("NFTMarket")

        // deploying the contract and waiting for its deployment
        const nftMarket = await NFTMarket.deploy()
        await nftMarket.waitForDeployment()

        // executing the transaction
        const tokenURI = 'https://some-token.uri/'
        const transaction = await nftMarket.createNFT(tokenURI)
        await transaction.wait()

        // getting tokenID
        const filter = nftMarket.filters.Transfer
        const events = await nftMarket.queryFilter(filter, -1)
        const tokenID = events[0].args.tokenId

        // getting owner address
        const ownerAddress = await nftMarket.ownerOf(tokenID)

        // getting signer address
        const signers = await ethers.getSigners()
        const signerAddress = await signers[0].getAddress()

        // assert if owner address and signer address are same 
        expect(ownerAddress).to.equal(signerAddress)
    })
})