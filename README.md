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

<img width="28" align="left" src="https://github.com/Aurumaker72/mupen-lua-ugui/assets/48759429/cfc1beec-ba7e-4000-a845-a479ed80e780">

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

<img width="28" align="left" src="https://private-user-images.githubusercontent.com/48759429/253744715-c57389da-9536-4bf4-abaa-8125a30f2a7c.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MjczNDQyMjMsIm5iZiI6MTcyNzM0MzkyMywicGF0aCI6Ii80ODc1OTQyOS8yNTM3NDQ3MTUtYzU3Mzg5ZGEtOTUzNi00YmY0LWFiYWEtODEyNWEzMGYyYTdjLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDA5MjYlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwOTI2VDA5NDUyM1omWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWY2ZmFiZDI0NWJiZmM4Y2M2MjQ4YWIyY2I0YTFkMTMyZDAyMWQ3MzI3YTU4ZDBiYTI1YTEzMDlkYjYzMzExNTAmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.uttN6Y1S1YrmUZXMdpYAUX4RFp4f8wLV3viCZMVeUgQ">

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
    <img width="128" align="center" src="https://user-images.githubusercontent.com/48759429/211370337-f5ce87e7-75de-4339-8ebd-401585a5f9f3.png">
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
