var market_name ="Market";
var create_id_name ="CreateID";
var user_list_name ="UserList";
var god_account = "0xe6091bbd070cd8c5738df3f31fb544fcb312731b";

// Step 1: Get a contract into my application
var UserList_json           = require("./build/contracts/UserList.json");
var ContractAddress_json    = require("./build/contracts/ContractAddress.json");
var Market_json             = require("./build/contracts/Market.json");
var CreateID_json           = require("./build/contracts/CreateID.json");
var Login_json              = require("./build/contracts/Login.json");
var Admin_json              = require("./build/contracts/Admin.json");
var Web3                    = require('web3');

// Step 2: Turn that contract into an abstraction I can use
var contract        = require("truffle-contract");
var UserList        = contract(UserList_json);
var ContractAddress = contract(ContractAddress_json);
var Market          = contract(Market_json);
var CreateID        = contract(CreateID_json);
var Login           = contract(Login_json);
var Admin           = contract(Admin_json);

// Step 3: Provision the contract with a web3 provider
var web3 = new Web3.providers.HttpProvider("http://localhost:8548");
UserList.setProvider(web3);
ContractAddress.setProvider(web3);
Market.setProvider(web3);
CreateID.setProvider(web3);
Login.setProvider(web3);
Admin.setProvider(web3);

// Step 4: Use the contract!
let UserList_instance;
let ContractAddress_instance;
let Market_instance;
let CreateID_instance;
let Login_instance;
let Admin_instance;
async function initAddress()
{
   console.log("Start:获取系统合约的地址....");
   UserList_instance = await UserList.deployed(); 
   console.log("\tUserList Address:"+UserList_instance.address);
   ContractAddress_instance = await ContractAddress.deployed(); 
   console.log("\tContractAddress Address:"+ContractAddress_instance.address);
   Market_instance = await Market.deployed(); 
   console.log("\tMarket Address:"+Market_instance.address);
   CreateID_instance = await CreateID.deployed(); 
   console.log("\tCreateID Address:"+CreateID_instance.address);
   Login_instance = await Login.deployed(); 
   console.log("\tLogin Address:"+Login_instance.address);
   Admin_instance = await Admin.deployed(); 
   console.log("\tAdmin Address:"+Admin_instance.address);
   console.log("End:...获取系统合约地址结束");
   
}
async function setDep()
{
    console.log("Start:设置合约依赖关系....");
    console.log("\t设置ContractAddress合约");
    await ContractAddress_instance.setContractAddress.sendTransaction(market_name,Market_instance.address,{from:god_account});
    await ContractAddress_instance.setContractAddress.sendTransaction(create_id_name,CreateID_instance.address,{from:god_account});
    await ContractAddress_instance.setContractAddress.sendTransaction(user_list_name,UserList_instance.address,{from:god_account});

    console.log("\t设置Market合约");
    await Market_instance.setContractAddress.sendTransaction(ContractAddress_instance.address,{from:god_account});
    await Market_instance.setCreateIDName.sendTransaction(create_id_name,{from:god_account});
    await Market_instance.setUserListName.sendTransaction(user_list_name,{from:god_account});

    console.log("\t设置Login合约");
    await Login_instance.init.sendTransaction(ContractAddress_instance.address,user_list_name,{from:god_account});

    console.log("\t设置Admin合约");
    await Admin.init.sendTransaction(ContractAddress_instance.address,user_list_name,{from:god_account});
    console.log("End:...设置合约依赖关系完毕")
}
initAddress().then( function(){
    setDep();
});
