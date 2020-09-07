const AST_Token = artifacts.require("AST_Token");

module.exports = function (deployer) {
  deployer.deploy(AST_Token);
};
