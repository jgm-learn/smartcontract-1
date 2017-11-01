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
	
    function verfication(bytes32 user_id, address external_addr) returns(bool existed, bool access, bool admin, address user_addr)
    {
        if(!user_list.isExisted(user_id))
            {
                existed = false;
                access = false;
                return;
            }
        else if(external_addr == user_list.getExternal_addr(user_id))
            {
               user_addr = user_list.getExternal_addr(user_id);
               access = true;
               if(user_id == "admin")
                   admin = true;
               else
                   admin = false;
               return;

            }
             else
                   access = false; 
    }
}
