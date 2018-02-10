cd ~
# -*- coding: utf-8 -*- 
chcp 65001
#powershell5下载地址  https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/W2K12-KB3191565-x64.msu
$MyWorkSpace="C:\Dev\workspace"
$MyHome="~"
$HYPERV="C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks"
$GOAPP="C:\Users\arafa\env\dgolang\app"

#中文输出需要先转换为unicode
function _utf8ToUnicode($sourceStr){
    $matchEvaluator={
        param($v)
        [char][int]($v.Value.replace('\u','0x'))
    }
    [regex]::Replace($sourceStr,'\\u[0-9-a-f]{4}',$matchEvaluator)
}

#$sourceStr="abc\u6717\u8bf5strong\uff1a\u5ef6\u4f38<\/p>\n<p>\u6211\u5e38\u5e38\u5728\u503e\u542c\u5927\u81ea\u7136\u58f0\u97f3\u7684\u65f6\u5019\uff0c\u89c9\u5bdf\u5230\u4e00\u4e9b\u9690\u6ca1\u5728\u65f6\u5149\u6df1\u5904\u7684\u8bdd\u8bed\u3002\u8fd9\u4e9b\u6709\u7740\u6c89\u6728\u4e00\u6837\u8d28\u5730\u7684\u58f0\u97f3\uff0c\u4f3c\u4e4e\u67d4\u8f6f\u5374\u53c8\u575a\u97e7\u3002\u5c3d\u7ba1\u90a3\u4e9b\u7ebf\u7d22\u65f6\u800c\u6e05\u6670\uff0c\u65f6\u800c\u6a21\u7cca\uff0c\u53ef\u662f\u5728\u9690\u7ea6\u7684\u8282\u594f\u91cc\u5374\u603b\u6709\u4e9b\u7529\u4e0d\u8131\u7684\u8bb0\u5fc6\u75d5\u8ff9\uff0c\u575a\u5b9a\uff0c\u53c8\u5bcc\u4e8e\u8868\u60c5\u3002"
#_utf8ToUnicode($sourceStr)

#
#
#  重命名已有的命令(模拟Bash命令)
#
#
Set-Alias which Get-Command   #


#go与c交互
#设置编译参数-ldflags "-w -s"。 其中-w为去掉调试信息（无法使用gdb调试），-s为去掉符号表（暂未清楚具体作用）。
# go build -buildmode=c-archive libC.go
# 动态编译 
# gcc -shared -pthread -o main.dll main.c libC.a -lWinMM -lntdll -lWS2_32
# 静态编译
# gcc main.c libC.a -o test.exe -l winmm -l ntdll -l Ws2_32
# 统计代码行数
#find . -name "*.go" | xargs grep '^.' | wc -l                                 
#docker-compose build | docker-compose up -d

#
#
#  重命名已有的命令(模拟Bash命令)
#
#

#命令行打开chrome浏览器浏览网页
function Search-Url{
 [CmdletBinding(DefaultParameterSetName="NoCredentials")]
   param(
      [Parameter(Mandatory=$true,Position=0)]
      [System.Uri]$Uri,
      [Parameter(Mandatory=$false,Position=1)]
      [System.Uri]$agent    
   )

   $userAgent = "https://www.google.com/search?q=$Uri&ie=utf-8" 
    if($agent -eq [System.Uri]("bd") -or $agent -eq [System.Uri]("baidu")){
        $userAgent = "https://www.baidu.com/s?wd=$Uri&ie=utf-8"
    }
    elseif ($agent -eq [System.Uri]("github") -or $agent -eq [System.Uri]("gh")) {
        $userAgent = "https://github.com/search?utf8=%E2%9C%93&q=$Uri"
    }
    elseif($agent -eq [System.Uri]("sof") -or $agent -eq [System.Uri]("stackoverflow")){
        $userAgent = "https://stackoverflow.com/search?q=$Uri"
    }
    elseif($agent -eq [System.Uri]("bookmark") -or $agent -eq [System.Uri]("bm")){
        $userAgent =(_bookmark $bookmarks $Uri "0")
        
        #return
    }
    & "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"  $userAgent
}
Set-Alias url Search-Url 

$MyChromeJsonPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Bookmarks"
$MyChromeJson = ConvertFrom-Json((Get-Content $MyChromeJsonPath -Encoding UTF8) | out-string)
$bookmarks = $MyChromeJson.roots.bookmark_bar.children

