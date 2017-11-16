pragma solidity ^0.4.11;

import "./lib/LibString.sol";
import "./ContractAddress.sol";
import "./User.sol";
import "./UserList.sol";
contract Admin
{
    struct ConfirmListReq
    {
        bytes32 user_id_;
        bytes32 user_sell_id_;
        uint    trade_id_;
        uint    trade_qty_;
        bytes32 class_id_;
        uint    funds_;
        uint    fee_;
        bool    status_;
    }
    struct ConfirmNegReq
    {
        bytes32 user_id_;
        bytes32 user_sell_id_;
        uint    trade_id_;
        uint    trade_qty_;
        //bytes32 class_id_;//暂时不予考虑
        uint    funds_;
        uint    fee_;
        bool    status_;
    }
    ContractAddress     contract_address;
    UserList            user_list;
    ConfirmListReq[]    confirm_list_req;
    ConfirmNegReq[]     confirm_neg_req;
    User                user;
    User                user_sell;
    function init(address addr, string user_list_name)
    {
        contract_address = ContractAddress(addr);
        user_list =  UserList(contract_address.getContractAddress(user_list_name));
    }
    function insertConfirmListReq(bytes32 user_id, bytes32 user_sell_id,uint trade_id,bytes32 class_id,uint trade_qty,uint funds,uint fee)
    {
        confirm_list_req.push( ConfirmListReq(user_id,user_sell_id,trade_id,trade_qty,class_id,funds,fee,false));
    }

    function insertConfirmNegReq(bytes32 user_id, bytes32 user_sell_id, uint trade_id,uint trade_qty,uint funds,uint fee)
    {
        confirm_neg_req.push( ConfirmNegReq(user_id,user_sell_id,trade_id,trade_qty,funds,fee,false));
    }
    //确认挂牌交易
    function confirmList(uint index)
    {
        user        = User(user_list.getUserAgentAddr(confirm_list_req[index].user_id_));
        user_sell   = User(user_list.getUserAgentAddr(confirm_list_req[index].user_sell_id_));
        user.confirmList(confirm_list_req[index].trade_id_);
        user_sell.confirmList(confirm_list_req[index].trade_id_);
        confirm_list_req[index].status_  =   true;
    }

    //确认协商交易
    function confirmNeg(uint index)
    {
        user        = User(user_list.getUserAgentAddr(confirm_neg_req[index].user_id_));
        user_sell   = User(user_list.getUserAgentAddr(confirm_neg_req[index].user_sell_id_));
        user.confirmNeg(confirm_neg_req[index].trade_id_);
        user_sell.confirmNeg(confirm_neg_req[index].trade_id_);
        confirm_neg_req[index].status_   =   false;
    }

    function OnlyaddUser(address external_addr, bytes32 user_id)
    {
        user = new User();
        user.initNoChangeDep();
        user.setContractAddress(contract_address);
        user.setUserID(user_id);
        user_list.addUser(external_addr,user,user_id,1);
    }

    function addUser(address external_addr, bytes32 user_id, bytes32 class_id, bytes32 make_date,
                    bytes32 lev_id, bytes32 wh_id, bytes32 place_id, uint all_amount,
                    uint frozen_amount, uint available_amount, uint funds)
    {//TODO 重复用户判断
        user = new User();
        user.initNoChangeDep();
        user.setContractAddress(contract_address);
        user.setUserID(user_id);
        user.insertSheet(user_id, class_id, make_date, lev_id, wh_id, place_id, all_amount, frozen_amount, available_amount);
        user.insertFunds(funds);
        user_list.addUser(external_addr,user,user_id,1);
    }
    //删除用户
    function delUser(bytes32 user_id)
    {
            user_list.delUserInfo(user_id);
    }
   
    //重设资金
    function modifyFunds(bytes32 user_id, uint qty)
    {
        user    =   User(user_list.getUserAgentAddr(user_id));
        user.setFunds(qty);
    }
    //获取用户id和账户地址
    function getUserInfo(uint index) returns(string user_id_str, address external_addr)
    {
        var(ret_external_addr,agent_addr,user_id,user_auth) = user_list.getUserInfoByIndex(index);
        user_id_str =   LibString.bytes32ToString(user_id);
        external_addr = ret_external_addr;
    }

    //获取用户仓单数量、资金数据
    function getSheetFunds(uint index) returns(uint total_sheet, uint available_sheet, uint frozen_sheet, uint available_funds, uint frozen_funds)
    {
        user            =   User(user_list.getAgentAddrByIndex(index));
        (total_sheet,available_sheet,frozen_sheet) =   user.getSheetTotalAmount();
        available_funds =   user.getAvaFunds();
        frozen_funds    =   user.getFrozenFunds();
    }

    //获取仓单数据固定属性
    function getSheetInfo(uint index) returns(string user_id_str, uint sheet_id,string class_id_str,string make_date_str,string lev_id_str,string wh_id_str, string place_id_str)
    {
        user                =   User(user_list.getAgentAddrByIndex(index));
        user_id_str         =   LibString.bytes32ToString(user_list.getUserIDByIndex(index));
        var(class_id,make_date,lev_id,wh_id,place_id) = user.getSheetAttributeByIndex(index);
    }

    //获取挂牌交易确认请求列表的长度
    function getConfirmListReqSize() returns(uint)
    {
        return confirm_list_req.length; 
    }
    

    //获取协商交易确认请求列表的长度
    function getConfirmNegReqSize() returns(uint)
    {
         return confirm_neg_req.length; 
    }

    //获取挂牌交易确认请求列表的元素
    function getConfirmListReq(uint index) external returns(string user_id,string user_sell_id,uint trade_id,string class_id,uint trade_qty,uint funds,uint fee,bool status)
    {
            user_id         =   LibString.bytes32ToString(confirm_list_req[index].user_id_);
            user_sell_id    =   LibString.bytes32ToString(confirm_list_req[index].user_sell_id_);
            trade_id        =   confirm_list_req[index].trade_id_;
            class_id        =   LibString.bytes32ToString(confirm_list_req[index].class_id_);
            trade_qty       =   confirm_list_req[index].trade_qty_;
            funds           =   confirm_list_req[index].funds_;
            fee             =   confirm_list_req[index].fee_;
            status          =   confirm_list_req[index].status_;
    }

    //获取协商交易确认请求列表的元素
    function getConfirmNegReq(uint index) external returns(string user_id,string user_sell_id,uint trade_id,uint trade_qty,uint funds,uint fee,bool status)
    {
            user_id         =   LibString.bytes32ToString(confirm_neg_req[index].user_id_);
            user_sell_id    =   LibString.bytes32ToString(confirm_neg_req[index].user_sell_id_);
            trade_id        =   confirm_neg_req[index].trade_id_;
            //class_id        =   LibString.bytes32ToString(confirm_list_req[index].class_id_);
            trade_qty       =   confirm_neg_req[index].trade_qty_;
            funds           =   confirm_neg_req[index].funds_;
            fee             =   confirm_neg_req[index].fee_;
            status          =   confirm_neg_req[index].status_;
    }
}
