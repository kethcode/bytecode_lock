// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Lock {
    // this is an addition puzzle, part of the tutorial.
    // push 2 numbers onto the stack that will add up to 9.
    // it will be phrased a little differently of course.
    bytes32 answer =
        0x6e1540171b6c0c960b71a7020d9f60077f6af931a8bbf590da0223dacf75c7af;

    function unlock(bytes memory input) public {
        // init format limits contract size to 256 bytes

        console.logBytes(input);
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

        (bool success, bytes memory data) = deployment.call("");

		// result 0: should not occur
		// result 1: success
		// result 2: failure
		// result 3: bad bytecode
        // uint256 result = 0;
        // if (!success) {
        //     result = 3;
        // }
        // (keccak256(data) == answer) ? result = 1 : result = 2;

		// assembly {
		// 	mstore8(0x00, result)
		// 	revert(0x00, 0x01)
		// }

        if (!success) {
            console.log("bad bytecode");
            revert("bad bytecode");
        }

        console.log((keccak256(data) == answer) ? "success" : "failure");
        revert((keccak256(data) == answer) ? "success" : "failure");
    }
}

contract Player {
    function play(address lock, bytes calldata output) public returns (bool) {
        // this will always fail, but it will return the result of the attempt
        console.log(lock);
        console.logBytes(output);

        (bool success, bytes memory data) = lock.call(
            abi.encodeWithSignature("unlock(bytes memory input)", output)
        );

		console.log(success);
		console.logBytes(data);
    }
}

// jump(shr(253, calldataload(0)))
// https://gist.github.com/Philogy/2de6348f6d5ea36ab24d95356f9ef088


        // if (!success) {
        // 	revert(0);
        // }
        // revert((keccak256(data) == answer) ? 0x0001 : 0x0000);

        // // console.log("     s: ", success);
        // // console.log("     d: ", abi.decode(data, (uint256)));

        // // assembly {
        // // 	let ptr := mload(0x40)
        // // 	let size := returndatasize()
        // // 	returndatacopy(ptr, 0, size)
        // // 	revert(ptr, size)
        // // }

		        // console.logBytes32(keccak256(data));
        // console.logBytes32(answer);
        //console.log(keccak256(data) == keccak256(abi.encodePacked(answer)) ? "success" : "failure");



		    // function _getRevertMsg(bytes memory _returnData)
    //     internal
    //     pure
    //     returns (string memory)
    // {
    //     // If the _res length is less than 68, then the transaction failed silently (without a revert message)
    //     if (_returnData.length < 68) return "Transaction reverted silently";

    //     assembly {
    //         // Slice the sighash.
    //         _returnData := add(_returnData, 0x04)
    //     }
    //     return abi.decode(_returnData, (string)); // All that remains is the revert string
    // }

			// uint256 result = 0;
		// assembly {
		// 	let ptr := mload(0x40)
		// 	returndatacopy(ptr, 0, 1)
		// 	result := mload(ptr)
		// }
		// console.log(result);

        // if (!success) {
        //     string memory _revertMsg = _getRevertMsg(data);
        //     console.log(_revertMsg);
        //     return (keccak256(abi.encodePacked(_revertMsg)) ==
        //         keccak256(abi.encodePacked("success")));
        // }

        // if (!success) {
        //     assembly {
        //         let ptr := mload(0x40)
        //         let size := returndatasize()
        //         returndatacopy(ptr, 0, size)
        //         revert(ptr, size)
        //     }
        // }

        // console.log("     s: ", success);
        // console.logBytes(data);