#################################################################################################################
# THIS FILE IS PROVIDED AS-IS WITH NO WARRANTY
#################################################################################################################
#
# Author: Andy Little
# Date: 10-Oct-19
# Purpose: 
#   Simulate impact reporting through LBYPROC utility. This script aims to perform a two-level impact
#   report, given a primary resource (in this case a graphic/LOG file). The script will search the library
#   for sections/FAPs with references to the LOG file, and will then search the library for forms/FORs 
#   referencing those identified FAPs.
#
#################################################################################################################
#
# Platform: Documaker 12.6.2, but should work on previous platforms
# OS: Windows (This is a PowerShell script but could be adapted for UNIX
#
############################################################ Usage ##############################################
#
# To run this, you need to enable PowerShell (PS) to run script files.
# Start PS as administrator, then enter:
#   Set-ExecutionPolicy RemoteSigned 
# and hit Enter, Y, Enter.
#
# Save this file to your MRL directory (this is required) and modify the variables below,
# then start up PS and run this file e.g.
#    PS c:\fap\mstrres\dmres> report.ps1
#
# It should generate a FinalReport.txt containing the identified FOR files.
#
########################################################## Settings ##############################################
#
# this variable is the name and type of file to search for.
$search = “CEOSIG"
$searchType = "LOG"
#
# this variable is the path/filename of the master.lby file.
$library = "C:\FAP1262\mstrres\dmres\DEFLIB\Master.lby"
#
# variable is the filename of the FSIUSER ini.
$fsiuser = "fsiuser_studio.ini"
#
#
####################################################################################################################
################################ STOP EDITING UNLESS YOU KNOW WHAT YOU'RE DOING ####################################
################################ OR UNLESS YOU JUST GENERALLY WANT TO POKE ABOUT ###################################
####################################################################################################################

Function librarySearch ( $lib, $type, $name, $text, $case, $out ){

$lsc = @"
<DOCUMENT TYPE="RPWIP" VERSION="12.6.2">
<LBYSCRIPT>
<FILTER>
<LIBRARY VALUE="$lib"/>
<LO VALUE="0"/>
<NAME VALUE=""/>
<TYPE VALUE=""/>
<DESC VALUE=""/>
<VERSION VALUE="all"/>
<REVISION VALUE="last"/>
<USERID VALUE=""/>
<SECURED VALUE=""/>
<LOCKED VALUE="any"/>
<EFFDATE VALUE=""/>
<EFFDATE2 VALUE=""/>
<MODTIME VALUE=""/>
<MODTIME2 VALUE=""/>
<MODE VALUE=""/>
<STATUS VALUE=""/>
<CLASS VALUE=""/>
<PROJECT VALUE=""/>
<OBJECTTYPE VALUE="$type"/>
<OBJECTNAME VALUE="$name"/>
<OBJECTTEXT VALUE="$text"/>
<OBJECTTEXTCASE VALUE="$case"/>
</FILTER>
</LBYSCRIPT>
</DOCUMENT>
"@
	Set-Content -Path "search1.lsc" -Value $lsc
	Write-Host "Search for : $name ($type)..."
	(lbyproc /i="search1.lsc" /INI="$fsiuser" /nolog /s > $out)

}
Write-Host "Reminder : run this from your MRL directory."
Write-Host "`tLibrary: $library"
Write-Host "`tINI    : $fsiuser"
Write-Host "`tDLL    : $fapDllPath"
$startTime=(Get-Date -UFormat "%A %m/%d/%Y %R")
Set-Content -Path FinalReport.txt -Value ""
Add-Content FinalReport.txt "Search for $search ($searchType) started on $startTime"

librarySearch "$library" "$searchType" "$search" "" "" "report.txt"
Remove-Item "search1.lsc"
cat "report.txt" | where { $_ -match "Found match" } | foreach-object { 

	$fapName = $_.split('<')[1].split('>')[0] 
	$resVer = $_.split('<')[3].split('>')[0]
	$resRev = $_.split('<')[4].split('>')[0]
	Write-Host "$search found in $fapName"
	Add-Content FinalReport.txt "$search located in $fapName ($resVer.$resRev)"
	Write-Host "Searching for usages of $fapName"
	librarySearch "$library" "FAP" "$fapName" "" "" "report$fapName.txt"
	Add-Content FinalReport.txt "$fapName located in:"
	cat "report$fapName.txt" | where { $_ -match "Found match" } | foreach-object{
		$resName = $_.split('<')[1].split('>')[0]
		$resType = $_.split('<')[2].split('>')[0]
		$resVer = $_.split('<')[3].split('>')[0]
		$resRev = $_.split('<')[4].split('>')[0]
		Add-Content FinalReport.txt "`t$resName ($resType) $resVer.$resRev"
	}
	Remove-Item "report$fapName.txt"
}
Remove-Item "report.txt"
$endTime = (Get-Date -UFormat "%A %m/%d/%Y %R")
Add-Content FinalReport.txt "Finished on $endTime"
Write-Host "Finished."
