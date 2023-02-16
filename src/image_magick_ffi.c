#include "image_magick_ffi.h"
#include <MagickWand/MagickWand.h>
#include "dart_api_dl.h"
#include <json.h>

/*########################################## Dart Sdk Api ############################################*/
FFI_PLUGIN_EXPORT intptr_t initDartAPI(void *data) {
    return Dart_InitializeApiDL(data);
}
/*########################################## Dart Sdk Api ############################################*/


/*########################################## Image Magick ############################################*/

json_object *progressInfoToJsonObject(const char *text, const MagickOffsetType offset, const MagickSizeType size) {
    const char *infoKey = "info";
    const char *sizeKey = "size";
    const char *offsetKey = "offset";

    json_object *jobj = json_object_new_object();
    json_object_object_add(jobj, infoKey, json_object_new_string(text));
    json_object_object_add(jobj, sizeKey, json_object_new_uint64(size));
    json_object_object_add(jobj, offsetKey, json_object_new_int64(offset));
    return jobj;
}

MagickBooleanType
progressMonitor(const char *text, const MagickOffsetType offset, const MagickSizeType size, void *clientData) {
    json_object *jobj = progressInfoToJsonObject(text, offset, size);
    intptr_t sendPort = *((intptr_t *) clientData);
    Dart_CObject *message = malloc(sizeof *message);
    message->type = Dart_CObject_kString;
    message->value.as_string = json_object_to_json_string_ext(jobj,
                                                              JSON_C_TO_STRING_PRETTY); // TODO: update the dart sdk to remove the warning here
    Dart_PostCObject_DL(sendPort, message);
    json_object_put(jobj);
    free(message);
    return MagickTrue; // TODO: find a way to get the dart's method return value and return it here to support canceling
}


FFI_PLUGIN_EXPORT intptr_t *magickSetProgressMonitorPort(void *wand, intptr_t sendPort) {
    intptr_t *sendPortPtr = malloc(sizeof *sendPortPtr);
    *sendPortPtr = sendPort;
    MagickSetProgressMonitor((MagickWand *) wand, progressMonitor, sendPortPtr);
    return sendPortPtr;
}

/*########################################## Image Magick ############################################*/