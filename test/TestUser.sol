pragma solidity ^0.4.11;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/User.sol";
contract TestUser
{
    User user;
   function beforeEach()
   {
        user = new User();
        user.insertSheet("user_id",1,"SR","make_date","level_id","wh_id","产地",20);
   }
   function testInsertSheet()
   {
        var all_amount = user.getReceiptAmount(1);
        Assert.equal(all_amount, 20, "");
   }

   function testFreeze_normal()
   {
        user.freeze(1, 5);
        user.freeze(1, 6);
        var all_amount = user.getReceiptAmount(1);
        Assert.equal(all_amount, 20, "");

        var available_amount = user.getAvailableAmount(1);
        Assert.equal(available_amount, 20 - 5 -6, "");
   }
   function testFreeze_exceed_owned_sheet()
   {
        user.freeze(1, 21);
        var available_amount = user.getAvailableAmount(1);
        Assert.equal(available_amount, 20, "");
   }
}
