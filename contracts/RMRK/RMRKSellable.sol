pragma solidity ^0.8.9;

import "./RMRKCore.sol";

contract RMRKSellable is RMRKCore {
    using RMRKLib for uint256;

    constructor(string memory name_, string memory symbol_, string memory resourceName_)
    RMRKCore(name_, symbol_, resourceName_)
    {

    }

    event TokenListedForSale(uint256 tokenId, uint256 tokenPrice);
    event TokenBought(uint256 tokenId);

    mapping(uint256 => uint256) public tokenPrice;

    uint256[] public allTokensOnSale;

    function listForSale(uint256 _tokenId, uint256 _tokenPrice) external onlyIssuer {
        tokenPrice[_tokenId] = _tokenPrice;
        _mint(address(this), _tokenId);

        emit TokenListedForSale(_tokenId, _tokenPrice);
    }

    function buy(uint256 _tokenId) external payable {
        require(ownerOf(_tokenId) == address(this), "Token not for sale");
        require(msg.value >= tokenPrice[_tokenId], "Buy underpriced");
        delete(tokenPrice[_tokenId]); //delete storage value for gas saving
        transfer(msg.sender, _tokenId);

        emit TokenBought(_tokenId);
    }

}
