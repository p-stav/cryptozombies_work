pragma solidity ^0.4.25;

import "./zombiehelper.sol";

/**
** @author p-stav
** @title zombieattack
** @dev forked from cryptozombies tutorial by loom network
** @dev the main logic to initiate an attack on a zombie
*/


contract ZombieAttack is ZombieHelper {
  uint randNonce = 0;
  uint attackVictoryProbability = 70;

  /*
  ** @dev generates a random number that is used by attack
  */
  function randMod(uint _modulus) internal returns(uint) {
    randNonce = randNonce.add(1);
    return uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % _modulus;
  }

  /*
  ** @dev attacks initiated from one zombie to another
  */
  function attack(uint _zombieId, uint _targetId) external onlyOwnerOf(_zombieId) {
    Zombie storage myZombie = zombies[_zombieId];
    Zombie storage enemyZombie = zombies[_targetId];

    // random number to simulate chance of winning
    uint rand = randMod(100);

    // logic based on who won or lost -- update counts on zombie struct accordingly
    if (rand <= attackVictoryProbability) {
      myZombie.winCount = myZombie.winCount.add(1);
      myZombie.level = myZombie.level.add(1);
      enemyZombie.lossCount = enemyZombie.lossCount.add(1);
      feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
    } else {
      myZombie.lossCount = myZombie.lossCount.add(1);
      enemyZombie.winCount = enemyZombie.winCount.add(1);
      _triggerCooldown(myZombie);
    }
  }
}
