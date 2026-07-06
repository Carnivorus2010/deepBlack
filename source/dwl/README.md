# dwl - Industrial Void Build

This repository houses a customized, production-hardened build of `dwl` (dwm for Wayland), tailored explicitly around the **Industrial Void** design spec. It balances ultra-minimalist execution with high-visibility cybernetic aesthetics, built against modern `wlroots-0.19` layout structures.

## 🛠️ Visual & Functional Profile

- **Absolute Void Canvas**: Root textures and inactive layouts drop down into pure black (`#000000`). Inactive window boundaries vanish into the background matrix.
- **Glow-Wire Frames**: Active focused windows are wrapped in a 1px razor-sharp industrial green line (`#39ff14`).
- **Tightly Interlocked Cells**: Layout window gaps are strictly hard-locked to `0`, packing terminal and application nodes completely flush against each other like heavy plates.
- **Ergonomic Thumb Anchors**: The master window action modifier is explicitly retained on `ALT` (`WLR_MODIFIER_ALT`) to leverage structural spacebar muscle memory.

## 📦 Companion System Dependencies

To compile the source code and realize the complete workspace framework, ensure the following core tools, display libraries, and companion utilities are installed on your target system:

### 1. Hard Build-Time Dependencies (Required to Compile)
- **`wlroots`** (version 0.19 or matching package) - The fundamental base compositor architecture library.
- **`wayland-protocols`** - Provides the XML design specifications for communication layers.
- **`libinput`** - Manages physical system inputs (mouse, keyboard, trackpad layout layers).
- **`libxkbcommon`** - Handles custom layout definitions and key translation map arrays.

### 2. Operational Stack (Runtime Ecosystem)
- **`foot`**: Fast, lightweight Wayland-native terminal emulator configured to handle transparent terminal grids.
- **`dmenu-wl`**: Flawless Wayland port of standard dynamic menu tool, targeted specifically by the `menucmd` variable inside your configuration header.
- **`wayland`** / **`xorg-xwayland`** *(Optional)*: Include XWayland if you plan to execute legacy X11 binary applications inside your Wayland framework.
## ⌨️ Core Environment Bindings

| Key Combination | Operational Directive | Target Output |
| :--- | :--- | :--- |
| `ALT + p` | Spawn Application Launcher | `dmenu-wl` (Inherited Industrial Theme Flags) |
| `ALT + SHIFT + Return` | Initialize Terminal Element | `foot` terminal emulator |
| `ALT + j` / `ALT + k` | Cycle Stack Node Focus | Focus Next / Previous Window Cell |
| `ALT + SHIFT + c` | Terminate Window Node | Kill active application process cleanly |
| `ALT + SHIFT + q` | Exit Compositor Session | Gracefully drop down back to Linux TTY |

## 🚀 Desktop Provisioning Script

Execute this sequence on your newly deployed Arch Linux desktop system to pull down, resolve dependencies, and compile this user interface directly into the machine architecture:

```bash
# 1. Synchronize system and provision toolchains & Wayland/wlroots infrastructure
sudo pacman -Syu --needed base-devel git wlroots wayland-protocols libinput libxkbcommon

# 2. Extract your custom repository clone from the cloud
git clone [https://github.com/Carnivorus2010/custom-dwl-build.git](https://github.com/Carnivorus2010/custom-dwl-build.git) ~/src/custom-dwl-build
cd ~/src/custom-dwl-build

# 3. Assemble and flash the compositor binaries into system binaries
make
sudo make install
