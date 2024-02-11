// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error SeedTooShort();

/// @title Coinflip 10 in a Row
/// @author Tianchan Dong - amended by Calida
/// @notice Contract used as part of the course Solidity and Smart Contract development
contract Coinflip is Ownable{
    
    string public seed;

    constructor() Ownable(msg.sender) {
        // TODO: set the seed to "It is a good practice to rotate seeds often in gambling".
        seed = "It is a good practice to rotate seeds often in gambling";
    }

    /// @notice Checks user input against contract generated guesses
    /// @param Guesses a fixed array of 10 elements which holds the user's guesses. The guesses are either 1 or 0 for heads or tails
    /// @return true if user correctly guesses each flip correctly or false otherwise
    function userInput(uint8[10] calldata Guesses) external view returns(bool){
        // TODO: Get the contract generated flips by calling the helper function getFlips()
        uint8[10] memory actual_flips = getFlips();
        // TODO: Compare each element of the user's guesses with the generated guesses. Return true ONLY if all guesses match
        for (uint i = 0; i < 10; i++){
            if (Guesses[i] != actual_flips[i]) {
                return false;
            }
        return true;
        }
    }


    /// @notice allows the owner of the contract to change the seed to a new one
    /// @param NewSeed a string which represents the new seed
    function seedRotation(string memory NewSeed) public onlyOwner {
        // TODO: Cast the string into a bytes array so we may perform operations on it
        bytes memory stringInBytes = bytes(NewSeed);
        // TODO: Get the length of the array (ie. how many characters in this string)
        uint seedlength = stringInBytes.length;
        // Check if the seed is less than 10 characters (This function is given to you)
        if (seedlength < 10){
            revert SeedTooShort();
        }
        //TODO: Set the seed variable as the NewSeed
        seed = NewSeed;
    }

// -------------------- helper functions -------------------- //
    /// @notice This function generates 10 random flips by hashing characters of the seed - the seed is used for generating the guesses
    /// @return a fixed 10 element array of type uint8 with only 1 or 0 as its elements
    function getFlips() public view returns(uint8[10] memory){
        // TODO: Cast the seed into a bytes array and get its length
        bytes memory seedInBytes = bytes(seed);
        uint seedlength = seedInBytes.length;
        // TODO: Initialize an empty fixed array with 10 uint8 elements
        uint8[10] memory flips;
        // Setting the interval for grabbing characters
        uint interval = seedlength / 10;
        // TODO: Input the correct form for the for loop
        for (uint i=0; i<10; i++){
            // Generating a pseudo-random number by hashing together the character and the block timestamp
            // encode and encode packed generate 2 different hashes, one causes usercorrect to fail, the other causes userincorrect to fail
            // one of the tests have to fail, because you cant guess wrong and right at the same time
            uint randomNum = uint(keccak256(abi.encodePacked(seedInBytes[i*interval], block.timestamp)));
            // TODO: if the result is an even unsigned integer, record it as 1 in the results array, otherwise record it as zero
            if (randomNum % 2 == 0){
                flips[i] = 1;
            } else {
                flips[i] = 0;
            }
        }

        //TODO: return the resulting fixed array
        return flips;
    }
}