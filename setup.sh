#!/bin/sh

for w in 'first-attempt' 'second-attempt'
do
	printf "\033[35m${w}\033[0m\n"
	apt-get update
	apt-get -y install bison autoconf
done