function _bookmark($bookmarks, $text,$flag) {
    foreach ($item in $bookmarks) {
        switch ($item.type) {
            'folder' {
                if ($item.name -ne 'private') {
                    _bookmark $item.children ($text)
                }
                break
            }
            'url' {
                if($item.name -match $text){
                    if($flag -eq "0"){
                        Write-Host -ForegroundColor Green $item.url
                        return $item.url;
                    }
                    else{
                        $link = "* [$($item.name)] $($item.url)"
                        Write-Host -ForegroundColor Green $link
                    }
                    
                }
                break
            }
 
        }
    }       
}


#
#
# Alias别名定义区域
#
#

function My_Test{
    # create new excel instance
     $objExcel = New-Object -comobject Excel.Application
     $objExcel.Visible = $True
     $objWorkbook = $objExcel.Workbooks.Add()
     $objWorksheet = $objWorkbook.Worksheets.Item(1)

     # write information to the excel file
    $i = 0
    $first10 = (ps | sort ws -Descending | select -first 10)
    $first10 | foreach -Process {$i++; $objWorksheet.Cells.Item($i,1) = $_.name; $objWorksheet.Cells.Item($i,2) = $_.ws}
    $otherMem = (ps | measure ws -s).Sum - ($first10 | measure ws -s).Sum
    $objWorksheet.Cells.Item(11,1) = "Others"; $objWorksheet.Cells.Item(11,2) = $otherMem

    # draw the pie chart
    $objCharts = $objWorksheet.ChartObjects()
    $objChart = $objCharts.Add(0, 0, 500, 300)
    $objChart.Chart.SetSourceData($objWorksheet.range("A1:B11"), 2)
    $objChart.Chart.ChartType = 70
    $objChart.Chart.ApplyDataLabels(5)
}
Set-Alias mytest My_Test

function Get-SerialNumber {
    param
    (
        [Parameter(Mandatory = $false,
                   ValueFromPipeline = $True,
                   ValueFromPipelineByPropertyName = $True)]
        #[System.String][Alias("cn")]$computer=$env:COMPUTERNAME
        [System.String]$computer=$env:COMPUTERNAME
    )
    $computer
    $cred = Get-Credential
    $Serial = Get-WmiObject win32_bios -ComputerName $computer -Credential $cred | Select-Object -ExpandProperty SerialNumber
    return $Serial

}# close function

function CdCmd_GO{
     cd $Home"\env\go"
}
Set-Alias cdgo CdCmd_GO
function CdCmd_JS{
     cd $MyWorkSpace"\ReactProject"
}
Set-Alias cdjs CdCmd_JS
function CdCmd_DPHP{
     cd $Home"\env\dphp"
}
Set-Alias cddphp CdCmd_DPHP
function CdCmd_DGOLANG{
     cd $Home"\env\dgolang"
}
Set-Alias cddgo CdCmd_DGOLANG

function Sh_Xpl {
   [CmdletBinding(DefaultParameterSetName="NoCredentials")]
   param(
      [Parameter(Mandatory=$false,Position=0)]
      [System.Uri][Alias("path")]$Uri    
   )
   if(Test-Path $PWD/$Uri)
   {
        sh xpl.sh $Uri
   }
   else{
      if($Uri -ne $null)
      {
        New-Item $Uri
      }
      sh xpl.sh $Uri
   }
   
}
Set-Alias xpl Sh_Xpl

# Get-ChildItem *.zip | % {& "C:\Program Files\7-Zip\7z.exe" "x" $_ "-o$PWD"}
#copy -Force -Recurse G:\EFI\* Y:\EFI
function Export-HTML{
    Get-ChildItem $HOME\*.ps1  | Select-String 'clear' |  #-Recurse
    foreach {
        $matchTokens = $_ -split ':'
        Write-Verbose $_
        
        [PSCustomObject]@{
            File = ($matchTokens | select -First 2) -join ':'
            Line = $matchTokens[2]
            Context = ($matchTokens | select -Skip 3 ) -join ':'
        }
    }   | ConvertTo-Html |
    Out-File "c:\select-string-report.html"
}


#
#
# Docker命令区域
#
#

