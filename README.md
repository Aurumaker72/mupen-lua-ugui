<p align="center">
  <img width="128" align="center" src="https://github.com/Aurumaker72/mupen-lua-ugui/assets/48759429/cfc1beec-ba7e-4000-a845-a479ed80e780">
</p>


<h1 align="center">
  mupen-lua-ugui
</h1>
<p align="center">
  Flexible immediate-mode GUI library for Mupen Lua
</p>

# 🚀 Quickstart

```lua
dofile("mupen-lua-ugui.lua")
```

That's it. Don't forget to pass an absolute path, not a relative one.

Read the [demo scripts](https://github.com/Aurumaker72/mupen-lua-ugui/tree/main/demos) and function documentation for usage information.

# 🏗️ Projects

Cool projects using `mupen-lua-ugui`

- [SM64Lua Redux](https://github.com/Mupen64-Rewrite/SM64Lua)
- [mupen-lua-ugui-ext](https://github.com/Aurumaker72/mupen-lua-ugui-ext)
- [TASInput Lua](https://github.com/Aurumaker72/tasinput-lua)


# 📈 Advantages

- Easy Usage
  - Include only one file
- Flexible
  - Add or extend controls
  - Add or extend stylers
  - Mock subsystems
- Host-authoritative
  - Invokable anytime and anywhere
  - No global pollution - only necessary components are exposed as tables
- Fast
  - Shallow callstacks
  - Reduced indirection
  - Controls optimized for large datasets

# ✨ Features

- Stylers
  - Windows 10 (built-in)
- Flexibility
  - Modify any parts of the framework to your liking
- User Productivity
  - Interactions behave exactly like Windows
- Button
- TextBox
  - Full-fledged selection and editing system
- ToggleButton
- Joystick
- TrackBar
  - Automatic layout adjustement based on size ratio 
- ComboBox
- ListBox
  - Scrolling support
  - Unlimited items with no performance degradation

# 🎨 Graphics

<p align="center">
    <img width="128" align="center" src="https://user-images.githubusercontent.com/48759429/211370337-f5ce87e7-75de-4339-8ebd-401585a5f9f3.png">
</p>
<h1 align="center">
  BreitbandGraphics
</h1>
<p align="center">
  Powerful abstraction layer over Mupen Lua Direct2D APIs
</p>

`mupen-lua-ugui` uses `BreitbandGraphics` for rendering.

## 🧩 Porting

### To mupen-lua-ugui

Porting a script to `mupen-lua-ugui` requires an understanding of the library's usage, achieved by reading the demos and comment docs.
For individual help, contact me on Discord (`aurumaker72`) or post an issue in this repository.

## 📈 Advantages
- Maximized usability
  - Stable API surface
- Helpful utilities
  - Hexadecimal color conversion
  - Standard color tables
- Low overhead
