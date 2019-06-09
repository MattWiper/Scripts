$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name;
$path = "HKCU:\Software\Wow6432Node\Policies\Microsoft\Windows\Server\ServerManager"

Write-Host "Disabling display of Server Manager at logon for user " -NoNewline
Write-Host $currentUser -ForegroundColor Green
Write-Host "Checking if $path exists"

if(Test-Path $path) {
    Write-Host "$path exists. Updating DoNotOpenAtLogon"

    Get-Item $path | New-ItemProperty -Name DoNotOpenAtLogon -Value 1 -Force | Out-Null
}
else {
    Write-Host "$pathr does not exist. Creating and setting DoNotOpenAtLogon"

    New-Item $path -Name ServerManager -Force | New-ItemProperty -Name DoNotOpenAtLogon -Value 1 -Force | Out-Null
}

if(Test-Path $path) {
    if((Get-ItemProperty $path -Name DoNotOpenAtLogon).DoNotOpenAtLogon -eq 1){
        Write-Host "SUCCESS" -ForegroundColor Green
    } else {
        Write-Host "FAILURE: DoNotOpenAtLogon was not set" -ForegroundColor Red
    }
}
else 
{
    Write-Host "FAILURE: $path was not created" -ForegroundColor Red
}