# CAU regulations MCP (8445, no token) - one-shot installer for Windows
# Installs bridge files to %USERPROFILE%\cau-regulations-client, runs --check,
# registers in Claude Desktop, Claude Code and Codex (if present). Backs up configs.
# Run on campus network or school VPN:
#   powershell -ExecutionPolicy Bypass -File install-cau-regulations.ps1
# Package: 2026-11-13 package, bridge sha256 8224d8431afb..., cert expires 2027-02-11

$ErrorActionPreference = 'Stop'
$dest  = Join-Path $env:USERPROFILE 'cau-regulations-client'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
function Step($m) { Write-Host "`n== $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "   $m" -ForegroundColor Green }
function Warn($m) { Write-Host "   $m" -ForegroundColor Yellow }

$payload = @{
'cau-regulations-bridge.js' = @'
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
AVg+ZjJzGwAA
'@
'config.json' = @'
H4sIAAAAAAAC/6vmUlBQKi3KUbJSUMooKSkottLXNzQz1TO0NNEzM9QzN7SyMDEx1c9NLlDSASktKE3KyUwGqi4pKk3lquUCAKl5
bTlAAAAA
'@
'server-cert.pem' = @'
H4sIAAAAAAAC/2WUy66ySBSF5zxFz82JCIg66EEVVQJCFRRXYQZyOQKColLi07f+g04nvYdrX5Kd9WX9/HwKYt2kf2nYC8y9qYEA
f8UfgZgm2jeaBiq1BtyEoDZDTc5kpSDxMN/V3fq4DZ2n54C7JbshRyw5WENq/k4nChi2BcgA1xGOCWQ6WIUYcE5JkKzsBq+ppkjE
V2QSgHLPxZk2+EUCwknDFIKi7KsJ9A1mEuB/RQLr174BIaxpBAEhKMAS9ZWXE7Dn58CTvjGva3wmQNQ1/6YLvpnLiGEIWAiAYkLE
wXfAAsPnHYYYw4vSfXcI5/PVKtVbnO+SM1Vmw5B2kt74AiaGZEReXYEpxWlGnZeOXtlwXyezBh+65J3ydCg067CoptGxH6WlSLfj
cWT35WN85UCQ0dzKRuHb54n1iDq9t1CqNj2fHBUDMEhdq42buO7Hg74j2eVi5r1vWYEkJdY63+Jc2AbuGhzU7OxpVApujylgt3qn
xzVRgM9Dun2VdSC/2igpT6t0dxvT4elXtnf1dlqjXE3hlNZGO8XyMp0cTe8HRvlbuT3d0otbefNWLhctai+bJbH6y+QquK4L504C
W2TTwokkQ/CNjEf3uOdK1KD78CwdJh98D9rFyktKpJIrmGe7LFdcte1kII+op6AmEAC9iRGMBQLFr/8FqlkMob8+N5r8wHZnDRkw
z04n0t4i2tPhAXC/1hreZ7naYhgABJixFAjY/jmAGTMJyAxoHTU3PHHMExR5Ygc/ZGl1Ylo8gZCFBvh0/kuj8MXxQyP6eA+BDeW2
49jbeo/mnfkL8D5p6fU19rdmDgmmQFyO7W47R9f9pgmcVxWXgq3mjmQf3fymnruhvU+01LvMea6Tt2Y1xny/kT3qN6oXa7K/OCx3
SdbwJSfZ+IxETkxBBePLByYQb1d17SPonawtXh1e+e/CC2s66PziVsdhHAp5kgwpdJGfnvaGaKOuvZBiFGZLGen+HdLYzLp2oauL
RwGg4rz3xyuzhnN/WM30+QgiZlqevEU5cVeVQWkHxPK4k2dh9a6m313hV7XuGBRm82rJ2jHMavfsFWChnoPV+3fA/JZFx+pUH5TH
BijQlxy5UMTO3wnqdPe47q3Ivcxzca56vwzTKDct8KvwcV+nl/pv4U90YIr+Hyf/AMmpYPlrBAAA
'@
}

Step '1/6 Node.js'
$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeCmd) { throw 'Node.js not found. Install LTS from https://nodejs.org and run again.' }
$node = $nodeCmd.Source
$ver = (& $node -v).Trim()
if ([int]($ver.TrimStart('v').Split('.')[0]) -lt 18) { throw "Node.js $ver found; 18 or later is required." }
Ok "$ver ($node)"

