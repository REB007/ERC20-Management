const ERC20TD = artifacts.require("ERC20TD");
const DepositorContract = artifacts.require("DepositorContract");
const DepositorContractTokenized = artifacts.require("DepositorContractTokenized");
const DepositorToken = artifacts.require("DepositorToken");

const initialSupply = 1000000;

module.exports = function(deployer) {
  //if(network === 'development'){
    deployer.deploy(ERC20TD, initialSupply)
    .then(() => deployer.link(ERC20TD, [DepositorContract, DepositorContractTokenized]))
    .then(() => deployer.deploy(DepositorContract, ERC20TD.address))
    .then(() => deployer.deploy(DepositorToken))
    .then(() => deployer.link(DepositorToken, DepositorContractTokenized))
    .then(() => deployer.deploy(DepositorContractTokenized,  ERC20TD.address, DepositorToken.address))
  //}
};
