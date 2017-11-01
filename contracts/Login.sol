pragma solidity ^0.4.11;

import "./ContractAddress.sol";
import "./UserList.sol";

contract Login
{
    ContractAddress        contract_address;
    UserList    user_list;
    string      user_list_name; 

    function init(address addr, string name)
    {
         contract_address = ContractAddress(addr);
         user_list_name = name;
         user_list = UserList(user_list = UserList(contract_address.getContractAddress(user_list_name)));
    }
	
    function verfication(bytes32 user_id, address external_addr) returns(int ret, int user_auth, address user_addr)
    {
        if(!user_list.isExisted(user_id))
            {
                ret = -1;
                return;
            }
        else if(external_addr == user_list.getExternal_addr(user_id))
            {
               ret = 0;
               var(un1,ret_user_addr,un2,ret_user_auth) = user_list.getUserInfo(user_id);//un1,un2代表未使用的变量
               user_auth = ret_user_auth;
               user_addr = ret_user_addr;
               return;
            }
             else
                   ret = -2; 
    }
}
