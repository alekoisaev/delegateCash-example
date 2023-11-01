// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC721A} from "erc721a/contracts/ERC721A.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

error NotAllowedUser();
error AllowlistUsed();

contract NFTSaleMerkleTree is ERC721A {
    bytes32 public merkleRoot;

    constructor(bytes32 _merkleRoot) ERC721A("Token", "TKN") {
        merkleRoot = _merkleRoot;
    }

    function validateSender(bytes32[] calldata _merkleProof) internal view {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        if (!MerkleProof.verifyCalldata(_merkleProof, merkleRoot, leaf)) revert NotAllowedUser();
    }

    function allowedUserMint(bytes32[] calldata merkleProof) external {
        // if a user used their allowlist
        if (_getAux(msg.sender) != 0) revert AllowlistUsed();

        // validate merkle proof
        validateSender(merkleProof);

        // Mark that the user's allowlist is used.
        _setAux(msg.sender, 1);

        // mint NFT to the user
        _mint(msg.sender, 1);
    }

    // override erc721a's built-in method
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }
}
