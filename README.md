# RomM <-> SMB <-> OPL

A Docker container for exposing PS2 games managed in RomM to OPL via SMB.

## Security Warning

**This server is intentionally configured with INSECURE settings** to maintain compatibility with OPL:

- SMB1 (NT1) protocol support (known security vulnerabilities)
- Guest access enabled
- No encryption
- Wide symlinks enabled

**DO NOT expose this server to untrusted networks or the internet.** Use only on isolated local networks.

## Requirements

- Docker
- Docker Compose
- A RomM instance with PS2 games
- This container and the RomM instance running on the same machine

## Quick Start

### 1. Create Hard Links to RomM Game Files

On your host system, create hard links from your RomM PS2 games directory:

```bash
cp -al /{ROMM_ROOT}/ROMS/ps2/roms/* /{WHERE_YOU_WANT}/PS2SMB/DVD/
```

> **Note:** The source directory is intentionally one level above the `DVD` folder. This allows OPL to create the necessary folders alongside `DVD`.

### 2. Configure Docker Compose

Edit `docker-compose.yml` and update the volume source path:

```yaml
source: /{WHERE_YOU_WANT}/PS2SMB
```

### 3. Start the Container

Build and start the container:

```bash
docker-compose up -d
```

### 4. SMB Share Details

The SMB share will be available at:

- **Share name:** `PS2SMB`
- **Network path:** `\\<host-ip>\PS2SMB`
- **User:** `guest`
- **Password:** (none)
- **Port:** `445`

### 5. Configure OPL Network Settings

On OPL, configure the following settings under **Network Settings**:

#### PS2 Settings
- **IP Address Type:** Static
- **IP Address:** A static IP configured on your DHCP server
- **Mask:** Your subnet mask
- **Gateway:** Your router's local IP address
- **DNS Server:** Typically the same as your router's local IP

#### SMB Server Settings
- **Address Type:** IP
- **Address:** Host IP of the machine running this container
- **Port:** `445`
- **Share:** `PS2SMB`
- **User:** `guest`
- **Password:** (leave blank)