function Dock_Cmd {
    [CmdletBinding(DefaultParameterSetName="NoCredentials")]
       param(
          [Parameter(Mandatory=$true,Position=0)]
          [System.Uri][Alias("Url")]$Uri  
         ,
         [Parameter(Mandatory=$false,Position=1)]   
          [System.Uri]$CmdName
       )
    "$Uri --  $CmdName"
    if($CmdName -eq $null)
    {
        docker exec -it $(docker ps -aq -f "name=$Uri") /bin/sh
    }
    elseif ($CmdName -eq [System.Uri]("mysql")) {
        docker exec -it $(docker ps -aq -f "name=$Uri") $CmdName -uroot -proot --database=dphpdb
    }
    else 
    {
        docker exec -it $(docker ps -aq -f "name=$Uri") $CmdName
    }  
}
Set-Alias dockcmd Dock_Cmd

function Dock_Stopa{
    docker stop $(docker ps -a -q)
}
Set-Alias dockstopa Dock_Stopa

function Dock_StartByName{
  [CmdletBinding(DefaultParameterSetName="NoCredentials")]
       param(
          [Parameter(Mandatory=$true,Position=0)]
          [System.Uri]$Name  
       )
  if($Name -eq [System.Uri]("mygo")) {
    docker run -d --name $Name -it -v C:/Users/arafa/env/go:/apps/go -v C:/Users/arafa/gopath/src:/go/src/ golang:1.9-alpine3.7 /bin/sh
    dockcmd $Name
  }
  elseif($Name -eq [System.Uri]("dphp")){
    $ww = $PWD
    cddphp
    docker-compose up -d
    cd $ww
  }
  elseif($Name -eq [System.Uri]("ubuntu")){
    docker run -d --name $Name -it ubuntu 
    dockcmd $Name /bin/bash
  }
  elseif($Name -eq [System.Uri]("ariang")){
    docker run -d --name $Name -p 9000:80 -p 6800:6800 -v E:/Downloads:/data  -v E:/aria2/aria2.session:/root/conf/aria2.session wahyd4/aria2-ui
    #docker run -d --name ariang -p 9000:80 -p 6800:6800 -v E:/Downloads:/data  wahyd4/aria2-ui
  }
  
}
Set-Alias dockstart Dock_StartByName


function Dock_StopAndRM{
    [CmdletBinding(DefaultParameterSetName="NoCredentials")]
       param(
          [Parameter(Mandatory=$true,Position=0)]
          [System.Uri]$Name  
       )
       $ret = docker ps -a -q -f "name=$Name";
       if($ret -ne $null){
            docker stop  $ret | docker rm $ret
       }
       
}
Set-Alias docksm Dock_StopAndRM



#设置环境变量永久生效
function Set-EnvironmentVariable {
     [CmdletBinding(DefaultParameterSetName="NoCredentials")]
       param(
          [Parameter(Mandatory=$true,Position=0)]
          [System.Uri]$Name  
          ,
          [Parameter(Mandatory=$true,Position=1)]   
          [System.Uri]$Value
       )
       $flag0 = $Name -match "path"
       if( $flag0 -and  (($Value -eq $null) -or ($Value -eq [System.Uri](""))) ){
             "Path's Value could not be null"
       }
       else{
         [Environment]::SetEnvironmentVariable($Name, $Value, "User")
       }
    
}
Set-Alias setenv Set-EnvironmentVariable

function Get-EnvironmentVariable {
  [CmdletBinding(DefaultParameterSetName="NoCredentials")]
       param(
          [Parameter(Mandatory=$true,Position=0)]
          [System.Uri]$Name 
       )
    [Environment]::GetEnvironmentVariable($Name, "User")
}
Set-Alias getenv Get-EnvironmentVariable
#在已有环境变量基础上添加
function Add-EnvironmentVariable {
     [CmdletBinding(DefaultParameterSetName="NoCredentials")]
       param(
          [Parameter(Mandatory=$true,Position=0)]
          [System.Uri]$Name  
          ,
          [Parameter(Mandatory=$true,Position=1)]   
          [System.Uri]$Value
       )
      $originvalue=[Environment]::GetEnvironmentVariable($Name, "User")
      [Environment]::SetEnvironmentVariable($Name,$originvalue+";"+$Value, "User")
}
Set-Alias addenv Add-EnvironmentVariable
#在已有环境变量基础上删除
function Del-EnvironmentVariable{
  [CmdletBinding(DefaultParameterSetName="NoCredentials")]
       param(
          [Parameter(Mandatory=$true,Position=0)]
          [System.Uri]$Name 
          ,
          [Parameter(Mandatory=$true,Position=1)]   
          [System.Uri]$Value
       )
       $originvalue=[Environment]::GetEnvironmentVariable($Name, "User")
 
       $array=$originvalue.Split(";")
       $num =-1
       for($i=0;$i -le $array.count;$i++)
        {
            if($array[$i] -eq $Value ){
               $num  = $i
               break
            }
        }
        
        if($num -ge 0){
          $newarray = $array[0..($num-1)]+$array[($num+1)..$array.count] 
          if($num -eq 0){
            $newarray = $array[($num+1)..$array.count] 
          }
          $newv = ""
          foreach($k in $newarray){
            if($k -ne ""){
              $newv += $k + ";"
            }
          } 
          [Environment]::SetEnvironmentVariable($Name,$newv, "User")
        }
}
Set-Alias delenv Del-EnvironmentVariable

