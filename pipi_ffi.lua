local ffi = require("ffi")





--#include <pipi_types.h>


ffi.cdef[[

/* pipi_scan_t: this enum is a list of all possible scanning methods when
 * parsing an image’s pixels. Not all functions support all scanning paths. */
typedef enum
{
    PIPI_SCAN_RASTER = 0,
    PIPI_SCAN_SERPENTINE = 1
}
pipi_scan_t;

/* pipi_format_t: this enum is a list of all possible pixel formats for
 * our internal images. RGBA_U8 is the most usual format when an image has
 * just been loaded, but RGBA_F32 is a lot better for complex operations. */
typedef enum
{
    PIPI_PIXELS_UNINITIALISED = -1,

    PIPI_PIXELS_RGBA_U8 = 0,
    PIPI_PIXELS_BGR_U8 = 1,
    PIPI_PIXELS_RGBA_F32 = 2,
    PIPI_PIXELS_Y_F32 = 3,

    PIPI_PIXELS_MASK_U8 = 4,

    PIPI_PIXELS_MAX = 5
}
pipi_format_t;


typedef enum
{
    PIPI_COLOR_R = 1,
    PIPI_COLOR_G = 2,
    PIPI_COLOR_B = 4,
    PIPI_COLOR_A = 8,
    PIPI_COLOR_Y = 16
}
pipi_color_flag_t;

struct pixel_u32
{
    uint8_t r, g, b, a;
};
struct pixel_float
{
    float r, g, b, a;
};

typedef struct
{
    union
    {
        struct pixel_float pixel_float;
        struct pixel_u32   pixel_u32;
    };
}
pipi_pixel_t;

/* pipi_pixels_t: this structure stores a pixel view of an image. */
typedef struct
{
    void *pixels;
    int w, h, pitch, bpp;
    size_t bytes;
}
pipi_pixels_t;

/* pipi_tile_t: the internal tile type */
typedef struct pipi_tile pipi_tile_t;

/* pipi_image_t: the main image type */
typedef struct pipi_image pipi_image_t;

/* pipi_sequence_t: the image sequence type */
typedef struct pipi_sequence pipi_sequence_t;

/* pipi_context_t: the processing stack */
typedef struct pipi_context pipi_context_t;

/* pipi_histogram_t: the histogram type */
typedef struct pipi_histogram pipi_histogram_t;

/* pipi_command_t: the command type */
typedef struct
{
    char const *name;
    int argc;
}
pipi_command_t;
]]

