# Athena LED

English | [简体中文](README_zh.md)

A fork of [athena-led](https://github.com/haipengno1/athena-led) for controlling LED matrix displays on OpenWrt devices.

## Features

- Display current time and date
- Show system temperature
- Custom text display
- Adjustable brightness levels
- Multiple display modes
- HTTP status monitoring

## Building (ArchLinux)

1. Install Rust and Cargo ([ArchWiki](https://wiki.archlinux.org/title/Rust))
   ```bash
   sudo pacman -S rustup
   rustup toolchain install stable
   rustup default stable

   # verify rust and cargo
   rustc --version
   cargo --version
   ```

2. Set up cross-compilation environment for OpenWrt

   **Option 2.1: Using traditional linker:**

   ```bash
   # install toolchain for aarch64-linux-musl
   yay -S aarch64-linux-musl

   # set environment variables for cross-compilation
   mkdir -p ~/.cargo
   echo "[target.aarch64-unknown-linux-musl]" > ~/.cargo/config.toml
   echo 'linker = "aarch64-linux-musl-gcc"' >> ~/.cargo/config.toml

   # add rustup targets
   rustup target add aarch64-unknown-linux-musl
   rustup target add x86_64-unknown-linux-gnu
   ```

   **Option 2.2: Using zig for cross-compilation:**
   ```bash
   # install zig and toolchain
   yay -S zig aarch64-linux-musl
   cargo install cargo-zigbuild

   # add rustup targets
   rustup target add aarch64-unknown-linux-musl
   rustup target add x86_64-unknown-linux-gnu
   ```

3. Build the project:

   **Using cargo build:**
   ```bash
   # build for aarch64-unknown-linux-musl
   cargo build --release --target aarch64-unknown-linux-musl
   # build for x86_64-unknown-linux-gnu
   cargo build --release --target x86_64-unknown-linux-gnu
   ```

   **Using cargo zigbuild:**
   ```bash
   # build for aarch64-unknown-linux-musl
   cargo zigbuild --release --target aarch64-unknown-linux-musl
   # build for x86_64-unknown-linux-gnu
   cargo zigbuild --release --target x86_64-unknown-linux-gnu
   ```

   **Using Makefile:**
   ```bash
   # build all targets
   make all
   # build for aarch64-unknown-linux-musl only
   make build-arm
   # build for x86_64-unknown-linux-gnu only
   make build-x64
   # clean build artifacts
   make clean
   # check build targets
   make check
   ```

4. Compiled binaries will be in the `dist/` directory

## Installation

Copy the compiled binary `athena-led` to your OpenWrt device's `/usr/sbin/` directory.

## Usage

```bash
athena-led [OPTIONS]

Options:
    --status <STATUS>          Set status string [default: ""]
    --seconds <SECONDS>        Update interval in seconds [default: 5]
    --light-level <LEVEL>      Set brightness level (0-7) [default: 5]
    --option <OPTION>          Display mode (e.g., "date", "timeBlink") [default: "date timeBlink"]
    --value <VALUE>           Custom display characters [default: "abcdefghijklmnopqrstuvwxyz0123456789+-*/=.:：℃"]
    --url <URL>               URL for status monitoring [default: "https://www.baidu.com/"]
    --temp-flag <FLAG>        Temperature sensor flag (0:nss-top, 1:nss, 2:wcss-phya0, 3:wcss-phya1, 4:cpu, 5:lpass, 6:ddrss) [default: "4"]
```

## FAQ

1. **Time Display Issues**  
   If the displayed time doesn't match your system timezone, please ensure the required timezone data packages are installed on your system:
   - For OpenWrt: Install `zoneinfo-core` and your region's package (e.g., `zoneinfo-asia`)
   - For other Linux distributions: Install `tzdata` package

## License

This project is licensed under the Apache License, Version 2.0 - see the [LICENSE](LICENSE) file for details.
