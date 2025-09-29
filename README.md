# sysBOFH Nix Shell

Modular Nix development environments with specialized profiles for different use cases.

## Available Profiles

### `nixvim` - Lightweight Development

Minimal environment with NixVim and essential dev tools.

- NeoVim (NixVim distribution by wverac)
- File navigation tools (ripgrep, fd, fzf)
- Modern CLI utilities (bat, eza, zoxide)
- Aliases: `vim`, `vi`, `v` → `nvim`

```bash
nix develop .#nixvim
```

### `devops` - DevOps Toolkit

Complete DevOps environment with infrastructure tools.

- Infrastructure as Code (Terraform, Ansible, Packer)
- Container tools (Docker Compose, Kubernetes, Helm)
- Cloud tools (AWS CLI, Vault, Consul, Nomad)
- Python development environment
- Git and version control tools

```bash
nix develop .#devops
```

### `bofh` - System Administration & Troubleshooting

Comprehensive toolkit for system administration, troubleshooting, and forensics.

- Network analysis (nmap, tcpdump, wireshark-cli, mtr)
- System monitoring (htop, btop, iotop, strace)
- Filesystem tools (smartmontools, testdisk, photorec)
- Security & forensics (sleuthkit, volatility3, binwalk)
- Hardware diagnostics (lshw, dmidecode, stress-ng)
- GPU monitoring tools (nvtop, gpustat)

```bash
nix develop .#bofh
```

### `all` - Everything

Combined environment with all profiles loaded.

```bash
nix develop .#all
```

### `default` - Legacy Default

Original environment for backward compatibility.

```bash
nix develop
# or
nix develop .#default
```

## Usage

1. **Enter a specific profile:**

   ```bash
   nix develop .#<profile-name>
   ```

2. **Quick one-off commands:**

   ```bash
   nix develop .#bofh -c htop
   nix develop .#devops -c terraform plan
   ```

3. **Profile activation examples:**

   ```bash
   # Light development work
   nix develop .#nixvim

   # DevOps tasks
   nix develop .#devops

   # System troubleshooting
   nix develop .#bofh

   # Everything at once
   nix develop .#all
   ```

4. **Remote usage:**
   ```bash
   nix develop github:wverac/nix-shell#devops
   ```

## Requirements

- Nix with flakes enabled
- Linux x86_64 or macOS (aarch64-darwin, x86_64-darwin) systems
