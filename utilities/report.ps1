#################################################################################################################
# THIS FILE IS PROVIDED AS-IS WITH NO WARRANTY
#################################################################################################################
# Author: Andy Little
# Date: 10-Oct-19
# Purpose: 
#   Simulate impact reporting through LBYPROC utility. This script aims to perform a two-level impact
#   report, given a primary resource (in this case a graphic/LOG file). The script will search the library
#   for sections/FAPs with references to the LOG file, and will then search the library for forms/FORs 
#   referencing those identified FAPs.
#################################################################################################################
# Platform: Documaker 12.6.2, but should work on previous platforms
# OS: Windows (This is a PowerShell script but could be adapted for UNIX
############################################################ Usage ##############################################
# To run this, you need to enable PowerShell (PS) to run script files.
# Start PS as administrator, then enter:
#   Set-ExecutionPolicy RemoteSigned 
# and hit Enter, Y, Enter.
#
# Save this file to your desktop and modify the variables below,
# then start up PS and run this file e.g.
#    PS c:\fap\dll>report.ps1
# It should generate a FinalReport.txt containing the identified FOR files.
########################################################## Settings ##############################################
#
# this variable is the name of the LOGO to search for
$search = “CEOSIG"
$searchType = "LOG"
#
# this variable is the path/filename of the master.lby file.
$library = "C:\FAP1262\mstrres\dmres\DEFLIB\Master.lby"
#
# variable is the path/filename of the FSIUSER ini.
$fsiuser = "c:\fap1262\mstrres\dmres\fsiuser_studio.ini"
#
# path to DLLs, where reports will be created.
$fapDllPath = "C:\FAP1262\DLL"
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
	Set-Content -Path "$fapDllPath\myscript.lsc" -Value $lsc
	Write-Host "Search for	: $name ($type)..."
	(lbyproc /i="$fapDllPath\myscript.lsc" /INI="$fsiuser" /nolog /s > $out)

}

Write-Host "Library: $library"
Write-Host "INI    : $fsiuser"
Write-Host "DLL    : $fapDllPath"

Remove-Item "$fapDllPath\FinalReport.txt"

librarySearch "$library" "$searchType" "$search" "" "" "$fapDllPath\report.txt"

cat "$fapDllPath\report.txt" | where { $_ -match "Found match" } | foreach-object { 

	$fapName = $_.split('<')[1].split('>')[0] 
	Write-Host "$logFile found in $fapName"
	Write-Host "Searching for usages of $fapName"
	librarySearch "$library" "FAP" "$fapName" "" "" "$fapDllPath\report$fapName.txt"

	cat "$fapDllPath\report$fapName.txt" | where { $_ -match "Successful" } >> "$fapDllPath\FinalReport.txt"
}

Remove-Item "$fapDllPath\trace"
Remove-Item "$fapDllPath\report.txt"
Remove-Item "$fapDllPath\myscript.lsc"
Write-Host "Finished."
