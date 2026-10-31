
# Windows IT Support Toolkit
# Version: 1.0
# Purpose: Collect basic Windows system information.

Clear-Host
# Load toolkit settings from the configuration file.
function Get-ToolkitSettings {

    # Build the path to the settings file.
    $configPath = Join-Path $PSScriptRoot "config\settings.json"

    # Check whether the configuration file exists.
    if (-not (Test-Path $configPath)) {
        throw "Configuration file not found: $configPath"
    }

    try {
        # Read and convert JSON configuration into a PowerShell object.
        $settings = Get-Content -Path $configPath -Raw |
            ConvertFrom-Json -ErrorAction Stop

        return $settings
    }
    catch {
        throw "Failed to load configuration: $($_.Exception.Message)"
    }
}

# Load configuration when the toolkit starts.
$settings = Get-ToolkitSettings

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       WINDOWS IT SUPPORT TOOLKIT       " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

function Get-SystemInformation {

    Write-Host "`n[ SYSTEM INFORMATION ]" -ForegroundColor Yellow

    $os = Get-CimInstance Win32_OperatingSystem
    $computer = Get-CimInstance Win32_ComputerSystem

    Write-Host "Computer Manufacturer: $($computer.Manufacturer)"
    Write-Host "Windows Version: $($os.Caption)"
    Write-Host "OS Architecture: $($os.OSArchitecture)"
    Write-Host "Windows Build: $($os.BuildNumber)"
    Write-Host "Last Boot: $($os.LastBootUpTime)"
}

# Collect basic network information.
function Get-NetworkInformation {

    Write-Host "`n[ NETWORK INFORMATION ]" -ForegroundColor Yellow

    # Get active network adapters with an IPv4 address.
    $adapters = Get-NetIPConfiguration |
        Where-Object {
            $_.IPv4Address -ne $null
        }

    foreach ($adapter in $adapters) {

        Write-Host "`nNetwork Adapter: $($adapter.InterfaceAlias)"

        # Display IPv4 address.
        Write-Host "IPv4 Address: $($adapter.IPv4Address.IPAddress)"

        # Display default gateway.
        if ($adapter.IPv4DefaultGateway) {
            Write-Host "Default Gateway: $($adapter.IPv4DefaultGateway.NextHop)"
        }
        else {
            Write-Host "Default Gateway: Not available"
        }

        # Display DNS servers.
        if ($adapter.DNSServer.ServerAddresses) {
            Write-Host "DNS Servers: $($adapter.DNSServer.ServerAddresses -join ', ')"
        }
        else {
            Write-Host "DNS Servers: Not available"
        }
    }
}

# Test network connectivity to a specified host.
function Test-NetworkConnection {

    Write-Host "`n[ CONNECTIVITY TEST ]" -ForegroundColor Yellow

    # Define the target server.
    $target = $settings.TargetHost

    Write-Host "Testing connection to $target ..."

    # Send one ICMP ping request.
    $result = Test-Connection -ComputerName $target -Count 1 -Quiet

    if ($result) {
        Write-Host "Connection successful!" -ForegroundColor Green
    }
    else {
        Write-Host "Connection failed!" -ForegroundColor Red
    }
}

# Check DNS name resolution.
function Test-DNSResolution {

    Write-Host "`n[ DNS RESOLUTION TEST ]" -ForegroundColor Yellow

    # Define the domain to resolve.
    $domain = $settings.DnsDomain

    Write-Host "Resolving DNS for $domain ..."

    try {
        # Request DNS records for the domain.
        $result = Resolve-DnsName -Name $domain -ErrorAction Stop

        # Display IPv4 addresses.
        $addresses = $result |
            Where-Object { $_.Type -eq "A" } |
            Select-Object -ExpandProperty IPAddress

        if ($addresses) {
            Write-Host "DNS resolution successful!" -ForegroundColor Green

            foreach ($address in $addresses) {
                Write-Host "Resolved IPv4 Address: $address"
            }
        }
        else {
            Write-Host "No IPv4 address found." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "DNS resolution failed!" -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)"
    }
}

