const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("Lock", function () {
  async function deployLockFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Lock = await ethers.getContractFactory("Lock");
    const lock = await Lock.deploy();

    const Player = await ethers.getContractFactory("Player");
    const player = await Player.deploy();

    return { lock, player, owner, otherAccount };
  }

  describe("Lock", function () {
    it("Should revert with bad bytecode on bad code", async function () {
      const { lock } = await loadFixture(deployLockFixture);
      // await expect(lock.unlock("0x6003")).to.be.revertedWith("bad bytecode");
      await expect(lock.unlock("0x6003"))
        .to.be.revertedWithCustomError(lock, "result")
        .withArgs(3);
    });
    it("Should revert with failure on wrong answer", async function () {
      const { lock } = await loadFixture(deployLockFixture);
      //   await expect(lock.unlock("0x60036005")).to.be.revertedWith("failure");
      await expect(lock.unlock("0x60036005"))
        .to.be.revertedWithCustomError(lock, "result")
        .withArgs(2);
    });
    it("Should revert with success on right answer", async function () {
      const { lock } = await loadFixture(deployLockFixture);
      //   await expect(lock.unlock("0x60036006")).to.be.revertedWith("success");
      await expect(lock.unlock("0x60036006"))
        .to.be.revertedWithCustomError(lock, "result")
        .withArgs(1);
    });
  });

  describe("Player", function () {
    it("Should return false on bad code", async function () {
      const { lock, player } = await loadFixture(deployLockFixture);
      //console.log(await player.play(lock.address, "0x6003"));
      expect(await player.play(lock.address, "0x6003")).to.equal(false);
    });

    it("Should return false on wrong answer", async function () {
      const { lock, player } = await loadFixture(deployLockFixture);
      //console.log(await player.play(lock.address, "0x60036005"));
      expect(await player.play(lock.address, "0x60036005")).to.equal(false);
    });

    it("Should return true on right answer", async function () {
      const { lock, player } = await loadFixture(deployLockFixture);
      //console.log(await player.play(lock.address, "0x60036006"));
      expect(await player.play(lock.address, "0x60036006")).to.equal(true);
    });
  });
});
