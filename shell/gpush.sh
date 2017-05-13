#!/bin/bash
echo "-------Git Push Begin-------"
git add .
git commit -m $1
echo $1
git push origin $2
echo "--------Git Push End--------"