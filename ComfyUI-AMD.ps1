Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  🚀 ComfyUI Setup for AMD RDNA GPUs with UV (Windows)    ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "🔍 Checking for UV installation..." -ForegroundColor Yellow
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "❌ UV not found. Installing UV 0.9.5..." -ForegroundColor Red
    Write-Host "📦 Downloading and installing UV..." -ForegroundColor Cyan
    try {
        powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/0.9.5/install.ps1 | iex"
        Write-Host "`n✅ UV installed successfully!" -ForegroundColor Green
        Write-Host "⚠️  Please restart your terminal and run this script again." -ForegroundColor Yellow
        Write-Host "`nPress any key to exit..." -ForegroundColor Gray
        pause
        exit 0
    } catch {
        Write-Host "`n❌ Failed to install UV automatically." -ForegroundColor Red
        Write-Host "📖 Please install it manually from: https://docs.astral.sh/uv/getting-started/installation/" -ForegroundColor Yellow
        pause
        exit 1
    }
}

$uvVersion = uv --version 2>$null
if ($uvVersion) {
    Write-Host "✅ UV is ready: $uvVersion" -ForegroundColor Green
} else {
    Write-Host "❌ UV installation verification failed. Please restart your terminal." -ForegroundColor Red
    pause
    exit 1
}

$scriptPath = $PSScriptRoot
if (-not $scriptPath) { $scriptPath = (Get-Location).Path }
Set-Location $scriptPath
Write-Host "📁 Working directory: $scriptPath`n" -ForegroundColor Cyan

if (-not (Test-Path "$scriptPath\ComfyUI")) {
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║  🎮 Select Your AMD GPU Generation    ║" -ForegroundColor Magenta
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host "1️⃣  RDNA 3   (RX 7000 series)" -ForegroundColor White
    Write-Host "2️⃣  RDNA 3.5 (Ryzen AI / Strix Halo / 365)" -ForegroundColor White
    Write-Host "3️⃣  RDNA 4   (RX 9000 series)" -ForegroundColor White

    $gpuChoice = Read-Host "`n👉 Enter 1, 2, or 3"

    switch ($gpuChoice) {
        '1' { $torchIndexUrl="https://rocm.nightlies.amd.com/v2/gfx110X-dgpu/"; $gfxVersion="11.0.0"; $gpuName="RDNA 3 (RX 7000 series)"; $emoji="🔴" }
        '2' { $torchIndexUrl="https://rocm.nightlies.amd.com/v2/gfx1151/"; $gfxVersion="11.5.1"; $gpuName="RDNA 3.5 (Strix Halo / Ryzen AI)"; $emoji="🟣" }
        '3' { $torchIndexUrl="https://rocm.nightlies.amd.com/v2/gfx120X-all/"; $gfxVersion="12.0.0"; $gpuName="RDNA 4 (RX 9000 series)"; $emoji="🔵" }
        default { Write-Host "`n❌ Invalid choice. Exiting..." -ForegroundColor Red; pause; exit 1 }
    }

    Write-Host "`n$emoji Selected GPU: $gpuName" -ForegroundColor Green
    Write-Host "🔗 ROCm PyTorch index: $torchIndexUrl`n" -ForegroundColor Gray
    
    # Save GPU choice for future runs
    @{
        torchIndexUrl = $torchIndexUrl
        gfxVersion = $gfxVersion
        gpuName = $gpuName
        emoji = $emoji
    } | ConvertTo-Json | Out-File "$scriptPath\.gpu_config.json"
} else {
    # Load saved GPU configuration
    if (Test-Path "$scriptPath\.gpu_config.json") {
        $gpuConfig = Get-Content "$scriptPath\.gpu_config.json" | ConvertFrom-Json
        $torchIndexUrl = $gpuConfig.torchIndexUrl
        $gfxVersion = $gpuConfig.gfxVersion
        $gpuName = $gpuConfig.gpuName
        $emoji = $gpuConfig.emoji
        if (-not $emoji) { $emoji = "🎮" }
        Write-Host "$emoji Loaded GPU configuration: $gpuName`n" -ForegroundColor Green
    } else {
        Write-Host "⚠️  GPU configuration not found. Using default RDNA 3 settings.`n" -ForegroundColor Yellow
        $torchIndexUrl = "https://rocm.nightlies.amd.com/v2/gfx110X-dgpu/"
        $gfxVersion = "11.0.0"
        $gpuName = "RDNA 3 (RX 7000 series)"
        $emoji = "🔴"
    }
}

