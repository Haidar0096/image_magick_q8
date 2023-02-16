# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(image_magick_q8_library VERSION 0.0.1 LANGUAGES C)

add_library(image_magick_q8 SHARED
  "image_magick_q8.c"
)

set_target_properties(image_magick_q8 PROPERTIES
  PUBLIC_HEADER image_magick_q8.h
  OUTPUT_NAME "image_magick_q8"
)

target_compile_definitions(image_magick_q8 PUBLIC DART_SHARED_LIB)
