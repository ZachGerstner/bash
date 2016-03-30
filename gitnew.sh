#!/bin/bash
DIR=bash
echo "Edit DIR variable before using this! 5 sec rest..."
sleep 5
echo "# bash" >> README.md
git init
git add README.md
git commit -m "Initation commit"
git remote add origin https://github.com/ZachGerstner/$DIR
git push -u origin master
