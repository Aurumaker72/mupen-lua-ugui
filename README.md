<p align="center">
  <img width="128" align="center" src="https://github.com/Aurumaker72/mupen-lua-ugui/blob/main/assets/ugui.png?raw=true">
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
  - Immediate-mode control spawning API
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

<img width="28" align="left" src="https://github.com/Aurumaker72/mupen-lua-ugui/blob/main/assets/ugui.png?raw=true">

mupen-lua-ugui

- Stylers
  - Windows 10 (built-in)
- Flexibility
  - Modify any parts of the framework to your liking
- User Productivity
  - Interactions emulate commctl behaviour to ensure consistency
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
- Scrollbar

<img width="28" align="left" src="https://github.com/Aurumaker72/mupen-lua-ugui/blob/main/assets/ugui-ext.png?raw=true">

mupen-lua-ugui-ext

- Spinner
- TabControl
- NumberBox
- TreeView
- Performance
  - Graphics caching extension
- Stylers
  - Nineslice (built-in)

# 🎨 Graphics

<p align="center">
    <img width="128" align="center" src="https://github.com/Aurumaker72/mupen-lua-ugui/blob/main/assets/breitbandgraphics.png?raw=true">
</p>
<h1 align="center">
  BreitbandGraphics
</h1>
<p align="center">
  Powerful abstraction layer over Mupen Lua drawing APIs
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
