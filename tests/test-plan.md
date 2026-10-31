
# Windows IT Support Toolkit – Test Plan

## 1. Purpose

This test plan describes how the Windows IT Support Toolkit is tested.

The goal is to verify that all diagnostic functions work correctly and that errors are handled safely.

## 2. Test Environment

- Operating System: Windows 11
- Shell: Windows PowerShell
- Language: PowerShell
- Execution Environment: Visual Studio Code Terminal

## 3. Functional Tests

| Test ID | Function | Test Description | Expected Result |
|---|---|---|---|
| TC-01 | System Information | Retrieve Windows information | System details are displayed |
| TC-02 | Network Information | Retrieve network configuration | IP, gateway and DNS are displayed |
| TC-03 | Connectivity Test | Ping example.com | Connection status is displayed |
| TC-04 | DNS Resolution | Resolve example.com | IPv4 addresses are displayed |
| TC-05 | Disk Information | Retrieve local disk information | Disk usage is displayed |
| TC-06 | JSON Report | Generate diagnostic report | JSON file is created |
| TC-07 | Main Menu | Select option 1–6 | Correct function is executed |
| TC-08 | Exit | Select option 0 | Toolkit closes |

## 4. Error Handling Tests

| Test ID | Test Description | Expected Result |
|---|---|---|
| TC-09 | Enter an invalid menu option | Error message is displayed |
| TC-10 | DNS resolution fails | DNS error is handled |
| TC-11 | Connectivity test fails | Connection failure is displayed |

## 5. Safety Checks

- The toolkit only reads system information.
- No Windows configuration is modified.
- No files are deleted.
- No network port scanning is performed.
- Diagnostic reports are saved locally.

## 6. Test Results

| Test ID | Status | Notes |
|---|---|---|
| TC-01 | Passed | Verified manually |
| TC-02 | Passed | Verified manually |
| TC-03 | Passed | example.com reachable |
| TC-04 | Passed | DNS resolution successful |
| TC-05 | Passed | Disk information displayed |
| TC-06 | Passed | JSON report created |
| TC-07 | Passed | Menu functions tested |
| TC-08 | Passed | Toolkit exited successfully |
| TC-09 | Passed | Invalid option handled correctly |
| TC-10 | Passed | Invalid domain handled correctly |
| TC-11 | Passed | Unreachable destination handled correctly |
