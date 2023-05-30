<p align="center">
  <img width="128" align="center" src="https://github.com/Aurumaker72/mupen-lua-ugui/assets/48759429/cfc1beec-ba7e-4000-a845-a479ed80e780">
</p>


<h1 align="center">
  mupen-lua-ugui
</h1>
<p align="center">
  A truly lightweight and tunable immediate-mode GUI library for Mupen Lua
</p>


# Advantages

- Easy setup
  - Include only one file
- Flexible
  - Display controls whenever you want, with any data you want
  - Easily add new controls and stylers
- Host-authoritative
  - The host script coordinates everything: no library lock-in
  - No global pollution - only necessary components are exposed as tables
  
  
# Why would I use this?

This library provides more control and extensibility than the monolithic Mupen-Lua-Universal-GUI.

It's also more efficient than rolling your own solution, as you don't need to write control or rendering logic.
Any extensions, such as custom styling or new controls, are easy to create by writing to the global `Mupen_lua_ugui` table.

# BreitbandGraphics

<details>

<summary>BreitbandGraphics</summary>
<p align="center">
    <img width="128" align="center" src="https://user-images.githubusercontent.com/48759429/211370337-f5ce87e7-75de-4339-8ebd-401585a5f9f3.png">
</p>
<h1 align="center">
  BreitbandGraphics
</h1>
<p align="center">
  A wrapper and utility function provider for the Mupen Lua Graphics APIs
</p>

`BreitbandGraphics` is a part of `mupen-lua-ugui`, but can also be used directly by the host.
  
</details>
