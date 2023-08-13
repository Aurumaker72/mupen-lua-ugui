import os

with open("mupen-lua-ugui.lua", "r") as file:
    content = file.read()

header_content = "#pragma once\n\nconst char* mupen_lua_ugui = R\"(\n" + content + "\n)\";\n"

with open("mupen-lua-ugui.h", "w") as header_file:
    header_file.write(header_content)