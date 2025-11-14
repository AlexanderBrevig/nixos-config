# NixOS Configuration with Home Manager & Hyprland

A complete NixOS configuration with Home Manager integration, featuring Hyprland as the window manager and a comprehensive development environment.

## 🚀 Features

- **Dual Host Support**: Separate configurations for laptop (`ablaptop`) and desktop workstation (`abstation`)
- **Hyprland**: Modern Wayland compositor with screen sharing capabilities
- **Home Manager**: Declarative user environment management
- **Development Ready**: Pre-configured tools for Rust, Go, Java, Flutter, C++, Python, OCaml
- **Modern Terminal Stack**: Fish shell, Starship prompt, WezTerm, Helix editor
- **LUKS Encryption**: Full disk encryption support
- **Automatic Updates**: System security updates with flake management
- **NVIDIA Support**: Proprietary drivers for workstation with container runtime

## 📁 Project Structure

```
nixos/
├── flake.nix              # Main flake configuration with inputs and outputs
├── hosts/                 # Host-specific configurations
│   ├── ablaptop.nix      # Laptop configuration (ThinkPad T14 Gen 6)
│   └── abstation.nix     # Desktop workstation configuration
├── modules/               # Reusable NixOS modules
│   ├── shared.nix        # Common system configuration
│   └── hyprland.nix      # Hyprland and Wayland setup
└── home/                  # Home Manager configurations
    └── home.nix          # User environment and applications
```

## 🛠 Prerequisites

1. **NixOS Installation Media**: Download from [nixos.org](https://nixos.org/download.html)
2. **Git**: For cloning this repository
3. **Internet Connection**: Required for downloading packages

## 📦 Installation Instructions

### Step 1: Boot NixOS Installation Media

1. Create a bootable USB drive with the NixOS installation ISO
2. Boot your system from the USB drive
3. Connect to the internet:
   ```bash
   # For WiFi
   sudo systemctl start wpa_supplicant
   wpa_cli
   > add_network
   > set_network 0 ssid "YourWiFiName"
   > set_network 0 psk "YourWiFiPassword"
   > enable_network 0
   > quit
   
   # For Ethernet (usually automatic)
   ping google.com
   ```

### Step 2: Partition Your Disk

**⚠️ Warning: This will erase your disk. Back up important data first!**

```bash
# Identify your disk (usually /dev/nvme0n1 or /dev/sda)
lsblk

# Replace /dev/nvme0n1 with your actual disk
export DISK=/dev/nvme0n1

# Create GPT partition table
parted $DISK -- mklabel gpt

# Create EFI boot partition (512MB)
parted $DISK -- mkpart ESP fat32 1MB 512MB
parted $DISK -- set 1 esp on

# Create LUKS partition (rest of disk)
parted $DISK -- mkpart primary 512MB 100%
```

### Step 3: Set Up LUKS Encryption

```bash
# Set up LUKS encryption on the main partition
cryptsetup luksFormat ${DISK}p2

# Open the encrypted partition
cryptsetup luksOpen ${DISK}p2 nixos-enc

# Format the encrypted partition
mkfs.ext4 -L nixos /dev/mapper/nixos-enc

# Format the boot partition
mkfs.fat -F 32 -n boot ${DISK}p1
```

### Step 4: Mount File Systems

```bash
# Mount the main partition
mount /dev/disk/by-label/nixos /mnt

# Create boot directory
mkdir -p /mnt/boot

# Mount boot partition
mount /dev/disk/by-label/boot /mnt/boot
```

### Step 5: Clone This Repository

```bash
# Clone the configuration
git clone https://github.com/yourusername/nixos-config.git /mnt/etc/nixos

# Or if you're setting this up locally:
cd /mnt/etc/nixos
git init
# Copy your configuration files here
```

### Step 6: Update Hardware Configuration

```bash
# Generate hardware configuration
nixos-generate-config --root /mnt

# Get UUIDs for updating the configuration
blkid

# Note down:
# - Boot partition UUID (fat32 partition)
# - LUKS partition UUID (the encrypted partition)
# - Root filesystem UUID (from /dev/mapper/nixos-enc)
```

### Step 7: Configure Host-Specific Settings

Edit the appropriate host configuration file:

**For Laptop (`hosts/ablaptop.nix`):**
```nix
# Update these sections with your actual UUIDs from blkid output:

boot.initrd.luks.devices."luks-root" = {
  device = "/dev/disk/by-uuid/YOUR-LUKS-UUID-HERE";  # LUKS partition UUID
  keyFile = null;
  allowDiscards = true;
  bypassWorkqueues = true;
};

fileSystems."/" = {
  device = "/dev/disk/by-uuid/ROOT-UUID-HERE";       # Root filesystem UUID
  fsType = "ext4";
};

fileSystems."/boot" = {
  device = "/dev/disk/by-uuid/BOOT-UUID-HERE";       # Boot partition UUID
  fsType = "vfat";
  options = [ "fmask=0077" "dmask=0077" ];
};
```

**For Desktop (`hosts/abstation.nix`):**
Update the same sections with your desktop's UUIDs.

### Step 8: Update Personal Information

Edit `home/home.nix` to set your personal information:

```nix
# Update git configuration
programs.git = {
  enable = true;
  userName = "Your Name";
  userEmail = "your-email@example.com";
  # ... rest of config
};
```

### Step 9: Install NixOS

```bash
# Install NixOS with your configuration
nixos-install --flake /mnt/etc/nixos#ablaptop  # or #abstation for desktop

# Set root password when prompted
# Set user password
nixos-enter --root /mnt
passwd ab
exit

# Reboot
reboot
```

## 🔧 Post-Installation Configuration

### First Boot

1. **Remove Installation Media**: Take out the USB drive
2. **Login**: Use username `ab` with the password you set
3. **Update Email**: Edit git configuration in `home/home.nix`
4. **Configure Monitors**: Update monitor configuration in Hyprland settings

### Monitor Configuration

Edit the monitor section in `home/home.nix`:

```nix
wayland.windowManager.hyprland.settings.monitor = [
  # Example for dual monitor setup:
  "DP-1,2560x1440@144,0x0,1"      # Primary monitor
  "DP-2,1920x1080@60,2560x0,1"    # Secondary monitor
  
  # Or for automatic detection:
  ",preferred,auto,1"
];
```

### SSH Configuration

The system comes with SSH server enabled by default with secure settings (key-based authentication only). Configure SSH access:

#### 1. Generate SSH Key Pair

```bash
# Generate a new ED25519 SSH key (recommended)
ssh-keygen -t ed25519 -C "ab@yourdomain.com" -f ~/.ssh/id_ed25519

# Or RSA if ED25519 is not supported
ssh-keygen -t rsa -b 4096 -C "ab@yourdomain.com" -f ~/.ssh/id_rsa

# Set proper permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

#### 2. Enable SSH Access (Optional)

If you want to enable SSH access TO this machine, add your public keys to the system configuration:

Edit `modules/shared.nix` and uncomment/modify:

```nix
services.openssh = {
  enable = true;
  # ... existing config ...
  users.ab.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... your-public-key-here"
    # Add more keys as needed
  ];
};
```

#### 3. Configure SSH Client

Edit `home/programs/ssh.nix` to add frequently used hosts:

```nix
matchBlocks = {
  "myserver" = {
    hostname = "server.example.com";
    user = "ab";
    port = 22;
    identityFile = "~/.ssh/id_ed25519";
  };
  
  "github" = {
    hostname = "github.com";
    user = "git";
    identityFile = "~/.ssh/id_ed25519";
  };
};
```

#### 4. Test SSH Configuration

```bash
# Test SSH connection to a server
ssh ab@server.example.com

