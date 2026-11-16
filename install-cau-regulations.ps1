# CAU regulations MCP (8445, no token) - one-shot installer for Windows
# Installs bridge files to %USERPROFILE%\cau-regulations-client, runs --check,
# registers in Claude Desktop, Claude Code and Codex (if present). Backs up configs.
# Run on campus network or school VPN:
#   powershell -ExecutionPolicy Bypass -File install-cau-regulations.ps1
# Package: 2026-11-16 package, bridge sha256 8224d8431afb..., cert expires 2029-02-13 (CA:FALSE), portable Node.js v26.13.1 pinned by SHA-256
# Also trusts the server certificate for this Windows user so Chrome/Edge open
# https://165.194.61.71:8445/ without a warning (Windows asks once; click Yes).

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
H4sIAAAAAAAC/2WUS5OqOhSF5/yKO7dOiTwUhyGEd4AA8poBAi0KiIgBf/21u+vcyc0sa+1alZ391f7z53NkpBnOPxD5oaEaEITo
W/zDYMNQmjeEoJsbQA0ZNMYp1Rz8Euq1GGEvSv3hJQljb/hqt0hUIalpDZnx9SodQJDNyATQQEExlokGdicEKHVwmO7sFokOFDgc
CDwO0Ywh/fFhQ2+EVSNDN28ZH01Mmvj3ghPfBtopJwiGlFOfpR69De02n7VoLTp1skJQqZRdnRYtn3CKW7DD71v+rTFuCFYc4v9E
jJpFbcFJbpxIBhgrIeKcQFjckMyfgNl5o8VuwfTrD5gxT44cBfKaxeddoalsHh/ncpUdsgONpTlfRSLvPvd70fu3shO/CnilTYMu
GLAaDEaNCYyCVwiSATkBIBiyQsF3gQWGz4cShRC0qbz3TUHFereq/RgXx/TiCKuuc0dOawMGYZ3TI7+pwStDWe64i6Ys+TCJ6Qrl
p8b5ZZENZ2iZm/r1cO1nZQncmCQPMm2fj6UADK+sV14/B/blRXrFcXt/I9TX7FK6ewTAwN2u8HGIm/5hakecd51R9IFlhRyXWmIh
oYKRQk8E5j6/+NDhwvH5CsnYHLW4wQII6MmRlqoJ+eUapVW5y47jIxvmoLb9u3+ErXA3mDJr9Osr5rfZy4VaPxCHvoVx9io/vvKH
t9B1MLp2hy22+u7lCahpzu6EQ5slr40bcToT6DmNprinQtQq0zBXLuHNwJft885PK2WP72Bd7ara0b1tpwN+Rr0DGiwDoLVZKLcM
Bj+EnRFF8pYSiAGgSpMqkc96gOjb71GA5tORjH/qTEIwBoMG4aR9JqcyMv1YQPoNIcTAINdlK4HeqaQ6+QlyZTlFqt1Z2K5YMp/G
rwFcjH1CuHKgjCUc5L9Q/GUC0l8mAIEP/v0hotRv8v2UvKVOKjRd8h4x2yWg/lpKjynFMzQKlY2Bearm2R1Aqbp7zzr0t+YxiHQz
1zC54Ie4IN30yjvnunn7CDojG01/dd4MzLLpjqcXwf3uPoyS/aw3Ydq8Wj0lbJ3a+7mAde0nj9zdhDy3OzfP0H2W2VPlZ0dhj0w9
IpvK8D6pUvjur+4jud57aV9220HU8q1RIad6Jrq/j5qG843DU3K6KbFKZUw6NZwwo7/565JLuVeLF6cC/JRwrasrkrmlHnIPX5Ev
R1QwWu4oGLWlepulKv3DgNjtdVKjumPUYyyuBykp9MhMDhek84gTpTbumn3v3dbTlzR/XuMAlixEH7AwHE475meZIUf5/4L7F387
Tqb9BAAA
'@
}

