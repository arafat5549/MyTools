cd ~
#powershell5下载地址  https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/W2K12-KB3191565-x64.msu
$MyWorkSpace="C:\Dev\workspace"

function Sh_Xpl {
   [CmdletBinding(DefaultParameterSetName="NoCredentials")]
   param(
      [Parameter(Mandatory=$false,Position=0)]
      [System.Uri][Alias("path")]$Uri    
   )
    sh xpl.sh $Uri
}
Set-Alias xpl Sh_Xpl

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
    $conf="$MyWorkSpace\MyTools\conf"
    "Dest : $conf 
    $PROFILE 
    $HOME\.bashrc 
    $HOME\.bash_aliases "
    copy $PROFILE $conf
    copy $HOME\.bashrc $conf
    copy $HOME\.bash_aliases $conf
    $ww = $PWD
    cd "$MyWorkSpace\MyTools\"
    sh gpush.sh "MyToolsConf"
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