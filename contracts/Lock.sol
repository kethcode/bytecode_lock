// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Lock {
    error result(uint256);
    // this is an addition puzzle, part of the tutorial.
    // push 2 numbers onto the stack that will add up to 9.
    // it will be phrased a little differently of course.
    bytes32 answer =
        0x6e1540171b6c0c960b71a7020d9f60077f6af931a8bbf590da0223dacf75c7af;

    function unlock(bytes memory input) external {
        // init format limits contract size to 256 bytes

        // console.logBytes(input);
        bytes memory runtime = abi.encodePacked(
            // input: push two numbers to the stack that add up to the answer
            // ADD(a,b)
            // MSTORE(memory slot, bytes32 value) => memory[slot]
            // RETURN(memory slot, length) => return bytes32 to caller

            input,
            hex"01_3D_52_60_20_3D_F3"
        );

        bytes memory init = abi.encodePacked(
            // PUSH contract length to stack
            // PUSH contract start location in init code to stack
            // PUSH memory slot to stack
            // CODECOPY(stack[0], stack[1], stack[2]) => memory[0] = contract
            // RETURN memory slot, contract length

            hex"60",
            uint8(runtime.length),
            hex"60_0A_3D_39_60",
            uint8(runtime.length),
            hex"3D_F3"
        );

        bytes memory bytecode = abi.encodePacked(init, runtime);

        address deployment;
        assembly {
            deployment := create(0, add(bytecode, 32), mload(bytecode))
        }

        (bool success, bytes memory data) = deployment.staticcall("");

        // result 0: should not occur
        // result 1: success
        // result 2: failure
        // result 3: bad bytecode
        uint256 retval = 0;
        if (!success) {
            retval = 3;
        } else {
            (keccak256(data) == answer) ? retval = 1 : retval = 2;
        }

        revert result(retval);
    }
}

contract Player {
    function play(address lock, bytes calldata output) public returns (bool) {
        Lock l = Lock(lock);
        bool retval = false;

        // (, bytes memory lowLevelData) = lock.staticcall(
        //     abi.encodeWithSignature("unlock(bytes memory input)", output)
        // );

        // assembly {
        //     lowLevelData := add(lowLevelData, 0x04)
        // }
        // console.log("     ", abi.decode(lowLevelData, (uint8)) == 1);
        // return abi.decode(lowLevelData, (uint8)) == 1;
        // this will always revert, but it will catch the result of the attempt
        try l.unlock(output) {} catch (bytes memory lowLevelData) {
            assembly {
                lowLevelData := add(lowLevelData, 0x04)
            }
            console.log("     ", abi.decode(lowLevelData, (uint8)) == 1);
        	retval = abi.decode(lowLevelData, (uint8)) == 1;
        }
        return retval;
    }
}

// jump(shr(253, calldataload(0)))
// https://gist.github.com/Philogy/2de6348f6d5ea36ab24d95356f9ef088
