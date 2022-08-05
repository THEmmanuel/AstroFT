// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
// Import from the openzepellin erc 721 contract.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AstroFT is ERC721 {
    // struct to hold NFT data attributes.
    struct NFTAttributes {
        string imageURL;
        string date;
        string eventName;
    }

    // Compare NFT attributes for updates.
    function checkNFTAttributes(uint256) public view {}

    function SetNFTImage() public view {
        string memory imageURL;
    }

    function setNFTName() public view {
        string memory eventName;
    }
}
