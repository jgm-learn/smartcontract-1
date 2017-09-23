pragma solidity ^0.4.5;
 
import "./CreateID.sol";
import "./Market.sol";
import "./lib/LibSheetMap.sol";
import "./lib/StructSheet.sol";
import "./ContractAddress.sol";

contract User
{
    //仓单数据结构
    struct Sheet
    {
        string      user_id_;       //客户id
        uint        sheet_id_;    //仓单序号
        string      class_id_;      //品种id
        string      make_date_;     //产期
        string      lev_id_;        //等级
        string      wh_id_;         //仓库代码
        string      place_id_;      //产地代码
        uint        receipt_amount_;  //仓单总量
        uint        frozen_amount_;   //冻结数量   
        uint        available_amount_;//可用数量
        bool        state_;          //是否存在
    }
     
    //挂牌请求数据结构
    struct ListRequest
    {
         uint       sheet_id_;    //仓单序号
         uint       quo_id_;        //挂单编号
         uint       price_;         //价格（代替浮点型）
         uint       quo_qty_;       //挂牌量
         uint       deal_qty_;      //成交量
         uint       rem_qty_;       //剩余量
    }
    
    //合同数据结构
    struct  TradeContract
    {
        uint        con_data_;          //合同日期
        uint        con_id_;            //合同编号
        uint        sheet_id_;        //仓单编号
        string      buy_or_sell_;       //买卖
        uint        price_;             //价格
        uint        con_qty_;           //合同量
        //uint        fee_;               //手续费
        //uint        transfer_money_;    //已划货款
        //uint        remainder_money_;   //剩余货款
        string      user_id_;           //己方id
        string      countparty_id_;     //对手方id
        //string      trade_state_;       //交收状态
        //string      trade_type_         //交易方式
    }   
    
    //协商交易请求数据结构 发送
    struct NegSendRequest
    {
        uint        sheet_id_;    //仓单序号
        uint        quantity_;      //交易数量
        uint        price_;         //价格
        uint        negotiate_id_;  //协商编号
        string      counterparty_id_;//对手方id
        string      trade_state;    //成交状态
    }
    
    //协商交易请求数据结构 接收
    struct NegReceiveRequest
    {
        uint        sheet_id_;        //仓单序号
        uint        quantity_;          //交易数量
        uint        price_;             //价格
        uint        neg_id_;            //协商编号
        string      user_sell_id_;      //对手方id
        address     sell_con_addr_;     //卖方的合约地址
        string      trade_state;        //成交状态
    }
    
     
     Market                          market;          //行情合约变量
     CreateID                        ID;                 //ID合约变量
     
     //存储仓单     
 //    mapping(uint => Sheet)           sheet_map;         //仓单ID => 仓单
        
     //存储挂牌请求     
     ListRequest[]                      list_req_array;     
     
     //存储合同
     mapping(uint => TradeContract)       contract_map;       //合同编号 => 合同
     
     //协商交易请求列表
     NegSendRequest[]                  neg_req_send_array; 
     NegReceiveRequest[]               neg_req_receive_array; 
     
      
     //打印错误信息
     event error(string,string, uint);
     event error1(string);
     event inform(string);

     using LibSheetMap for LibSheetMap.SheetMap;
     LibSheetMap.SheetMap   sheet_map;
     ContractAddress        contract_address;
     string                 market_name;
     function setContractAddress(address addr)
     {
             contract_address = ContractAddress(addr); 
     }
     function setMarketName(string name)
     {
            market_name = name;
     }

     function insertSheet(bytes32 user_id, uint sheet_id, bytes32 class_id, bytes32 make_date,
                        bytes32 lev_id, bytes32 wh_id, bytes32 place_id, uint all_amount, 
                        uint frozen_amount, uint available_amount)
     {
        sheet_map.insert(sheet_id, StructSheet.value(user_id, sheet_id, 
                        class_id, make_date, lev_id, wh_id, place_id, all_amount,
                        frozen_amount, available_amount));
     }

    //获取持有者的仓单数量
    function getSheetAmount(uint sheet_id) returns (uint all_amount, uint available_amount, uint frozen_amount)
    {
        StructSheet.value memory sheet = sheet_map.getValue(sheet_id);
        all_amount = sheet.all_amount_;
        available_amount = sheet.available_amount_;
        frozen_amount = sheet.frozen_amount_;
    }

    //冻结仓单
    function freeze(uint sheet_id, uint amount) returns (bool)
    {
        var(all_amount, available_amount, frozen_amount) = getSheetAmount(sheet_id);
        if(amount > available_amount)  
              return false;
              
        sheet_map.update(sheet_id, all_amount, available_amount - amount, frozen_amount + amount);         
        return true;
    }

    //挂牌请求 "zhang",0,10,20
    function listRequire(string seller_user_id, uint sheet_id, uint price, uint sell_qty) returns(uint ret_market_id)
    {
        var sheet = sheet_map.getValue(sheet_id);
        if(sheet.available_amount_ == 0)
        {
            //TODO event
            return uint(-1);
        }
        /* TODO init market and test
        market.insertMarket_1(sheet.sheet_id_,sheet.class_id_, sheet.make_date_,   
           sheet.lev_id_, sheet.wh_id_, sheet.place_id_);

        var ret_market_id = market.insertMarket_2(sheet.price_, sheet.list_qty_, sheet.deal_qty_,
                            sheet.rem_qty_, sheet.deadline_, 
                            sheet.dlv_unit_, sheet.user_id_ );
        if(market_id >0)
        {
            freeze(sheet_id_, sheet_qty);
        }
        */
        /*
        list_req_array.push(ListRequest(sheet_id_, market_id, price, sheet_qty, 0, sheet_qty) ); 
        */
    }


     
     

   function insertSheet(string user_id, uint sheet_id, string class_id,string make_date,
                        string lev_id, string wh_id, string place_id,  uint receipt_amount)
    {
        
//        sheet_map[sheet_id] = Sheet(user_id, sheet_id,class_id, make_date, lev_id, 
                                   //     wh_id, place_id, receipt_amount,0,receipt_amount,true);
    }
    
    
     //获取可用仓单数量
    function getAvailableAmount(uint sheet_id_) returns (uint)
    {
//        return sheet_map[sheet_id_].available_amount_;
    }
    
    //更新卖方挂牌请求
    function updateListReq(uint quo_id, uint deal_qty)
    {
        for(uint i = 0; i<list_req_array.length; i++)
        {
            if(list_req_array[i].quo_id_ == quo_id)
            {
                list_req_array[i].deal_qty_      +=      deal_qty;
                list_req_array[i].rem_qty_       -=     deal_qty;
                break;
            }
        }
        
    }
    
    //摘牌请求 "li",1,10
    function delListReq(string user_id, uint quo_id, uint deal_qty) 
    {
        market.delList(user_id, quo_id, deal_qty);
    }
    
    //成交 创建“卖”合同
    function dealSellContract(uint  sheet_id_, string  buy_or_sell, 
                          uint price, uint con_qty, string countparty_id) returns(uint)
    {
        uint con_id = ID.getConID();//获取合同编号
        
        contract_map[con_id].con_data_ = now;
        contract_map[con_id].con_id_ = con_id;
        contract_map[con_id].sheet_id_ = sheet_id_;
        contract_map[con_id].buy_or_sell_ = buy_or_sell;
        contract_map[con_id].price_ = price;
        contract_map[con_id].con_qty_ = con_qty;
        contract_map[con_id].countparty_id_ = countparty_id;
        
        inform("成功创建合同，交易达成");
        
        return con_id;
    }
    
     //创建“买”合同
    function dealBuyContract(uint con_id,uint sheet_id_, string  buy_or_sell, uint price, 
                            uint con_qty, string countparty_id) 
    {
        contract_map[con_id].con_data_ = now;
        contract_map[con_id].con_id_ = con_id;
        contract_map[con_id].sheet_id_ = sheet_id_;
        contract_map[con_id].buy_or_sell_ = buy_or_sell;
        contract_map[con_id].price_ = price;
        contract_map[con_id].con_qty_ = con_qty;
        contract_map[con_id].countparty_id_ = countparty_id;
        
        inform("成功创建合同，交易达成");
    }
    

    
    
    //发送协商交易请求 卖方调用
    function sendNegReq(uint sheet_id_, uint price, 
                                uint quantity, string counterparty_id) returns(uint)
    {
    /*
        if(quantity > sheet_map[sheet_id_].available_amount_)
        {
            error("negotiate_req():可用仓单数量不足","错误代码:",uint(-1));
            return uint(-1);
        }
        
        //冻结仓单
        if( ! freeze(sheet_id_, quantity))
            {
                    error1("冻结仓单失败");
                    return;
            }
        
        uint    neg_id = ID.getNegID();//协商交易编号
        
        //更新协商交易请求列表（发送）
        neg_req_send_array.push( NegSendRequest(sheet_id_,quantity,price,
                                neg_id,counterparty_id,"未成交") );
       
        //调用对手方协商交易请求的接收方法
        //User counterparty =  User( user_list.GetUserConAddr(counterparty_id) );
        //counterparty.recieveNegReq(sheet_id_,quantity,price,
        //                        neg_id, sheet_map[sheet_id_].user_id_);
     */   
        
    }
    
    
    //接收协商交易请求 卖方调用买方
    function recieveNegReq(uint sheet_id_, uint price, uint quantity, 
                                    uint neg_id,string user_sell_id)
    {
        neg_req_receive_array.push( NegReceiveRequest(sheet_id_,quantity,price,
                                neg_id,user_sell_id, msg.sender,"未成交") );
    }
    
     //确认协商交易 买方调用此函数
    function agreeNeg(string user_buy_id, uint neg_id)
    {
        for(uint i= 0; i<neg_req_receive_array.length; i++ )
        {
            if(neg_req_receive_array[i].neg_id_ == neg_id)
                break;
        }
        
        //创建卖方合同
        User user_sell = User(neg_req_receive_array[i].sell_con_addr_);
        uint con_id_tmp = user_sell.dealSellContract(neg_req_receive_array[i].sheet_id_, "卖", neg_req_receive_array[i].price_,
                                neg_req_receive_array[i].quantity_,user_buy_id);
        //创建买方合同
        dealBuyContract(con_id_tmp,neg_req_receive_array[i]. sheet_id_, "买", neg_req_receive_array[i].price_,
                         neg_req_receive_array[i].quantity_,neg_req_receive_array[i].user_sell_id_);
        
    }
    
} 
