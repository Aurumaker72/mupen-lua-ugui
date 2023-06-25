---@meta

-- version 1.1.3.3

-- This file has meta definitions for the functions implemented in mupen64.
-- https://github.com/mkdasher/mupen64-rr-lua-/blob/master/lua/LuaConsole.cpp

-- Additional documentation can be found here:
-- https://docs.google.com/document/d/1SWd-oAFBKsGmwUs0qGiOrk3zfX9wYHhi3x5aKPQS_o0

emu = {}
memory = {}
gui = {}
wgui = {}
input = {}
joypad = {}
movie = {}
savestate = {}
ioHelper = {}
avi = {}

---@alias qword integer[] A representation of an 8 byte integer (quad word) as
---two 4 byte integers.

-- Global Functions
--#region

---Prints a value to the lua console
---@param data any The data to print to the console
---@return nil
function print(data) end

---Stops script execution
---@return nil
function stop() end

--#endregion


-- emu functions
--#region

---Displays the text `message` in the console. Similar to `print`, but only
---accepts strings. Because of this, `print` should be used instead.
---@deprecated Use `print` instead.
---@param message string The string to print to the console.
---@return nil
function emu.console(message) end

---Prints `message` to the debug console. If you are not debugging with Visual
---Studio, this function will do nothing.
---@deprecated This function has no use to the end user.
---@param message string The string to print to the debug console.
---@return nil
function emu.debugview(message) end

---Displays the text `message` in the status bar on the bottom while replacing
---any other text. The message will only display until the next frame.
---@param message string The string to display on the status bar.
---@return nil
function emu.statusbar(message) end

---Calls the function `f` every VI frame. For example, in Super Mario 64, the
---function will be called twice when you advance by one frame, whereas it will
---be called once in Ocarina of Time. If `unregister` is set to true, the
---function `f` will no longer be called when this event occurs, but it will
---error if you never registered the function.
---@param f fun(): nil The function to be called every VI frame.
---@param unregister boolean? If true, then unregister the function `f`.
---@return nil
function emu.atvi(f, unregister) end

---Similar to `emu.atvi`, except that it is called after. If `unregister` is set
---to true, the function `f` will no longer be called when this event occurs,
---but it will error if you never registered the function.
---@param f fun(): nil The function to be called after every VI frame.
---@param unregister boolean? If true, then unregister the function `f`.
---@return nil
function emu.atupdatescreen(f, unregister) end

---Calls the function `f` every input frame. The function `f` receives an
---argument that seems to always be `0`. If `unregister` is set to true, the
---function `f` will no longer be called when this event occurs, but it will
---error if you never registered the function. Alias for `joypad.register`.
---@param f fun(a: integer?): nil The function to be called every input frame. It receives an argument that seems to always be `0`.
---@param unregister boolean? If true, then unregister the function `f`.
---@return nil
function emu.atinput(f, unregister) end

---Calls the function `f` when the script is stopped. If `unregister` is set to
---true, the function `f` will no longer be called when this event occurs, but
---it will error if you never registered the function.
---@param f fun(): nil The function to be called when the script is stopped
---@param unregister boolean? If true, then unregister the function `f`.
---@return nil
function emu.atstop(f, unregister) end

---Defines a handler function that is called when a window receives a message.
---The message data is given to the function in 4 parameters. If `unregister`
---is set to true, the function `f` will no longer be called when this event
---occurs, but it will error if you never registered the function.
---@param f fun(a: integer, b: integer, c: integer, d: integer): nil The function to be called when a window message is received. a: wnd, b: msg, c: wParam, d: lParam.
---@param unregister boolean? If true, then unregister the function `f`.
---@return nil
function emu.atwindowmessage(f, unregister) end

---Calls the function `f` constantly, even when the emulator is paused. If
---`unregister` is set to true, the function `f` will no longer be called when
---this event occurs, but it will error if you never registered the function.
---@param f fun(): nil The function to be called constantly.
---@param unregister boolean? If true, then unregister the function `f`.
---@return nil
function emu.atinterval(f, unregister) end

---Calls the function `f` when a movie is played. If `unregister` is set to
---true, the function `f` will no longer be called when this event occurs, but
---it will error if you never registered the function.
---@param f fun(): nil The function to be called when a movie is played.
---@param unregister boolean? If true, then unregister the function `f`.
---@return nil
function emu.atplaymovie(f, unregister) end

---Calls the function `f` when a movie is stopped. If `unregister` is set to
---true, the function `f` will no longer be called when this event occurs, but
---it will error if you never registered the function.
---@param f fun(): nil The function to be called when a movie is stopped.
---@param unregister boolean? If true, then unregister the function `f`.
---@return nil
function emu.atstopmovie(f, unregister) end

