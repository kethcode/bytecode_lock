object "Lock2" {

	code {
		datacopy(0, dataoffset("runtime"), datasize("runtime"))
		return(0, datasize("runtime"))
	}

	object "runtime" {
		code {

			// require(iszero(callvalue()))

			switch selector()
			// case 0xa69df4b5 /* unlock() */ {
			// 	let retval := verbatim_0i_1o(hex"60_04_60_05_01_3D_52_60_20_3D_F3")
			// 	mstore(0, retval)
			// 	// mstore(0, 4)
			// 	return(0, 0x20)
			// }

			case 0x48c89491 /* unlock(bytes) */ {
				let input := calldataload(4)
				mstore(0, input)
				return(0, 0x20)
			}
			default {
				revert(0, 0)
			}

			function selector() -> s {
                s := div(calldataload(0), 0x100000000000000000000000000000000000000000000000000000000)
            }
		}
	}
}
