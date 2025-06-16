<# 
.NAME
    Nagios Host Creator
.SYNOPSIS
    Creates host CFG from template for Nagios monitoring 
.AUTHOR
    Anthony Ruscitto
.REVISION/DATE
    1.5 / 10/31/2024
.REVISIONS
	Fixed functionality to copy the CFG to the correct folder	
	on the Nagios server. 
.NOTES
	If this is stored in any location other than the c:\TEMP folder 
	you will need to modify the paths in the script below. this
	script also has to be kept within the NAGIOSTEMPLATE folder If
	you dont want a ton of frustration and errors. 

#>

#define the function
function makecfg {

#Set variabled for the server name and IP address 
$SRV = Read-Host "Enter Server Name "
$IPA = Read-Host "Enter Server IP "

#Define the template, make a copy of it, find and replace the server and IP info, then save it as a .cfg file
$original_file = 'c:\temp\nagiostemplate\template.txt'
$destination_file =  "c:\temp\nagiostemplate\$SRV.cfg"
(Get-Content $original_file) | Foreach-Object {
    $_ -replace '8459', "$SRV" `
       -replace '8460', "$IPA" `
    } | Set-Content $destination_file

Pause

# Copy the CFG to the HOSTS folder on Nagios server

scp "c:\temp\nagiostemplate\$SRV.cfg" administrator@<NAGIOS-IP>:/usr/local/nagios/etc/hosts/

# Delay a bit, then copy the CFG to the nagios_cfg folder 
start-sleep 10
copy c:\temp\nagiostemplate\$SRV.cfg c:\temp\nagiostemplate\nagios_cfg\

# Reminder that the Nagios service must be restarted on the Nagios server
msg * "Congrats, your cfg file has been created. Now copy it to the directory you keep your configs in on the Nagios server and restart the Nagios service."

}

#run the function 
makecfg