Step '2/6 Install files'
if (Test-Path $dest) {
    Rename-Item -Path $dest -NewName "cau-regulations-client.bak-$stamp"
    Ok "Old folder backed up: $dest.bak-$stamp"
}
New-Item -ItemType Directory -Path $dest | Out-Null
foreach ($name in $payload.Keys) {
    $gz = [Convert]::FromBase64String(($payload[$name] -replace '\s', ''))
    $in = New-Object System.IO.MemoryStream(,$gz)
    $zs = New-Object System.IO.Compression.GZipStream($in, [System.IO.Compression.CompressionMode]::Decompress)
    $out = New-Object System.IO.MemoryStream
    $zs.CopyTo($out); $zs.Close()
    [IO.File]::WriteAllBytes((Join-Path $dest $name), $out.ToArray())
}
Ok "Installed to $dest"

Step '3/6 Connection test (--check)'
$bridge = Join-Path $dest 'cau-regulations-bridge.js'
& $node $bridge --check
if ($LASTEXITCODE -ne 0) { throw 'Connection test failed. Check campus network/VPN (see README troubleshooting table).' }

$nodeFwd   = $node -replace '\\', '/'
$bridgeFwd = $bridge -replace '\\', '/'
$utf8 = New-Object System.Text.UTF8Encoding($false)

Step '4/6 Claude Desktop'
$candidates = @(Join-Path $env:APPDATA 'Claude\claude_desktop_config.json')
Get-ChildItem -Path (Join-Path $env:LOCALAPPDATA 'Packages') -Directory -Filter 'Claude_*' -ErrorAction SilentlyContinue |
    ForEach-Object { $candidates += (Join-Path $_.FullName 'LocalCache\Roaming\Claude\claude_desktop_config.json') }
$targets = @($candidates | Where-Object { Test-Path $_ })
if ($targets.Count -eq 0) { $targets = @($candidates[0]) }
foreach ($cfgPath in $targets) {
    $dir = Split-Path $cfgPath
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    $raw = ''
    if (Test-Path $cfgPath) { Copy-Item $cfgPath "$cfgPath.bak-$stamp"; $raw = [IO.File]::ReadAllText($cfgPath) }
    if ([string]::IsNullOrWhiteSpace($raw)) { $cfg = [pscustomobject]@{} } else { $cfg = $raw | ConvertFrom-Json }
    if (-not ($cfg.PSObject.Properties.Name -contains 'mcpServers')) {
        $cfg | Add-Member -NotePropertyName 'mcpServers' -NotePropertyValue ([pscustomobject]@{})
    }
    $entry = [pscustomobject]@{ command = $nodeFwd; args = @($bridgeFwd) }
    $cfg.mcpServers | Add-Member -NotePropertyName 'cau-regulations' -NotePropertyValue $entry -Force
    [IO.File]::WriteAllText($cfgPath, ($cfg | ConvertTo-Json -Depth 32), $utf8)
    Ok "Registered: $cfgPath"
}

$ErrorActionPreference = 'Continue'

Step '5/6 Claude Code'
if (Get-Command claude -ErrorAction SilentlyContinue) {
    cmd /c "claude mcp remove --scope user cau-regulations >nul 2>&1"
    cmd /c "claude mcp add --scope user cau-regulations -- `"$nodeFwd`" `"$bridgeFwd`""
    if ($LASTEXITCODE -eq 0) { Ok 'Registered (user scope). Restart running Claude Code sessions.' } else { Warn 'Registration failed; see message above.' }
} else { Ok 'Claude Code not installed - skipped' }

Step '6/6 Codex'
$toml = Join-Path $env:USERPROFILE '.codex\config.toml'
if (Test-Path $toml) {
    $text = [IO.File]::ReadAllText($toml)
    if ($text -match '(?m)^\[mcp_servers\.cau-regulations\]') {
        Warn "[mcp_servers.cau-regulations] already exists in $toml - left unchanged"
    } else {
        Copy-Item $toml "$toml.bak-$stamp"
        $block = "`r`n[mcp_servers.cau-regulations]`r`ncommand = `"$nodeFwd`"`r`nargs = [`"$bridgeFwd`"]`r`n"
        [IO.File]::AppendAllText($toml, $block, $utf8)
        Ok "Registered: $toml (restart Codex)"
    }
} else { Ok 'Codex config not found - skipped' }

Write-Host "`nDone. Quit Claude Desktop completely (tray icon > Quit) and reopen it." -ForegroundColor Yellow
