# Table Of Contents

- [Table Of Contents](#table-of-contents)
- [Contributors](#contributors)
- [ImageMagickFFI Plugin](#imagemagickffi-plugin)
  - [Feel Native](#feel-native)
  - [What Can It Do?](#what-can-it-do)
- [Variants](#variants)
- [Usage](#usage)
  - [In a Flutter app:](#in-a-flutter-app)
    - [Initialize a MagickWand](#initialize-a-magickwand)
    - [Use the MagickWand](#use-the-magickwand)
    - [Dispose the MagickWand and the plugin](#dispose-the-magickwand-and-the-plugin)
  - [In a pure Dart app:](#in-a-pure-dart-app)
  - [Learn how to use the plugin](#learn-how-to-use-the-plugin)
- [Contributing](#contributing)
- [Want to say thanks?](#want-to-say-thanks)

# Contributors

Special thanks to [Piero5W11](https://github.com/Piero512) for being the "FFI Master" and helping me
a lot with this plugin.

# ImageMagickFFI Plugin

This plugin brings to you the [ImageMagick](https://imagemagick.org/) C
library [MagickWand](https://imagemagick.org/script/magick-wand.php) to use with dart.

## Feel Native

Interact with the underlying ImageMagick C api just as you used to do in C (not with pointers, of
course 🙂).

## What Can It Do?

Here are some of the things you can do with this plugin, along with the  names of the functions that you can use to do them.

 Have a look the [#Usage](#usage) section below for more insights.   
![ImageMagick](https://imagemagick.org/image/examples.jpg)

# Variants
This plugin provides the Q8 variant of ImageMagick only. If you want to use another variant, then use the corresponding package for that variant.
- ### Windows
  Windows x64 (32 bits) and window x86 (32 bits) are both supported.
- ### Android
    Currently only arm64-v8a (64 bits) is supported. If you want to help add support to armeabi-v7a (
    32 bits), have a look [here](https://github.com/MolotovCherry/Android-ImageMagick7/discussions/95)
    .

  Also note that you might need to get write permissions from the system  
  for some operations as writing an image.

- #### Linux
  Coming Soon.
- #### Macos
  Your contributions to provide the binaries are welcomed.
- #### IOS
  Your contributions to provide the binaries are welcomed,

# Usage
## In a Flutter app:

### Initialize a MagickWand

```dart
  @override
  void initState() {
    _wand = MagickWand.newMagickWand(); // create a MagickWand to edit images

    // set a callback to be called when image processing progress changes
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async => await _wand.magickSetProgressMonitor(
        (info, offset, size, clientData) => setState(() =>
            status = '[${info.split('/').first}, $offset, $size, $clientData]'),
      ),
    );

    super.initState();
  }
```

### Use the MagickWand

```dart
  // read an image, do some operations on it, then save it
Future<String> _handlePress() async {
  try {
    setState(() => isLoading = true);

    String? result;

    await _wand.magickReadImage(_inputFile!.path); // read the image
    _throwWandExceptionIfExists(_wand);

    ///////////////////////// Do Some Operations On The Wand /////////////////////////

    // resize the image
    await _wand.magickAdaptiveResizeImage(1200, 800);
    _throwWandExceptionIfExists(_wand);
    // flip the image
    await _wand.magickFlipImage();
    _throwWandExceptionIfExists(_wand);
    // enhance the image
    await _wand.magickEnhanceImage();
    _throwWandExceptionIfExists(_wand);
    // add noise to the image
    await _wand.magickAddNoiseImage(NoiseType.GaussianNoise, 1.5);
    _throwWandExceptionIfExists(_wand);

    /////////////////////////////////////////////////////////////////////////////////

    String outputFilePath = _getOutputFilePath();

    await _wand.magickWriteImage(
            outputFilePath); // write the image to a file
    _throwWandExceptionIfExists(_wand);

    _outputFile = File(outputFilePath);
    isLoading = false;
    return result ?? 'Operation Successful!';
  } catch (e) {
    _outputFile = null;
    isLoading = false;
    return 'Error: ${e.toString()}';
  }
}

String _getOutputFilePath() {
  final String ps = Platform.pathSeparator;
  final String inputFileNameWithoutExtension =
          _inputFile!.path.split(ps).last.split('.').first;
  final String outputFilePath =
          '${_outputDirectory!.path}${ps}out_$inputFileNameWithoutExtension.png';
  return outputFilePath;
}

void _throwWandExceptionIfExists(MagickWand wand) {
  MagickGetExceptionResult e =
  _wand.magickGetException(); // get the exception if any
  if (e.severity != ExceptionType.UndefinedException) {
    throw e;
  }
}
```   

### Dispose the MagickWand and the plugin

```dart
@override
dispose() {
  _wand.destroyMagickWand(); // we are done with the wand 
  disposeImageMagick(); // we are done with the whole plugin
  super.dispose();
}
```

## In a pure Dart app:
- Depend on the plugin in your `pubspec.yaml` just as any other package.
- You then have to copy the dependencies (.lib files, .dll files) manually to the same path as your executable (unfortunately, this is how it is done now in dart). To get these dependencies, you can build a flutter app then copy the dependencies from there.

Then you can use the plugin normally, for ex:
```dart
import 'dart:io';
import 'package:image_magick_ffi/image_magick_ffi.dart';

Future<void> main(List<String> arguments) async {
  final File inputFile1 = File("D:\\magick\\Screenshot.png");
  final File inputFile2 = File("D:\\magick\\fayruz_love.png");
  final File inputFile3 = File("D:\\magick\\untitled.png");

  print('Magick Dart App Started!');

  initializeImageMagick(); // initialize the plugin

  MagickWand wand1 = MagickWand.newMagickWand(); // create a MagickWand
  MagickWand wand2 = MagickWand.newMagickWand(); // create a MagickWand

  // await setProgressMonitor(wand1, 'wand1');
  // throwWandExceptionIfExists(wand1);
  //
  // await setProgressMonitor(wand2, 'wand2');
  // throwWandExceptionIfExists(wand2);

  await wand1.magickReadImage(inputFile3.path);
  throwWandExceptionIfExists(wand1);

  await wand2.magickReadImage(inputFile2.path);
  throwWandExceptionIfExists(wand2);

  Stopwatch stopwatch = Stopwatch()..start();
  ///////////////////////////////// Use MagickWand here /////////////////////////////////
  final imagePage =
      wand1.magickGetImagePage(); // get the dimensions of the image
  throwWandExceptionIfExists(wand1);

  final int width = imagePage!.width;
  final int height = imagePage.height;
  final int x = 0;
  final int y = 0;

  final cropWand = await wand1.magickGetImageRegion(
    width: width ~/ 2,
    height: height ~/ 2,
    x: x,
    y: y,
  ); // crop the image into a new wand

  await cropWand!.magickWriteImage(getOutputFilePath(inputFile1.path));
  throwWandExceptionIfExists(wand2);

  ///////////////////////////////// Use MagickWand here /////////////////////////////////
  print('elapsed time: ${stopwatch.elapsedMilliseconds} millis');

  await wand1.destroyMagickWand(); // dispose the MagickWand
  await wand2.destroyMagickWand(); // dispose the MagickWand
  await cropWand.destroyMagickWand(); // dispose the MagickWand

  disposeImageMagick(); // dispose the plugin

  print('Magick Dart App Ended!');
}

String getOutputFilePath(String inputFilePath) {
  final String outputFilePath = inputFilePath.replaceAll(
      RegExp(r'\.(png|jpg|jpeg|gif|bmp|tiff|tif|webp|pdf|ps|eps|svg|ico)$'),
      '_output.png');
  return outputFilePath;
}

Future<void> setProgressMonitor(MagickWand wand, [String? wandName]) async {
  await wand.magickSetProgressMonitor((info, offset, size, clientData) {
    print('[${wandName ?? 'unnamed wand'}] $info, $offset, $size, $clientData');
  });
}

void throwWandExceptionIfExists(MagickWand wand) {
  final exception = wand.magickGetException();
  if (exception.severity != ExceptionType.UndefinedException) {
    throw Exception(
        'An exception occurred with the wand: ${exception.description}');
  }
}
```

## Learn how to use the plugin
- For more info about code usage, have a look at the example app in this repo, there is a complete working app there that is ready for you to play around with.
- Also check out
  - [The official ImageMagick website](https://imagemagick.org/).
  - [ImageMagick usage documentation](https://imagemagick.org/Usage/).
  - Fred's ImageMagick scripts (you can find them in the links above).
  - Snibgo's examples (you can find them in the links above).

# Contributing

- Feel free to open an issue if you have any problem or suggestion.
- Feel free to open a pull request if you want to contribute.

# Want to say thanks?
[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/haidarmehsen)
