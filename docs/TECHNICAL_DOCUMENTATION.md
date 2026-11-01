# Technical Documentation

## 1. System Information Collection

**Function:** `Get-SystemInformation`

**Purpose:** Collects essential information about the Windows operating system and computer hardware.

**Implementation:**
- `Get-CimInstance Win32_OperatingSystem` retrieves the Windows version, architecture, build number, and last boot time.
- `Get-CimInstance Win32_ComputerSystem` retrieves computer information, including the manufacturer.

**IT Support Relevance:** Helps technicians identify the workstation's operating system and hardware environment when troubleshooting incidents.

**Interview Explanation:**

"I used PowerShell's `Get-CimInstance` cmdlet to retrieve system information from Windows. This allows the toolkit to display important details such as the operating system version, architecture, build number, last boot time, and computer manufacturer."

## 2. Network Information Collection

**Function:** `Get-NetworkInformation`

**Purpose:** Retrieves network configuration details from available network adapters.

**Implementation:**
- `Get-NetIPConfiguration` retrieves network adapter configuration.
- `Where-Object` filters adapters with an IPv4 address.
- `IPv4Address` displays the assigned IP address.
- `IPv4DefaultGateway` identifies the default gateway.
- `DNSServer.ServerAddresses` displays configured DNS servers.

**IT Support Relevance:** Helps technicians investigate network connectivity issues, incorrect IP configurations, and DNS-related problems.

**Interview Explanation:**

"I used the `Get-NetIPConfiguration` cmdlet to retrieve network configuration details. The function filters network adapters with an IPv4 address and displays the IP address, default gateway, and DNS servers. This information is useful when troubleshooting network connectivity issues on Windows workstations."

## 3. Network Connectivity Testing

**Function:** `Test-NetworkConnection`

**Purpose:** Checks network connectivity to a configured host.

**Implementation:**
- `Test-Connection` sends an ICMP echo request to the specified target.
- `-Count 1` sends one request.
- `-Quiet` returns a Boolean result (`True` or `False`).
- The result determines whether the connection test is reported as successful or failed.

**IT Support Relevance:** Helps technicians perform an initial connectivity check when investigating network or server accessibility issues.

**Interview Explanation:**

"I implemented a connectivity test using PowerShell's `Test-Connection` cmdlet. It sends an ICMP request to a configured host and checks whether a response is received. This provides a quick initial indication of network reachability."

**Important:** A failed ping does not always mean that a server is unavailable. ICMP traffic may be blocked by a firewall."

## 4. DNS Resolution Testing

**Function:** `Test-DNSResolution`

**Purpose:** Checks whether a configured domain name can be resolved into an IP address.

**Implementation:**
- `Resolve-DnsName` queries DNS records for the configured domain.
- `Where-Object` filters the results to IPv4 (A) records.
- `Select-Object -ExpandProperty IPAddress` extracts the resolved IP addresses.
- `try/catch` handles DNS resolution errors.

**IT Support Relevance:** Helps technicians investigate DNS-related problems, such as websites or internal services that cannot be reached by hostname.

**Interview Explanation:**

"I implemented a DNS resolution test using PowerShell's `Resolve-DnsName` cmdlet. The function queries the configured domain, filters IPv4 records, and displays the resolved IP addresses. I also added error handling to report DNS resolution failures."

## 5. Disk Space Monitoring

**Function:** `Get-DiskInformation`

**Purpose:** Monitors available storage space on local fixed disks.

**Implementation:**
- `Get-CimInstance Win32_LogicalDisk` retrieves local disk information.
- `DriveType = 3` filters for local fixed disks.
- Disk capacity and free space are converted from bytes to gigabytes.
- `[math]::Round()` rounds the calculated values to two decimal places.
- The free space percentage is compared against a configurable threshold.
- A warning is displayed when available disk space falls below the configured threshold.

**IT Support Relevance:** Helps technicians identify storage capacity issues that may affect Windows performance, application installations, and system operations.

**Interview Explanation:**

