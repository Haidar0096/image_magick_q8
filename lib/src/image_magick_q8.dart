// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:developer';

import 'package:ffi/ffi.dart';
import 'extensions.dart';
import 'magick_wand_bindings_generated.dart'
    as mwbg;
import 'plugin_bindings_generated.dart' as pbg;

part 'magick_wand.dart';

part 'magick_wand_helpers.dart';

part 'drawing_wand.dart';

part 'drawing_wand_helpers.dart';

part 'affine_matrix.dart';

part 'point_info.dart';

part 'segment_info.dart';

part 'type_metric.dart';

part 'pixel_wand.dart';

part 'pixel_wand_helpers.dart';

part 'pixel_info.dart';

part 'magick_enums.dart';

part 'magick_global_methods.dart';

part 'kernel_info.dart';

part 'magick_compute.dart';

part 'channel_features.dart';

part 'channel_statistics.dart';

part 'pixel_iterator.dart';

part 'pixel_iterator_helpers.dart';

typedef _PluginFfiBindings = pbg.PluginFfiBindings;
typedef _MagickWandFfiBindings = mwbg.MagickWandFfiBindings;

const String _pluginLibName = 'image_magick_ffi';

const String _magickWandWindowsLibName = 'CORE_RL_MagickWand_';

DynamicLibrary _openDynamicLibrary(String libName) {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$libName.framework/$libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}

/// The dynamic libraries in which the symbols for [_PluginFfiBindings] can
/// be found.
final DynamicLibrary _pluginLibraryDylib = _openDynamicLibrary(_pluginLibName);

/// The dynamic libraries in which the symbols for [_MagickWandFfiBindings] can
/// be found.
final DynamicLibrary _magickWandDylib = Platform.isWindows
    ? _openDynamicLibrary(_magickWandWindowsLibName)
    : _pluginLibraryDylib;

/// The bindings to the native functions in [_pluginLibraryDylib].
final _PluginFfiBindings _pluginBindings =
    _PluginFfiBindings(_pluginLibraryDylib);

/// The bindings to the native functions in [_magickWandDylib].
final _MagickWandFfiBindings _magickWandBindings =
    _MagickWandFfiBindings(_magickWandDylib);

class ImageMagickFFIPlugin {
  /// This method is called automatically to initialize the plugin.
  ///
  /// Do not call this method manually.
  static void registerWith() =>
      initializeImageMagick(); // initialize the plugin
}
