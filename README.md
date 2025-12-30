# 🚀 ComfyUI x AMD (Windows)

A streamlined PowerShell script to set up [ComfyUI](https://github.com/comfyanonymous/ComfyUI) with ROCm support for AMD RDNA graphics cards on Windows. Uses [UV](https://docs.astral.sh/uv/) for blazing-fast package management.

## ✨ Features

- 🎮 **Full AMD GPU Support**: RDNA 3, RDNA 3.5, and RDNA 4
- ⚡ **Lightning Fast**: Uses UV for 10-100x faster package installation
- 🔄 **Automatic Setup**: One command to rule them all
- 💾 **Persistent Configuration**: Remembers your GPU settings
- 🎨 **Beautiful CLI**: Colorful interface with helpful emojis
- 🔧 **Zero Config**: Handles virtual environments, dependencies, and ROCm PyTorch automatically

## 🎯 Supported GPUs

| Generation | GPUs | Architecture |
|------------|------|--------------|
| 🔴 RDNA 3 | RX 7900 XTX, RX 7900 XT, RX 7800 XT, RX 7700 XT, RX 7600 | gfx1100 |
| 🟣 RDNA 3.5 | Ryzen AI (Strix Point/Halo), Radeon 890M, 8060S | gfx1151 |
| 🔵 RDNA 4 | RX 9070 XT, RX 9070 | gfx1200 |

## 📋 Prerequisites

- **Windows 10/11** (64-bit)
- **Git** ([Download](https://git-scm.com/downloads))
- **PowerShell 5.1+** (included in Windows)

## ⚡ Quick Install

Open PowerShell and run this one-liner:

```powershell
irm https://raw.githubusercontent.com/SystemVll/ComfyUI-AMD/main/ComfyUI-AMD.ps1 | iex
```

### Alternative: Manual Installation

1. **Download the script**:
   ```powershell
   git clone https://github.com/SystemVll/ComfyUI-AMD.git
   cd ComfyUI-AMD
   ```

2. **Run the setup**:
   ```powershell
   .\ComfyUI-AMD.ps1
   ```

## 🎬 What It Does

1. ✅ Installs UV (if not present)
2. ✅ Clones ComfyUI repository
3. ✅ Creates Python 3.12 virtual environment
4. ✅ Installs ROCm PyTorch for your specific GPU
5. ✅ Installs all ComfyUI dependencies
6. ✅ Configures GPU settings (HIP_VISIBLE_DEVICES)
7. ✅ Launches ComfyUI web interface

## 🔧 Configuration

### GPU Selection

On first run, you'll be prompted to select your GPU generation:
- `1` - RDNA 3 (RX 7000 series)
- `2` - RDNA 3.5 (Ryzen AI)
- `3` - RDNA 4 (RX 9000 series)

Your choice is saved and reused on subsequent runs.

### Multi-GPU Systems

If you have multiple GPUs, the script will ask you to configure `HIP_VISIBLE_DEVICES`:
- `0` - First GPU
- `1` - Second GPU
- `0,1` - Use both GPUs

## 📁 Directory Structure

```
your-folder/
├── setup.ps1                 # This setup script
├── .gpu_config.json         # Saved GPU configuration
└── ComfyUI/                 # ComfyUI installation
    ├── .venv/               # Virtual environment
    ├── models/              # Place your models here
    ├── custom_nodes/        # Custom nodes
    └── output/              # Generated images
```

## 🎨 Usage

### First Run
```powershell
.\setup.ps1
```
Select your GPU, configure settings, and ComfyUI will launch automatically.

### Subsequent Runs
```powershell
.\setup.ps1
```
Just hit Enter through the prompts - your settings are remembered!

### Access ComfyUI
Once launched, open your browser to:
```
http://127.0.0.1:8188
```

## 🔄 Updating

To update ComfyUI to the latest version:

```powershell
cd ComfyUI
git pull
cd ..
.\setup.ps1
```

The script will handle any new dependencies automatically.

## 📦 What's UV?

[UV](https://github.com/astral-sh/uv) is a modern, extremely fast Python package manager written in Rust. Benefits:

- ⚡ **10-100x faster** than pip
- 🎯 Better dependency resolution
- 💾 Efficient caching
- 🔒 More reliable installations

## 🐛 Troubleshooting

### "UV not found" after installation
- Close and reopen your PowerShell terminal
- Run the script again

### "Execution policy" error
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### GPU not detected
- Ensure your AMD GPU drivers are up to date
- Check that ROCm is supported on your GPU model
- Try setting `HIP_VISIBLE_DEVICES=0` manually

### ComfyUI won't start
- Check that no other instance is running on port 8188
- Look for error messages in the console
- Try deleting `.venv` folder and running setup again

## 🔗 Useful Links

- [ComfyUI Documentation](https://github.com/comfyanonymous/ComfyUI)
- [ROCm Documentation](https://rocm.docs.amd.com/)
- [UV Documentation](https://docs.astral.sh/uv/)
- [Model Downloads](https://huggingface.co/models)

## 📝 Notes

- First installation may take 5-10 minutes depending on your internet speed
- ROCm PyTorch builds are large (~2-3GB)
- Models are not included - download them separately to `ComfyUI/models/`

## 🤝 Contributing

Found a bug? Have a suggestion? Open an issue or submit a PR!

## 📄 License

This setup script is provided as-is. ComfyUI has its own license - please refer to the [ComfyUI repository](https://github.com/comfyanonymous/ComfyUI) for details.

## ⭐ Credits

- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - The amazing UI for Stable Diffusion
- [UV](https://github.com/astral-sh/uv) - Modern Python package management
- [AMD ROCm](https://www.amd.com/en/products/software/rocm.html) - GPU compute platform

---

Made with ❤️ for the AMD + AI community
