function pkill
  set pid (netstat -ano | grep $argv | awk '{if($4=="LISTENING") print $5+0}')
    #echo $pid
  if test $pid -gt 0;  
    taskkill /pid $pid -t -f;
  else
    echo "Port not linsenting"; 
  end
    #netstat -ano | grep 8080 | awk '{if($4=="LISTENING") print $5+0}'
end
