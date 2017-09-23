//independ
var CreateID = artifacts.require("CreateID");

//struct
var StructAddressInfo = artifacts.require("StructAddressInfo");
var StructMarket = artifacts.require("StructMarket");
var StructUserAddr = artifacts.require("StructUserAddr");

//lib
var LibArray = artifacts.require("LibArray");
var LibString = artifacts.require("LibString");
var LibAddressMap = artifacts.require("LibAddressMap");
var LibMarketMap = artifacts.require("LibMarketMap");
var LibUserAddrMap = artifacts.require("LibUserAddrMap");

//contract
var ContractAddress = artifacts.require("ContractAddress");
var User = artifacts.require("User");
var UserList = artifacts.require("UserList");
var Market = artifacts.require("Market");

module.exports = function(deployer) {

  //independ
  deployer.deploy(CreateID);

  //struct
  deployer.deploy(StructAddressInfo);
  deployer.deploy(StructMarket);
  deployer.deploy(StructUserAddr);

  //lib
  deployer.deploy(LibString);
  deployer.deploy(LibArray);
  deployer.deploy(LibAddressMap);
  deployer.deploy(LibMarketMap);
  deployer.deploy(LibUserAddrMap);

  //befor deploy contract. link lib.
  deployer.link(StructAddressInfo, [ContractAddress]);
  deployer.link(LibArray, [ContractAddress, Market, UserList]);
  deployer.link(LibString, [ContractAddress]);
  deployer.link(LibAddressMap, [ContractAddress]);

  deployer.link(StructMarket, [Market]);
  deployer.link(LibMarketMap, [Market]);

  deployer.link(StructUserAddr, [UserList]);
  deployer.link(LibUserAddrMap, [UserList]);

  //contract
  deployer.deploy(ContractAddress);
  deployer.deploy(Market);
};
