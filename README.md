# Bash-Ironsworn-Dice
This bash script is for rolling dice in the tabletop RPG Ironsworn. It simulates real dice via dice arrays and loops, making the results as close to real life as possible.

## Usage
On Ubuntu, use `bash dice.sh` for it to work.

## Dice Arrays
deeSix and deeTen are arrays containing values of each side of both type of dice, along with what their adjacent sides are. Think of these arrays as 3D arrays where the first element on the X axis represents the actual dice side, from 1 to 6 (d6) or 0 to 9 (d10).

Both d6 and d10s have 4 adjacent sides per face, so every 5th element starting from the 1st in both arrays represent the Y axis on the 3D array.

The arrays are based on real dice.

## Loops
Using a loop, the dice is "rolled" through the array ten times. This in combination with the dice arrays simulates the rolling of dice, making this much more fair and real than using a random number generator. 
