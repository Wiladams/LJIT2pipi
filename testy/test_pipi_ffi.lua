-- test_pipi_ffi.lua
package.path = package.path..";../?.lua"

local ffi = require("ffi")
local pipi_ffi = require("pipi_ffi")();
local utils = require("utils")()
local rand = math.random


local function test_version()
	local version = pipi_get_version();

	print(ffi.string(version));
end

test_version();


print(rand(), rand(), rand())