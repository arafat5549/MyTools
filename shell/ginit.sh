#!/bin/bash
echo "-------Git Init Begin-------"
git init 
git add README.md
git add .
git commit -m "Init Commit"
git remote add origin git@github.com:arafat5549/$1.git
git push -u origin master
echo "--------Git Init End--------"