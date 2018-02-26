#!/bin/bash

echo "-------Git Clone Begin-------"
git clone -b $2 git@github.com:arafat5549/$1.git $2
cd $2
echo "--------Git Clone End--------"