Step '1/7 Node.js'
function Find-Node {
    $c = Get-Command node -ErrorAction SilentlyContinue
    if ($c) { return $c.Source }
    foreach ($p in @("$env:ProgramFiles\nodejs\node.exe", "$env:LOCALAPPDATA\cau-regulations-node\node.exe")) { if (Test-Path $p) { return $p } }
    return $null
}
function Get-NodeMajor($p) { try { return [int]((& $p -v).Trim().TrimStart('v').Split('.')[0]) } catch { return 0 } }
$node = Find-Node
if (-not $node -or (Get-NodeMajor $node) -lt 18) {
    Warn 'Node.js 18+ not found. Installing Node.js LTS automatically...'
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements
        $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
        $node = Find-Node
    }
    if (-not $node -or (Get-NodeMajor $node) -lt 18) {
        Warn 'winget unavailable or failed. Installing portable Node.js for this user (no admin rights needed)...'
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $ProgressPreference = 'SilentlyContinue'
        # Pinned version and SHA-256 (nodejs.org SHASUMS256.txt, cross-checked with a mirror
        # and a test download on 2026-11-16). A download that does not match is not used.
        $lts = 'v26.13.1'
        $nodeSha256 = @{
            'x64'   = 'e2edda75bfb089654705cf65a13b58933bfd5f57148e8ebda916f58a2474f1f7'
            'arm64' = '181ebe431b90787113a9e4fc80d38ce86d37888a353a0386de44d2872e48cb97'
        }
        $arch = if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } else { 'x64' }
        $zipName = "node-$lts-win-$arch"
        $zipPath = Join-Path $env:TEMP "$zipName.zip"
        $unpack = Join-Path $env:TEMP "cau-node-$stamp"
        $portable = Join-Path $env:LOCALAPPDATA 'cau-regulations-node'
        Invoke-WebRequest -Uri "https://nodejs.org/dist/$lts/$zipName.zip" -OutFile $zipPath -UseBasicParsing
        $got = (Get-FileHash -Path $zipPath -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($got -ne $nodeSha256[$arch]) {
            Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
            throw "Node.js download failed its SHA-256 check (got $got). Nothing was installed. Install LTS from https://nodejs.org and run again."
        }
        Ok "Node.js $lts download verified (SHA-256)"
        Expand-Archive -Path $zipPath -DestinationPath $unpack
        if (Test-Path $portable) { Remove-Item $portable -Recurse -Force }
        Move-Item -Path (Join-Path $unpack $zipName) -Destination $portable
        Remove-Item $zipPath, $unpack -Recurse -Force -ErrorAction SilentlyContinue
        $node = Join-Path $portable 'node.exe'
    }
    if (-not $node -or -not (Test-Path $node) -or (Get-NodeMajor $node) -lt 18) {
        throw 'Automatic Node.js install failed. Install LTS from https://nodejs.org and run again.'
    }
}
$ver = (& $node -v).Trim()
Ok "$ver ($node)"

Step '2/7 Install files'
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

Step '3/7 Connection test (--check)'
$bridge = Join-Path $dest 'cau-regulations-bridge.js'
& $node $bridge --check
if ($LASTEXITCODE -ne 0) { throw 'Connection test failed. Check campus network/VPN (see README troubleshooting table).' }

Step '4/7 Browser certificate (Chrome/Edge)'
# Trust only this server's certificate (CA:FALSE: it cannot vouch for other sites).
# Windows shows a security prompt once; answer Yes. Saying No only keeps the browser warning.
try {
    $certPath = Join-Path $dest 'server-cert.pem'
    $newCert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2(,[IO.File]::ReadAllBytes($certPath))
    $store = New-Object System.Security.Cryptography.X509Certificates.X509Store('Root', 'CurrentUser')
    $store.Open('ReadWrite')
    $old = @($store.Certificates | Where-Object { $_.Subject -like 'CN=165.194.61.71*' -and $_.Thumbprint -ne $newCert.Thumbprint })
    foreach ($c in $old) { $store.Remove($c); Ok "Removed old server certificate $($c.Thumbprint.Substring(0,8))..." }
    if (@($store.Certificates | Where-Object { $_.Thumbprint -eq $newCert.Thumbprint }).Count -gt 0) {
        Ok 'Already trusted'
    } else {
        $store.Add($newCert)
        Ok 'Trusted for this user. Restart Chrome/Edge, then open https://165.194.61.71:8445/'
    }
    $store.Close()
} catch {
    Warn 'Certificate not trusted (prompt declined or blocked). MCP still works; the browser keeps showing a warning.'
    Warn 'To open the page anyway: Advanced > Continue to 165.194.61.71 (unsafe).'
}

$nodeFwd   = $node -replace '\\', '/'
$bridgeFwd = $bridge -replace '\\', '/'
$utf8 = New-Object System.Text.UTF8Encoding($false)

Step '5/7 Claude Desktop'
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

Step '6/7 Claude Code'
if (Get-Command claude -ErrorAction SilentlyContinue) {
    cmd /c "claude mcp remove --scope user cau-regulations >nul 2>&1"
    cmd /c "claude mcp add --scope user cau-regulations -- `"$nodeFwd`" `"$bridgeFwd`""
    if ($LASTEXITCODE -eq 0) { Ok 'Registered (user scope). Restart running Claude Code sessions.' } else { Warn 'Registration failed; see message above.' }
} else { Ok 'Claude Code not installed - skipped' }

Step '7/7 Codex'
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
