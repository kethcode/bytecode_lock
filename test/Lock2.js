const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("Lock2", function () {
  async function deployLockFixture() {
    var abi = require("../build/Lock2.abi.json");
    var bytecode = require("../build/Lock2.bytecode.json");

    const Lock2Contract = await hre.ethers.getContractFactory(abi, bytecode);
    const lock2 = await Lock2Contract.deploy();
    await lock2.deployed();

    return { lock2 };
  }

  describe("The deployment", function () {
    it("Should deploy to an address", async function () {
      const { lock2 } = await loadFixture(deployLockFixture);

      expect(lock2.address).is.properAddress;
      expect(lock2.address).is.not.null;
    });
  });

  //   describe("unlock", function () {
  //     it("Should return the correct value", async function () {
  //       const { lock2 } = await loadFixture(deployLockFixture);

  //       expect(await lock2.unlock()).to.equal(9);

  //     });
  //   });
  describe("unlock", function () {
    it("Should return the correct value", async function () {
      const { lock2 } = await loadFixture(deployLockFixture);

      expect(await lock2.unlock("0x60056004")).to.equal("0x60056004");
    });
  });
});

// describe("Lock", function () {
//   async function deployLockFixture() {
//     // Contracts are deployed using the first signer/account by default
//     const [owner, otherAccount] = await ethers.getSigners();

//     const Lock = await ethers.getContractFactory("Lock");
//     const lock = await Lock.deploy();

//     const Player = await ethers.getContractFactory("Player");
//     const player = await Player.deploy();

//     return { lock, player, owner, otherAccount };
//   }

//   describe("Lock", function () {
//     it("Should revert with bad bytecode on bad code", async function () {
//       const { lock } = await loadFixture(deployLockFixture);
//       // await expect(lock.unlock("0x6003")).to.be.revertedWith("bad bytecode");
//       await expect(lock.unlock("0x6003"))
//         .to.be.revertedWithCustomError(lock, "result")
//         .withArgs(3);
//     });
//     it("Should revert with failure on wrong answer", async function () {
//       const { lock } = await loadFixture(deployLockFixture);
//       //   await expect(lock.unlock("0x60036005")).to.be.revertedWith("failure");
//       await expect(lock.unlock("0x60036005"))
//         .to.be.revertedWithCustomError(lock, "result")
//         .withArgs(2);
//     });
//     it("Should revert with success on right answer", async function () {
//       const { lock } = await loadFixture(deployLockFixture);
//       //   await expect(lock.unlock("0x60036006")).to.be.revertedWith("success");
//       await expect(lock.unlock("0x60036006"))
//         .to.be.revertedWithCustomError(lock, "result")
//         .withArgs(1);
//     });
//   });

//   describe("Player", function () {
//     it("Should return false on bad code", async function () {
//       const { lock, player } = await loadFixture(deployLockFixture);
//       //console.log(await player.play(lock.address, "0x6003"));
//       expect(await player.play(lock.address, "0x6003")).to.equal(false);
//     });

//     it("Should return false on wrong answer", async function () {
//       const { lock, player } = await loadFixture(deployLockFixture);
//       //console.log(await player.play(lock.address, "0x60036005"));
//       expect(await player.play(lock.address, "0x60036005")).to.equal(false);
//     });

//     it("Should return true on right answer", async function () {
//       const { lock, player } = await loadFixture(deployLockFixture);
//       //console.log(await player.play(lock.address, "0x60036006"));
//       expect(await player.play(lock.address, "0x60036006")).to.equal(true);
//     });
//   });
// });
