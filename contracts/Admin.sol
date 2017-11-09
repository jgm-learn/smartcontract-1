pragma solidity ^0.4.11;

import "./ContractAddress.sol";
import "./UserList.sol";
import "./User.sol";

contract Admin
{
    struct ConfirmListReq
    {
        bytes32 user_id_;
        uint    trade_id_;
    }
    struct ConfirmNegReq
    {
        bytes32 user_id_;
        uint    trade_id_;
    }

    ContractAddress     contract_address;
    UserList            user_list;
    ConfirmListReq[]    confirm_list_req;
    ConfirmNegReq[]     confirm_neg_req;
    User                user;

    function init(address addr, string user_list_name)
    {
        contract_address = ContractAddress(addr);
        user_list =  UserList(contract_address.getContractAddress(user_list_name));
    }

    function insertConfirmListReq(bytes32 user_id, uint trade_id)
    {
        confirm_list_req.push( ConfirmListReq(user_id,trade_id));
    }

    function insertConfirmNegReq(bytes32 user_id, uint trade_id)
    {
        confirm_neg_req.push( ConfirmNegReq(user_id,trade_id));
    }

    //确认挂牌交易
    function confirmList(uint index)
    {
        user = User(user_list.getUserAgentAddr(confirm_list_req[index].user_id_));
        user.confirmList(confirm_list_req[index].trade_id_);
    }

    //确认协商交易
    function confirmNeg(uint index)
    {
        user = User(user_list.getUserAgentAddr(confirm_neg_req[index].user_id_));
        user.confirmNeg(confirm_neg_req[index].trade_id_);
    }

    //添加用户
    function addUser(address external_addr, bytes32 user_id)
    {//TODO 重复用户判断
        user = new User();
        user.setContractAddress(contract_address);
        user.setMarketName("Market");
        user.setCreateIDName("CreateID");
        user.setUserListName("UserList");
        user.setUserID(user_id);
        user.setAdmin("Admin");
        user_list.addUser(external_addr,user,user_id,1);
    }
    function addUser(address external_addr, bytes32 user_id, bytes32 class_id, bytes32 make_date,
                    bytes32 lev_id, bytes32 wh_id, bytes32 place_id, uint all_amount,
                    uint frozen_amount, uint available_amount)
    {//TODO 重复用户判断
        user = new User();
        user.setContractAddress(contract_address);
        user.setMarketName("Market");
        user.setCreateIDName("CreateID");
        user.setUserListName("UserList");
        user.setUserID(user_id);
        user.setAdmin("Admin");
        user_list.addUser(external_addr,user,user_id,1);
        user.insertSheet(user_id, class_id, make_date, lev_id, wh_id, place_id, all_amount, frozen_amount, available_amount);
    }

    //删除用户
    function delUser(bytes32 user_id)
    {
        user_list.delUserInfo(user_id);
    }
}