# Generate a JSON diagnostic report.
function Export-DiagnosticReport {

    Write-Host "`n[ REPORT GENERATION ]" -ForegroundColor Yellow

    # Collect system information.
    $os = Get-CimInstance Win32_OperatingSystem
    $computer = Get-CimInstance Win32_ComputerSystem

    # Collect network information.
    $network = Get-NetIPConfiguration |
        Where-Object { $_.IPv4Address -ne $null } |
        ForEach-Object {

            [PSCustomObject]@{
                Adapter = $_.InterfaceAlias
                IPv4Address = $_.IPv4Address.IPAddress
                Gateway = $_.IPv4DefaultGateway.NextHop
                DNS = $_.DNSServer.ServerAddresses
            }
        }
# Collect local disk information.
$diskInformation = Get-CimInstance Win32_LogicalDisk -Filter "DriveType = 3" |
    ForEach-Object {

        $totalSize = [math]::Round($_.Size / 1GB, 2)
        $freeSpace = [math]::Round($_.FreeSpace / 1GB, 2)

        [PSCustomObject]@{
            Drive = $_.DeviceID
            TotalGB = $totalSize
            FreeGB = $freeSpace
            UsedGB = [math]::Round($totalSize - $freeSpace, 2)
            FreePercentage = [math]::Round(($freeSpace / $totalSize) * 100, 2)
        }
    }
    # Run connectivity test and store the result.
$connectivityStatus = Test-Connection -ComputerName "example.com" -Count 1 -Quiet -ErrorAction SilentlyContinue

# Run DNS resolution test and store the result.
try {
    $dnsResult = Resolve-DnsName -Name "example.com" -Type A -ErrorAction Stop

    $dnsAddresses = @(
        $dnsResult |
            Where-Object { $_.Type -eq "A" } |
            Select-Object -ExpandProperty IPAddress
    )

    $dnsStatus = $dnsAddresses.Count -gt 0
}
catch {
    $dnsAddresses = @()
    $dnsStatus = $false
}
    # Create the report object.
    $report = [PSCustomObject]@{
        ReportDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        System = [PSCustomObject]@{
            Manufacturer = $computer.Manufacturer
            WindowsVersion = $os.Caption
            Architecture = $os.OSArchitecture
            Build = $os.BuildNumber
        }

        Network = $network
        Disk = $diskInformation
        Diagnostics = [PSCustomObject]@{
    Connectivity = if ($connectivityStatus) { "Successful" } else { "Failed" }
    DNS = if ($dnsStatus) { "Successful" } else { "Failed" }
    ResolvedIPv4Addresses = $dnsAddresses
}
    }

    # Define the report file path.
    $reportPath = Join-Path $PSScriptRoot "reports\$($settings.ReportFileName)"

    # Convert the report to JSON and save it.
    $report |
        ConvertTo-Json -Depth 5 |
        Set-Content -Path $reportPath -Encoding UTF8

    Write-Host "Report successfully created!" -ForegroundColor Green
    Write-Host "Saved to: $reportPath"
}

# Check available disk space on local drives.
function Get-DiskInformation {

    Write-Host "`n[ DISK INFORMATION ]" -ForegroundColor Yellow

    # Retrieve information about local fixed disks.
    $disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType = 3"

    foreach ($disk in $disks) {

        # Convert disk size from bytes to gigabytes.
        $totalSize = [math]::Round($disk.Size / 1GB, 2)
        $freeSpace = [math]::Round($disk.FreeSpace / 1GB, 2)

        # Calculate used space.
        $usedSpace = [math]::Round($totalSize - $freeSpace, 2)

        # Calculate percentage of free space.
        $freePercentage = [math]::Round(($freeSpace / $totalSize) * 100, 2)

        Write-Host "`nDrive: $($disk.DeviceID)"
        Write-Host "Total Size: $totalSize GB"
        Write-Host "Used Space: $usedSpace GB"
        Write-Host "Free Space: $freeSpace GB"
        Write-Host "Free Space Percentage: $freePercentage %"

        # Warn if less than 15% free space remains.
        if ($freePercentage -lt $settings.LowDiskSpaceThreshold) {
            Write-Host "WARNING: Low disk space!" -ForegroundColor Red
        }
        else {
            Write-Host "Disk space status: OK" -ForegroundColor Green
        }
    }
}

# Main menu for the Windows IT Support Toolkit.
function Show-MainMenu {

    do {
        Clear-Host

        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "       WINDOWS IT SUPPORT TOOLKIT       " -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan

        Write-Host ""
        Write-Host "1. System Information"
        Write-Host "2. Network Information"
        Write-Host "3. Connectivity Test"
        Write-Host "4. DNS Resolution Test"
        Write-Host "5. Disk Information"
        Write-Host "6. Generate JSON Report"
        Write-Host "0. Exit"

        Write-Host ""

        $choice = Read-Host "Select an option"

        try {

    switch ($choice) {

        "1" { Get-SystemInformation }
        "2" { Get-NetworkInformation }
        "3" { Test-NetworkConnection }
        "4" { Test-DNSResolution }
        "5" { Get-DiskInformation }
        "6" { Export-DiagnosticReport }

        "0" {
            Write-Host "Exiting toolkit..." -ForegroundColor Cyan
        }

        default {
            Write-Host "Invalid option. Please try again." -ForegroundColor Red
        }
    }
}
catch {
    Write-Host "`nAn unexpected error occurred!" -ForegroundColor Red
    Write-Host "Details: $($_.Exception.Message)" -ForegroundColor Yellow
}

        if ($choice -ne "0") {
            Write-Host ""
            Read-Host "Press Enter to return to the main menu"
        }

    } while ($choice -ne "0")
}

# Start the toolkit.
Show-MainMenu