ffi.cdef[[
pipi_pixel_t *pipi_get_color_from_string(const char* s);

char const * pipi_get_version(void);

pipi_context_t *pipi_create_context(void);
void pipi_destroy_context(pipi_context_t *);
pipi_command_t const *pipi_get_command_list(void);
int pipi_command(pipi_context_t *, char const *, ...);

pipi_tile_t *pipi_get_tile(pipi_image_t *, int, int, int,
                                    pipi_format_t, int);
void pipi_release_tile(pipi_image_t *, pipi_tile_t *);
pipi_tile_t *pipi_create_tile(pipi_format_t, int);

pipi_image_t *pipi_load(char const *);
pipi_image_t *pipi_load_stock(char const *);
pipi_image_t *pipi_new(int, int);
pipi_image_t *pipi_copy(pipi_image_t *);
void pipi_free(pipi_image_t *);
int pipi_save(pipi_image_t *, const char *);

void pipi_set_gamma(double);
pipi_pixels_t *pipi_get_pixels(pipi_image_t *, pipi_format_t);
void pipi_release_pixels(pipi_image_t *, pipi_pixels_t *);
void pipi_set_colorspace(pipi_image_t *, pipi_format_t);
int pipi_get_image_width(pipi_image_t *img);
int pipi_get_image_height(pipi_image_t *img);
int pipi_get_image_pitch(pipi_image_t *img);
int pipi_get_image_last_modified(pipi_image_t *img);
const char* pipi_get_format_name(int format);


double pipi_measure_msd(pipi_image_t *, pipi_image_t *);
double pipi_measure_rmsd(pipi_image_t *, pipi_image_t *);

pipi_image_t *pipi_resize_bresenham(pipi_image_t *, int, int);
pipi_image_t *pipi_resize_bicubic(pipi_image_t *, int, int);
pipi_image_t *pipi_crop(pipi_image_t *, int, int, int, int);

pipi_image_t *pipi_render_random(int, int);
pipi_image_t *pipi_render_bayer(int, int);
pipi_image_t *pipi_render_halftone(int, int);

pipi_image_t *pipi_rgb(pipi_image_t *, pipi_image_t *, pipi_image_t *);
pipi_image_t *pipi_red(pipi_image_t *);
pipi_image_t *pipi_green(pipi_image_t *);
pipi_image_t *pipi_blue(pipi_image_t *);
pipi_image_t *pipi_blit(pipi_image_t *, pipi_image_t *, int, int);
pipi_image_t *pipi_merge(pipi_image_t *, pipi_image_t *, double);
pipi_image_t *pipi_mean(pipi_image_t *, pipi_image_t *);
pipi_image_t *pipi_min(pipi_image_t *, pipi_image_t *);
pipi_image_t *pipi_max(pipi_image_t *, pipi_image_t *);
pipi_image_t *pipi_add(pipi_image_t *, pipi_image_t *);
pipi_image_t *pipi_sub(pipi_image_t *, pipi_image_t *);
pipi_image_t *pipi_difference(pipi_image_t *, pipi_image_t *);
pipi_image_t *pipi_multiply(pipi_image_t *, pipi_image_t *);
pipi_image_t *pipi_divide(pipi_image_t *, pipi_image_t *);
pipi_image_t *pipi_screen(pipi_image_t *, pipi_image_t *);
pipi_image_t *pipi_overlay(pipi_image_t *, pipi_image_t *);

pipi_image_t *pipi_convolution(pipi_image_t *, int, int, double[]);
pipi_image_t *pipi_gaussian_blur(pipi_image_t *, float);
pipi_image_t *pipi_gaussian_blur_ext(pipi_image_t *,
                                            float, float, float, float, float);
pipi_image_t *pipi_box_blur(pipi_image_t *, int);
pipi_image_t *pipi_box_blur_ext(pipi_image_t *, int, int);
pipi_image_t *pipi_brightness(pipi_image_t *, double);
pipi_image_t *pipi_contrast(pipi_image_t *, double);
pipi_image_t *pipi_autocontrast(pipi_image_t *);
pipi_image_t *pipi_invert(pipi_image_t *);
pipi_image_t *pipi_threshold(pipi_image_t *, double);
pipi_image_t *pipi_hflip(pipi_image_t *);
pipi_image_t *pipi_vflip(pipi_image_t *);
pipi_image_t *pipi_rotate(pipi_image_t *, double);
pipi_image_t *pipi_rotate90(pipi_image_t *);
pipi_image_t *pipi_rotate180(pipi_image_t *);
pipi_image_t *pipi_rotate270(pipi_image_t *);
pipi_image_t *pipi_median(pipi_image_t *, int);
pipi_image_t *pipi_median_ext(pipi_image_t *, int, int);
pipi_image_t *pipi_dilate(pipi_image_t *);
pipi_image_t *pipi_erode(pipi_image_t *);
pipi_image_t *pipi_sine(pipi_image_t *, double, double,
                                 double, double);
pipi_image_t *pipi_wave(pipi_image_t *, double, double,
                                 double, double);
pipi_image_t *pipi_rgb2yuv(pipi_image_t *);
pipi_image_t *pipi_yuv2rgb(pipi_image_t *);

pipi_image_t *pipi_order(pipi_image_t *);

pipi_image_t *pipi_tile(pipi_image_t *, int, int);
int pipi_flood_fill(pipi_image_t *,
                           int, int, float, float, float, float);
int pipi_draw_line(pipi_image_t *, int, int, int, int, uint32_t, int);
int pipi_draw_rectangle(pipi_image_t *, int, int, int, int, uint32_t, int);
int pipi_draw_polyline(pipi_image_t *, int const[], int const[],
                              int , uint32_t, int);
int pipi_draw_bezier4(pipi_image_t *,int, int, int, int, int, int, int, int, uint32_t, int, int);
pipi_image_t *pipi_reduce(pipi_image_t *, int, double const *);

pipi_image_t *pipi_dither_ediff(pipi_image_t *, pipi_image_t *,
                                       pipi_scan_t);
pipi_image_t *pipi_dither_ordered(pipi_image_t *, pipi_image_t *);
pipi_image_t *pipi_dither_ordered_ext(pipi_image_t *, pipi_image_t *,
                                             double, double);
pipi_image_t *pipi_dither_halftone(pipi_image_t *, double, double);
pipi_image_t *pipi_dither_random(pipi_image_t *);
pipi_image_t *pipi_dither_ostromoukhov(pipi_image_t *, pipi_scan_t);
pipi_image_t *pipi_dither_dbs(pipi_image_t *);
void pipi_dither_24to16(pipi_image_t *);

pipi_histogram_t* pipi_new_histogram(void);
int pipi_get_image_histogram(pipi_image_t *, pipi_histogram_t *, int);
int pipi_free_histogram(pipi_histogram_t*);
int pipi_render_histogram(pipi_image_t *, pipi_histogram_t*, int);

pipi_sequence_t *pipi_open_sequence(char const *, int, int, int,
                                             int, int, int, int);
int pipi_feed_sequence(pipi_sequence_t *, uint8_t const *, int, int);
int pipi_close_sequence(pipi_sequence_t *);

]]

