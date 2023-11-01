// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "erc721a/contracts/ERC721A.sol";

interface IDelegateRegistry {
    function checkDelegateForERC721(
        address to, address from, address contract_,
        uint256 tokenId, bytes32 rights
    ) external view returns (bool);
}

error NotOwnerOrDelegater();

contract AzukiKatanas is ERC721A {
    // delegate registry v2 addr on EVM chains
    address constant public REGISTRY_ADDRESS = 0x00000000000000447e69651d841bD8D104Bed493;

    address constant public AZUKI_CONTRACT = 0xED5AF388653567Af2F388E6224dC7C4b3241C544;

    constructor() ERC721A("Azuki Katanas", "KATANA") {}

    function mintKatana(uint256 azukiTokenId, uint256 _katanasCount) external {
        address azukiOwner = ERC721A(AZUKI_CONTRACT).ownerOf(azukiTokenId);

        if (msg.sender == azukiOwner ||
            IDelegateRegistry(REGISTRY_ADDRESS).checkDelegateForERC721(
                msg.sender,
                azukiOwner,
                AZUKI_CONTRACT,
                azukiTokenId,
                ""
            )
        ) {
            _mint(azukiOwner, _katanasCount);
        } else {
            revert NotOwnerOrDelegater();
        }
    }
}