---Calls the function `f` when a savestate is loaded. If `unregister` is set to
---true, the function `f` will no longer be called when this event occurs, but
---it will error if you never registered the function.
---@param f fun(): nil The function to be called when a savestate is loaded.
---@param unregister boolean? If true, then unregister the function `f`.
---@return nil
function emu.atloadstate(f, unregister) end

---Calls the function `f` when a savestate is saved. If `unregister` is set to
---true, the function `f` will no longer be called when this event occurs, but
---it will error if you never registered the function.
---@param f fun(): nil The function to be called when a savestate is saved.
---@param unregister boolean? If true, then unregister the function `f`.
---@return nil
function emu.atsavestate(f, unregister) end

---Calls the function `f` when the emulator is reset. If `unregister` is set to
---true, the function `f` will no longer be called when this event occurs, but
---it will error if you never registered the function.
---@param f fun(): nil The function to be called when the emulator is reset.
---@param unregister boolean? If true, then unregister the function `f`.
---@return nil
function emu.atreset(f, unregister) end

---Returns the number of VIs since the last movie was played. This should match
---the statusbar (assuming you have `0-index statusbar` off). If no movie has
---been played, it returns the number of VIs since the emulator was started, not
---reset.
---@nodiscard
---@return integer framecount The number of VIs since the last movie was played.
function emu.framecount() end

---Returns the number of input frames since the last movie was played. This
---should match the statusbar (assuming you have `0-index statusbar` off). If no
---movie is playing, it will return the last value when a movie was playing. If
---no movie has been played yet, it will return `-1`.
---@nodiscard
---@return integer samplecount The number of input frames since the last movie was played.
function emu.samplecount() end

---Returns the number of input frames that have happened since the emulator was
---started. It does not reset when a movie is started. Alias for `joypad.count`.
---@nodiscard
---@return integer inputcount The number of input frames that have happened since the emulator was started.
function emu.inputcount() end

---Returns the current mupen version. If `type` is 0 or less, it
---will return the full version name (Mupen 64 0.0.0). If `type`
---is 1 or more, it will return only the version number (0.0.0).
---@nodiscard
---@param type 0|1 Whether to get the full version (less that 0) or the short version (more than 1).
---@return string version The mupen version
function emu.getversion(type) end

---Pauses or unpauses the emulator.
---@param pause boolean True pauses the emulator and false resumes it.
---@return nil
function emu.pause(pause) end

---Returns `true` if the emulator is paused and `false` if it is not.
---@nodiscard
---@return boolean emu_paused `true` if the emulator is paused and `false` if it is not.
function emu.getpause() end

---Returns the current speed limit (not the current speed) of the emulator.
---@nodiscard
---@return integer speed_limit The current speed limit of the emulator.
function emu.getspeed() end

---Sets the speed limit of the emulator.
---@param speed_limit integer The new speed limit of the emulator.
---@return nil
function emu.speed(speed_limit) end

---Sets the speed mode of the emulator.
---@param mode "normal"|"maximum"
---@return nil
function emu.speedmode(mode) end

---?
---@param mode 0|1
---@return nil
function emu.setgfx(mode) end

---?
---@nodiscard
---@param address string
---@return integer
function emu.getaddress(address) end

---Returns true if the currently playing movie is read only and false if it is
---not.
---@nodiscard
---@return boolean read_only
function emu.isreadonly() end

---Gets a system metric using the windows
---[GetSystemMetrics](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getsystemmetrics)
---function.
---@nodiscard
---@param param integer
---@return integer metric
function emu.getsystemmetrics(param) end

---Returns `true` if the main mupen window is focused and false if it is not.
---@nodiscard
---@return boolean focused
function emu.ismainwindowinforeground() end

---Takes a screenshot and saves it to the directory `dir`.
---@param dir string The directory to save the screenshot to.
---@return nil
function emu.screenshot(dir) end

--#endregion


-- memory functions
--#region

---Reinterprets the bits of a 4 byte integer `n` as a float and returns it. This
--- does not convert from an int to a float, but reinterprets the memory.
---@nodiscard
---@param n integer
---@return number
function memory.inttofloat(n) end

---Reinterprets the bits of an 8 byte integer `n` as a double and returns it.
---This does not convert from an int to a double, but reinterprets the memory.
---@nodiscard
---@param n qword
---@return number
function memory.inttodouble(n) end