# Test GitHub SSH (if configured)
ssh -T git@github.com

# Copy public key to remote server
ssh-copy-id -i ~/.ssh/id_ed25519.pub ab@server.example.com
```

#### 5. SSH Security Best Practices

Your SSH server is configured with security best practices:
- ✅ **Password authentication disabled** - Only SSH keys work
- ✅ **Root login disabled** - Must use your user account
- ✅ **X11 forwarding enabled** - For GUI applications over SSH
- ✅ **Connection multiplexing** - Faster subsequent connections

### Docker Configuration

Docker is pre-configured and ready to use:

```bash
# Test Docker installation
docker run hello-world

# Use helpful aliases
d ps              # docker ps
dc up -d          # docker-compose up -d
docker-clean      # Clean up unused resources
docker-enter web  # Enter 'web' container with bash/sh

# Docker management
docker-stop-all   # Stop all running containers
docker-logs-follow nginx  # Follow logs for 'nginx' container
```

### Rebuilding the System

After making changes to your configuration:

```bash
# Navigate to your configuration directory
cd /etc/nixos  # or wherever you put the config

# Rebuild and switch
sudo nixos-rebuild switch --flake .#ablaptop  # or #abstation
```

## 🎮 Usage Guide

### Key Bindings (Hyprland)

- `Super + Q`: Open terminal (WezTerm)
- `Super + R`: Application launcher (Rofi)
- `Super + E`: File manager (Nautilus)
- `Super + S`: Screenshot tool (Flameshot)
- `Super + C`: Close window
- `Super + 1-9`: Switch workspaces
- `Super + Shift + 1-9`: Move window to workspace
- `Super + Mouse`: Move/resize windows

### Development Workflow

```bash
# Navigate to projects
proj  # fish function to go to ~/projects

# Create new project directory
mkcd my-new-project

# Initialize with development environment
init-project rust  # Creates flake.nix template

