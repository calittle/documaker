# *************************************************************
# SetOmitFlag.ps1
# Author:  Andy Little
# Date:  27 Mar 2020
# Purpose: 
#
# This script provides a model for how to set the Documaker Mobile
# Omit flag for the following object types:
#       Fields, MLT fields, Sections
#
# This script will process all files meeting a given filespec.
#
# *************************************************************

# replace the following with your directory and filespec.
$dir = ".\"
$filespec = $dir + "test.*"

# Function processRecord
# Identify if the given line indicates the start of a specific
# Record Type that we want to modify. The script assumes ALL
# record types will be given the Omit=Yes attribute. You can
# add logic here to determine how you want to handle a given
# record type. If you want to *unset* the Omit=Yes flag, you 
# will need to first find the desired record and REMOVE the 
# <<A,*28,1,"" >> attribute record associated with it. 
# Such functionality is beyond the scope of this script.
# 
# For now, the script finds these object types:
# H: Section > H, > HA28
# F: Field > F, > FA28
# M: Text Area > M,H, MA28 <-- this is troublesome as Tables use
#    the same records too, so need special handler.
# X: Box/Line/Shade > X, > XA28
# I: Vector > I, > IA28
# T: Text Label > T, > TA28 
# B: Barcode > B, > BA28
# G: Graphic > G, > GA28
# Q: Table > A,Q1, > QA28
# D: Chart > A,D1, > DZ28
# N: Note/Bookmark > N, > NA28
# Z: Signature > Z, > ZA28

function processRecord{  
  Param ([string]$recordString)
  
  if ($recordString.IndexOf('H,') -eq 0){
    logWrite (' -- found Section record, omitting.')
    return ("A,HA28,1,""""")
  }
  if ($recordString.IndexOf('F,') -eq 0){
    logWrite (' -- found Field record, omitting.')
    return ("A,FA28,1,""""")
  }
  if ($recordString.IndexOf('X,') -eq 0){
    logWrite (' -- found Box/Line/Shade record, omitting.')
    return ("A,XA28,1,""""")
  }
  if ($recordString.IndexOf('M,X,') -eq 0){
    logWrite (' -- found Textarea Box/Line/Shade record, omitting.')
    return ("A,XA28,1,""""")
  }
  if ($recordString.IndexOf('I,') -eq 0){
  logWrite (' -- found Vector record, omitting.')
    return ("A,IA28,1,""""")
  }
  if ($recordString.IndexOf('T,') -eq 0){
    logWrite (' -- found Textlabel record, omitting.')
    return ("A,TA28,1,""""")
  }
  if ($recordString.IndexOf('B,') -eq 0){
    logWrite (' -- found Barcode record, omitting.')
    return ("A,BA28,1,""""")
  }
  if ($recordString.IndexOf('G,') -eq 0){
    logWrite (' -- found Graphic record, omitting.')
    return ("A,GA28,1,""""")
  }
  if ($recordString.IndexOf('M,G,') -eq 0){
    logWrite (' -- found Textarea Graphic record, omitting.')
    return ("A,GA28,1,""""")
  }
  if ($recordString.IndexOf('A,Q1,') -eq 0){
    logWrite (' -- found Table record, omitting.')
    return ("A,QA28,1,""""")
  }
  if ($recordString.IndexOf('A,D1,') -eq 0){
    logWrite (' -- found Chart record, omitting.')
    return ("A,DZ28,1,""""")
  }
  if ($recordString.IndexOf('N,') -eq 0){
    logWrite (' -- found Bookmark/Note record, omitting.')
    return ("A,NA28,1,""""")
  }
  if ($recordString.IndexOf('Z,') -eq 0){
    logWrite (' -- found Signature record, omitting.')
    return ("A,ZA28,1,""""")
  }
  return ("")
}

function logWrite{
 Param ([string]$logstring)
 $log = "{0} : {1}" -f ((Get-Date), $logstring)
 Add-Content $logFile -value $log
}

$logFile = ".\SetOmitFlag.log"
logWrite ('SetOmitFlag started.')
logWrite ('Using FileSpec ' + $filespec)
$files = @(Get-ChildItem $filespec)

foreach ($file in $files){
  logWrite ('Processing ' + $file)
  $content = Get-Content $file
  Add-Content "$file.bkp" -value $content
  Clear-Content $file
  foreach ($line in $content){    
    Add-Content $file -value $line    
    $return = processRecord($line)
    if ($return){
      Add-Content $file -value $return
    }else{
      # conditional handler for textarea.
      if ($line.IndexOf('M,H,') -eq 0){
        $preTextArea = 1
      }elseif (($pretextArea -eq 1) -and ($line.IndexOf('M,HX,') -eq 0)){
        # found a table, so ignore it.
        $preTextArea = 0
      }
      elseif (($preTextArea -eq 1) -and ($line.IndexOf('M,P,') -eq 0)){
        # found the text area
        logWrite (' -- found Textarea record, omitting.')
        Add-Content $file -value "A,MA28,1,"""""
        $preTextArea = 0
      }
    }
    
  }   
}
logWrite ('Completed.')