local Lib_pipi = ffi.load("pipi")

local exports = {
    Lib_pipi = Lib_pipi;

    pipi_get_color_from_string = Lib_pipi.pipi_get_color_from_string;
    pipi_get_version = Lib_pipi.pipi_get_version;
    pipi_create_context = Lib_pipi.pipi_create_context,
    pipi_destroy_context = Lib_pipi.pipi_destroy_context,
    pipi_get_command_list = Lib_pipi.pipi_get_command_list,
    pipi_command = Lib_pipi.pipi_command,
--pipi_get_tile = Lib_pipi.pipi_get_tile,
--pipi_release_tile = Lib_pipi.pipi_release_tile,
--pipi_create_tile = Lib_pipi.pipi_create_tile,
    pipi_load = Lib_pipi.pipi_load,
    pipi_load_stock = Lib_pipi.pipi_load_stock,
    pipi_new = Lib_pipi.pipi_new,
    pipi_copy = Lib_pipi.pipi_copy,
    pipi_free = Lib_pipi.pipi_free,
    pipi_save = Lib_pipi.pipi_save,
    pipi_set_gamma = Lib_pipi.pipi_set_gamma, 
    pipi_get_pixels = Lib_pipi.pipi_get_pixels,
    pipi_release_pixels = Lib_pipi.pipi_release_pixels,
    pipi_set_colorspace = Lib_pipi.pipi_set_colorspace,
    pipi_get_image_width = Lib_pipi.pipi_get_image_width,
    pipi_get_image_height = Lib_pipi.pipi_get_image_height,
    pipi_get_image_pitch = Lib_pipi.pipi_get_image_pitch,
    pipi_get_image_last_modified = Lib_pipi.pipi_get_image_last_modified,
    pipi_get_format_name = Lib_pipi.pipi_get_format_name,

    pipi_measure_msd = Lib_pipi.pipi_measure_msd,
    pipi_measure_rmsd = Lib_pipi.pipi_measure_rmsd,

    pipi_resize_bresenham = Lib_pipi.pipi_resize_bresenham,
    pipi_resize_bicubic = Lib_pipi.pipi_resize_bicubic,
    pipi_crop = Lib_pipi.pipi_crop,

    pipi_render_random = Lib_pipi.pipi_render_random,
    pipi_render_bayer = Lib_pipi.pipi_render_bayer,
    pipi_render_halftone = Lib_pipi.pipi_render_halftone,

    pipi_rgb = Lib_pipi.pipi_rgb,
    pipi_red = Lib_pipi.pipi_red,
    pipi_green = Lib_pipi.pipi_green,
    pipi_blue = Lib_pipi.pipi_blue,
    pipi_blit = Lib_pipi.pipi_blit,
    pipi_merge = Lib_pipi.pipi_merge,
    pipi_mean = Lib_pipi.pipi_mean,
    pipi_min = Lib_pipi.pipi_min,
    pipi_max = Lib_pipi.pipi_max,
    pipi_add = Lib_pipi.pipi_add,
    pipi_sub = Lib_pipi.pipi_sub,
    pipi_difference = Lib_pipi.pipi_difference,
    pipi_multiply = Lib_pipi.pipi_multiply,
    pipi_divide = Lib_pipi.pipi_divide,
    pipi_screen = Lib_pipi.pipi_screen,
    pipi_overlay = Lib_pipi.pipi_overlay,

    pipi_convolution = Lib_pipi.pipi_convolution,
    pipi_gaussian_blur = Lib_pipi.pipi_gaussian_blur,
    pipi_gaussian_blur_ext = Lib_pipi.pipi_gaussian_blur_ext,

    pipi_box_blur = Lib_pipi.pipi_box_blur,
    pipi_box_blur_ext = Lib_pipi.pipi_box_blur_ext,
    pipi_brightness = Lib_pipi.pipi_brightness,
    pipi_contrast = Lib_pipi.pipi_contrast,
    pipi_autocontrast = Lib_pipi.pipi_autocontrast,
    pipi_invert = Lib_pipi.pipi_invert,
    pipi_threshold = Lib_pipi.pipi_threshold,
    pipi_hflip = Lib_pipi.pipi_hflip,
    pipi_vflip = Lib_pipi.pipi_vflip,
    pipi_rotate = Lib_pipi.pipi_rotate,
    pipi_rotate90 = Lib_pipi.pipi_rotate90,
    pipi_rotate180 = Lib_pipi.pipi_rotate180,
    pipi_rotate270 = Lib_pipi.pipi_rotate270,
    pipi_median = Lib_pipi.pipi_median,
    pipi_median_ext = Lib_pipi.pipi_median_ext,
    pipi_dilate = Lib_pipi.pipi_dilate,
    pipi_erode = Lib_pipi.pipi_erode,
    pipi_sine = Lib_pipi.pipi_sine,

    pipi_wave = Lib_pipi.pipi_wave,

    pipi_rgb2yuv = Lib_pipi.pipi_rgb2yuv,
    pipi_yuv2rgb = Lib_pipi.pipi_yuv2rgb,

    pipi_order = Lib_pipi.pipi_order,

    pipi_tile = Lib_pipi.pipi_tile,
    pipi_flood_fill = Lib_pipi.pipi_flood_fill,

    pipi_draw_line = Lib_pipi.pipi_draw_line,
    pipi_draw_rectangle = Lib_pipi.pipi_draw_rectangle,
    pipi_draw_polyline = Lib_pipi.pipi_draw_polyline,
    pipi_draw_bezier4 = Lib_pipi.pipi_draw_bezier4,
    pipi_reduce = Lib_pipi.pipi_reduce,

    pipi_dither_ediff = Lib_pipi.pipi_dither_ediff,
    pipi_dither_ordered = Lib_pipi.pipi_dither_ordered,
    pipi_dither_ordered_ext = Lib_pipi.pipi_dither_ordered_ext,
    pipi_dither_halftone = Lib_pipi.pipi_dither_halftone,
    pipi_dither_random = Lib_pipi.pipi_dither_random,
    pipi_dither_ostromoukhov = Lib_pipi.pipi_dither_ostromoukhov,
    pipi_dither_dbs = Lib_pipi.pipi_dither_dbs,
    pipi_dither_24to16 = Lib_pipi.pipi_dither_24to16,

    pipi_new_histogram = Lib_pipi.pipi_new_histogram,
    pipi_get_image_histogram = Lib_pipi.pipi_get_image_histogram,
    pipi_free_histogram = Lib_pipi.pipi_free_histogram,
    pipi_render_histogram = Lib_pipi.pipi_render_histogram,

    pipi_open_sequence = Lib_pipi.pipi_open_sequence,
    pipi_feed_sequence = Lib_pipi.pipi_feed_sequence,
    pipi_close_sequence = Lib_pipi.pipi_close_sequence,
}


setmetatable(exports, {
    __call = function(self, ...)
        for k,v in pairs(exports) do
            _G[k] = v;
        end

        return self;
    end,
})

return exports
