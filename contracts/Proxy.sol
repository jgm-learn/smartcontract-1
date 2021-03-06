pragma solidity ^0.4.5; 

import "./User.sol";
import "./UserList.sol";
import "./ContractAddress.sol";
import "./lib/LibString.sol";

contract Proxy
{
    string user_list_name;

    UserList user_list;
    ContractAddress contract_address;

    function Proxy()
    {
        user_list_name = "UserList";
    }
    function getName() returns(string)
    {
        return user_list_name;
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

    function getListReqNum(bytes32 user_id)returns(uint ret){
		User user = User(user_list.getUserAgentAddr(user_id));
		ret = user.getListReqNum();
	}
    function getListReq_1(bytes32 user_id, uint i)external returns(string class_id, string make_date,string lev_id,string wh_id,string place_id)
	{
		User user = User(user_list.getUserAgentAddr(user_id));
		if( i < user.getListReqNum())
		{
			var(class_id_, make_date_,lev_id_,wh_id_,place_id_) = user.getListReq_1(i);
			class_id    =   LibString.bytes32ToString(class_id_);
			make_date   =   LibString.bytes32ToString(make_date_);
            lev_id      =   LibString.bytes32ToString(lev_id_); 
            wh_id       =   LibString.bytes32ToString(wh_id_);
            place_id    =   LibString.bytes32ToString(place_id_);
		}
	}
    function getListReq_2(bytes32 user_id, uint i)external returns(uint sheet_id,uint market_id,uint date, uint price, uint list_qty, uint deal_qty, uint rem_qty)
    {
		User user = User(user_list.getUserAgentAddr(user_id));
		if( i < user.getListReqNum())
		{
			(sheet_id,market_id,date, price, list_qty, deal_qty, rem_qty) = user.getListReq_2(i);
		}
    }

    function getTradeNum(bytes32 user_id)returns (uint ret)
	{
		User user = User(user_list.getUserAgentAddr(user_id));
		ret = user.getTradeNum();
	}
    function getTrade_1(bytes32 id, uint i)external returns( string user_id,  string opp_id, string bs,string trade_state)
    {
        User user = User(user_list.getUserAgentAddr(id));
        if(i < user.getTradeNum())
        {
            var(user_id_, opp_id_,bs_,trade_state_) = user.getTrade_1(i);
            user_id     =   LibString.bytes32ToString(user_id_);
            opp_id      =   LibString.bytes32ToString(opp_id_);
            bs          =   LibString.bytes32ToString(bs_);
            trade_state =   LibString.bytes32ToString(trade_state_);
        }
     }
    function getTrade_2(bytes32 id, uint i)external returns(uint trade_date, uint trade_id, uint sheet_id,uint price, uint trade_qty,uint payment,uint fee)
    {
        User user = User(user_list.getUserAgentAddr(id));
        if(i < user.getTradeNum())
        {
            (trade_date,trade_id,sheet_id,price,trade_qty,payment,fee) = user.getTrade_2(i);
        }
    }


    function getSheetMapNum(bytes32 user_id) returns(uint ret)
	{
		User user = User(user_list.getUserAgentAddr(user_id));
		ret = user.getSheetMapNum();
	}
    function getSheetMap_1(bytes32 id, uint index)external returns(string user_id, uint sheet_id,string class_id, string make_date, string level_id)
	{
		User user = User(user_list.getUserAgentAddr(id));
		var(user_id_, sheet_id_, class_id_, make_date_, lev_id_)=user.getSheetMap_1(index);
		user_id = LibString.bytes32ToString(user_id_);
		sheet_id = sheet_id_;
		class_id = LibString.bytes32ToString(class_id_);
		make_date = LibString.bytes32ToString(make_date_);
		level_id = LibString.bytes32ToString(lev_id_);
	}
    function getSheetMap_2(bytes32 user_id, uint index)external returns(string wh_id, string place_id, uint all_amount, uint avail_amount, uint frozen_amount)
	{
		User user = User(user_list.getUserAgentAddr(user_id));
		var(wh_id_, place_id_,all_amount_, avail_amount_, frozen_amount_) = user.getSheetMap_2(index);
		wh_id = LibString.bytes32ToString(wh_id_);
		place_id = LibString.bytes32ToString(place_id_);
		all_amount = all_amount_;
		avail_amount = avail_amount_;
		frozen_amount = frozen_amount_;
	}
    function insertFunds(bytes32 user_id, uint qty)
	{
		User user = User(user_list.getUserAgentAddr(user_id));
		user.insertFunds(qty);
	}
}
