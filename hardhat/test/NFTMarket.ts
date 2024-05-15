import hre from 'hardhat';
import { expect } from "chai";

describe("NFTMarket", function () {
    it("Should transmit Transfer event", async function () {
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

        // checking if tokenURI is correct
        const tokenID = events[0].args.tokenId
        const mintedTokenURI = await nftMarket.tokenURI(tokenID)
        
        expect(mintedTokenURI).to.equal(tokenURI)

    })
})