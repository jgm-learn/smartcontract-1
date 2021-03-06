pragma solidity ^0.4.11;
library StructTrade {
    //合同数据结构
    struct  value
    {
        uint        trade_date_;        //合同日期
        uint        trade_id_;          //合同编号
        uint        sheet_id_;          //仓单编号
        uint        price_;             //价格
        uint        trade_qty_;         //合同量
        uint        payment_;           //货款
        uint        fee_;               //手续费
        //uint        transfer_money_;  //已划货款
        //uint        remainder_money_; //剩余货款
        bytes32      user_id_;          //己方id
        bytes32      opp_id_;           //对手方id
        bytes32      bs_;               //买卖
        bytes32     trade_state_;       //交收状态
        //string      trade_type_       //交易方式
    }   
}
