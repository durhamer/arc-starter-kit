// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/HelloArchitect.sol";

contract HelloArchitectTest is Test {
    HelloArchitect public hello;
    address public deployer = address(this);

    function setUp() public {
        hello = new HelloArchitect();
    }

    function testInitialGreeting() public view {
        assertEq(hello.getGreeting(), "Hello Architect! Welcome to Arc.");
    }

    function testOwnerIsDeployer() public view {
        assertEq(hello.getOwner(), deployer);
    }

    function testSetGreeting() public {
        hello.setGreeting("Building on Arc!");
        assertEq(hello.getGreeting(), "Building on Arc!");
    }

    function testGreetingChangedEvent() public {
        vm.expectEmit(true, true, true, true);
        emit HelloArchitect.GreetingChanged(deployer, "New greeting");
        hello.setGreeting("New greeting");
    }

    function testAnyoneCanSetGreeting() public {
        address user = address(0xBEEF);
        vm.prank(user);
        hello.setGreeting("User greeting");
        assertEq(hello.getGreeting(), "User greeting");
    }
}
