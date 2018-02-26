#!/bin/bash
echo "-------Git Push Begin-------"
git add .
git commit -m $1
echo $1
git push origin master
echo "--------Git Push End--------"