---Reinterprets the bits of a float `n` as a 4 byte integer and returns it. This
--- does not convert from an int to a float, but reinterprets the memory.
---@nodiscard
---@param n number
---@return integer
function memory.floattoint(n) end

---Reinterprets the bits of a 8 byte integer `n` as a double and returns it.
---This does not convert from an int to a float, but reinterprets the memory.
---@nodiscard
---@param n qword
---@return number
function memory.doubletoint(n) end

---Takes in an 8 byte integer and returns it as a lua number. This function
---should only be used when reading a qword from memory.
---@nodiscard
---@param n qword
---@return number
function memory.qwordtonumber(n) end

---Reads a signed byte from memory at `address` and returns it.
---@nodiscard
---@param address integer
---@return integer
function memory.readbytesigned(address) end

---Reads an unsigned byte from memory at `address` and returns it.
---@nodiscard
---@param address integer
---@return integer
function memory.readbyte(address) end

---Reads a signed word (2 bytes) from memory at `address` and returns it.
---@nodiscard
---@param address integer
---@return integer
function memory.readwordsigned(address) end

---Reads an unsigned word (2 bytes) from memory at `address` and returns it.
---@nodiscard
---@param address integer
---@return integer
function memory.readword(address) end

---Reads a signed dword (4 bytes) from memory at `address` and returns it.
---@nodiscard
---@param address integer
---@return integer
function memory.readdwordsigned(address) end

---Reads an unsigned dword (4 bytes) from memory at `address` and returns it.
---@nodiscard
---@param address integer
---@return integer
function memory.readdword(address) end

---Reads a signed qword (8 bytes) from memory at `address` and returns it as a
---table of the upper and lower 4 bytes.
---@nodiscard
---@param address integer
---@return qword
function memory.readqwordsigned(address) end

---Reads an unsigned qword (8 bytes) from memory at `address` and returns it as
---a table of the upper and lower 4 bytes.
---@nodiscard
---@param address integer
---@return integer
function memory.readqword(address) end

---Reads a float (4 bytes) from memory at `address` and returns it.
---@nodiscard
---@param address integer
---@return number
function memory.readfloat(address) end

---Reads a double (8 bytes) from memory at `address` and returns it.
---@nodiscard
---@param address integer
---@return number
function memory.readdouble(address) end

---Reads `size` bytes from memory at `address` and returns them. The memory is
---treated as signed if `size` is is negative.
---@nodiscard
---@param address integer
---@param size 1|2|4|8|-1|-2|-4|-8
---@return nil
function memory.readsize(address, size) end

---Writes an unsigned byte to memory at `address`.
---@param address integer
---@param data integer
---@return nil
function memory.writebyte(address, data) end

---Writes an unsigned word (2 bytes) to memory at `address`.
---@param address integer
---@param data integer
---@return nil
function memory.writeword(address, data) end

---Writes an unsigned dword (4 bytes) to memory at `address`.
---@param address integer
---@param data integer
---@return nil
function memory.writedword(address, data) end

---Writes an unsigned qword consisting of a table with the upper and lower 4
---bytes to memory at `address`.
---@param address integer
---@param data qword
---@return nil
function memory.writeqword(address, data) end

---Writes a float to memory at `address`.
---@param address integer
---@param data number
---@return nil
function memory.writefloat(address, data) end

---Writes a double to memory at `address`.
---@param address integer
---@param data number
---@return nil
function memory.writedouble(address, data) end

---Writes `size` bytes to memory at `address`. The memory is treated as signed
---if `size` is is negative.
---@param address integer
---@param size 1|2|4|8|-1|-2|-4|-8
---@param data integer|qword
---@return nil
function memory.writesize(address, size, data) end

--#endregion


-- wgui functions
--#region

---Draws a filled in rectangle at the specified coordinates and color.
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@param red number d2d colors range from 0.0 to 1.0
---@param green number d2d colors range from 0.0 to 1.0
---@param blue number d2d colors range from 0.0 to 1.0
---@param alpha number d2d colors range from 0.0 to 1.0
---@return nil
function wgui.fill_rectangle(x1, y1, x2, y2, red, green, blue, alpha) end

---Draws the border of a rectangle at the specified coordinates and color.
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@param red number d2d colors range from 0.0 to 1.0
---@param green number d2d colors range from 0.0 to 1.0
---@param blue number d2d colors range from 0.0 to 1.0
---@param alpha number d2d colors range from 0.0 to 1.0
---@param thickness number
---@return nil
function wgui.draw_rectangle(x1, y1, x2, y2, red, green, blue, alpha, thickness) end

