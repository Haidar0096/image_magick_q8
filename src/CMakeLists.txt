# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(image_magick_ffi_library VERSION 0.0.1 LANGUAGES C)

add_library(image_magick_q8 SHARED
        "image_magick_ffi.c"
        )

set_target_properties(image_magick_q8 PROPERTIES
        PUBLIC_HEADER image_magick_ffi.h
        OUTPUT_NAME "image_magick_ffi"
        )

target_compile_definitions(image_magick_q8 PUBLIC DART_SHARED_LIB)

# Check if non-supported platforms are being used
if (ANDROID)
    if (${ANDROID_ABI} STREQUAL "arm64-v8a")
        set(dir arm64-v8a)
    else ()
        message(FATAL_ERROR "Only arm64-v8a is supported for android at the moment")
    endif ()
endif ()

# Include FetchContent module to download dependencies at configure time.
include(FetchContent)

################################### Dart Sdk Api ###################################

# Download the zipped folder of dart-sdk-api from the dependencies repo
set(dart_sdk_api_zip_url "https://github.com/Haidar0096/image_magick_ffi_deps/raw/master/dart_sdk_api.zip")
message(STATUS "Downloading dart-sdk-api from ${dart_sdk_api_zip_url}")
FetchContent_Declare(
        dart_sdk_api
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        URL "${dart_sdk_api_zip_url}"
)
FetchContent_MakeAvailable(dart_sdk_api)

# Fail if the download failed
if (NOT EXISTS ${dart_sdk_api_SOURCE_DIR})
    message(FATAL_ERROR "Failed to download dart-sdk-api from ${dart_sdk_api_zip_url}")
endif ()

# Include the include folder of dart_sdk_api from the downloaded zip
include_directories(${dart_sdk_api_SOURCE_DIR}/include)

# Create a target from the sources of the downloaded zip and link it to the executable
file(GLOB_RECURSE DART_SDK_API_SOURCES "${dart_sdk_api_SOURCE_DIR}/src/*.c")
add_library(dart_sdk_api STATIC ${DART_SDK_API_SOURCES})
target_link_libraries(image_magick_q8 dart_sdk_api)

################################### Dart Sdk Api ###################################

################################### Json-C ###################################
# Download the zipped include folder of json-c from the dependencies repo
if (WIN32)
    set(json_c_zip_url "https://github.com/Haidar0096/image_magick_ffi_deps/raw/master/json-c/windows.zip")
elseif (ANDROID)
    set(json_c_zip_url "https://github.com/Haidar0096/image_magick_ffi_deps/raw/master/json-c/arm64-v8a.zip")
endif ()
message(STATUS "Downloading json-c from ${json_c_zip_url}")
FetchContent_Declare(
        json-c
        DOWNLOAD_EXTRACT_TIMESTAMP TRUE
        URL ${json_c_zip_url}
)
FetchContent_MakeAvailable(json-c)

# Fail if the download failed
if (NOT EXISTS ${json-c_SOURCE_DIR})
    message(FATAL_ERROR "Failed to download json-c from ${json_c_zip_url}")
endif ()

# Include the include folder of json-c from the downloaded zip
include_directories(${json-c_SOURCE_DIR}/include)

