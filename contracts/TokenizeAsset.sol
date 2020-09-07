// SPDX-License-Identifier: MIT

pragma solidity >0.6.0;
pragma experimental ABIEncoderV2;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract TokenizeAsset is ERC721 {
    constructor() public ERC721("MyAsset", "MST") {}

    struct Asset {
        string name;
        uint256 price;
        uint256 tokenId;
        address[] previousOwners;
    }

    //array of all assests for sale
    Asset[] public assets;
    uint256 tokenId;

    //mapping between the user address and all the assest he has
    mapping(address => Asset[]) assetUserMapping;

    //mapping between the user address,token id and the particular Asset
    mapping(address => mapping(uint256 => Asset)) assetUserTokenMapping;

    // mapping between the tokenId and the asset;
    mapping(uint256 => Asset) tokenIdMapping;

    //function to list your asset for sale, unique ERC721 token will be generated for your asset
    function listAssetForSale(string memory _name, uint256 _price) public {
        tokenId = assets.length + 1;
        Asset memory _asset;
        _asset.name = _name;
        _asset.price = _price;
        _asset.tokenId = tokenId;
        _mint(msg.sender, tokenId);

        assetUserMapping[msg.sender].push(_asset);
        assetUserTokenMapping[msg.sender][tokenId] = _asset;
        tokenIdMapping[tokenId] = _asset;
        assets.push(_asset);
    }

    //function to resale an existing asset
    function repostAssetForSale(uint256 _price, uint256 _tokenId) public {
        Asset memory _asset;
        _asset = assetUserTokenMapping[msg.sender][_tokenId];
        _asset.price = _price;
        assetUserTokenMapping[msg.sender][_tokenId] = _asset;
        tokenIdMapping[tokenId] = _asset;
        for (uint256 i = 0; i < assetUserMapping[msg.sender].length; i++) {
            if (assetUserTokenMapping[msg.sender][i].tokenId == _tokenId) {
                assetUserTokenMapping[msg.sender][i] = _asset;
            }
        }
        assets.push(_asset);
    }

    //function to list all the assets under the user address
    function myAssets() public view returns (Asset[] memory) {
        return assetUserMapping[msg.sender];
    }

    //function to return an array of all the assets listed for sale
    function getAllAssetsForSale() public view returns (Asset[] memory) {
        return assets;
    }

    //function to transfer the ownership, delete the item from the sale list and to update the mappings
    function transferAssetOwnership(address _buyer, uint256 _tokenId) public {
        transferFrom(msg.sender, _buyer, _tokenId);
        assetUserTokenMapping[msg.sender][_tokenId].previousOwners.push(
            msg.sender
        );
        Asset memory _asset = assetUserTokenMapping[msg.sender][_tokenId];

        assetUserMapping[_buyer].push(_asset);
        assetUserTokenMapping[_buyer][_tokenId] = _asset;
        tokenIdMapping[_tokenId] = _asset;

        delete assets[_tokenId - 1];
        for (uint256 i = 0; i < assetUserMapping[msg.sender].length; i++) {
            if (assetUserMapping[msg.sender][i].tokenId == _tokenId) {
                delete assetUserMapping[msg.sender][i];
            }
        }
        delete assetUserTokenMapping[msg.sender][_tokenId];
    }

    //function to get the asset details of the user by the tokenId
    function myAssetById(uint256 _tokenId) public view returns (Asset memory) {
        return assetUserTokenMapping[msg.sender][_tokenId];
    }

    //function to get the asset details of any asset by id
    function getAssetById(uint256 _tokenId) public view returns (Asset memory) {
        return tokenIdMapping[_tokenId];
    }

    //function to get the history of ownership of a particular asset by its id
    function getAssetOwnershipHistory(uint256 _tokenId)
        public
        view
        returns (address[] memory)
    {
        return tokenIdMapping[_tokenId].previousOwners;
    }
}