---Draws a filled in ellipse at the specified coordinates and color.
---@param x integer
---@param y integer
---@param radiusX integer
---@param radiusY integer
---@param red number d2d colors range from 0.0 to 1.0
---@param green number d2d colors range from 0.0 to 1.0
---@param blue number d2d colors range from 0.0 to 1.0
---@param alpha number d2d colors range from 0.0 to 1.0
---@return nil
function wgui.fill_ellipse(x, y, radiusX, radiusY, red, green, blue, alpha) end

---Draws the border of an ellipse at the specified coordinates and color.
---@param x integer
---@param y integer
---@param radiusX integer
---@param radiusY integer
---@param red number d2d colors range from 0.0 to 1.0
---@param green number d2d colors range from 0.0 to 1.0
---@param blue number d2d colors range from 0.0 to 1.0
---@param alpha number d2d colors range from 0.0 to 1.0
---@param thickness number
---@return nil
function wgui.draw_ellipse(x, y, radiusX, radiusY, red, green, blue, alpha, thickness) end

---Draws a line from `(x1, y1)` to `(x2, y2)` in the specified color.
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@param red number d2d colors range from 0.0 to 1.0
---@param green number d2d colors range from 0.0 to 1.0
---@param blue number d2d colors range from 0.0 to 1.0
---@param alpha number d2d colors range from 0.0 to 1.0
---@param thickness number
---@return nil
function wgui.draw_line(x1, y1, x2, y2, red, green, blue, alpha, thickness) end

---Draws the text `text` at the specified coordinates, color, font, and
---alignment.
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@param red number d2d colors range from 0.0 to 1.0
---@param green number d2d colors range from 0.0 to 1.0
---@param blue number d2d colors range from 0.0 to 1.0
---@param alpha number d2d colors range from 0.0 to 1.0
---@param text string
---@param fontname string
---@param fontsize number
---@param fontstyle 0|1|2|3 0: normal, 1: bold, 2: italic, 3: bold + italic
---@param horizalign integer
---@param vertalign integer
---@return nil
function wgui.draw_text(x1, y1, x2, y2, red, green, blue, alpha, text, fontname, fontsize, fontstyle, horizalign, vertalign) end

---Returns the width and height of the specified text.
---@param text string
---@param fontname string
---@param fontsize number
---@param max_width number
---@param max_height number
---@return {width: integer, height: integer}
function wgui.get_text_size(text, fontname, fontsize, max_width, max_height) end

---Specifies a rectangle to which all subsequent drawing operations are clipped.
---This clip is put onto a stack. It can then be popped off the stack with
---`wgui.d2d_pop_clip`.
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@return nil
function wgui.push_clip(x1, y1, x2, y2) end

---Pops the most recent clip off the clip stack.
---@return nil
function wgui.pop_clip() end

---Draws a filled in rounded rectangle at the specified coordinates, color and
---radius
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@param radiusX number
---@param radiusY number
---@param red number d2d colors range from 0.0 to 1.0
---@param green number d2d colors range from 0.0 to 1.0
---@param blue number d2d colors range from 0.0 to 1.0
---@param alpha number d2d colors range from 0.0 to 1.0
---@return nil
function wgui.fill_rounded_rectangle(x1, y1, x2, y2, radiusX, radiusY, red, green, blue, alpha) end

---Draws the border of a rounded rectangle at the specified coordinates, color
---and radius
---@param x1 integer
---@param y1 integer
---@param x2 integer
---@param y2 integer
---@param radiusX number
---@param radiusY number
---@param red number d2d colors range from 0.0 to 1.0
---@param green number d2d colors range from 0.0 to 1.0
---@param blue number d2d colors range from 0.0 to 1.0
---@param alpha number d2d colors range from 0.0 to 1.0
---@param thickness number
---@return nil
function wgui.draw_rounded_rectangle(x1, y1, x2, y2, radiusX, radiusY, red, green, blue, alpha, thickness) end

---Loads an image file from `path` which you can then access through
---`identifier`.
---@param path string
---@param identifier string
---@return nil
function wgui.load_image(path, identifier) end

---Frees the image at `identifier`.
---@param identifier string
---@return nil
function wgui.free_image(identifier) end

---Draws an image by taking the pixels in the source rectangle of the image, and
---drawing them to the destination rectangle on the screen.
---@param destx1 integer
---@param desty1 integer
---@param destx2 integer
---@param desty2 integer
---@param srcx1 integer
---@param srcy1 integer
---@param srcx2 integer
---@param srcy2 integer
---@param identifier string
---@param opacity number
---@param interpolationMode integer 0: nearest neighbor, 1: linear, -1: don't use
---@return nil
function wgui.draw_image(destx1, desty1, destx2, desty2, srcx1, srcy1, srcx2, srcy2, identifier, opacity, interpolationMode) end

