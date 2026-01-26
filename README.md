<h1 style="display: flex; align-items: center; gap: 10px;">
  <img
    src="https://github.com/user-attachments/assets/4a73e24c-1307-4dbc-b406-f8f84f94954f"
    width="32"
    alt="logo"
  />
  ComfyUI x AMD
</h1>

A PowerShell script that sets up [ComfyUI](https://github.com/comfyanonymous/ComfyUI) with ROCm support for AMD RDNA GPUs on Windows. It uses [uv](https://docs.astral.sh/uv/) for fast and reliable Python package management.

## Features

* Native AMD GPU support (RDNA 3, 3.5, and 4)
* Fast installs using uv instead of pip
* One-command setup
* GPU configuration is saved between runs
* Handles venvs, dependencies, and ROCm PyTorch automatically

## Supported GPUs

| Generation | GPUs                                                     | Architecture |
| ---------- | -------------------------------------------------------- | ------------ |
| RDNA 3     | RX 7900 XTX, RX 7900 XT, RX 7800 XT, RX 7700 XT, RX 7600 | gfx1100      |
| RDNA 3.5   | Ryzen AI (Strix Point / Halo), Radeon 890M, 8060S        | gfx1151      |
| RDNA 4     | RX 9070 XT, RX 9070                                      | gfx1200      |

## Prerequisites

* Windows 10 or 11 (64-bit)
* Git ([download](https://git-scm.com/downloads))
* PowerShell 5.1 or newer (already included with Windows)

## Quick Install

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/SystemVll/ComfyUI-AMD/main/ComfyUI-AMD.ps1 | iex
```

## Manual Installation

1. Clone the repository:

   ```powershell
   git clone https://github.com/SystemVll/ComfyUI-AMD.git
   cd ComfyUI-AMD
   ```

2. Run the script:

   ```powershell
   .\ComfyUI-AMD.ps1
   ```

## What the Script Does

* Installs uv if it isn’t already installed
* Clones the ComfyUI repository
* Creates a Python 3.12 virtual environment
* Installs the correct ROCm PyTorch build for your GPU
* Installs ComfyUI dependencies
* Configures HIP_VISIBLE_DEVICES
* Launches the ComfyUI web UI

## Configuration

### GPU Selection

On the first run, you’ll be asked which GPU generation you’re using:

* `1` – RDNA 3 (RX 7000 series)
* `2` – RDNA 3.5 (Ryzen AI)
* `3` – RDNA 4 (RX 9000 series)

Your choice is saved and reused on future runs.

### Multi-GPU Systems

If more than one GPU is detected, you’ll be prompted to set `HIP_VISIBLE_DEVICES`:

* `0` – first GPU
* `1` – second GPU
* `0,1` – use both

## Directory Layout

```
your-folder/
├── setup.ps1
├── .gpu_config.json
└── ComfyUI/
    ├── .venv/
    ├── models/
    ├── custom_nodes/
    └── output/
```

## Usage

### First Run

```powershell
.\setup.ps1
```

Follow the prompts and ComfyUI will start automatically.

### Later Runs

```powershell
.\setup.ps1
```

You can usually just press Enter — your settings are reused.

### Open ComfyUI

Once running, open:

```
http://127.0.0.1:8188
```

## Updating ComfyUI

```powershell
cd ComfyUI
git pull
cd ..
.\setup.ps1
```

Any new dependencies will be handled automatically.

## About uv

[uv](https://github.com/astral-sh/uv) is a modern Python package manager written in Rust. Compared to pip, it’s significantly faster and tends to be more reliable, especially for large dependency trees.

## Troubleshooting

### uv not found

* Restart PowerShell and try again

### Execution policy error

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### GPU not detected

* Update your AMD drivers
* Verify your GPU supports ROCm
* Try setting `HIP_VISIBLE_DEVICES=0` manually

### ComfyUI won’t start

* Make sure port 8188 isn’t already in use
* Check the console output for errors
* Delete the `.venv` folder and rerun the script

## Links

* ComfyUI: [https://github.com/comfyanonymous/ComfyUI](https://github.com/comfyanonymous/ComfyUI)
* ROCm: [https://rocm.docs.amd.com/](https://rocm.docs.amd.com/)
* uv: [https://docs.astral.sh/uv/](https://docs.astral.sh/uv/)
* Models: [https://huggingface.co/models](https://huggingface.co/models)

## Notes

* First install can take a while, especially on slower connections
* ROCm PyTorch wheels are large (2–3 GB)
* Models are not included — place them in `ComfyUI/models/`

## Contributing

Issues and pull requests are welcome.

## License

This script is provided as-is. ComfyUI is licensed separately; see the ComfyUI repository for details.
