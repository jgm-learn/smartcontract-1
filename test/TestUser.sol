pragma solidity ^0.4.11;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/User.sol";
import "../contracts/ContractAddress.sol";
import "../contracts/Market.sol";
contract TestUser
{
    User user;
    Market market;
    ContractAddress contract_addr;
    string market_name;
    bytes32 user_id;
    uint sheet_id;
    uint all_amount;
    uint available_amount;
    uint frozen_amount;
   function beforeEach()
   {
        user = new User();
        contract_addr = new ContractAddress();
        market  = new Market();
        market_name = "market";

        contract_addr.setContractAddress(market_name, market);
        user.setContractAddress(contract_addr);
        user.setMarketName(market_name);

        user_id = "user_a";
        sheet_id = 3;
        all_amount = 20;
        available_amount = 30;
        frozen_amount = 40;
   }
   function testInsertSheet()
   {
        user.insertSheet(user_id,sheet_id,"SR","make_date","level_id","wh_id","产地",all_amount, available_amount, frozen_amount);
        var(ret_all_amount, ret_available_amount, ret_frozen_amount) = user.getSheetAmount(sheet_id);
        Assert.equal(all_amount, ret_all_amount, "");
        Assert.equal(available_amount, ret_available_amount, "");
        Assert.equal(frozen_amount, ret_frozen_amount, "");
   }

   function testFreeze_normal()
   {
        user.insertSheet(user_id,sheet_id,"SR","make_date","level_id","wh_id","产地",all_amount, available_amount, frozen_amount);
        user.freeze(sheet_id, 5);
        user.freeze(sheet_id, 6);
        var(ret_all_amount, ret_available_amount, ret_frozen_amount) = user.getSheetAmount(sheet_id);
        Assert.equal(ret_all_amount, ret_all_amount, "");
        Assert.equal(ret_available_amount, available_amount - 5 -6, "");
        Assert.equal(ret_frozen_amount, frozen_amount + 5 + 6, "");
   }
   function testFreeze_exceed_owned_sheet()
   {
        user.insertSheet(user_id,sheet_id,"SR","make_date","level_id","wh_id","产地",all_amount, available_amount, frozen_amount);
        user.freeze(1, available_amount + 1);
        var(ret_all_amount, ret_available_amount, ret_frozen_amount) = user.getSheetAmount(sheet_id);
        Assert.equal(all_amount, ret_all_amount, "");
        Assert.equal(available_amount, ret_available_amount, "");
        Assert.equal(frozen_amount, ret_frozen_amount, "");
   }
}
