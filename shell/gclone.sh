#!/bin/bash

echo "-------Git Clone Begin-------"
git clone -b $1 git@github.com:arafat5549/SSFDemo.git $1
cd $1
echo "--------Git Clone End--------"