# FPX

**FPX** is a **lightweight, fully autonomous first-person camera and humanoid movement system for Roblox**.  
It works seamlessly across **all platforms** (PC, mobile, VR) and is designed with performance and server-authoritative support in mind.

> FPX runs by itself-there are no methods to call. It operates directly on the humanoid and camera through low-level hooks and upvalue manipulation.
<img src="FPX_Logo.png" alt="Hierarchy Saver logo" width="500" height="500">

---

## Features

- 🏎 **High-performance** – minimal overhead, optimized for all devices  
- 🎮 **Cross-platform** – supports mouse/keyboard, touch, gamepad, and VR  
- 🔒 **Server-authoritative ready** – secure movement replication  
- 👻 **Invisible integration** – fully autonomous, no API calls needed  
- ⚡ **Optimized input handling** – uses low-level input signals for instant responsiveness  

---

## How It Works

- Automatically attaches to the player's **Humanoid** and **HumanoidRootPart**.  
- Hooks into **PreRender** and input signals to handle camera rotation and movement deltas.  
- Handles all platform-specific input:
  - **PC**: mouse delta  
  - **Mobile**: touchpad joystick and jump button  
  - **Gamepad**: analog sticks  
  - **VR**: head-tracking and controller movement  
- Updates the camera `CFrame` and fires **UnreliableRemoteEvents** for server synchronization.  
- Supports jumping and WASD-style movement without any setup.  

---

## Installation

1. Drop the `FPX` files into your game (e.g., `ReplicatedStorage`).  
2. Ensure `ReplicatedStorage` contains the required remote events:
   - `CameraRotation`  
   - `MoveInputEvent`  
   - `MoveAndCameraRotation`  
   - `RequestJump`  
3. Include FPX in a **LocalScript/ModuleScript** inside `StarterPlayerScripts` or equivalent.  
4. It automatically starts working; no initialization required.  

---

## Configuration

- **Sensitivity** can be tweaked by editing the `Sensativity` upvalue in the script.  
- **Hidden parts** can be configured by editing `HiddenParts` for invisibility logic.  

> FPX is designed to be minimal and autonomous—direct configuration via exposed variables is the only supported customization.

---

## Roadmap

- Full server-authoritative movement with predictive smoothing  
- Advanced VR support and motion correction  
- Optional custom input remapping  

---

## License

Apache License 2.0 © 2025 Yarik_superpro  
Use freely, optimize ruthlessly, and respect the core design philosophy.

---

## Contact

- Roblox: `Yarik_superpro`  
- Discord: `yarik_pro`
- DevForum: https://devforum.roblox.com/t/fpx-%E2%80%93-lightweight-playermodule-replacement-for-first-person-server-ready/4409000
