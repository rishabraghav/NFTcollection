// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Collection is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;
    Counters.Counter private _totalMinted;
    
    mapping(address => uint8) mintedAddress;
    mapping(string => uint8) URImapping;
    
    uint public PRICE_PER_TOKEN = 0.01 ether;
    uint public LIMIT_PER_ADDRESS = 2;
    uint public MAX_SUPPLY = 5;

    constructor () ERC721("Collection", "NFT") {}
    
    function setPrice(uint price) external onlyOwner {
        PRICE_PER_TOKEN = price;
    }
    function setLimit(uint limit) external onlyOwner {
        LIMIT_PER_ADDRESS = limit;
    }
    function setMaxSupply(uint maxSupply) external onlyOwner {
        MAX_SUPPLY = maxSupply;
    }

    function mintNFT(string memory tokenURI) payable external returns(uint) {
        require(PRICE_PER_TOKEN <= msg.value, "Not Enough ETH!");
        require(LIMIT_PER_ADDRESS > mintedAddress[msg.sender], "You have exceeded the limit for minting new NFT");
        require(_totalMinted.current() < MAX_SUPPLY, "All the NFTs are minted already");
        require(URImapping[tokenURI] == 0, "You have already minted this NFT");

        URImapping[tokenURI] += 1;
        mintedAddress[msg.sender] += 1;
        _tokenId.increment();
        _totalMinted.increment();

        uint newItemId = _tokenId.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function withdrawMoney() external onlyOwner {
        address payable to = payable(msg.sender);
        to.transfer(address(this).balance);
    }

}

