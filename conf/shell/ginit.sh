<<<<<<< HEAD:shell/ginit.sh
#!/bin/bash
echo "-------Git Init Begin[192.168.0.133:wangyao]-------"
git init 
git remote add origin git@192.168.0.133:wangyao/$1.git
#git add README.md
git add .
git commit -m "Init Commit"
git push -u origin master
=======
#!/bin/bash
echo "-------Git Init Begin-------"
git init 
git remote add origin git@192.168.0.133:wangyao/$1.git
#git add README.md
git add .
git commit -m "Init Commit"
git push -u origin master
>>>>>>> d1377683825f9af913fbf8217193e92d78679bbb:conf/shell/ginit.sh
echo "--------Git Init End--------"