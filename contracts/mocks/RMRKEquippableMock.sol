// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.14;

import "../RMRK/RMRKEquippable.sol";

//Minimal public implementation of RMRKCore for testing.

error RMRKOnlyIssuer();
error RMRKCoreTransferCallerNotOwnerOrApproved();

contract RMRKEquippableMock is RMRKEquippable {

    address private _issuer;

    constructor(
        string memory name_,
        string memory symbol_
    ) RMRKEquippable(name_, symbol_)
    {
        _setIssuer(_msgSender());
    }

    modifier onlyIssuer() {
        if(_msgSender() != _issuer) revert RMRKOnlyIssuer();
        _;
    }

    function setFallbackURI(string memory fallbackURI) external onlyIssuer {
        _setFallbackURI(fallbackURI);
    }

    function setTokenEnumeratedResource(
        bytes8 resourceId,
        bool state
    ) external onlyIssuer {
        _setTokenEnumeratedResource(resourceId, state);
    }

    function setIssuer(address issuer) external onlyIssuer {
        _setIssuer(issuer);
    }

    function getIssuer() external view returns (address) {
        return _issuer;
    }

    //The preferred method here is to overload the function, but hardhat tests prevent this.
    function mint(address to, uint256 tokenId) external {
        _mint(to, tokenId);
    }

    function burn(uint256 tokenId) public {
        if(!_isApprovedOrOwner(_msgSender(), tokenId)) revert RMRKCoreTransferCallerNotOwnerOrApproved();
        _burn(tokenId);
    }

    function onRMRKNestingReceived(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata
    ) external returns (bytes4) {
        return IRMRKNestingReceiver.onRMRKNestingReceived.selector;
    }

    function addResourceToToken(
        uint256 tokenId,
        bytes8 resourceId,
        bytes8 overwrites
    ) external onlyIssuer {
        if(ownerOf(tokenId) == address(0)) revert ERC721OwnerQueryForNonexistentToken();
        _addResourceToToken(tokenId, resourceId, overwrites);
    }

    function addResourceEntry(
        bytes8 id,
        bytes8 equippableRefId,
        string calldata metadataURI,
        address baseAddress,
        bytes8 slotId,
        bytes16[] calldata custom
    ) external onlyIssuer {
        _addResourceEntry(id, equippableRefId, metadataURI, baseAddress, slotId, custom);
    }

    function setCustomResourceData(
        bytes8 resourceId,
        bytes16 customResourceId,
        bytes memory data
    ) external onlyIssuer {
        _setCustomResourceData(resourceId, customResourceId, data);
    }

    function addCustomDataToResource(
        bytes8 resourceId,
        bytes16 customResourceId
    ) external onlyIssuer {
        _addCustomDataToResource(resourceId, customResourceId);
    }

    function removeCustomDataFromResource(
        bytes8 resourceId,
        uint256 index
    ) external onlyIssuer {
        _removeCustomDataFromResource(resourceId, index);
    }

    function _setIssuer(address issuer) private {
        _issuer = issuer;
    }
}