#拷贝到MyTools配置文件
function CopyToMyToolsConf{
    [CmdletBinding(DefaultParameterSetName="NoCredentials")]
       param(
          [Parameter(Mandatory=$false,Position=0)]
          [System.Uri]$commitLog 
       )

    $conf="$MyWorkSpace\MyTools\conf"
    $script="$MyWorkSpace\MyTools\script"
    #mkdir $script
    $ww = $PWD
    # "Dest : $conf 
    # $PROFILE 
    # $HOME\.bashrc 
    # $HOME\.bash_aliases"
    copy $PROFILE $conf
    copy $HOME\.bashrc $conf
    copy $HOME\.bash_aliases $conf
    
    cdgo 
    copy $(ls *.go) $script

    if(($commitLog -eq $null)){

    }
    else{
        cd "$MyWorkSpace\MyTools\"
        sh gpush.sh "MyToolsConf:$commitLog"
    }
    cd $ww
}
Set-Alias copytotool CopyToMyToolsConf

#下载文件
function Get-WebFile {

[CmdletBinding(DefaultParameterSetName="NoCredentials")]
   param(
      #  The URL of the file/page to download
      [Parameter(Mandatory=$true,Position=0)]
      [System.Uri][Alias("Url")]$Uri # = (Read-Host "The URL to download")
   ,
      #  A Path to save the downloaded content. 
      [string]$FileName
   ,
      #  Leave the file unblocked instead of blocked
      [Switch]$Unblocked
   ,
      #  Rather than saving the downloaded content to a file, output it.  
      #  This is for text documents like web pages and rss feeds, and allows you to avoid temporarily caching the text in a file.
      [switch]$Passthru
   ,
      #  Supresses the Write-Progress during download
      [switch]$Quiet
   ,
      #  The name of a variable to store the session (cookies) in
      [String]$SessionVariableName
   ,
      #  Text to include at the front of the UserAgent string
      [string]$UserAgent = "PowerShellWget/$(1.0)"      
   )

   Write-Verbose "Downloading &#39;$Uri'"
   $EAP,$ErrorActionPreference = $ErrorActionPreference, "Stop"
   $request = [System.Net.HttpWebRequest]::Create($Uri);
   $ErrorActionPreference = $EAP   
   $request.UserAgent = $(
         "{0} (PowerShell {1}; .NET CLR {2}; {3}; http://fuhaijun.com)" -f $UserAgent, 
         $(if($Host.Version){$Host.Version}else{"1.0"}),
         [Environment]::Version,
         [Environment]::OSVersion.ToString().Replace("Microsoft Windows ", "Win")
      )

   $Cookies = New-Object System.Net.CookieContainer
   if($SessionVariableName) {
      $Cookies = Get-Variable $SessionVariableName -Scope 1 
   }
   $request.CookieContainer = $Cookies
   if($SessionVariableName) {
      Set-Variable $SessionVariableName -Scope 1 -Value $Cookies
   }

   try {
      $res = $request.GetResponse();
   } catch [System.Net.WebException] { 
      Write-Error $_.Exception -Category ResourceUnavailable
      return
   } catch {
      Write-Error $_.Exception -Category NotImplemented
      return
   }

   if((Test-Path variable:res) -and $res.StatusCode -eq 200) {
      if($fileName -and !(Split-Path $fileName)) {
         $fileName = Join-Path (Convert-Path (Get-Location -PSProvider "FileSystem")) $fileName
      }
      elseif((!$Passthru -and !$fileName) -or ($fileName -and (Test-Path -PathType "Container" $fileName)))
      {
         #echo $res.Headers["Content-Disposition"]

         #[string]$fileName = ([regex]'&#40;?i)filename=(.*)$').Match( $res.Headers["Content-Disposition"] ).Groups[1].Value
         #$fileName = $fileName.trim("&#92;/""'")
        [string]$fileName = ([regex]'(?i)filename=(.*)$').Match( $res.Headers["Content-Disposition"] ).Groups[1].Value
        $fileName = $fileName.trim("\/""'")

         $ofs = ""
         $fileName = [Regex]::Replace($fileName, "[$([Regex]::Escape(""$([System.IO.Path]::GetInvalidPathChars())$([IO.Path]::AltDirectorySeparatorChar)$([IO.Path]::DirectorySeparatorChar)""))]", "_")
         $ofs = " "

         if(!$fileName) {
            $fileName = $res.ResponseUri.Segments[-1]
            $fileName = $fileName.trim("\/")
            if(!$fileName) { 
               $fileName = Read-Host "Please provide a file name"
            }
            $fileName = $fileName.trim("\/")
            if(!([IO.FileInfo]$fileName).Extension) {
               $fileName = $fileName + "." + $res.ContentType.Split(";")[0].Split("/")[1]
            }
         }
         $fileName = Join-Path (Convert-Path (Get-Location -PSProvider "FileSystem")) $fileName
      }
      if($Passthru) {
         $encoding = [System.Text.Encoding]::GetEncoding( $res.CharacterSet )
         [string]$output = ""
      }

      [int]$goal = $res.ContentLength
      $reader = $res.GetResponseStream()
      if($fileName) {
         try {
            $writer = new-object System.IO.FileStream $fileName, "Create"
         } catch {
            Write-Error $_.Exception -Category WriteError
            return
         }
      }
      [byte[]]$buffer = new-object byte[] 4096
      [int]$total = [int]$count = 0
      do
      {
         $count = $reader.Read($buffer, 0, $buffer.Length);
         if($fileName) {
            $writer.Write($buffer, 0, $count);
         } 
         if($Passthru){
            $output += $encoding.GetString($buffer,0,$count)
         } elseif(!$quiet) {
            $total += $count
            if($goal -gt 0) {
               Write-Progress "Downloading $Uri" "Saving $total of $goal" -id 0 -percentComplete (($total/$goal)*100)
            } else {
               Write-Progress "Downloading $Uri" "Saving $total bytes..." -id 0
            }
         }
      } while ($count -gt 0)

      $reader.Close()
      if($fileName) {
         $writer.Flush()
         $writer.Close()
      }
      if($Passthru){
         $output
      }
   }
   if(Test-Path variable:res) { $res.Close(); }
   if($fileName) {
      ls $fileName
   }
}

