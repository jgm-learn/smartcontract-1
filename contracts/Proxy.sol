pragma solidity ^0.4.5; 

import "./User.sol";
import "./UserList.sol";
import "./ContractAddress.sol";

contract Proxy
{
    string user_list_name;

    UserList user_list;
    ContractAddress contract_address;

    function Proxy()
    {
        user_list_name = "UserList";
    }

    //设置ContractAddress
    function setContractAddress(address addr)
    {
        contract_address = ContractAddress(addr);
    }

    //初始化
    function init(address addr)
    {
        setContractAddress(addr);
        user_list = UserList(contract_address.getContractAddress(user_list_name));
    }

    //挂牌
    function insertSheet(bytes32 user_id, bytes32 class_id, bytes32 make_date,bytes32 lev_id, bytes32 wh_id, bytes32 place_id,uint all_amount,uint frozen_amount, uint available_amount)
    {
          User user = User(user_list.getUserAgentAddr(user_id));
          user.insertSheet(user_id, class_id, make_date, lev_id, wh_id, place_id, all_amount, frozen_amount, available_amount);
    }

    function getSheetAmount(bytes32 user_id, uint sheet_id)
        returns(uint all_amount, uint available_amount, uint  frozen_amount)
    {
        User user = User(user_list.getUserAgentAddr(user_id));
        var(all_amount_,available_amount_, frozen_amount_) = user.getSheetAmount(sheet_id);
        all_amount = all_amount_;
        available_amount = available_amount_;
        frozen_amount = frozen_amount_;
    }
    
    function listRequest(bytes32 user_id, bytes32 seller_user_id, uint sheet_id, uint price, uint sell_qty) 
        returns(uint ret)
    {
        User user = User(user_list.getUserAgentAddr(user_id));
        ret = user.listRequest(seller_user_id, sheet_id, price, sell_qty);
    }

    function delistRequest(bytes32 user_id, bytes32 buy_user_id, uint selected_market_id, uint confirm_qty)
        returns(int ret)
    {
        User user = User(user_list.getUserAgentAddr(user_id));
        ret = user.delistRequest(buy_user_id, selected_market_id, confirm_qty);
    }
}