if (WIN32)
    # Create a target from the sources of the downloaded zip and link it to the executable
    file(GLOB_RECURSE json-c-src ${json-c_SOURCE_DIR}/src/*.c)
    add_library(json-c-lib ${json-c-src})
    target_link_libraries(image_magick_q8 json-c-lib)
elseif (ANDROID)
    # Create a target from the sources of the downloaded zip and link it to the executable
    add_library(json-c-lib SHARED IMPORTED)
    set_target_properties(json-c-lib PROPERTIES IMPORTED_LOCATION ${json-c_SOURCE_DIR}/bin/libjson-c.so)
    target_link_libraries(image_magick_q8 json-c-lib)
endif ()


################################### Json-C ###################################

################################### Image Magick ###################################
macro(setDir dir)
  set(dir ${dir}/Q8)
endmacro()

macro(downloadImageMagick dir downloadedContentName)
    # Download the zipped folder of ImageMagick from the dependencies repo
    set(image_magick_zip_url "https://github.com/Haidar0096/image_magick_ffi_deps/raw/master/ImageMagick/${dir}.zip")
    message(STATUS "Downloading ImageMagick from ${image_magick_zip_url}")
    FetchContent_Declare(
            ${downloadedContentName}
            DOWNLOAD_EXTRACT_TIMESTAMP TRUE
            URL ${image_magick_zip_url}
    )
    FetchContent_MakeAvailable(${downloadedContentName})
endmacro()

# Set MAGICKCORE_QUANTUM_DEPTH and MAGICKCORE_HDRI_ENABLE flags
add_definitions(-DMAGICKCORE_QUANTUM_DEPTH=8 -DMAGICKCORE_HDRI_ENABLE=0)

# Download the zipped folder of ImageMagick from the dependencies repo and link it
if (WIN32)
    if (CMAKE_SIZEOF_VOID_P EQUAL 8)
        # 64 bits
        set(dir x64)
    elseif (CMAKE_SIZEOF_VOID_P EQUAL 4)
        # 32 bits
        set(dir x86)
    endif ()

    setDir(${dir})

    # Download ImageMagick from the dependencies repo
    downloadImageMagick(${dir} imagemagick-windows)

    # Fail if the download failed
    if (NOT EXISTS ${imagemagick-windows_SOURCE_DIR})
        message(FATAL_ERROR "Failed to download ImageMagick from ${image_magick_zip_url}")
    endif ()

    # Include the include folder of ImageMagick from the downloaded zip
    include_directories(${imagemagick-windows_SOURCE_DIR}/include)

    # Link the ImageMagick libs from the downloaded zip to the executable
    file(GLOB_RECURSE ImageMagick-libs ${imagemagick-windows_SOURCE_DIR}/lib/*.lib)
    target_link_libraries(image_magick_q8 ${ImageMagick-libs})

    # Set the path to the ImageMagick dlls as a cache entry to be used in windows/CMakeLists.txt
    set(ImageMagick-dlls ${imagemagick-windows_SOURCE_DIR}/bin CACHE PATH "Path to ImageMagick dlls")

elseif (ANDROID)
    setDir(${dir})

    # Download ImageMagick from the dependencies repo
    downloadImageMagick(${dir} imagemagick-arm64-v8a)

    # Fail if the download failed
    if (NOT EXISTS ${imagemagick-arm64-v8a_SOURCE_DIR})
        message(FATAL_ERROR "Failed to download ImageMagick from ${image_magick_zip_url}")
    endif ()

    # Include the include folder of ImageMagick from the downloaded zip
    include_directories(${imagemagick-arm64-v8a_SOURCE_DIR}/include)

    # MagickCore
    add_library(magickcore SHARED IMPORTED)
    set_target_properties(magickcore PROPERTIES IMPORTED_LOCATION ${imagemagick-arm64-v8a_SOURCE_DIR}/bin/libmagickcore-7.so)
    target_link_libraries(image_magick_q8 magickcore)

    # MagickWand
    add_library(magickwand SHARED IMPORTED)
    set_target_properties(magickwand PROPERTIES IMPORTED_LOCATION ${imagemagick-arm64-v8a_SOURCE_DIR}/bin/libmagickwand-7.so)
    target_link_libraries(image_magick_q8 magickwand)

    # libomp
    add_library(omp SHARED IMPORTED)
    set_target_properties(omp PROPERTIES IMPORTED_LOCATION ${imagemagick-arm64-v8a_SOURCE_DIR}/bin/libomp.so)
    target_link_libraries(image_magick_q8 omp)

    # libc++_shared
    add_library(cxx_shared SHARED IMPORTED)
    set_target_properties(cxx_shared PROPERTIES IMPORTED_LOCATION ${imagemagick-arm64-v8a_SOURCE_DIR}/bin/libc++_shared.so)
    target_link_libraries(image_magick_q8 cxx_shared)

    # android log lib
    find_library(log-lib log)
    target_link_libraries(image_magick_q8 ${log-lib})
endif ()
################################### Image Magick ###################################