---Returns the width and height of the image at `identifier`.
---@nodiscard
---@param identifier string
---@return {width: integer, height: integer}
function wgui.get_image_info(identifier) end

---Draws a polygon at the specified coordinates and color
---@param points integer[][] Double array of points. For example, `{{0, 0}, {1, 0}, {0, 1}}` will draw a triangle.
---@param alpha integer GDI+ colors range from 0 to 255
---@param red integer GDI+ colors range from 0 to 255
---@param green integer GDI+ colors range from 0 to 255
---@param blue integer GDI+ colors range from 0 to 255
---@return nil
function wgui.gdip_fillpolygona(points, alpha, red, green, blue) end

---Returns the current size of the window.
---@nodiscard
---@return {width: integer, height: integer}
function wgui.info() end

---Resizes the window to `width` and `height`
---@param width integer
---@param height integer
---@return nil
function wgui.resize(width, height) end

--#endregion


-- input functions
--#region

---Returns the state of all keyboard keys and the mouse position in a table. Ex:
---`input.get() -> {xmouse=297, ymouse=120, A=true, B=true}`.
---@nodiscard
---@return table
function input.get() end

---Returns the differences between `t1` and `t2`. For example, if `t1` is the
---inputs for this frame, and `t2` is the inputs for last frame, it would return
---which buttons were pressed this frame, not which buttons are active.
---@nodiscard
---@param t1 table
---@param t2 table
---@return table
function input.diff(t1, t2) end

---Opens a window where the user can input text. If `OK` is clicked, that text
---is returned. If `Cancel` is clicked or the window is closed, `nil` is
---returned.
---@nodiscard
---@param title string? The title of the text box. Defaults to "input:".
---@param placeholder string? The text box is filled with this string when it opens. Defaults to "".
---@return string|nil
function input.prompt(title, placeholder) end

--#endregion


-- joypad functions
--#region

---Gets the currently pressed game buttons and stick direction for a given port.
---Note that the `y` coordinate of the stick is the opposite of what is shown on
---TAS Input.
---@nodiscard
---@param port 1|2|3|4
---@return table
function joypad.get(port) end

---Sets the current joypad to `inputs`. If you do not specify one or more
---inputs, they will be set to `false` for buttons or `0` for stick coordinates
---@param port 1|2|3|4
---@param inputs table
---@return nil
function joypad.set(port, inputs) end

---Calls the function `f` every input frame. The function `f` receives an
---argument that seems to always be `0`. If `unregister` is set to true, the
---function `f` will no longer be called when this event occurs, but it will
---error if you never registered the function. Alias for `emu.atinput`.
---@param f fun(a: integer?): nil The function to be called every input frame. It receives an argument that seems to always be `0`.
---@param unregister boolean? If true, then unregister the function `f`.
---@return nil
function joypad.register(f, unregister) end

---Returns the number of input frames that have happened since the emulator was
---started. It does not reset when a movie is started. Alias for
---`emu.inputcount`.
---@nodiscard
---@return integer inputcount The number of input frames that have happened since the emulator was started.
function joypad.count() end

--#endregion


-- movie functions
--#region

---Plays a movie file located at `filename`. This function sets `Read Only` to
---true.
---@param filename string
---@return nil
function movie.playmovie(filename) end

---Stops the currently playing movie.
---@return nil
function movie.stopmovie() end

---Returns the filename of the currently playing movie. It will error if no
---movie is playing.
---@nodiscard
---@return string
function movie.getmoviefilename() end

--#endregion


-- savestate functions
--#region

---Saves a savestate to `filename`.
---@param filename string
---@return nil
function savestate.savefile(filename) end

---Loads a savestate from `filename`
---@param filename string
---@return nil
function savestate.loadfile(filename) end

--#endregion


-- ioHelper functions
--#region

---Opens a file dialouge and returns the file path of the file chosen.
---@nodiscard
---@param filter string This string acts as a filter for what files can be chosen. For example `*.*` selects all files, where `*.txt` selects only text files
---@param type integer Unknown
---@return string
function ioHelper.filediag(filter, type) end

--#endregion


-- avi functions
--#region

---Begins an avi recording using the previously saved encoding settings. It is
---saved to `filename`.
---@param filename string
---@return nil
function avi.startcapture(filename) end

---Stops avi recording.
---@return nil
function avi.stopcapture() end

--#endregion
