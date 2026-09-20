# Setup inicial — Windows
#Requires -Version 5.1
$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $RepoRoot

$MediaRoot = "C:\Media"
$dirs = @(
    "$MediaRoot\Movies",
    "$MediaRoot\Series",
    "$MediaRoot\YouTube",
    "$MediaRoot\Kids\Movies",
    "$MediaRoot\Kids\Series",
    "$MediaRoot\Kids\YouTube",
    "$RepoRoot\jellyfin\config",
    "$RepoRoot\jellyfin\cache"
)
foreach ($d in $dirs) {
    New-Item -ItemType Directory -Force -Path $d | Out-Null
}
Write-Host "Pastas de mídia em $MediaRoot"

if (-not (Test-Path "$RepoRoot\.env")) {
    Copy-Item "$RepoRoot\.env.example" "$RepoRoot\.env"
}

$ip = (Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.InterfaceAlias -notmatch 'Loopback' -and $_.IPAddress -notmatch '^169' } |
    Select-Object -First 1).IPAddress

if ($ip) {
    $url = "http://${ip}:8096"
    Write-Host "IP LAN detectado: $ip"
    Write-Host "Sugestão JELLYFIN_PUBLISHED_SERVER_URL=$url"
    $envContent = Get-Content "$RepoRoot\.env" -Raw
    if ($envContent -notmatch 'MEDIA_PATH=' -or $envContent -match 'MEDIA_PATH=\s*$') {
        $envContent = $envContent -replace 'MEDIA_PATH=.*', 'MEDIA_PATH=C:/Media'
    }
    if ($envContent -notmatch 'JELLYFIN_PUBLISHED_SERVER_URL=http') {
        $envContent = $envContent -replace 'JELLYFIN_PUBLISHED_SERVER_URL=.*', "JELLYFIN_PUBLISHED_SERVER_URL=$url"
    }
    Set-Content -Path "$RepoRoot\.env" -Value $envContent -NoNewline
}

Write-Host ""
Write-Host "Próximo passo:"
Write-Host "  docker compose -f docker-compose.yml -f docker-compose.windows.yml up -d"
Write-Host "  Abra http://127.0.0.1:8096"
