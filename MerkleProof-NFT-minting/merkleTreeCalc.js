const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

// users' addresses for allowlisting
// address should be in lowercase, as `msg.sender` is in lowercase.
const addresses = [
  "0x1",
  "0x2",
  "0x3",
  ...
];
const leaves = addresses.map(address => keccak256(address));
const tree = new MerkleTree(leaves, keccak256, {sortPairs: true});

// rootHash - will be used for merkleRoot in contract.
const rootHash = tree.getHexRoot().toString();

// returns bytes32 array - will be used as param merkleProof
// for minting function
const proof = tree.getHexProof(keccak256('0xAleko'));

console.log("MerkleRoot:", rootHash);
console.log("Merkle Proof for `0xAleko`:", proof);