# Enter project environment  
dev  # Automatically detects flake.nix, shell.nix, or .envrc

# Clone and enter repository
gcl https://github.com/user/repo
cd repo-name
dev  # Enter the project's development environment

# Quick commands (available globally or in project env)
j build      # just build
g st         # git status
hx .         # open helix editor

# Quick temporary environments
quick-env nodejs python3  # Temporary shell with specific tools
```

### Project Environment Management

This configuration uses a **hybrid approach** for development tools:

**🌍 Global Tools (Always Available):**
- Core tools: git, just, cmake
- Stable languages: Rust, Go, Python (system defaults)
- Language servers for editor integration

**📦 Project-Specific Tools (Per-Project Flakes):**
- Specific language versions (Java 17 vs 21, Node 18 vs 20)
- Project dependencies and build tools
- Database tools, cloud CLIs, etc.

**🔄 Workflow:**
1. `init-project <lang>` - Set up project environment template
2. Edit `flake.nix` to uncomment needed tools
3. `dev` - Enter project environment (or use direnv for automatic)
4. Work with project-specific toolchain

**💡 Benefits:**
- ✅ Fast startup (core tools always available)
- ✅ Version isolation (different projects, different versions)  
- ✅ Editor integration (LSPs work globally)
- ✅ Team consistency (share flake.nix with team)

### SSH & Remote Development

```bash
# Connect to remote servers (uses connection multiplexing)
ssh myserver  # if configured in ssh.nix

# Run commands remotely
ssh myserver "htop"

# Copy files (uses SSH for secure transfer)
scp file.txt myserver:~/
scp -r ./project/ myserver:~/projects/

# Mount remote filesystem locally (if sshfs is installed)
sshfs myserver:~/projects ~/remote-projects

# Forward ports for development
ssh -L 8080:localhost:3000 myserver  # Forward remote port 3000 to local 8080
```

### Docker Workflow

```bash
# Start development environment
dc up -d          # Start services in background

# View running containers
dps               # Short for docker ps

# Enter container for debugging
docker-enter web  # Enters 'web' container with bash/sh

# Follow logs
docker-logs-follow nginx

# Clean up when done
docker-clean      # Remove unused containers, images, volumes
```

### System Management

```bash
# Rebuild system
rebuild

# Update flake inputs
update

# Check system status
systemctl status

# Monitor system
btop
```

## 🔄 Maintenance

### Automatic Updates

The system is configured for automatic security updates. Updates run daily at 02:00 with a random delay.

### Manual Updates

```bash
# Update flake inputs
nix flake update

# Rebuild with new packages
sudo nixos-rebuild switch --flake .#hostname

# Clean old generations
sudo nix-collect-garbage -d

# Optimize nix store
sudo nix-store --optimize
```

### Backup Strategy

Consider backing up:
- `/etc/nixos/` - Your configuration
- `/home/ab/` - User data and settings
- List of installed packages: `nix-env -qa --installed`

## 🛠 Customization

### Adding New Packages

Add packages to `home/home.nix`:

```nix
home.packages = with pkgs; [
  # Existing packages...
  your-new-package
];
```

### Adding System Services

Add services to `modules/shared.nix` or host-specific files:

```nix
services.your-service = {
  enable = true;
  # configuration...
};
```

### Configuring Applications

Most application configurations go in `home/home.nix` using Home Manager modules:

```nix
programs.your-app = {
  enable = true;
  # configuration...
};
```

## 🐛 Troubleshooting

### Boot Issues

1. **LUKS Password Prompt**: Enter your encryption password at boot
2. **Boot Partition Not Found**: Check UUIDs in host configuration
3. **Kernel Panic**: Try booting with an older generation from GRUB

### Display Issues

1. **No Display on NVIDIA**: Check driver configuration in `hosts/abstation.nix`
2. **Wayland Issues**: Try setting `WLR_NO_HARDWARE_CURSORS=1`
3. **Multi-monitor Problems**: Update monitor configuration and rebuild

### Network Issues

```bash
# Check network status
nmcli device status

# Restart NetworkManager
sudo systemctl restart NetworkManager

# WiFi connection
nmcli device wifi connect "SSID" password "password"
```

### Application Issues

```bash
# Check if application is available
nix-env -qaP application-name

# Run application with debug info
application-name --verbose

# Check systemd services
systemctl --user status
```

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Documentation](https://hyprland.org/)
- [Nix Package Search](https://search.nixos.org/)
- [NixOS Discourse](https://discourse.nixos.org/)

## 🤝 Contributing

Feel free to submit issues and pull requests to improve this configuration!

## 📄 License

This configuration is provided as-is for educational and personal use. Modify as needed for your setup.

---

**Note**: Remember to update git remote URLs, email addresses, and any personal information before using this configuration. Always test configurations in a virtual machine before applying to production systems.