if (-not (Test-Path "$scriptPath\ComfyUI")) {
    Write-Host "📥 Cloning ComfyUI repository..." -ForegroundColor Cyan
    git clone https://github.com/comfyanonymous/ComfyUI.git
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ ComfyUI repository cloned successfully!`n" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to clone ComfyUI repository." -ForegroundColor Red
        pause
        exit 1
    }
} else {
    Write-Host "✅ ComfyUI directory found.`n" -ForegroundColor Green
}
Set-Location "$scriptPath\ComfyUI"

Write-Host "🐍 Setting up Python environment with UV..." -ForegroundColor Cyan
if (-not (Test-Path "$scriptPath\ComfyUI\.venv")) {
    Write-Host "📦 Creating virtual environment with Python 3.12..." -ForegroundColor Yellow
    uv venv --python 3.12
    Write-Host "✅ Virtual environment created!`n" -ForegroundColor Green
} else {
    Write-Host "✅ Virtual environment already exists.`n" -ForegroundColor Green
}

Write-Host "🔥 Installing/updating ROCm PyTorch..." -ForegroundColor Cyan
Write-Host "⏳ This may take a few minutes..." -ForegroundColor Gray
uv pip install --pre torch torchvision torchaudio --index-url $torchIndexUrl
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ PyTorch installation complete!`n" -ForegroundColor Green
} else {
    Write-Host "⚠️  PyTorch installation finished with warnings.`n" -ForegroundColor Yellow
}

Write-Host "📚 Installing ComfyUI dependencies..." -ForegroundColor Cyan
if (Test-Path "requirements.txt") {
    # Filter out torch-related packages and install with UV
    $requirements = Get-Content requirements.txt | Where-Object {$_ -notmatch "torch" -and $_ -notmatch "^#" -and $_.Trim() -ne ""}
    if ($requirements) {
        $requirements | Out-File -FilePath "requirements_filtered.txt" -Encoding UTF8
        uv pip install -r requirements_filtered.txt
        Remove-Item "requirements_filtered.txt" -ErrorAction SilentlyContinue
        Write-Host "✅ Dependencies installed!`n" -ForegroundColor Green
    }
} else {
    Write-Host "⚠️  requirements.txt not found. Skipping dependency installation.`n" -ForegroundColor Yellow
}

Write-Host "🔧 Installing torchsde..." -ForegroundColor Cyan
uv pip install torchsde
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ torchsde installed!`n" -ForegroundColor Green
}

Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "║  ⚙️  GPU Device Configuration          ║" -ForegroundColor Magenta
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Magenta
$currentHip = $env:HIP_VISIBLE_DEVICES
if (-not $currentHip) { $currentHip = "(not set)" }
Write-Host "Current HIP_VISIBLE_DEVICES: $currentHip" -ForegroundColor Yellow

$changeHip = Read-Host "`n🔧 Do you want to change HIP_VISIBLE_DEVICES? (y/n)"
if ($changeHip -eq "y" -or $changeHip -eq "Y") {
    $newHip = Read-Host "👉 Enter the new HIP_VISIBLE_DEVICES value (e.g., 0 for first GPU)"
    $env:HIP_VISIBLE_DEVICES = $newHip
    Write-Host "✅ HIP_VISIBLE_DEVICES updated to: $newHip" -ForegroundColor Green
} else {
    Write-Host "✅ Using existing HIP_VISIBLE_DEVICES: $currentHip" -ForegroundColor Green
}

Write-Host "`n💡 Make sure this matches the GPU you want to use!`n" -ForegroundColor Cyan

Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  🚀 Launching ComfyUI...              ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════╝`n" -ForegroundColor Green
$env:HSA_OVERRIDE_GFX_VERSION = $gfxVersion

Write-Host "🎮 GPU: $gpuName" -ForegroundColor Cyan
Write-Host "🔧 GFX Version: $gfxVersion" -ForegroundColor Cyan
Write-Host "🌐 Starting web interface...`n" -ForegroundColor Cyan

uv run python main.py

Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "║  👋 ComfyUI has exited.                                   ║" -ForegroundColor Yellow
Write-Host "║  🔄 You can rerun this script anytime to start again.    ║" -ForegroundColor Yellow
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Yellow
pause
