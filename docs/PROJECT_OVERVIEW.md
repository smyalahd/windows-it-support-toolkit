# Project Overview – Windows IT Support Toolkit

## 1. Project Introduction

The Windows IT Support Toolkit is a PowerShell-based diagnostic utility developed to support common Windows IT troubleshooting tasks.

The primary objective is to collect essential system information, inspect network configurations, test network connectivity, verify DNS resolution, monitor local disk usage, and generate structured diagnostic reports.

The toolkit provides an interactive command-line interface that allows IT support technicians to perform basic diagnostic checks from a single application.

## 2. Project Objectives

The project was developed to demonstrate practical skills in Windows administration, PowerShell scripting, and IT troubleshooting.

The main objectives are:

- Automate the collection of basic Windows system information.
- Retrieve network configuration details, including IPv4 addresses, default gateways, and DNS servers.
- Perform basic network connectivity checks.
- Identify DNS resolution issues.
- Monitor available disk space on local drives.
- Generate structured JSON reports for diagnostic documentation.
- Apply configuration management and error handling.
- Provide a simple and accessible command-line interface.

## 3. Main Functionality

The toolkit consists of several independent PowerShell functions:

| Function | Description |
|---|---|
| `Get-ToolkitSettings` | Loads configuration settings from an external JSON file. |
| `Get-SystemInformation` | Retrieves Windows operating system and computer information. |
| `Get-NetworkInformation` | Displays network adapter, IPv4, gateway, and DNS information. |
| `Test-NetworkConnection` | Tests connectivity to a configured host using ICMP. |
| `Test-DNSResolution` | Checks whether a configured domain can be resolved. |
| `Get-DiskInformation` | Calculates disk capacity, used space, and available space. |
| `Export-DiagnosticReport` | Collects diagnostic information and exports it as a JSON report. |
| `Show-MainMenu` | Provides an interactive menu for accessing the toolkit functions. |

## 4. Technologies and Tools

- **PowerShell:** Main scripting language used to implement the toolkit.
- **Windows CIM/WMI:** Used to retrieve operating system, computer, and disk information.
- **Windows Networking Cmdlets:** Used to inspect network configuration and connectivity.
- **DNS Resolution:** Uses `Resolve-DnsName` to retrieve DNS records.
- **JSON:** Used for external configuration and structured diagnostic reports.
- **Git and GitHub:** Used for source control, version management, and project documentation.

## 5. Configuration Management

The toolkit uses an external configuration file located at `config/settings.json`.

The configuration defines:

- Target host for connectivity testing.
- Domain name for DNS resolution testing.
- Low disk space warning threshold.
- Diagnostic report filename.

This approach separates configurable values from the main PowerShell script and makes the toolkit easier to maintain.

## 6. Error Handling and Reliability

The implementation includes error handling using PowerShell `try/catch` blocks.

Examples include:

- Checking whether the configuration file exists.
- Handling invalid or unreadable JSON configuration.
- Handling DNS resolution failures.
- Catching unexpected errors during menu operations.

The toolkit also handles invalid menu selections and allows the user to return to the main menu.

## 7. Diagnostic Reporting

The toolkit can generate a structured JSON report containing:

- Report generation timestamp.
- System information.
- Network adapter configuration.
- Local disk usage.
- Connectivity test status.
- DNS resolution status and resolved IPv4 addresses.

The report provides a consolidated overview that can support troubleshooting and documentation.

## 8. Safety and Scope

The toolkit is designed for read-only diagnostic operations.

It does not intentionally modify Windows configuration, change network settings, or perform port scanning.

Network connectivity checks use ICMP requests to a specified host.

## 9. Skills Demonstrated

This project demonstrates practical knowledge of:

- Windows system administration fundamentals.
- PowerShell scripting and automation.
- System and network diagnostics.
- TCP/IP and DNS troubleshooting fundamentals.
- Disk space monitoring.
- JSON configuration and reporting.
- Error handling and defensive scripting.
- Technical documentation and test planning.

## 10. Project Purpose

This project was created as a practical portfolio demonstration of Windows IT support and troubleshooting capabilities.

It combines several common diagnostic tasks into one PowerShell application and demonstrates how routine support checks can be organized, automated, and documented.