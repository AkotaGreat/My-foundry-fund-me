//MIT-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from 'forge-std/Test.sol';
import {FundMe} from '../../src/FundMe.sol';
import {FundMeDeployScript} from '../../script/FundMeDeployScript.s.sol';
import {FundFundMe, WithdrawFundMe} from '../../script/Interactions.s.sol';

contract FundMeTestIntegration is Test {
    FundMe public fundMe;
    FundMeDeployScript Deployer;

    address USER = makeAddr("user");
    uint public constant SEND_VALUE = 0.1 ether;
    uint public constant STARTING_USER_BALANCE = 10 ether;

    function setUp() external {
        vm.txGasPrice(0);
        Deployer = new FundMeDeployScript();
        fundMe = Deployer.run();
        vm.deal(USER, STARTING_USER_BALANCE);
    }
    function testUserAndOwnerInteractions() public {

        uint preUSERBalance = address(USER).balance;
        uint preOwnerBalance = address(fundMe.getOwner()).balance;

        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        uint afterUSERBalance = address(USER).balance;
        uint afterOwnerBalance = address(fundMe.getOwner()).balance;

        assert(address(fundMe).balance == 0);
        assertEq(afterUSERBalance + SEND_VALUE, preUSERBalance);
        assertGe(afterOwnerBalance, SEND_VALUE + preOwnerBalance);
    }
    

}