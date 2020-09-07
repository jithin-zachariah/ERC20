const TokenizeAsset = artifacts.require("TokenizeAsset");

module.exports = function (deployer) {
  deployer.deploy(TokenizeAsset);
};