Set-Alias dget Get-WebFile

#批量下载
function Func_InitMyComputer {
  #"zip"
  dget "http://d.7-zip.org/a/7z1801-x64.exe"
  #"DockerforWindows"
  #dget "https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe"
  #"msys2"
  #dget "http://repo.msys2.org/distrib/x86_64/msys2-x86_64-20161025.exe"
  dget "https://github.com/aria2/aria2/releases/download/release-1.33.1/aria2-1.33.1-win-64bit-build1.zip"
} 

Set-Alias initos Func_InitMyComputer

#查看网络状态 带参数的netstat
function Get-NetworkStatistics {
    <#
    .SYNOPSIS
        Display current TCP/IP connections for local or remote system

    .FUNCTIONALITY
        Computers

    .DESCRIPTION
        Display current TCP/IP connections for local or remote system.  Includes the process ID (PID) and process name for each connection.
        If the port is not yet established, the port number is shown as an asterisk (*).    
    
    .PARAMETER ProcessName
        Gets connections by the name of the process. The default value is '*'.
    
    .PARAMETER Port
        The port number of the local computer or remote computer. The default value is '*'.

    .PARAMETER Address
        Gets connections by the IP address of the connection, local or remote. Wildcard is supported. The default value is '*'.

    .PARAMETER Protocol
        The name of the protocol (TCP or UDP). The default value is '*' (all)
    
    .PARAMETER State
        Indicates the state of a TCP connection. The possible states are as follows:
        
        Closed       - The TCP connection is closed. 
        Close_Wait   - The local endpoint of the TCP connection is waiting for a connection termination request from the local user. 
        Closing      - The local endpoint of the TCP connection is waiting for an acknowledgement of the connection termination request sent previously. 
        Delete_Tcb   - The transmission control buffer (TCB) for the TCP connection is being deleted. 
        Established  - The TCP handshake is complete. The connection has been established and data can be sent. 
        Fin_Wait_1   - The local endpoint of the TCP connection is waiting for a connection termination request from the remote endpoint or for an acknowledgement of the connection termination request sent previously. 
        Fin_Wait_2   - The local endpoint of the TCP connection is waiting for a connection termination request from the remote endpoint. 
        Last_Ack     - The local endpoint of the TCP connection is waiting for the final acknowledgement of the connection termination request sent previously. 
        Listen       - The local endpoint of the TCP connection is listening for a connection request from any remote endpoint. 
        Syn_Received - The local endpoint of the TCP connection has sent and received a connection request and is waiting for an acknowledgment. 
        Syn_Sent     - The local endpoint of the TCP connection has sent the remote endpoint a segment header with the synchronize (SYN) control bit set and is waiting for a matching connection request. 
        Time_Wait    - The local endpoint of the TCP connection is waiting for enough time to pass to ensure that the remote endpoint received the acknowledgement of its connection termination request. 
        Unknown      - The TCP connection state is unknown.
    
        Values are based on the TcpState Enumeration:
        http://msdn.microsoft.com/en-us/library/system.net.networkinformation.tcpstate%28VS.85%29.aspx
        
        Cookie Monster - modified these to match netstat output per here:
        http://support.microsoft.com/kb/137984

    .PARAMETER ComputerName
        If defined, run this command on a remote system via WMI.  \\computername\c$\netstat.txt is created on that system and the results returned here

    .PARAMETER ShowHostNames
        If specified, will attempt to resolve local and remote addresses.

    .PARAMETER tempFile
        Temporary file to store results on remote system.  Must be relative to remote system (not a file share).  Default is "C:\netstat.txt"

    .PARAMETER AddressFamily
        Filter by IP Address family: IPv4, IPv6, or the default, * (both).

        If specified, we display any result where both the localaddress and the remoteaddress is in the address family.

    .EXAMPLE
        Get-NetworkStatistics | Format-Table

    .EXAMPLE
        Get-NetworkStatistics iexplore -computername k-it-thin-02 -ShowHostNames | Format-Table

    .EXAMPLE
        Get-NetworkStatistics -ProcessName md* -Protocol tcp

    .EXAMPLE
        Get-NetworkStatistics -Address 192* -State LISTENING

    .EXAMPLE
        Get-NetworkStatistics -State LISTENING -Protocol tcp

    .EXAMPLE
        Get-NetworkStatistics -Computername Computer1, Computer2

    .EXAMPLE
        'Computer1', 'Computer2' | Get-NetworkStatistics

    .OUTPUTS
        System.Management.Automation.PSObject

    .NOTES
        Author: Shay Levy, code butchered by Cookie Monster
        Shay's Blog: http://PowerShay.com
        Cookie Monster's Blog: http://ramblingcookiemonster.github.io/

    .LINK
        http://gallery.technet.microsoft.com/scriptcenter/Get-NetworkStatistics-66057d71
    #>  
    [OutputType('System.Management.Automation.PSObject')]
    [CmdletBinding()]
    param(
        
        [Parameter(Position=0)]
        [System.String][Alias("pn")]$ProcessName='*',
        
        [Parameter(Position=1)]
        [System.String]$Address='*',        
        
        [Parameter(Position=2)]
        $Port='*',

        [Parameter(Position=3,
                   ValueFromPipeline = $True,
                   ValueFromPipelineByPropertyName = $True)]
        [System.String[]][Alias("cn")]$ComputerName=$env:COMPUTERNAME,

        [ValidateSet('*','tcp','udp')]
        [System.String][Alias("p")]$Protocol='*',

        [ValidateSet('*','Closed','Close_Wait','Closing','Delete_Tcb','DeleteTcb','Established','Fin_Wait_1','Fin_Wait_2','Last_Ack','Listening','Syn_Received','Syn_Sent','Time_Wait','Unknown')]
        [System.String][Alias("s")]$State='LISTENING',

        [switch]$ShowHostnames,
        
        [switch]$ShowProcessNames = $true,  

        [System.String]$TempFile = "C:\netstat.txt",

        [validateset('*','IPv4','IPv6')]
        [string]$AddressFamily = '*'
    )
    
    begin{
        #Define properties
            $properties = 'ComputerName','Protocol','LocalAddress','LocalPort','RemoteAddress','RemotePort','State','ProcessName','PID'

        #store hostnames in array for quick lookup
            $dnsCache = @{}
            
    }
    
    process{

        foreach($Computer in $ComputerName) {

            #Collect processes
            if($ShowProcessNames){
                Try {
                    $processes = Get-Process -ComputerName $Computer -ErrorAction stop | select name, id
                }
                Catch {
                    Write-warning "Could not run Get-Process -computername $Computer.  Verify permissions and connectivity.  Defaulting to no ShowProcessNames"
                    $ShowProcessNames = $false
                }
            }
        
            #Handle remote systems
                if($Computer -ne $env:COMPUTERNAME){

                    #define command
                        [string]$cmd = "cmd /c c:\windows\system32\netstat.exe -ano >> $tempFile"
            
                    #define remote file path - computername, drive, folder path
                        $remoteTempFile = "\\{0}\{1}`${2}" -f "$Computer", (split-path $tempFile -qualifier).TrimEnd(":"), (Split-Path $tempFile -noqualifier)

                    #delete previous results
                        Try{
                            $null = Invoke-WmiMethod -class Win32_process -name Create -ArgumentList "cmd /c del $tempFile" -ComputerName $Computer -ErrorAction stop
                        }
                        Catch{
                            Write-Warning "Could not invoke create win32_process on $Computer to delete $tempfile"
                        }

                    #run command
                        Try{
                            $processID = (Invoke-WmiMethod -class Win32_process -name Create -ArgumentList $cmd -ComputerName $Computer -ErrorAction stop).processid
                        }
                        Catch{
                            #If we didn't run netstat, break everything off
                            Throw $_
                            Break
                        }

                    #wait for process to complete
                        while (
                            #This while should return true until the process completes
                                $(
                                    try{
                                        get-process -id $processid -computername $Computer -ErrorAction Stop
                                    }
                                    catch{
                                        $FALSE
                                    }
                                )
                        ) {
                            start-sleep -seconds 2 
                        }
            
                    #gather results
                        if(test-path $remoteTempFile){
                    
                            Try {
                                $results = Get-Content $remoteTempFile | Select-String -Pattern '\s+(TCP|UDP)'
                            }
                            Catch {
                                Throw "Could not get content from $remoteTempFile for results"
                                Break
                            }

                            Remove-Item $remoteTempFile -force

                        }
                        else{
                            Throw "'$tempFile' on $Computer converted to '$remoteTempFile'.  This path is not accessible from your system."
                            Break
                        }
                }
                else{
                    #gather results on local PC
                        $results = netstat -ano | Select-String -Pattern '\s+(TCP|UDP)'
                }

            #initialize counter for progress
                $totalCount = $results.count
                $count = 0
    
            #Loop through each line of results    
                foreach($result in $results) {
            
                    $item = $result.line.split(' ',[System.StringSplitOptions]::RemoveEmptyEntries)
    
                    if($item[1] -notmatch '^\[::'){
                    
                        #parse the netstat line for local address and port
                            if (($la = $item[1] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6'){
                                $localAddress = $la.IPAddressToString
                                $localPort = $item[1].split('\]:')[-1]
                            }
                            else {
                                $localAddress = $item[1].split(':')[0]
                                $localPort = $item[1].split(':')[-1]
                            }
                    
                        #parse the netstat line for remote address and port
                            if (($ra = $item[2] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6'){
                                $remoteAddress = $ra.IPAddressToString
                                $remotePort = $item[2].split('\]:')[-1]
                            }
                            else {
                                $remoteAddress = $item[2].split(':')[0]
                                $remotePort = $item[2].split(':')[-1]
                            }

                        #Filter IPv4/IPv6 if specified
                            if($AddressFamily -ne "*")
                            {
                                if($AddressFamily -eq 'IPv4' -and $localAddress -match ':' -and $remoteAddress -match ':|\*' )
                                {
                                    #Both are IPv6, or ipv6 and listening, skip
                                    Write-Verbose "Filtered by AddressFamily:`n$result"
                                    continue
                                }
                                elseif($AddressFamily -eq 'IPv6' -and $localAddress -notmatch ':' -and ( $remoteAddress -notmatch ':' -or $remoteAddress -match '*' ) )
                                {
                                    #Both are IPv4, or ipv4 and listening, skip
                                    Write-Verbose "Filtered by AddressFamily:`n$result"
                                    continue
                                }
                            }
                    
                        #parse the netstat line for other properties
                            $procId = $item[-1]
                            $proto = $item[0]
                            $status = if($item[0] -eq 'tcp') {$item[3]} else {$null}    

                        #Filter the object
                            if($remotePort -notlike $Port -and $localPort -notlike $Port){
                                write-verbose "remote $Remoteport local $localport port $port"
                                Write-Verbose "Filtered by Port:`n$result"
                                continue
                            }

                            if($remoteAddress -notlike $Address -and $localAddress -notlike $Address){
                                Write-Verbose "Filtered by Address:`n$result"
                                continue
                            }
                             
                            if($status -notlike $State){
                                Write-Verbose "Filtered by State:`n$result"
                                continue
                            }

                            if($proto -notlike $Protocol){
                                Write-Verbose "Filtered by Protocol:`n$result"
                                continue
                            }
                   
                        #Display progress bar prior to getting process name or host name
                            Write-Progress  -Activity "Resolving host and process names"`
                                -Status "Resolving process ID $procId with remote address $remoteAddress and local address $localAddress"`
                                -PercentComplete (( $count / $totalCount ) * 100)
                    
                        #If we are running showprocessnames, get the matching name
                            if($ShowProcessNames -or $PSBoundParameters.ContainsKey -eq 'ProcessName'){
                        
                                #handle case where process spun up in the time between running get-process and running netstat
                                if($procName = $processes | Where {$_.id -eq $procId} | select -ExpandProperty name ){ }
                                else {$procName = "Unknown"}

                            }
                            else{$procName = "NA"}

                            if($procName -notlike $ProcessName){
                                Write-Verbose "Filtered by ProcessName:`n$result"
                                continue
                            }
                                    
                        #if the showhostnames switch is specified, try to map IP to hostname
                            if($showHostnames){
                                $tmpAddress = $null
                                try{
                                    if($remoteAddress -eq "127.0.0.1" -or $remoteAddress -eq "0.0.0.0"){
                                        $remoteAddress = $Computer
                                    }
                                    elseif($remoteAddress -match "\w"){
                                        
                                        #check with dns cache first
                                            if ($dnsCache.containskey( $remoteAddress)) {
                                                $remoteAddress = $dnsCache[$remoteAddress]
                                                write-verbose "using cached REMOTE '$remoteAddress'"
                                            }
                                            else{
                                                #if address isn't in the cache, resolve it and add it
                                                    $tmpAddress = $remoteAddress
                                                    $remoteAddress = [System.Net.DNS]::GetHostByAddress("$remoteAddress").hostname
                                                    $dnsCache.add($tmpAddress, $remoteAddress)
                                                    write-verbose "using non cached REMOTE '$remoteAddress`t$tmpAddress"
                                            }
                                    }
                                }
                                catch{ }

                                try{

                                    if($localAddress -eq "127.0.0.1" -or $localAddress -eq "0.0.0.0"){
                                        $localAddress = $Computer
                                    }
                                    elseif($localAddress -match "\w"){
                                        #check with dns cache first
                                            if($dnsCache.containskey($localAddress)){
                                                $localAddress = $dnsCache[$localAddress]
                                                write-verbose "using cached LOCAL '$localAddress'"
                                            }
                                            else{
                                                #if address isn't in the cache, resolve it and add it
                                                    $tmpAddress = $localAddress
                                                    $localAddress = [System.Net.DNS]::GetHostByAddress("$localAddress").hostname
                                                    $dnsCache.add($localAddress, $tmpAddress)
                                                    write-verbose "using non cached LOCAL '$localAddress'`t'$tmpAddress'"
                                            }
                                    }
                                }
                                catch{ }
                            }
    
                        #Write the object   
                            New-Object -TypeName PSObject -Property @{
                                ComputerName = $Computer
                                PID = $procId
                                ProcessName = $procName
                                Protocol = $proto
                                LocalAddress = $localAddress
                                LocalPort = $localPort
                                RemoteAddress =$remoteAddress
                                RemotePort = $remotePort
                                State = $status
                            } | Select-Object -Property $properties                       

                        #Increment the progress counter
                            $count++
                    }

                }

        }
        #Format-Table -autosize
    }

    # end{
    #     "abcdfff"
    #     Format-Table -autosize
    # }
}
Set-Alias gstat Get-NetworkStatistics