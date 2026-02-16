# Athena LED 控制器

[简体中文](README_zh.md) | [English](README.md)

[原项目](https://github.com/haipengno1/athena-led) 的分支，用于在 OpenWrt 设备上控制 LED 点阵显示屏。

## 功能特性

- 显示当前时间和日期
- 显示系统温度
- 自定义文本显示
- 可调节亮度级别
- 多种显示模式
- HTTP 状态监控

## 构建说明 (ArchLinux)

1. 安装 Rust 和 Cargo ([ArchWiki](https://wiki.archlinux.org/title/Rust))
   ```bash
   sudo pacman -S rustup
   rustup toolchain install stable
   rustup default stable

   # 验证 rust 和 cargo
   rustc --version
   cargo --version
   ```

2. 针对 OpenWrt 设置交叉编译环境

   **选项 2.1: 使用传统链接器：**

   ```bash
   # 安装 aarch64-linux-musl 工具链
   yay -S aarch64-linux-musl

   # 设置交叉编译环境变量
   mkdir -p ~/.cargo
   echo "[target.aarch64-unknown-linux-musl]" > ~/.cargo/config.toml
   echo 'linker = "aarch64-linux-musl-gcc"' >> ~/.cargo/config.toml

   # 添加 rustup 目标
   rustup target add aarch64-unknown-linux-musl
   rustup target add x86_64-unknown-linux-gnu
   ```

   **选项 2.2: 使用 zig 进行交叉编译：**
   ```bash
   # 安装 zig 和工具链
   yay -S zig aarch64-linux-musl
   cargo install cargo-zigbuild

   # 添加 rustup 目标
   rustup target add aarch64-unknown-linux-musl
   rustup target add x86_64-unknown-linux-gnu
   ```
3. 构建项目：

   **使用 cargo build：**
   ```bash
   # 为 aarch64-unknown-linux-musl 构建
   cargo build --release --target aarch64-unknown-linux-musl
   # 为 x86_64-unknown-linux-gnu 构建
   cargo build --release --target x86_64-unknown-linux-gnu
   ```

   **使用 cargo zigbuild：**
   ```bash
   # 为 aarch64-unknown-linux-musl 构建
   cargo zigbuild --release --target aarch64-unknown-linux-musl
   # 为 x86_64-unknown-linux-gnu 构建
   cargo zigbuild --release --target x86_64-unknown-linux-gnu
   ```

   **使用 Makefile：**
   ```bash
   # 编译所有目标
   make all
   # 仅为 aarch64-unknown-linux-musl 编译
   make build-arm
   # 仅为 x86_64-unknown-linux-gnu 编译
   make build-x64
   # 清理构建产物
   make clean
   # 检查构建目标
   make check
   ```

4. 编译后的二进制文件位于 `dist/` 目录下

## 安装说明

将编译好的二进制文件 `athena-led` 复制到 OpenWrt 设备的 `/usr/sbin/` 目录下。

## 使用方法

```bash
athena-led [选项]

选项说明：
    --status <状态>            设置状态字符串 [默认: ""]
    --seconds <秒数>           更新间隔（秒） [默认: 5]
    --light-level <亮度>       设置亮度级别（0-7） [默认: 5]
    --option <选项>            显示模式（如 "date"、"timeBlink"） [默认: "date timeBlink"]
    --value <值>              自定义显示字符 [默认: "abcdefghijklmnopqrstuvwxyz0123456789+-*/=.:：℃"]
    --url <URL>               状态监控的 URL [默认: "https://www.baidu.com/"]
    --temp-flag <标志>         温度传感器标志（0:nss-top, 1:nss, 2:wcss-phya0, 3:wcss-phya1, 4:cpu, 5:lpass, 6:ddrss） [默认: "4"]
```

## 常见问题

1. **时间显示问题**  
   如果显示的时间与系统时区不匹配，请确保系统已安装所需的时区数据包：
   - OpenWrt 系统：安装 `zoneinfo-core` 和对应地区的包（如 `zoneinfo-asia`）
   - 其他 Linux 发行版：安装 `tzdata` 包

## 开源许可

本项目采用 Apache License 2.0 许可证 - 详见 [LICENSE](LICENSE) 文件。