"I implemented disk space monitoring using the `Win32_LogicalDisk` CIM class. The function retrieves information about local fixed disks, calculates used and available storage space, and determines the percentage of free space. It compares this value against a configurable threshold and displays a warning when disk space is low."

## 6. JSON Diagnostic Reporting

**Function:** `Export-DiagnosticReport`

**Purpose:** Collects system, network, disk, and diagnostic information and exports it into a structured JSON report.

**Implementation:**
- `Get-CimInstance` retrieves operating system, computer, and disk information.
- `Get-NetIPConfiguration` collects network adapter configuration.
- `Test-Connection` checks connectivity to the configured diagnostic target.
- `Resolve-DnsName` checks DNS resolution.
- `[PSCustomObject]` organizes the collected information into structured objects.
- `ConvertTo-Json -Depth 5` converts the report object into JSON format.
- `Set-Content` saves the generated report in the reports directory.

**IT Support Relevance:** Provides a consolidated diagnostic overview that can be stored, reviewed, and used for troubleshooting documentation or incident escalation.

**Interview Explanation:**

"I developed an automated reporting function that collects system, network, disk, and diagnostic information. I used PowerShell custom objects to structure the collected data and converted the result into JSON format. The report can then be saved and reviewed as part of a troubleshooting or incident documentation process."

## 7. Configuration Management

**Function:** `Get-ToolkitSettings`

**Purpose:** Loads external configuration settings from a JSON file when the toolkit starts.

**Implementation:**
- `Join-Path` builds the path to `config/settings.json`.
- `Test-Path` checks whether the configuration file exists.
- `Get-Content -Raw` reads the complete file.
- `ConvertFrom-Json` converts JSON data into a PowerShell object.
- `try/catch` handles configuration loading errors.

**IT Support Relevance:** Separating configuration from application logic makes the toolkit easier to maintain and allows settings to be changed without modifying the main script.

**Interview Explanation:**

"I implemented external configuration management using a JSON file. At startup, the toolkit checks whether the configuration file exists, reads its contents, and converts the JSON data into a PowerShell object. This allows important settings to be maintained separately from the main script."

## 8. Error Handling

**Implementation:** PowerShell `try/catch` blocks and conditional checks.

**Purpose:** Prevents common errors from interrupting the toolkit and provides meaningful error messages.

**Implementation Details:**
- `try` executes operations that may fail.
- `catch` handles errors and displays diagnostic information.
- `-ErrorAction Stop` ensures that certain command errors can be handled by `catch`.
- `Test-Path` checks whether required configuration files exist.
- Conditional statements handle missing DNS records and invalid menu selections.

**IT Support Relevance:** Reliable error handling helps technicians identify problems, understand failure conditions, and continue troubleshooting without unnecessary interruptions.

**Interview Explanation:**

"I implemented error handling using PowerShell's try/catch mechanism. For example, configuration loading and DNS resolution are protected against failures. I also use conditional checks to handle missing information and invalid menu selections. This makes the toolkit more reliable and provides clearer feedback during troubleshooting.

## 9. Testing and Validation

**Purpose:** Validates the toolkit's main functionality and checks how it behaves under different conditions.

**Testing Approach:**

The toolkit was manually tested using the test cases documented in `tests/test-plan.md`.

The tests cover:

- System information collection.
- Network configuration retrieval.
- Network connectivity testing.
- DNS resolution.
- Disk space monitoring.
- JSON report generation.
- Main menu navigation.
- Invalid menu selections.
- DNS resolution failures.
- Network connectivity failures.

**Validation:**

Both successful and unsuccessful diagnostic scenarios were tested to verify the toolkit's output and basic error handling.

**IT Support Relevance:** Testing helps ensure that diagnostic functions behave as expected and that common failure scenarios provide understandable feedback.

**Interview Explanation:**

"I created a test plan to validate the toolkit's main functions. I manually tested normal operations as well as failure scenarios, including invalid menu selections, unsuccessful connectivity tests, and DNS resolution failures. This helped me verify the expected behavior and identify potential issues."