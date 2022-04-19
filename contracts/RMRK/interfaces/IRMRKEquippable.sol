// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

interface IRMRKEquippable {
  function equip(uint256 _tokenId, uint256 _childIndex, bytes8 _baseResourceId, bytes8 _slotId) external;
  function unequip(uint256 _tokenId, uint256 _childIndex) external;
  /* function getResourceOfEquipped(uint256 _tokenId, uint256 childIndex) external view returns (BaseResource memory baseResource); */
}
