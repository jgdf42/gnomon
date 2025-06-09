### Gnomon 1.0


# Set log file path
$logFile = Join-Path $env:TEMP "RdpSaLog.txt"


# Clear the screen
Clear-Host


# Check for administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator privileges." -ForegroundColor Red
    Write-Host "Please close the script and run it again as administrator." -ForegroundColor Red
    Write-Host "Press any key to exit." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    exit
}


# Display script title and description with colorized parts
Write-Host "      /" -NoNewline -ForegroundColor Cyan
Write-Host "^| " -NoNewline -ForegroundColor Cyan
Write-Host "gnomon " -NoNewline -ForegroundColor DarkGreen
Write-Host "[ noh-mon ]" -ForegroundColor DarkBlue
Write-Host "     /" -NoNewline -ForegroundColor Cyan
Write-Host " ^| " -NoNewline -ForegroundColor Cyan
Write-Host "[noun]" -ForegroundColor DarkCyan
Write-Host "    /" -NoNewline -ForegroundColor Cyan
Write-Host "  ^| "  -NoNewline -ForegroundColor Cyan
Write-Host " A gnomon is a device used in ancient times to" -ForegroundColor Yellow
Write-Host "   /" -NoNewline -ForegroundColor Cyan
Write-Host "   ^| " -NoNewline -ForegroundColor Cyan
Write-Host " determine the time of day by measuring the" -ForegroundColor Yellow
Write-Host "  /" -NoNewline -ForegroundColor Cyan
Write-Host "____^|" -NoNeWLine -ForegroundColor Cyan
Write-Host "  length of a shadow on a sundial." -ForegroundColor Yellow


# Main loop
do {
    $rdpSaProcess = Get-Process RdpSa -ErrorAction SilentlyContinue
    if ($rdpSaProcess) {
        Write-Host "---" -ForegroundColor DarkYellow
        $notepadProcess = Get-Process notepad -ErrorAction SilentlyContinue
        if (-not $notepadProcess) {
            Start-Process "notepad"
        }
        Write-Host "[$(Get-Date)]" -ForegroundColor DarkYellow
        Stop-Process -Name vncviewer -Force -ErrorAction SilentlyContinue
        # Additional taskkill commands can be uncommented and added here
        "$((Get-Date))`n---`n" | Out-File -FilePath $logFile -Append


        # Define the number of recent events to fetch
        $numberOfEvents = 10


        # Get the recent logon events from the Security log
        $logonEvents = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4624} -MaxEvents $numberOfEvents


        # Process each event
        foreach ($event in $logonEvents) {
            # Convert the event to XML to access detailed event properties
            $eventXml = [xml]$event.ToXml()


            # Initialize variables to avoid null binding errors
            $logonProcessName = ""
            $targetUserName = ""


            # Try to extract "LogonProcessName" and "TargetUserName"
            foreach ($data in $eventXml.Event.EventData.Data) {
                if ($data.Name -eq "LogonProcessName") {
                    $logonProcessName = $data.'#text'
                }
                if ($data.Name -eq "TargetUserName") {
                    $targetUserName = $data.'#text'
                }
            }


            # Check if LogonProcessName is "Kerberos" and display TargetUserName
            if ($logonProcessName -eq "Kerberos") {
                Write-Host "Target User Name: $targetUserName" -ForegroundColor Yellow
            }
        }


        Start-Sleep -Seconds 1
    }
    Start-Sleep -Seconds 3
} while ($true)
