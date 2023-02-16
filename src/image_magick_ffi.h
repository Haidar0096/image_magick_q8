#pragma once

#include <stdlib.h>

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

/*############################################ Dart Sdk Api ############################################*/
FFI_PLUGIN_EXPORT intptr_t initDartAPI(void *data);
/*############################################ Dart Sdk Api ############################################*/


/*############################################ ImageMagick ############################################*/
FFI_PLUGIN_EXPORT intptr_t *magickSetProgressMonitorPort(void *wand, intptr_t sendPort);
/*############################################ ImageMagick ############################################*/