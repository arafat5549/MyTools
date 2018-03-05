#!/bin/bash
echo "-------Git Init Begin[github.com:arafat5549]-------"
git init 
git remote add origin git@github.com:arafat5549/$1.git
#git add README.md
git add .
git commit -m "Init Commit"
git push -u origin master
echo "--------Git Init End--------"