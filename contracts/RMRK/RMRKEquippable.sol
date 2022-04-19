// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.9;

import "./RMRKCore.sol";
import "./interfaces/IRMRKEquippable.sol";

contract RMRKEquippable is RMRKCore, IRMRKEquippable {

  using RMRKLib for bytes8[];

  constructor(string memory name_, string memory symbol_, string memory resourceName)
  RMRKCore(name_, symbol_, resourceName)
  {

  }

  //must check baseResourceIndex for corresponding slotId
  function equip(uint256 _tokenId, uint256 _childIndex, bytes8 _resourceId, bytes8 _slotId) public {

    require(_isApprovedOrOwner(_msgSender(), _tokenId), "Bad owner");
    /* RMRKResourceStorage.Resource memory resource = resourceStorage.getResource(_resourceId);
    require(resource.slotParts.contains(_resourceId), "resource not available in slotParts"); */
    //iterate through array of resources until we land on a match for something that contains the slotPartsId
    //check if child.resource.slotId in any parent.resource.slotParts
    Equipment memory equipment =  Equipment({
      resourceId: _resourceId,
      slotId: _slotId
    });
    _children[_tokenId][_childIndex].equipped = equipment;
  }

  function unequip(uint256 _tokenId, uint256 _childIndex) public {

    require(_isApprovedOrOwner(_msgSender(), _tokenId));
    delete _children[_tokenId][_childIndex].equipped;
  }

  /*
  Equipped memory equipped =  Equipped({
    baseResourceIndex: 0,
    slotId: 0
  });
  */

  function getResourceOfEquipped(uint256 _tokenId, uint256 childIndex) public view returns (Resource memory resource) {
    // check baseResource > Base
    bytes8 resourceId = _children[_tokenId][childIndex].equipped.resourceId;
  }

  /* function getBaseRefOfEquipped(uint256 _tokenId, uint256 childIndex, ) internal {

  } */

}
