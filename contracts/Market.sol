pragma solidity ^0.4.5;
 
import "./User.sol";
import "./UserList.sol";
import "./CreateID.sol";
import "./ContractAddress.sol";
import "./lib/StructMarket.sol";
import "./lib/LibMarketMap.sol";
 
contract  Market
{
    struct MarketData
    {
        uint        date_;      //挂牌日期
        uint        id_;        //挂牌编号
        uint        sheet_id_;    //仓单编号
        string      class_id_;      //品种代码
        string      make_date_;     //产期
        string      lev_id_;        //等级
        string      wh_id_;         //仓库代码
        string      place_id_;      //产地代码
        string      type_;      //报价类型
        uint        price_;         //价格（代替浮点型）
        uint        qty_;       //挂牌量
        uint        deal_qty_;      //成交量
        uint        rem_qty_;       //剩余量
        string      deadline_;  //挂牌截止日
        uint        dlv_unit_;      //交割单位
        string      user_id_;       //用户id
        address     seller_addr_;   //卖方地址
        bool        state;          //是否存在
    }

    using LibMarketMap for LibMarketMap.MarketMap;

    LibMarketMap.MarketMap          market_map;

    StructMarket.value              temp_market; //临时行情变量

    ContractAddress                 contract_address;

    string                          create_id_name;
    string                          user_list_name;


    uint                            market_id = 0;
    mapping(uint => MarketData)     data_map;   //挂牌编号 => 挂牌数据
    
    //外部依赖
    function setContractAddress(address addr)
    {
       contract_address = ContractAddress(addr); 
    }
    function setCreateIDName(string name)
    {
        create_id_name = name;
    }
    function setUserListName(string name)
    {
        user_list_name = name;
    }

    //操作行情
    function getMarketID() returns (uint)
    {
        address empty_addr;
        assert(contract_address != empty_addr);
        assert(bytes(create_id_name).length != 0);

        CreateID create_id = CreateID(contract_address.getContractAddress(create_id_name));

        assert(create_id != empty_addr);

        return create_id.getMarketID();
    }
    function insertMarket_1(uint sheet_id,
                        bytes32  class_id, bytes32  make_date,   
                        bytes32  lev_id, bytes32  wh_id, bytes32  place_id)
    {
        market_id = getMarketID();
        temp_market.date_       = now;
        temp_market.market_id_  = market_id;
        temp_market.sheet_id_   = sheet_id;
        temp_market.class_id_   = class_id;
        temp_market.make_date_  = make_date;
        temp_market.lev_id_     = lev_id;
        temp_market.wh_id_      = wh_id;
        temp_market.place_id_   = place_id;
        temp_market.type_       = "一口价";
    }
    function insertMarket_2(uint price, uint list_qty, uint deal_qty,
                            uint rem_qty, bytes32  deadline, 
                            uint dlv_unit, bytes32 user_id ) returns(uint)
    {
        temp_market.price_      = price;
        temp_market.list_qty_   = list_qty;
        temp_market.deal_qty_   = deal_qty;
        temp_market.rem_qty_    = rem_qty;
        temp_market.deadline_   = deadline;
        temp_market.dlv_unit_   = dlv_unit;
        temp_market.user_id_    = user_id;
        temp_market.seller_addr_= msg.sender;
        market_map.insert(market_id, temp_market);
        return market_id;        
    }
    function getMarket_1(uint market_id)
        returns (
            uint        date,    //挂牌日期
            uint        ret_market_id,        //挂牌编号
            uint        sheet_id,    //仓单编号
            bytes32      class_id,      //品种代码
            bytes32      make_date,     //产期
            bytes32      lev_id,        //等级
            bytes32      wh_id,         //仓库代码
            bytes32      place_id,      //产地代码
            bytes32      price_type      //报价类型
                )
    {
        StructMarket.value memory temp_value = market_map.getValue(market_id);
        date       = temp_value.date_;
        ret_market_id  = temp_value.market_id_;
        sheet_id   = temp_value.sheet_id_;
        class_id   = temp_value.class_id_;
        make_date  = temp_value.make_date_;
        lev_id     = temp_value.lev_id_;
        wh_id      = temp_value.wh_id_;
        place_id   = temp_value.place_id_;
        price_type       = temp_value.type_;
    }
    function getMarket_2(uint market_id)
        returns (
            uint        price,         //价格（代替浮点型）
            uint        list_qty,       //挂牌量
            uint        deal_qty,      //成交量
            uint        rem_qty,       //剩余量
            bytes32      deadline,  //挂牌截止日
            uint        dlv_unit,      //交割单位
            bytes32      user_id,       //用户id
            address     seller_addr   //卖方地址
        )

    {
        StructMarket.value memory temp_value = market_map.getValue(market_id);
        price      = temp_value.price_;
        list_qty   = temp_value.list_qty_;
        deal_qty   = temp_value.deal_qty_;
        rem_qty    = temp_value.rem_qty_;
        deadline   = temp_value.deadline_;
        dlv_unit   = temp_value.dlv_unit_;
        user_id    = temp_value.user_id_;
        seller_addr= temp_value.seller_addr_;
    }
    function getDynamicMarket(uint in_market_id) returns (bytes32 sell_user_id, uint deal_qty, uint rem_qty) //行情中，只有成交量和剩余量会发生变化
    {
        StructMarket.value memory temp_value = market_map.getValue(in_market_id);
        deal_qty        = temp_value.deal_qty_;
        rem_qty         = temp_value.rem_qty_;
        sell_user_id    = temp_value.user_id_;
    }
    function getMarketNum() returns(uint)
    {
        return market_map.size();
    }
    function getMarketIdByIndex(uint index) returns(uint)
    {
        return market_map.getKey(index);
    }
    function updateMarket(bytes32 buy_user_id, uint selected_market_id, uint confirm_qty) returns(uint)
    {
        var(sell_user_id, ret_deal_qty, ret_rem_qty) =  getDynamicMarket(selected_market_id);
        if(ret_rem_qty == 0 || confirm_qty == 0) //剩余量或确认量为0
        {
            //TODO event
            return uint(-1);
        }
        if(confirm_qty > ret_rem_qty ) //确认量大于挂牌量
        {
            //TODO event 
            return uint(-1);
        }
        else if(confirm_qty == ret_rem_qty) //确认量等于挂牌量，删除该条行情
        {
            market_map.remove(selected_market_id);
        }
        else //确立量小于挂牌量，更新成交量，剩余量
        {
            market_map.update(selected_market_id, ret_deal_qty + confirm_qty, ret_rem_qty - confirm_qty);
        }
        /*
        address empty_addr;

        UserList user_list  = UserList(contract_address.getContractAddress(user_list_name));
        assert(user_list != empty_addr);

        User sell_user      = User(user_list.getUserInfo(sell_user_id));
        User buy_user       = User(user_list.getUserInfo(buy_user_id));
        assert(sell_user != empty_addr);
        assert(buy_user != empty_addr);
        */
        
       
       /*
        //更新卖方挂牌请求
        User user_sell = User(data_map[market_id].seller_addr_);
        user_sell.updateListReq(market_id, deal_qty);
        
        //创建卖方合同
        uint con_id_tmp = user_sell.dealSellContract(data_map[market_id].sheet_id_, "卖",  data_map[market_id].price_, deal_qty, user_id);
        //创建买方合同
        User user_buy = User(msg.sender);
        user_buy.dealBuyContract(con_id_tmp,data_map[market_id].sheet_id_, "买",  data_map[market_id].price_, deal_qty, data_map[market_id].user_id_);
        
        */
        return 0;
    }
    //插入行情           
    function insertList1(uint sheet_id,
                        string  class_id, string  make_date,   
                        string  lev_id, string  wh_id, string  place_id)
    {
        market_id = getMarketID();
         
        data_map[market_id].date_ = now;
        data_map[market_id].id_ = market_id;
        data_map[market_id].sheet_id_ = sheet_id;
        data_map[market_id].class_id_ = class_id;
        data_map[market_id].make_date_ = make_date;
        data_map[market_id].lev_id_ = lev_id;
        data_map[market_id].wh_id_ = wh_id;
        data_map[market_id].place_id_ = place_id;
        data_map[market_id].type_ = "一口价";
    }
    function insertList2(uint price, uint quo_qty, uint deal_qty,
                            uint rem_qty, string  quo_deadline, 
                            uint dlv_unit, string user_id ) returns(uint)
    {
        data_map[market_id].price_ = price;
        data_map[market_id].qty_ = quo_qty;
        data_map[market_id].deal_qty_ = deal_qty;
        data_map[market_id].rem_qty_ = rem_qty;
        data_map[market_id].deadline_ = quo_deadline;
        data_map[market_id].dlv_unit_ = dlv_unit;
        data_map[market_id].user_id_ = user_id;
        data_map[market_id].seller_addr_ = msg.sender;
        data_map[market_id].state = true;  
                  
        return market_id;        
    }
  
  
    //摘牌
    function delList(string user_id, uint market_id, uint deal_qty) returns(uint)
    {
        if(deal_qty > data_map[market_id].rem_qty_ )
        {
            //TODO event
            return uint(-1);
        }
        
        //更新成交量，剩余量
        data_map[market_id].deal_qty_  =   deal_qty ;
        data_map[market_id].rem_qty_   -=  deal_qty ;
        
        //更新卖方挂牌请求
        User user_sell = User(data_map[market_id].seller_addr_);
        user_sell.updateListReq(market_id, deal_qty);
        
        //创建卖方合同
        uint con_id_tmp = user_sell.dealSellContract(data_map[market_id].sheet_id_, "卖",  data_map[market_id].price_, deal_qty, user_id);
        //创建买方合同
        User user_buy = User(msg.sender);
        user_buy.dealBuyContract(con_id_tmp,data_map[market_id].sheet_id_, "买",  data_map[market_id].price_, deal_qty, data_map[market_id].user_id_);
        
        //仓单全部成交，删除该条行情
        if(data_map[market_id].rem_qty_ == 0 )
            delete data_map[market_id];
            
        return 0;
        
        
    }
    
}
