#!/bin/sh

# END is the signal for whether the while loop ends or not.
END=0

# These are ANSI codes to determine color in the CLI.
RED='\033[0;31m'
GREEN='\033[0;32m'
LGRAY='\033[0;37m'
DGRAY='\033[1;30m'
NORMAL='\033[0m'

rolld6 () {
	# <-- DISREGARD THIS LITTLE REMARK -->
	# So, is this "simulation" fair? Apparently, no.
	# This function produces an average of 3.411.
	# A "$(( 1 + ($RANDOM % 6) ))" produces an average
	# of 3.484.
	# This function is further from the d6 average of
	# 3.5, meaning this is not fair.
	# I suspect the reason's because % 5 does not completely
	# make a fair random number, because $RANDOM generates
	# a number from 0 to 32,767; meaning the numbers 
	# 3, 4 and 5 are less likely to appear, although very
	# marginally. 
	
	# Disregard it, because the for loop actually
	# makes this function very fair. The average goes from
	# 3.411 to the range of 3.495 to 3.513. 
	# Much much closer to 3.5 than using a regular $RANDOM variable.
	
	# Every fifth element starting from the first is a 
	# number on a d6. The four numbers after are its
	# adjacent sides on the actual die.
	# ex: (1) 5 4 2 3 (2) 1 4 6 3 
	# $adjacent represents the amount of adjacent faces
	# $face is the face side, the one facing up
	# $sides decides how many sides there are in the dice.
	# You want to subtract the face because you wanna calculate
	# from 0. It's the Y axis on the array. deeSix in particular
	# goes from 0 to 29. Having $sides as 6 makes it possible
	# to do ${deeSix[30]} which is outside the range.
	# The extra arithmetic is not optimized but helps
	# with readaility, I would say.
	deeSix=(1 5 4 2 3 2 1 4 6 3 3 1 2 6 5 4 1 5 6 2 5 6 4 1 3 6 2 4 5 3)
	adjacent=4
	sides=6
	face=1
	adjacent=$(( $adjacent + $face ))
	sides=$(( $sides - $face ))
	
	# The first ($RANDOM % 5) decides whether the dice result
	# stays on the "face" or goes to one of the four adjacent
	# faces. Then, decide which one of the five-number
	# segments it goes to via + (5 * ($RANDOM % 5)).
	# Basically, imagine it as a 5x6 array, the first decides
	# the X axis and the second decides the Y axis.
	result=$(( ($RANDOM % ($adjacent + $face)) + (($adjacent + $face) * ($RANDOM % $sides)) ))
	
	# Then, the dice "rolls". The $decider decides if the die
	# is on the face or goes to the adjacent faces. Then
	# the first $result determines what kind of value the die 
	# gets, from 0 to 5. This $result is then used as a new input
	# for the Y axis on the array. This will happen ten times.
	for i in {1..10}
	do
		decider=$(( $RANDOM % $adjacent ))
		result=$(( deeSix[result] - 1 ))
		result=$(( $decider + (5 * $result) ))
	done
	
	# Then, return the result from within the deeSix array.
	dSix=${deeSix[result]}
}

rolld10 () {
	deeTen=(0 8 3 7 4 1 9 6 4 7 2 6 9 5 8 3 7 0 8 5 4 0 7 1 6 5 3 8 2 9 6 4 1 9 2 7 1 4 0 3 8 2 5 3 0 9 5 2 6 1)
	adjacent=4
	sides=10
	face=1
	adjacent=$(( $adjacent + $face ))
	sides=$(( $sides - $face ))
	
	result=$(( ($RANDOM % $adjacent) + ($adjacent * ($RANDOM % $sides)) ))
	
	for i in {1..10}
	do
		decider=$(( $RANDOM % $adjacent ))
		
		# Unlike rolld6, this one doesn't have "- 1" because
		# the result is from 0 to 9, not 1 to 10
		result=$(( deeTen[result] ))
		
		result=$(( $decide + (5 * $result) ))
	done
	
	dTen=${deeTen[result]}
}
	
# The first clear is to remove the other text, and make
# only the dice roller visible.
clear

# Initialize the $dSix and $dTen variables, because
# they will be used a lot in the while loop.
dSix=0
dTen=0

while [ $END = 0 ]
do
	# Determine the three dice, a d6 and 2d10.
	# Do the functions to put or reset the dice values.
	rolld6
	rolld10
	
	# Print the dice results and the "title" of sort.
	# Cut the second ${dTen} off to re-roll the die via
	# rolld10, then do printf to continue.
	printf "${GREEN}IRONSWORN DICE ${DGRAY}(d6 vs. 2d10)\n"
	printf "${DGRAY}d6: ${NORMAL}${dSix}"
	
	# This for loop is for my homebrew, Eyes of Destiny which
	# uses a dice pool. Ignore the other dice when needed.
	for i in {1..4}
	do
		rolld6
		printf " ${dSix}"
	done
	
	printf "${DGRAY}.. d10: ${NORMAL}${dTen}"
	rolld10
	printf " ${dTen}"
	
	# Read some input. If you input "8491" the script ends.
	read none
	if [ $none = 8491 ]
		then
		clear
		END=1
	fi
	
	# Then clear the previous dice results for a
	# new set of output.
	clear
	
done
