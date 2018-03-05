<<<<<<< HEAD:shell/ginit2.sh
#!/bin/bash
echo "-------Git Init Begin[github.com:arafat5549]-------"
git init 
git remote add origin git@github.com:arafat5549/$1.git
#git add README.md
git add .
git commit -m "Init Commit"
git push -u origin master
echo "--------Git Init End--------"
=======
git clone git@192.168.0.133:wangyao/sanming_gridsys.git
cd sanming_gridsys
touch README.md
git add README.md
git commit -m "add README"
git push -u origin master
>>>>>>> d1377683825f9af913fbf8217193e92d78679bbb:conf/shell/ginit2.sh
