#include "config.h"
package.path = package.path..";../?.lua"

local ffi = require("ffi")
local pipi_ffi = require("pipi_ffi")();
local utils = require("utils")()

local rand = math.random


local function main(argc, argv)

    srcname = nil
    dstname = nil;


    if(argc < 1) then
    
        fprintf(io.stderr, "%s: too few arguments\n", argv[0]);
        fprintf(io.stderr, "Usage: %s <src> <dest>\n", argv[0]);
        return -1;
    end

    srcname = argv[1];
    dstname = argv[2];

    local img = pipi_load(srcname);

    if(img == nil) then
        fprintf(io.stderr, "Can't open %s for reading\n", srcname);
    end

    local newimg = pipi_copy(img);
    pipi_free(img);

    local w = pipi_get_image_width(newimg);
    local h = pipi_get_image_height(newimg);

printf("Image Size: %dx%d\n", w, h);
    local count = 200;

    for i=1, count do
        local x1 = math.floor(rand()*w);
        local y1 = math.floor(rand()*h);
        local x2 = math.floor(rand()*w);
        local y2 = math.floor(rand()*h);

        pipi_draw_line(newimg,
                       x1, y1,
                       x2, y2,
                       0xff1e1eff,
                       0);
        local x1 = math.floor(rand()*w);
        local y1 = math.floor(rand()*h);
        local x2 = math.floor(rand()*w);
        local y2 = math.floor(rand()*h);

        pipi_draw_line(newimg,
                       x1, y1,
                       x2, y2,
                       0xff1e1eff,
                       1);
    end


    pipi_save(newimg, dstname);

    pipi_free(newimg);

    return 0;
end

main(#arg, arg)
