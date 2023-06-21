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

Check out the [demos](https://github.com/Aurumaker72/mupen-lua-ugui/blob/main/demos.md) to see how the library is used.

# 📈 Advantages

- Easy Usage
  - Include only one file
- Flexible
  - Call library functions at any time
  - Add or modify controls and stylers
- Host-authoritative
  - The host script coordinates everything: no library lock-in
  - The library keeps no copies of application state
  - No global pollution - only necessary components are exposed as tables
- Fast
  - Shallow callstacks
  - Virtualization support

# ✨ Features

- Stylers
  - Windows 10 (built-in)
- Modularity
  - Provide subsystem references in `begin_frame`
  - Modify any parts of the framework to your liking
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
It's recommended to use `BreitbandGraphics` when drawing graphics instead of directly calling the Mupen Lua APIs, due to Intellisense and helpful utilities. 

# 🔩 Porting

### To mupen-lua-ugui

Porting a script to `mupen-lua-ugui` is not trivial and requires manual work. Contact `aurumaker72` on Discord for help regarding this.

### To BreitbandGraphics

Porting a script which utilizes the Lua GDI APIs to `BreitbandGraphics` is, however, trivial.
By including the `mupen-lua-ugui` library, backwards compatibility will automatically be set up and no code will have to be changed manually.
