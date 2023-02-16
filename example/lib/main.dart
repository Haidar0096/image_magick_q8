// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_magick_q8/image_magick_q8.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _inputFile;
  Directory? _outputDirectory;
  File? _outputFile;
  bool isLoading = false;

  int? _progress;
  int? _maxProgress;

  String status = 'Idle';

  int? _operationTimeInMillis;

  late MagickWand _wand;

  @override
  void initState() {
    _wand = MagickWand.newMagickWand(); // create a MagickWand to edit images

    final File file = File("D:\\magick\\screenshot.png");
    if (file.existsSync()) {
      _inputFile = file;
    }

    Directory directory = Directory("D:\\magick");
    if (directory.existsSync()) {
      _outputDirectory = directory;
    }

    // set a callback to be called when image processing progress changes
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async => await _wand.magickSetProgressMonitor(
        (info, offset, size, clientData) => setState(() {
          _progress = offset;
          _maxProgress = size;
          status = '[${info.split('/').first}, $offset, $size, $clientData]';
        }),
      ),
    );

    super.initState();
  }

  @override
  dispose() {
    _wand.destroyMagickWand(); // we are done with the wand
    disposeImageMagick(); // we are done with the whole plugin
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Builder(builder: (context) {
          final double displayImageWidth =
              MediaQuery.of(context).size.width / 2.5;
          final double displayImageHeight =
              MediaQuery.of(context).size.height / 2.5;
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const Text("Input Image",
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(
                                  width: displayImageWidth,
                                  height: displayImageHeight / 2.5,
                                  child: _inputFile != null
                                      ? Text(
                                          _inputFile!.path,
                                          textAlign: TextAlign.center,
                                        )
                                      : const Text(
                                          "No file selected",
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                                _inputFile != null
                                    ? Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                        child: Image.file(
                                          _inputFile!,
                                          width: displayImageWidth,
                                          height: displayImageHeight,
                                        ),
                                      )
                                    : Container(
                                        width: displayImageWidth,
                                        height: displayImageHeight,
                                        color: Colors.grey,
                                        child: const Center(
                                            child: Text('No image selected')),
                                      ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              children: [
                                const Text("Output Image",
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(
                                  width: displayImageWidth,
                                  height: displayImageHeight / 2.5,
                                  child: _outputFile != null
                                      ? Text(
                                          _outputFile!.path,
                                          textAlign: TextAlign.center,
                                        )
                                      : const Text(
                                          "No file selected",
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                                _outputFile != null
                                    ? Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                        child: Image.memory(
                                          _outputFile!.readAsBytesSync(),
                                          width: displayImageWidth,
                                          height: displayImageHeight,
                                        ),
                                      )
                                    : Container(
                                        width: displayImageWidth,
                                        height: displayImageHeight,
                                        color: Colors.grey,
                                        child: const Center(
                                            child: Text('No image selected')),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'Status: $status',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Operation time: ${_operationTimeInMillis ?? 0} ms',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final filePickerResult = await FilePicker.platform
                                .pickFiles(
                                    allowedExtensions: ['jpg', 'jpeg', 'png'],
                                    type: FileType.custom);
                            if (filePickerResult != null) {
                              setState(() {
                                _inputFile =
                                    File(filePickerResult.files[0].path!);
                              });
                            }
                          },
                          child: const Text('pick input image'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final directoryPickerResult =
                                await FilePicker.platform.getDirectoryPath();
                            if (directoryPickerResult != null) {
                              setState(() {
                                _outputDirectory =
                                    Directory(directoryPickerResult);
                              });
                            }
                          },
                          child: const Text('pick output directory'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_inputFile == null) {
                                setState(() {
                                  status = 'Error: input file is null';
                                });
                                return;
                              }
                              if (_outputDirectory == null) {
                                setState(() {
                                  status = 'Error: output directory is null';
                                });
                                return;
                              }
                              // request permission if not granted
                              if (!await Permission.storage
                                  .request()
                                  .isGranted) {
                                setState(() {
                                  status =
                                      'Error: storage permission is not granted';
                                });
                                return;
                              }
                              final stopwatch = Stopwatch()..start();
                              status = await _handlePress();
                              stopwatch.stop();
                              print(
                                  "operation time: ${stopwatch.elapsedMilliseconds}ms");
                              _operationTimeInMillis =
                                  stopwatch.elapsedMilliseconds;
                              setState(() {});
                            },
                      child: const Text('Start Processing'),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: displayImageHeight / 9,
                      width: MediaQuery.of(context).size.width / 2,
                      child: isLoading
                          ? LinearProgressIndicator(
                              value: (_progress ?? 0) / (_maxProgress ?? 1),
                              color: Colors.blue,
                              backgroundColor: Colors.grey,
                            )
                          : Container(),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      );

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
          outputFilePath); // write the image to a file in the png format
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
}
