pragma solidity ^0.4.11;
 
import "./lib/StructUserAddr.sol";
import "./lib/LibUserAddrMap.sol";
import "./User.sol";

contract UserList
{
    using LibUserAddrMap for LibUserAddrMap.UserAddrMap;
    LibUserAddrMap.UserAddrMap   user_map;
    StructUserAddr.value user_addr;
    User user;
    function newUser() returns (address)
    {
        return new User();
    }
    function addUser(address external_addr, address agent_addr, bytes32 user_id, int user_auth)
    {
        user_map.insert(user_id, StructUserAddr.value(external_addr, agent_addr, user_id, user_auth));
    }
    
    //获取用户数量
    function getUserNum() returns (uint)
    {
        return user_map.size();
    }

    function getUserInfo(bytes32 user_id) returns(address external_addr, address agent_addr, bytes32 ret_user_id, int user_auth)
    {
        user_addr    = user_map.getValue(user_id);
        external_addr           = user_addr.extern_addr_;
        agent_addr              = user_addr.agent_addr_;
        ret_user_id             = user_addr.user_id_;
        user_auth               = user_addr.user_auth_;
    }

    function getUserInfoByIndex(uint index) returns(address external_addr, address agent_addr, bytes32 ret_user_id, int user_auth)
    {
        user_addr  = user_map.getValue(index);
        external_addr           = user_addr.extern_addr_;
        agent_addr              = user_addr.agent_addr_;
        ret_user_id             = user_addr.user_id_;
        user_auth               = user_addr.user_auth_;
    }

    //获取用户的合约地址
    function getUserAgentAddr(bytes32 user_id) returns(address agent_addr)
    {
        user_addr    = user_map.getValue(user_id);
        agent_addr   = user_addr.agent_addr_;
    }
    function getAgentAddrByIndex(uint index) returns(address agent_addr)
    {
        user_addr  = user_map.getValue(index);
        agent_addr              = user_addr.agent_addr_;
    }

    //获取外部账户地址
    function getExternalAddr(bytes32 user_id) returns(address external_addr)
    {
        user_addr       = user_map.getValue(user_id);
        external_addr   = user_addr.extern_addr_; 
    }

    //获取user_id
    function getUserIDByIndex(uint index) returns(bytes32 user_id)
    {
        user_addr  = user_map.getValue(index);
        user_id    = user_addr.user_id_;
    }


    //查询user_id 是否存在
    function isExisted(bytes32 user_id) returns(bool ret)
    {
       ret = user_map.isExisted(user_id);
    }


    function delUserInfo(bytes32 user_id)
    {
        user_map.remove(user_id);
    }

}
