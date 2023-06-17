<p align="center">
  <img width="128" align="center" src="https://github.com/Aurumaker72/mupen-lua-ugui/assets/48759429/cfc1beec-ba7e-4000-a845-a479ed80e780">
</p>


<h1 align="center">
  mupen-lua-ugui
</h1>
<p align="center">
  Lightweight and flexible immediate-mode GUI library for Mupen Lua
</p>

# Quickstart
Check out the [demos](https://github.com/Aurumaker72/mupen-lua-ugui/blob/main/demos.md) to see how the library is used.

# Advantages

- Easy Usage
  - Include only one file
- Flexible
  - Call library functions at any time
  - Add or modify controls and stylers
- Host-authoritative
  - The host script coordinates everything: no library lock-in
  - No global pollution - only necessary components are exposed as tables
- Fast
  - Shallow callstacks
  - Virtualization support
  
  
# Key points

- Architecturally unopinionated
- More efficient than a hand-rolled solution
- Extensible and hackable

# Features

- Stylers
  - Windows 10 (built-in)
- Modularity
  - Provide subsystem references in `begin_frame`
- Button
- TextBox
  - Keyboard- and mouse-controllable caret
- ToggleButton
- Joystick
- TrackBar
  - Automatically layout adjustement based on size ratio 
- ComboBox
- ListBox
  - Virtualization

# Graphics

<p align="center">
    <img width="128" align="center" src="https://user-images.githubusercontent.com/48759429/211370337-f5ce87e7-75de-4339-8ebd-401585a5f9f3.png">
</p>
<h1 align="center">
  BreitbandGraphics
</h1>
<p align="center">
  Mupen Lua Graphics API abstraction layer
</p>

`mupen-lua-ugui` depends on `BreitbandGraphics` for backend-agnostic rendering functionality.

⚠️ It is recommended to use `BreitbandGraphics` when drawing graphics instead of directly calling the Mupen Lua APIs, due to Intellisense and helpful utilities. 
