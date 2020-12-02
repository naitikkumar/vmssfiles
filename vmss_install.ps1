
#installing local accounts on vm

[string[]]$useraccounts = 'dbadmin','backupadmin','devaccount'
$passwords = ConvertTo-SecureString '$y$@dmin_2020' -AsPlainText -Force 
foreach ($users in $useraccounts)
{
    New-LocalUser -Name $users -AccountNeverExpires -Description "administrator accounts created using powershell" -FullName "this account belongs to $users" -Password $passwords 
}
foreach ($users in $useraccounts)
{
Add-LocalGroupMember -Group administrators -Member $useraccounts 
}
#installing iis on vm

Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools 


#removing default application, defaultsite and creating new application pool and new website
[string]$oldwebappool= 'DefaultAppPool'
Remove-WebAppPool -Name $oldwebappool

Remove-Website -Name 'Default Web site'

$newAppPool = New-WebAppPool -Name "mysite"

New-WebSite -Name "mysite" -Port 80  -PhysicalPath "$env:systemdrive\inetpub\wwwroot" -ApplicationPool $newAppPool.name

#installing firefox using on vmss

#$SourceURL = "https://redirector.gvt1.com/edgedl/release2/chrome/VM7AZGvxTD3eRDzvxYLSvg_86.0.4240.75/86.0.4240.75_chrome_installer.exe"
#$Installer = $env:TEMP + "\chrome.exe"
#Invoke-WebRequest $SourceURL -OutFile $Installer
#Start-Process -FilePath $Installer -Args "/s" -Verb  -Wait -PassThru
#Remove-Item -Path $Installer -Recurse -Force
