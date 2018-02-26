function mtool
    cp -r ~/.config/fish /d/workspace/MyTools/conf/
    cdtool 

      if test $argv;  
        gpush $argv;
      else
        echo "enter gitpush log"; 
      end

    cd -
end