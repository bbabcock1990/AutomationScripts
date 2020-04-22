<#
.SYNOPSIS
    Automated process of stopping WVD File Server after peak-hours.
.DESCRIPTION
    This script is intended to automatically stop the Windows Virtual Desktop File Server
    after peak-hours. The script pulls the WVD File Server from Azure and runs the Stop-AzVM 
    command to shut the server down. This runbook is triggered via a Azure Automation running 
    on a trigger.
    
.NOTES
    Script is offered as-is with no warranty, expressed or implied.
    Test it before you trust it
    Author      : Brandon Babcock
    Website     : https://www.linkedin.com/in/brandonbabcock1990/
    Version     : 1.0.0.0 Initial Build
#>

######## Variables ##########

#AD and Sub IDs Pulled From Runbook Variables
$aadTenantId = Get-AutomationVariable -Name 'aadTenantId'
$azureSubId = Get-AutomationVariable -Name 'azureSubId'

# File Server Resource Group
$fileServerRG = 'ahead-brandon-babcock-testwvd-rg'

# File Server Virtual Machine Name
$fileServerVMName = ''


########## Script Execution ##########

# Log into Azure
try {
    $creds = Get-AutomationPSCredential -Name 'WVD-Scaling-SVC'
    Connect-AzAccount -ErrorAction Stop -ServicePrincipal -SubscriptionId $azureSubId -TenantId $aadTenantId -Credential $creds
    Write-Verbose Get-RdsContext | Out-String -Verbose
}
catch {
    $ErrorMessage = $_.Exception.message
    Write-Error ("Error logging into Azure: " + $ErrorMessage)
    Break
}


# Shutdown File Server
try{
    Write-Verbose "Shutting down File Server: $fileServerName" -Verbose
    Stop-AzVM -ErrorAction Stop -ResourceGroupName $fileServerRG -Name $fileServerVMName -Force -AsJob
    
}
catch{
    $ErrorMessage = $_.Exception.message
    Write-Error ("Error shutting down File Server: " + $ErrorMessage)
    Break
}

