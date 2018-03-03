#!/bin/bash
echo "-------Git Init Begin-------"
git init 
git remote add origin git@192.168.0.133:wangyao/$1.git
#git add README.md
git add .
git commit -m "Init Commit"
git push -u origin master
echo "--------Git Init End--------"