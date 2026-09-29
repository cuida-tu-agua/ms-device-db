#Requires -Version 7
<#
.SYNOPSIS
  Factory registration of ONE real ESP32 (outside the dev seed).

.DESCRIPTION
  Generates the secret token and the pairing code, prints:
    1) the values to flash into the ESP32 and to print on the box label, and
    2) the INSERT to run as devices_migrator (only the SHA-256 hashes are stored).
  The plain values are shown ONCE: nothing is written to disk.

.EXAMPLE
  .\scripts\new-device.ps1 -Serial SW-ESP32-000100
#>
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^SW-ESP32-\d{6}$')]
    [string]$Serial
)

function Get-Sha256Hex([string]$text) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
    $hash = [System.Security.Cryptography.SHA256]::HashData($bytes)
    return ([System.Convert]::ToHexString($hash)).ToLowerInvariant()
}

# 24 random bytes -> 32 URL-safe characters (flashed into the firmware, never printed on the box)
$tokenBytes = [System.Security.Cryptography.RandomNumberGenerator]::GetBytes(24)
$token = [System.Convert]::ToBase64String($tokenBytes).TrimEnd('=').Replace('+', '-').Replace('/', '_')

# 8 characters without look-alikes (no 0/O, 1/I/L) -> printed on the box as XXXX-XXXX
$alphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789'
$code = -join (1..8 | ForEach-Object { $alphabet[[System.Security.Cryptography.RandomNumberGenerator]::GetInt32($alphabet.Length)] })

$tokenHash = Get-Sha256Hex $token
$pairingHash = Get-Sha256Hex "${Serial}:${code}"

Write-Host ''
Write-Host '=== Firmware (secrets.h) ===' -ForegroundColor Cyan
Write-Host "DEVICE_SERIAL = `"$Serial`""
Write-Host "DEVICE_TOKEN  = `"$token`""
Write-Host ''
Write-Host '=== Box label ===' -ForegroundColor Cyan
Write-Host "Serial: $Serial"
Write-Host ("Pairing code: {0}-{1}" -f $code.Substring(0, 4), $code.Substring(4))
Write-Host ''
Write-Host '=== SQL (run as devices_migrator) ===' -ForegroundColor Cyan
Write-Host "INSERT INTO devices.devices (serial_number, auth_token_hash, pairing_code_hash)"
Write-Host "VALUES (N'$Serial', '$tokenHash', '$pairingHash');"
