package.path = package.path..";../?.lua"

local ffi = require("ffi")
local pipi_ffi = require("pipi_ffi")();
local utils = require("utils")()

--[[
  strings such as:
  luajit test_get_color "rgb(255, 10, 20)"
  luajit test_get_color "frgb(.7, .3, .57)"
  luajit test_get_color "blue"
  luajit test_get_color "white"

--]]

local function main(argc, argv)
    if(argc ~=1) then
        print("Need one argument (only)");
        return -1;
    end


    local color = pipi_get_color_from_string(argv[1]);
    printf("Color : %1.2f %1.3f %1.3f %1.3f\n",
           color.pixel_float.r,
           color.pixel_float.g,
           color.pixel_float.b,
           color.pixel_float.a);

end

main(#arg, arg)