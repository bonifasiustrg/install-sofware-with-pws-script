Write-Host "Hello world! I created a PowerShell script!"

# Get all installed 32 bit app information from registry
$32bit_softwares = Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | 
                    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate


# Get all installed 64 bit app information from registry  and filter the information
$64bit_softwares = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | 
                    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate

# merge 32 bit and 64 bit app information
$all_softwares = $32bit_softwares + $64bit_softwares

## chech wheter specify app is installed or not
$all_softwares.DisplayName -like '*sdfsf*'

# add log file
Start-Transcript -Path "C:\test\winrar_install.log" -NoClobber

# source file location
$source = 'https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-621.exe'

# Destination to save the file
$destination_dir = 'C:\test'
$installation_file = "$destination_dir\winrarr.exe"
$softwareName='winrar'

if ($64bit_softwares.DisplayName -like "*$softwareName*") {
    Write-Output "Software is already installed"
    Write-Host "---------> Exiting <---------" -ForegroundColor Red -BackgroundColor Yellow
    #Exit;
} else {
    Write-Output "Software is not installed. Proceeding with installation"
}

#Download the file installer from internet at the specified location if have not been there
if (-not ( Test-Path $installation_file)) {
    New-Item $destination_dir -ItemType Directory -Force
    Invoke-WebRequest -Uri $source -OutFile $installation_file -Verbose
}

Write-Output "Installing software: $softwareName"
Start-Process $installation_file /S -NoNewWindow -Wait -PassThru

if ( $64bit_softwares.DisplayName -like "$softwareName*") {
    Write-Output "Software is installed successfully"
}

Stop-Transcript