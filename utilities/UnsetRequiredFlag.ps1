# *************************************************************
# UnsetRequiredFlag.ps1
# Author:  Andy Little
# Date:  21 Feb 2020
# Purpose: 
# 1) Search a given directory for any files.
# 2) For each file encountered, open the file and search for (F)ield records.
# 3) For each (F)ield record, locate the (A)ttribute F1 record.
# 4) On the (F)(A)(F1) record, check if the Required bit is set to 1. 
# 5) If the required bit is set to 1, set it to 0. If this is the first change.
# 6) Write changes to disk.
# *************************************************************

# replace the following with your directory and filespec.
$dir = ".\"
$filespec = $dir + "test.*"

function processRecordAF1{
  Param ([string]$recordString)
  # locate the 
  $vars = $recordString.split(",")
  #A,F1," ",x ," ",0,0,1,(255,0,0,0),4096,0,
  if ($vars[7] -eq "1"){
    logWrite(' -- Required field found.')
    $vars[7] = "0"        
  }

  return ($vars -join ',')
}

function logWrite{
 Param ([string]$logstring)
 $log = "{0} : {1}" -f ((Get-Date), $logstring)
 Add-Content $logFile -value $log
}


$logFile = ".\UnsetRequiredFlag.log"

logWrite ('UnsetRequiredFlag started.')
logWrite ('Using FileSpec ' + $filespec)

$files = @(Get-ChildItem $filespec)

foreach ($file in $files){
  logWrite ('Processing ' + $file)

  $content = Get-Content $file
  Add-Content "$file.bkp" -value $content
  Clear-Content $file
  
  foreach ($line in $content){    
    
    if ($line.IndexOf('A,F1') -gt -1){
      $line = (processRecordAF1($line))
    }
  
    Add-Content $file -value $line
  }
    
}

logWrite ('Completed.')