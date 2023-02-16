part of 'image_magick_q8.dart';

/// Signature for a callback to be called when an operation's progress changes.
/// - [info] The progress information.
/// - [offset] The offset of the progress.
/// - [size] The total size of the progress.
/// - [clientData] The user-provided data.
typedef MagickProgressMonitor = void Function(
  String info,
  int offset,
  int size,
  dynamic clientData,
);

/// The [MagickWand] can do operations on images like reading, resizing,
/// writing, cropping an image, etc...
///
/// The [MagickWand] can hold reference to multiple images at a point in time,
/// and thus it is an object that has a state. This state controls how the
/// images are treated when you use the wand's methods. You can set the
/// current referenced image by [MagickSetIteratorIndex] or reset it by
/// [MagickResetIterator]. In general the operations called on the wand are done
/// on the image at the current iterator index.
///
/// Initialize an instance of it with [MagickWand.newMagickWand].
/// When done from it, call [destroyMagickWand] to release the resources.
///
/// <li><strong>
/// Never use a [MagickWand] after calling [destroyMagickWand] on it.
/// </strong></li>
/// <li><strong>
/// Some methods of the MagickWand accept params like strings, there is no way
///  to validate what you are going to provide to these params by the plugin
///  itself, it is your responsibility to pass valid values to these params as
/// per the documentation, otherwise an invalid state may be reached and the
///  app may crash.
/// </strong></li>
///
/// - See `https://imagemagick.org/script/magick-wand.php` for more information
/// about the backing C-API.
class MagickWand {
  Pointer<mwbg.MagickWand> _wandPtr;

  /// ReceivePort to receive progress information from the C side.
  ReceivePort? _progressMonitorReceivePort;

  /// Pointer to the send port of [_progressMonitorReceivePort].
  Pointer<IntPtr>? _progressMonitorReceivePortSendPortPtr;

  /// Stream subscription of the stream of [_progressMonitorReceivePort].
  StreamSubscription? _progressMonitorReceivePortStreamSubscription;

  /// Stream subscription of the stream of [_progressMonitorStreamController].
  StreamSubscription? _progressMonitorStreamControllerStreamSubscription;

  /// Used to convert the stream of [_progressMonitorReceivePort] to a broadcast
  /// stream.
  StreamController<dynamic>? _progressMonitorStreamController;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MagickWand &&
          runtimeType == other.runtimeType &&
          _wandPtr == other._wandPtr;

  @override
  int get hashCode => _wandPtr.hashCode;

  MagickWand._(this._wandPtr);

  static MagickWand? _fromAddress(int address) => address == 0
      ? null
      : MagickWand._(Pointer<mwbg.MagickWand>.fromAddress(address));

  /// Clears resources associated with this wand, leaving the wand blank,
  /// and ready to be used for a new set of images.
  void clearMagickWand() => _magickWandBindings.ClearMagickWand(_wandPtr);

  /// Makes an exact copy of this wand.
  ///
  /// {@template magick_wand.do_not_forget_to_destroy_returned_wand}
  /// Don't forget to call [destroyMagickWand] on the returned [MagickWand] when
  /// done.
  /// {@endtemplate}
  MagickWand cloneMagickWand() =>
      MagickWand._(_magickWandBindings.CloneMagickWand(_wandPtr));

  /// Deallocates memory associated with this wand. You can't use the wand after
  /// calling this function.
  Future<void> destroyMagickWand() async {
    _wandPtr = _magickWandBindings.DestroyMagickWand(_wandPtr);

    // clean up the streams and stream subscriptions of the progress monitor
    _progressMonitorReceivePort?.close();
    if (_progressMonitorReceivePortSendPortPtr != null) {
      malloc.free(_progressMonitorReceivePortSendPortPtr!);
    }
    await _progressMonitorReceivePortStreamSubscription?.cancel();
    await _progressMonitorStreamControllerStreamSubscription?.cancel();
    await _progressMonitorStreamController?.close();
  }

  /// Returns true if this wand is verified as a magick wand. For example, after
  /// calling [destroyMagickWand] on this wand, then this method will return
  /// false.
  bool isMagickWand() => _magickWandBindings.IsMagickWand(_wandPtr).toBool();

  /// Clears any exceptions associated with this wand.
  bool magickClearException() =>
      _magickWandBindings.MagickClearException(_wandPtr).toBool();

  /// Returns the severity, reason, and description of any error that occurs
  /// when using other methods with this wand. For example, failure to read an
  /// image using [magickReadImage] will cause an exception to be associated
  /// with this wand and which can be retrieved by this method.
  ///
  /// - Note: if no exception has occurred, `UndefinedExceptionType` is
  /// returned.
  MagickGetExceptionResult magickGetException() => using((Arena arena) {
        final Pointer<Int32> severity = arena();
        final Pointer<Char> description =
            _magickWandBindings.MagickGetException(_wandPtr, severity);
        final MagickGetExceptionResult magickGetExceptionResult =
            MagickGetExceptionResult(
          ExceptionType.fromValue(severity.value),
          description.toNullableString()!,
        );
        _magickRelinquishMemory(description.cast());
        return magickGetExceptionResult;
      });

  /// Returns the exception type associated with this wand.
  /// If no exception has occurred, `UndefinedException` is returned.
  ExceptionType magickGetExceptionType() => ExceptionType.fromValue(
      _magickWandBindings.MagickGetExceptionType(_wandPtr));

  /// Returns the position of the iterator in the image list.
  int magickGetIteratorIndex() =>
      _magickWandBindings.MagickGetIteratorIndex(_wandPtr);

  /// Returns a 13 element array representing the following font metrics:
  ///
  ///     Element Description
  ///     -------------------------------------------------
  ///     0 character width
  ///     1 character height
  ///     2 ascender
  ///     3 descender
  ///     4 text width
  ///     5 text height
  ///     6 maximum horizontal advance
  ///     7 bounding box: x1
  ///     8 bounding box: y1
  ///     9 bounding box: x2
  ///     10 bounding box: y2
  ///     11 origin: x
  ///     12 origin: y
  /// - Note: null is returned if the font metrics cannot be determined from
  /// the given input (for ex: if the [MagickWand] contains no images).
  Float64List? magickQueryFontMetrics(DrawingWand drawingWand, String text) =>
      using((Arena arena) {
        final Pointer<Char> textPtr =
            text.toNativeUtf8(allocator: arena).cast();
        final Pointer<Double> metricsPtr =
            _magickWandBindings.MagickQueryFontMetrics(
          _wandPtr,
          drawingWand._wandPtr,
          textPtr,
        );
        final Float64List? metrics = metricsPtr.toFloat64List(13);
        _magickRelinquishMemory(metricsPtr.cast());
        return metrics;
      });

  /// Returns a 13 element array representing the following font metrics:
  ///
  ///     Element Description
  ///     -------------------------------------------------
  ///     0 character width
  ///     1 character height
  ///     2 ascender
  ///     3 descender
  ///     4 text width
  ///     5 text height
  ///     6 maximum horizontal advance
  ///     7 bounding box: x1
  ///     8 bounding box: y1
  ///     9 bounding box: x2
  ///     10 bounding box: y2
  ///     11 origin: x
  ///     12 origin: y
  /// This method is like magickQueryFontMetrics() but it returns the maximum
  /// text width and height for multiple lines of text.
  /// - Note: null is returned if the font metrics cannot be determined from the
  /// given input (for ex: if the [MagickWand] contains no images).
  Float64List? magickQueryMultilineFontMetrics(
          DrawingWand drawingWand, String text) =>
      using((Arena arena) {
        final Pointer<Char> textPtr =
            text.toNativeUtf8(allocator: arena).cast();
        final Pointer<Double> metricsPtr =
            _magickWandBindings.MagickQueryMultilineFontMetrics(
                _wandPtr, drawingWand._wandPtr, textPtr);
        final Float64List? metrics = metricsPtr.toFloat64List(13);
        _magickRelinquishMemory(metricsPtr.cast());
        return metrics;
      });

  /// Resets the wand iterator.
  ///
  /// It is typically used either before iterating though images, or before
  /// calling specific functions such as `magickAppendImages()` to append all
  /// images together.
  ///
  /// Afterward you can use `magickNextImage()` to iterate over all the images
  /// in a wand container, starting with the first image.
  ///
  /// Using this before `magickAddImages()` or `magickReadImages()` will cause
  /// new images to be inserted between the first and second image.
  void magickResetIterator() =>
      _magickWandBindings.MagickResetIterator(_wandPtr);

  /// Sets the wand iterator to the first image.
  ///
  /// After using any images added to the wand using `magickAddImage()` or
  /// `magickReadImage()` will be prepended before any image in the wand.
  ///
  /// Also the current image has been set to the first image (if any) in the
  /// Magick Wand. Using `magickNextImage()` will then set the current image to
  /// the second image in the list (if present).
  ///
  /// This operation is similar to `magickResetIterator()` but differs in how
  /// `magickAddImage()`, `magickReadImage()`, and magickNextImage()` behaves
  /// afterward.
  void magickSetFirstIterator() =>
      _magickWandBindings.MagickSetFirstIterator(_wandPtr);

  /// Sets the iterator to the given position in the image list specified with
  /// the index parameter. A zero index will set the first image as current,
  /// and so on. Negative indexes can be used to specify an image relative to
  /// the end of the images in the wand, with -1 being the last image in the
  /// wand.
  ///
  /// If the index is invalid (range too large for number of images in wand) the
  /// function will return false, but no 'exception' will be raised, as it is
  /// not actually an error. In that case the current image will not change.
  ///
  /// After using any images added to the wand using `magickAddImage()` or
  /// `magickReadImage()` will be added after the image indexed, regardless of
  /// if a zero (first image in list) or negative index (from end) is used.
  ///
  /// Jumping to index 0 is similar to `magickResetIterator()` but differs in
  /// how `magickNextImage()` behaves afterward.
  bool magickSetIteratorIndex(int index) =>
      _magickWandBindings.MagickSetIteratorIndex(_wandPtr, index).toBool();

  /// Sets the wand iterator to the last image.
  ///
  /// The last image is actually the current image, and the next use of
  /// `magickPreviousImage()` will not change this allowing this function to be
  /// used to iterate over the images in the reverse direction. In this sense
  /// it is more like `magickResetIterator()` than `magickSetFirstIterator()`.
  ///
  /// Typically this function is used before `magickAddImage()`,
  /// `magickReadImage()` functions to ensure' new images are appended to the
  /// very end of wand's image list.
  void magickSetLastIterator() =>
      _magickWandBindings.MagickSetLastIterator(_wandPtr);

  /// Returns a wand required for all other methods in the API.
  /// A fatal exception is thrown if there is not enough memory to allocate the
  /// wand. Use `destroyMagickWand()` to dispose of the wand when it is no
  /// longer needed.
  factory MagickWand.newMagickWand() =>
      MagickWand._(_magickWandBindings.NewMagickWand());

  /// Deletes a wand artifact.
  bool magickDeleteImageArtifact(String artifact) => using(
        (Arena arena) => _magickWandBindings.MagickDeleteImageArtifact(
          _wandPtr,
          artifact.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// Deletes a wand property.
  bool magickDeleteImageProperty(String property) => using(
        (Arena arena) => _magickWandBindings.MagickDeleteImageProperty(
          _wandPtr,
          property.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// Deletes a wand option.
  bool magickDeleteOption(String option) => using(
        (Arena arena) => _magickWandBindings.MagickDeleteOption(
          _wandPtr,
          option.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// Returns the antialias property associated with the wand.
  bool magickGetAntialias() =>
      _magickWandBindings.MagickGetAntialias(_wandPtr).toBool();

  /// Returns the wand background color.
  PixelWand magickGetBackgroundColor() =>
      PixelWand._(_magickWandBindings.MagickGetBackgroundColor(_wandPtr));

  /// Gets the wand colorspace type.
  ColorspaceType magickGetColorspace() =>
      ColorspaceType.values[_magickWandBindings.MagickGetColorspace(_wandPtr)];

  /// Gets the wand compression type.
  CompressionType magickGetCompression() => CompressionType
      .values[_magickWandBindings.MagickGetCompression(_wandPtr)];

  /// Gets the wand compression quality.
  int magickGetCompressionQuality() =>
      _magickWandBindings.MagickGetCompressionQuality(_wandPtr);

  /// Returns the filename associated with an image sequence.
  String magickGetFilename() =>
      _magickWandBindings.MagickGetFilename(_wandPtr).toNullableString()!;

  /// Returns the font associated with the MagickWand.
  String? magickGetFont() {
    final Pointer<Char> fontPtr = _magickWandBindings.MagickGetFont(_wandPtr);
    final String? result = fontPtr.toNullableString();
    _magickRelinquishMemory(fontPtr.cast());
    return result;
  }

  /// Returns the format of the magick wand.
  String magickGetFormat() =>
      _magickWandBindings.MagickGetFormat(_wandPtr).toNullableString()!;

  /// Gets the wand gravity.
  GravityType magickGetGravity() =>
      GravityType.fromValue(_magickWandBindings.MagickGetGravity(_wandPtr));

  /// Returns a value associated with the specified artifact.
  String? magickGetImageArtifact(String artifact) => using((Arena arena) {
        final Pointer<Char> artifactPtr =
            artifact.toNativeUtf8(allocator: arena).cast();
        final Pointer<Char> resultPtr =
            _magickWandBindings.MagickGetImageArtifact(_wandPtr, artifactPtr);
        final String? result = resultPtr.toNullableString();
        _magickRelinquishMemory(resultPtr.cast());
        return result;
      });

  /// Returns all the artifact names that match the specified pattern associated
  /// with a wand. Use `magickGetImageProperty()` to return the value of a
  /// particular artifact.
  List<String>? magickGetImageArtifacts(String pattern) => using((Arena arena) {
        final Pointer<Char> patternPtr =
            pattern.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> numArtifactsPtr = arena();
        final Pointer<Pointer<Char>> artifactsPtr =
            _magickWandBindings.MagickGetImageArtifacts(
                _wandPtr, patternPtr, numArtifactsPtr);
        final int numArtifacts = numArtifactsPtr.value;
        final List<String>? result = artifactsPtr.toStringList(numArtifacts);
        _magickRelinquishMemory(artifactsPtr.cast());
        return result;
      });

  /// Returns the named image profile.
  Uint8List? magickGetImageProfile(String name) => using((Arena arena) {
        final Pointer<Char> namePtr =
            name.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> lengthPtr = arena();
        final Pointer<UnsignedChar> profilePtr =
            _magickWandBindings.MagickGetImageProfile(
                _wandPtr, namePtr, lengthPtr);
        final Uint8List? profile = profilePtr.toUint8List(lengthPtr.value);
        _magickRelinquishMemory(profilePtr.cast());
        return profile;
      });

  /// MagickGetImageProfiles() returns all the profile names that match the
  /// specified pattern associated with a wand. Use `magickGetImageProfile()`
  /// to return the value of a particular property.
  /// - Note: An empty list is returned if there are no results.
  List<String>? magickGetImageProfiles(String pattern) => using((Arena arena) {
        final Pointer<Char> patternPtr =
            pattern.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> numProfilesPtr = arena();
        final Pointer<Pointer<Char>> profilesPtr =
            _magickWandBindings.MagickGetImageProfiles(
                _wandPtr, patternPtr, numProfilesPtr);
        final int numProfiles = numProfilesPtr.value;
        final List<String>? result = profilesPtr.toStringList(numProfiles);
        _magickRelinquishMemory(profilesPtr.cast());
        return result;
      });

  /// Returns a value associated with the specified property.
  String? magickGetImageProperty(String property) => using((Arena arena) {
        final Pointer<Char> propertyPtr =
            property.toNativeUtf8(allocator: arena).cast();
        final Pointer<Char> resultPtr =
            _magickWandBindings.MagickGetImageProperty(_wandPtr, propertyPtr);
        final String? result = resultPtr.toNullableString();
        _magickRelinquishMemory(resultPtr.cast());
        return result;
      });

  /// Returns all the property names that match the specified pattern
  /// associated with a wand. Use `magickGetImageProperty()` to return the value
  /// of a particular property.
  List<String>? magickGetImageProperties(String pattern) =>
      using((Arena arena) {
        final Pointer<Char> patternPtr =
            pattern.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> numPropertiesPtr = arena();
        final Pointer<Pointer<Char>> propertiesPtr =
            _magickWandBindings.MagickGetImageProperties(
                _wandPtr, patternPtr, numPropertiesPtr);
        final int numProperties = numPropertiesPtr.value;
        final List<String>? result = propertiesPtr.toStringList(numProperties);
        _magickRelinquishMemory(propertiesPtr.cast());
        return result;
      });

  /// Gets the wand interlace scheme.
  InterlaceType magickGetInterlaceScheme() => InterlaceType
      .values[_magickWandBindings.MagickGetInterlaceScheme(_wandPtr)];

  /// Gets the wand compression.
  PixelInterpolateMethod magickGetInterpolateMethod() => PixelInterpolateMethod
      .values[_magickWandBindings.MagickGetInterpolateMethod(_wandPtr)];

  /// Returns a value associated with a wand and the specified key.
  String? magickGetOption(String key) => using((Arena arena) {
        final Pointer<Char> keyPtr = key.toNativeUtf8(allocator: arena).cast();
        final Pointer<Char> resultPtr =
            _magickWandBindings.MagickGetOption(_wandPtr, keyPtr);
        final String? result = resultPtr.toNullableString();
        _magickRelinquishMemory(resultPtr.cast());
        return result;
      });

  /// Returns all the option names that match the specified pattern associated
  /// with a wand. Use `magickGetOption()` to return the value of a particular
  /// option.
  List<String>? magickGetOptions(String pattern) => using((Arena arena) {
        final Pointer<Char> patternPtr =
            pattern.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> numOptionsPtr = arena();
        final Pointer<Pointer<Char>> optionsPtr =
            _magickWandBindings.MagickGetOptions(
                _wandPtr, patternPtr, numOptionsPtr);
        final int numOptions = numOptionsPtr.value;
        final List<String>? result = optionsPtr.toStringList(numOptions);
        _magickRelinquishMemory(optionsPtr.cast());
        return result;
      });

  /// Gets the wand orientation type.
  OrientationType magickGetOrientation() => OrientationType
      .values[_magickWandBindings.MagickGetOrientation(_wandPtr)];

  /// Returns the page geometry associated with the magick wand.
  MagickGetPageResult? magickGetPage() => using((Arena arena) {
        final Pointer<Size> widthPtr = arena();
        final Pointer<Size> heightPtr = arena();
        final Pointer<mwbg.ssize_t> xPtr = arena();
        final Pointer<mwbg.ssize_t> yPtr = arena();
        final bool result = _magickWandBindings.MagickGetPage(
                _wandPtr, widthPtr, heightPtr, xPtr, yPtr)
            .toBool();
        if (!result) {
          return null;
        }
        return MagickGetPageResult(
            widthPtr.value, heightPtr.value, xPtr.value, yPtr.value);
      });

  /// Returns the font pointsize associated with the MagickWand.
  double magickGetPointsize() =>
      _magickWandBindings.MagickGetPointsize(_wandPtr);

  /// Gets the image X and Y resolution.
  MagickGetResolutionResult? magickGetResolution() => using((Arena arena) {
        final Pointer<Double> xResolutionPtr = arena();
        final Pointer<Double> yResolutionPtr = arena();
        final bool result = _magickWandBindings.MagickGetResolution(
          _wandPtr,
          xResolutionPtr,
          yResolutionPtr,
        ).toBool();
        if (!result) {
          return null;
        }
        return MagickGetResolutionResult(
            xResolutionPtr.value, yResolutionPtr.value);
      });

  /// Gets the horizontal and vertical sampling factor.
  Float64List? magickGetSamplingFactors() => using((Arena arena) {
        final Pointer<Size> numFactorsPtr = arena();
        final Pointer<Double> factorsPtr =
            _magickWandBindings.MagickGetSamplingFactors(
                _wandPtr, numFactorsPtr);
        final int numFactors = numFactorsPtr.value;
        final Float64List? factors = factorsPtr.toFloat64List(numFactors);
        _magickRelinquishMemory(factorsPtr.cast());
        return factors;
      });

  /// Returns the size associated with the magick wand.
  MagickGetSizeResult? magickGetSize() => using((Arena arena) {
        final Pointer<Size> widthPtr = arena();
        final Pointer<Size> heightPtr = arena();
        final bool result =
            _magickWandBindings.MagickGetSize(_wandPtr, widthPtr, heightPtr)
                .toBool();
        if (!result) {
          return null;
        }
        return MagickGetSizeResult(widthPtr.value, heightPtr.value);
      });

  /// Returns the size offset associated with the magick wand.
  int? magickGetSizeOffset() => using((Arena arena) {
        Pointer<mwbg.ssize_t> sizeOffsetPtr = arena();
        final bool result =
            _magickWandBindings.MagickGetSizeOffset(_wandPtr, sizeOffsetPtr)
                .toBool();
        if (!result) {
          return null;
        }
        return sizeOffsetPtr.value;
      });

  /// Returns the wand type
  ImageType magickGetType() =>
      ImageType.values[_magickWandBindings.MagickGetType(_wandPtr)];

  /// Adds or removes a ICC, IPTC, or generic profile from an image. If the
  /// profile is NULL, it is removed from the image otherwise added. Use a name
  /// of '*' and a profile of NULL to remove all profiles from
  /// the image.
  bool magickProfileImage(String name, Uint8List? profile) => using(
        (Arena arena) {
          final Pointer<UnsignedChar> profilePtr =
              profile?.toUnsignedCharArrayPointer(allocator: arena) ?? nullptr;
          final Pointer<Char> namePtr =
              name.toNativeUtf8(allocator: arena).cast();
          return _magickWandBindings.MagickProfileImage(
            _wandPtr,
            namePtr,
            profilePtr.cast(),
            profile?.length ?? 0,
          ).toBool();
        },
      );

  /// Removes the named image profile and returns it.
  Uint8List? magickRemoveImageProfile(String name) => using((Arena arena) {
        final Pointer<Char> namePtr =
            name.toNativeUtf8(allocator: arena).cast();
        final Pointer<Size> lengthPtr = arena();
        final Pointer<UnsignedChar> profilePtr =
            _magickWandBindings.MagickRemoveImageProfile(
                _wandPtr, namePtr, lengthPtr);
        Uint8List? result = profilePtr.toUint8List(lengthPtr.value);
        _magickRelinquishMemory(profilePtr.cast());
        return result;
      });

  ///  Sets the antialias property of the wand.
  bool magickSetAntialias(bool antialias) =>
      _magickWandBindings.MagickSetAntialias(_wandPtr, antialias.toInt())
          .toBool();

  /// Sets the wand background color.
  bool magickSetBackgroundColor(PixelWand pixelWand) =>
      _magickWandBindings.MagickSetBackgroundColor(_wandPtr, pixelWand._wandPtr)
          .toBool();

  /// Sets the wand colorspace type.
  bool magickSetColorspace(ColorspaceType colorspaceType) =>
      _magickWandBindings.MagickSetColorspace(_wandPtr, colorspaceType.index)
          .toBool();

  /// Sets the wand compression type.
  bool magickSetCompression(CompressionType compressionType) =>
      _magickWandBindings.MagickSetCompression(_wandPtr, compressionType.index)
          .toBool();

  /// Sets the wand compression quality.
  bool magickSetCompressionQuality(int quality) =>
      _magickWandBindings.MagickSetCompressionQuality(_wandPtr, quality)
          .toBool();

  /// Sets the wand pixel depth.
  bool magickSetDepth(int depth) =>
      _magickWandBindings.MagickSetDepth(_wandPtr, depth).toBool();

  /// Sets the extract geometry before you read or write an image file. Use it
  /// for inline cropping (e.g. 200x200+0+0) or resizing (e.g.200x200).
  bool magickSetExtract(String geometry) => using(
        (Arena arena) => _magickWandBindings.MagickSetExtract(
          _wandPtr,
          geometry.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// Sets the filename before you read or write an image file.
  bool magickSetFilename(String filename) => using(
        (Arena arena) => _magickWandBindings.MagickSetFilename(
          _wandPtr,
          filename.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// Sets the font associated with the MagickWand.
  bool magickSetFont(String font) => using(
        (Arena arena) => _magickWandBindings.MagickSetFont(
          _wandPtr,
          font.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// Sets the format of the magick wand.
  bool magickSetFormat(String format) => using(
        (Arena arena) => _magickWandBindings.MagickSetFormat(
          _wandPtr,
          format.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// Sets the gravity type.
  bool magickSetGravity(GravityType gravityType) =>
      _magickWandBindings.MagickSetGravity(_wandPtr, gravityType.value)
          .toBool();

  /// Sets a key-value pair in the image artifact namespace. Artifacts differ
  /// from properties. Properties are public and are generally exported to an
  /// external image format if the format supports it. Artifacts are private
  /// and are utilized by the internal ImageMagick API to modify
  /// the behavior of certain algorithms.
  bool magickSetImageArtifact(String key, String value) => using(
        (Arena arena) {
          final Pointer<Char> keyPtr =
              key.toNativeUtf8(allocator: arena).cast();
          final Pointer<Char> valuePtr =
              value.toNativeUtf8(allocator: arena).cast();
          return _magickWandBindings.MagickSetImageArtifact(
              _wandPtr, keyPtr, valuePtr);
        },
      ).toBool();

  /// Adds a named profile to the magick wand. If a profile with the same name
  /// already exists, it is replaced. This method differs from the
  /// MagickProfileImage() method in that it does not apply any CMS color
  /// profiles.
  bool magickSetImageProfile(String name, Uint8List profile) => using(
        (Arena arena) {
          final Pointer<UnsignedChar> profilePtr =
              profile.toUnsignedCharArrayPointer(allocator: arena);
          final Pointer<Char> namePtr =
              name.toNativeUtf8(allocator: arena).cast();
          return _magickWandBindings.MagickSetImageProfile(
            _wandPtr,
            namePtr,
            profilePtr.cast(),
            profile.length,
          );
        },
      ).toBool();

  /// Associates a property with an image.
  bool magickSetImageProperty(String key, String value) => using(
        (Arena arena) {
          final Pointer<Char> keyPtr =
              key.toNativeUtf8(allocator: arena).cast();
          final Pointer<Char> valuePtr =
              value.toNativeUtf8(allocator: arena).cast();
          return _magickWandBindings.MagickSetImageProperty(
              _wandPtr, keyPtr, valuePtr);
        },
      ).toBool();

  /// Sets the image compression.
  bool magickSetInterlaceScheme(InterlaceType interlaceType) =>
      _magickWandBindings.MagickSetInterlaceScheme(
              _wandPtr, interlaceType.index)
          .toBool();

  /// Sets the interpolate pixel method.
  bool magickSetInterpolateMethod(
          PixelInterpolateMethod pixelInterpolateMethod) =>
      _magickWandBindings.MagickSetInterpolateMethod(
        _wandPtr,
        pixelInterpolateMethod.index,
      ).toBool();

  /// Associates one or options with the wand
  /// (.e.g MagickSetOption(wand,"jpeg:perserve","yes")).
  bool magickSetOption(String key, String value) => using(
        (Arena arena) {
          final Pointer<Char> keyPtr =
              key.toNativeUtf8(allocator: arena).cast();
          final Pointer<Char> valuePtr =
              value.toNativeUtf8(allocator: arena).cast();
          return _magickWandBindings.MagickSetOption(
              _wandPtr, keyPtr, valuePtr);
        },
      ).toBool();

  /// Sets the wand orientation type.
  bool magickSetOrientation(OrientationType orientationType) =>
      _magickWandBindings.MagickSetOrientation(_wandPtr, orientationType.index)
          .toBool();

  /// Sets the page geometry of the magick wand.
  bool magickSetPage({
    required int width,
    required int height,
    required int x,
    required int y,
  }) =>
      _magickWandBindings.MagickSetPage(_wandPtr, width, height, x, y).toBool();

  /// Sets the passphrase.
  bool magickSetPassphrase(String passphrase) => using(
        (Arena arena) => _magickWandBindings.MagickSetPassphrase(
          _wandPtr,
          passphrase.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// Sets the font pointsize associated with the MagickWand.
  bool magickSetPointsize(double pointSize) =>
      _magickWandBindings.MagickSetPointsize(_wandPtr, pointSize).toBool();

  /// MagickSetProgressMonitor() sets the wand progress monitor to  monitor the
  /// progress of an image operation to the specified method.
  ///
  //TODO: If the progress monitor method returns false, the current operation is
  // interrupted.
  /// - [clientData] : any user-provided data that will be passed to the
  /// progress monitor callback.
  Future<void> magickSetProgressMonitor(MagickProgressMonitor progressMonitor,
      [dynamic clientData]) async {
    if (_progressMonitorReceivePort == null) {
      _progressMonitorReceivePort = ReceivePort();
      _progressMonitorReceivePortSendPortPtr =
          _pluginBindings.magickSetProgressMonitorPort(
        _wandPtr.cast(),
        _progressMonitorReceivePort!.sendPort.nativePort,
      );
      _progressMonitorStreamController = StreamController<dynamic>.broadcast();
      _progressMonitorReceivePortStreamSubscription =
          _progressMonitorReceivePort!.listen((dynamic data) {
        if (_progressMonitorStreamController!.hasListener) {
          _progressMonitorStreamController!.add(data);
        }
      });
    }
    await _progressMonitorStreamControllerStreamSubscription
        ?.cancel(); // Cancel previous subscription, if any.
    _progressMonitorStreamControllerStreamSubscription =
        _progressMonitorStreamController!.stream.listen((event) {
      final dynamic data = jsonDecode(event);
      progressMonitor(data['info'], data['offset'], data['size'], clientData);
    });
  }

  /// Sets the image resolution.
  bool magickSetResolution(double xResolution, double yResolution) =>
      _magickWandBindings.MagickSetResolution(
              _wandPtr, xResolution, yResolution)
          .toBool();

  /// Sets the image sampling factors.
  /// - [samplingFactors] : An array of doubles representing the sampling factor
  /// for each color component (in RGB order).
  bool magickSetSamplingFactors(Float64List samplingFactors) => using(
        (Arena arena) => _magickWandBindings.MagickSetSamplingFactors(
          _wandPtr,
          samplingFactors.length,
          samplingFactors.toDoubleArrayPointer(allocator: arena),
        ),
      ).toBool();

  /// Sets the ImageMagick security policy. It returns false if the policy is
  /// already set or if the policy does not parse.
  bool magickSetSecurityPolicy(String securityPolicy) => using(
        (Arena arena) => _magickWandBindings.MagickSetSecurityPolicy(
          _wandPtr,
          securityPolicy.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// Sets the size of the magick wand. Set it before you read a raw image
  /// format such as RGB, GRAY, or CMYK.
  /// - [width] : the width in pixels.
  /// - [height] : the height in pixels.
  bool magickSetSize(int width, int height) =>
      _magickWandBindings.MagickSetSize(_wandPtr, width, height).toBool();

  /// Sets the size and offset of the magick wand. Set it before you read
  /// a raw image format such as RGB, GRAY, or CMYK.
  bool magickSetSizeOffset({
    required int columns,
    required int rows,
    required int offset,
  }) =>
      _magickWandBindings.MagickSetSizeOffset(_wandPtr, columns, rows, offset)
          .toBool();

  /// Sets the image type attribute.
  bool magickSetType(ImageType imageType) =>
      _magickWandBindings.MagickSetType(_wandPtr, imageType.index).toBool();

  /// Adaptively blurs the image by blurring less intensely near image edges
  /// and more intensely far from edges. We blur the image with a Gaussian
  /// operator of the given radius and standard deviation (sigma). For
  /// reasonable results, radius should be larger than sigma. Use a radius of 0
  /// and `magickAdaptiveBlurImage()` selects a suitable radius for you.
  ///
  /// {@template magick_wand.method_runs_in_different_isolate}
  /// This method runs inside an isolate different from the main isolate.
  /// {@endtemplate}
  ///
  /// - [radius] : the radius of the Gaussian, in pixels, not counting the
  /// center pixel.
  /// - [sigma] : the standard deviation of the Gaussian, in pixels.
  Future<bool> magickAdaptiveBlurImage(double radius, double sigma) async =>
      await _magickCompute(
        _magickAdaptiveBlurImage,
        _MagickAdaptiveBlurImageParams(_wandPtr.address, radius, sigma),
      );

  /// Adaptively resize image with data dependent triangulation.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [columns] : the number of columns in the scaled image.
  /// - [rows] : the number of rows in the scaled image.
  Future<bool> magickAdaptiveResizeImage(int columns, int rows) async =>
      await _magickCompute(
        _magickAdaptiveResizeImage,
        _MagickAdaptiveResizeImageParams(_wandPtr.address, columns, rows),
      );

  /// Adaptively sharpens the image by sharpening more intensely near image edges
  /// and less intensely far from edges. We sharpen the image with a Gaussian
  /// operator of the given radius and standard deviation (sigma). For
  /// reasonable results, radius should be larger than sigma. Use a radius of 0
  /// and `magickAdaptiveSharpenImage()` selects a suitable radius for you.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [radius] : the radius of the Gaussian, in pixels, not counting the
  /// center pixel.
  /// - [sigma] : the standard deviation of the Gaussian, in pixels.
  Future<bool> magickAdaptiveSharpenImage(double radius, double sigma) async =>
      await _magickCompute(
        _magickAdaptiveSharpenImage,
        _MagickAdaptiveSharpenImageParams(_wandPtr.address, radius, sigma),
      );

  /// Selects an individual threshold for each pixel based on the range of
  /// intensity values in its local neighborhood. This allows for thresholding
  /// of an image whose global intensity histogram doesn't contain distinctive
  /// peaks.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [width] : the width of the local neighborhood.
  /// - [height] : the height of the local neighborhood.
  /// - [bias] : the mean offset.
  Future<bool> magickAdaptiveThresholdImage({
    required int width,
    required int height,
    required double bias,
  }) async =>
      await _magickCompute(
        _magickAdaptiveThresholdImage,
        _MagickAdaptiveThresholdImageParams(
          _wandPtr.address,
          width,
          height,
          bias,
        ),
      );

  /// Adds a clone of the images from the second wand and inserts them into the
  /// first wand. Use `magickSetLastIterator()`, to append new images into an
  /// existing wand, current image will be set to last image so later adds with
  /// also be appended to end of wand. Use `magickSetFirstIterator()` to
  /// prepend new images into wand, any more images added will also be
  /// prepended before other images in the wand. However the order of a list of
  /// new images will not change. Otherwise the new images will be inserted just
  /// after the current image, and any later image will also be added after this
  /// current image but before the previously added images. Caution is advised
  /// when multiple image adds are inserted into the middle of the wand image
  /// list.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [other] : the other wand to add images from.
  Future<bool> magickAddImage(MagickWand other) async => await _magickCompute(
        _magickAddImage,
        _MagickAddImageParams(_wandPtr.address, other._wandPtr.address),
      );

  /// Adds random noise to the image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [noiseType] : the type of noise.
  /// - [attenuate] : attenuate the random distribution.
  Future<bool> magickAddNoiseImage(
          NoiseType noiseType, double attenuate) async =>
      await _magickCompute(
        _magickAddNoiseImage,
        _MagickAddNoiseImageParams(
          _wandPtr.address,
          noiseType.index,
          attenuate,
        ),
      );

  /// Transforms an image as dictated by the affine matrix of the drawing wand.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickAffineTransformImage(DrawingWand drawingWand) async =>
      await _magickCompute(
          _magickAffineTransformImage,
          _MagickAffineTransformImageParams(
              _wandPtr.address, drawingWand._wandPtr.address));

  /// Annotates an image with text.
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [x] : x ordinate to left of text.
  /// - [y] : y ordinate to text baseline.
  /// - [angle] : the text rotation angle.
  /// - [text] : the text to draw.
  Future<bool> magickAnnotateImage({
    required DrawingWand drawingWand,
    required double x,
    required double y,
    required double angle,
    required String text,
  }) async =>
      await _magickCompute(
        _magickAnnotateImage,
        _MagickAnnotateImageParams(
          _wandPtr.address,
          drawingWand._wandPtr.address,
          x,
          y,
          angle,
          text,
        ),
      );

  /// Append the images in a wand from the current image onwards, creating a new
  /// wand with the single image result. This is affected by the gravity and
  /// background settings of the first image. Typically you would call either
  /// `magickResetIterator()` or `magickSetFirstImage()` before calling this
  /// function to ensure that all the images in the wand's image list will be
  /// appended together.
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [stack] : By default, images are stacked left-to-right. Set stack to
  /// true to stack them top-to-bottom.
  Future<MagickWand?> magickAppendImages(bool stack) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickAppendImages,
          _MagickAppendImagesParams(_wandPtr.address, stack),
        ),
      );

  /// Extracts the 'mean' from the image and adjust the image to try make set
  /// its gamma appropriately.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickAutoGammaImage() async =>
      await _magickCompute(_magickAutoGammaImage, _wandPtr.address);

  /// Adjusts the levels of a particular image channel by scaling the minimum
  /// and maximum values to the
  /// full quantum range.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickAutoLevelImage() async =>
      await _magickCompute(_magickAutoLevelImage, _wandPtr.address);

  /// Adjusts an image so that its orientation is suitable $ for viewing (i.e.
  /// top-left orientation).
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickAutoOrientImage() async =>
      await _magickCompute(_magickAutoOrientImage, _wandPtr.address);

  /// Automatically performs image thresholding dependent on which method you
  /// specify.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [method] : the method to use.
  Future<bool> magickAutoThresholdImage(AutoThresholdMethod method) async =>
      await _magickCompute(
        _magickAutoThresholdImage,
        _MagickAutoThresholdImageParams(_wandPtr.address, method.index),
      );

  /// `magickBilateralBlurImage()` is a non-linear, edge-preserving, and
  /// noise-reducing smoothing filter for images. It replaces the intensity of
  /// each pixel with a weighted average of intensity values from nearby pixels.
  /// This weight is based on a Gaussian distribution. The weights depend not
  /// only on Euclidean distance of pixels, but also on the radiometric
  /// differences (e.g., range differences, such as color intensity, depth
  /// distance, etc.). This preserves sharp edges.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [radius] : the radius of the Gaussian, in pixels, not counting the
  /// center pixel.
  /// - [sigma] : the standard deviation of the , in pixels.
  /// - [intensity_sigma] :  sigma in the intensity space. A larger value means
  /// that farther colors within the pixel neighborhood (see spatial_sigma) will
  /// be mixed together, resulting in larger areas of semi-equal color.
  /// - [spatial_sigma] : sigma in the coordinate space. A larger value means
  /// that farther pixels influence each other as long as their colors are close
  /// enough (see intensity_sigma ). When the neighborhood diameter is greater
  /// than zero, it specifies the neighborhood size regardless of spatial_sigma.
  /// Otherwise, the neighborhood diameter is proportional to spatial_sigma.
  Future<bool> magickBilateralBlurImage({
    required double radius,
    required double sigma,
    required double intensitySigma,
    required double spatialSigma,
  }) async =>
      await _magickCompute(
        _magickBilateralBlurImage,
        _MagickBilateralBlurImageParams(
          _wandPtr.address,
          radius,
          sigma,
          intensitySigma,
          spatialSigma,
        ),
      );

  /// `magickBlackThresholdImage()` is like MagickThresholdImage() but forces
  /// all pixels below the threshold into black while leaving all pixels above
  /// the threshold unchanged.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [pixelWand] : the pixel wand to determine the threshold.
  Future<bool> magickBlackThresholdImage(PixelWand pixelWand) async =>
      await _magickCompute(
        _magickBlackThresholdImage,
        _MagickBlackThresholdImageParams(
          _wandPtr.address,
          pixelWand._wandPtr.address,
        ),
      );

  /// Mutes the colors of the image to simulate a scene at nighttime in the
  /// moonlight.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [factor] : the blue shift factor (default 1.5).
  Future<bool> magickBlueShiftImage([double factor = 1.5]) async =>
      await _magickCompute(
        _magickBlueShiftImage,
        _MagickBlueShiftImageParams(_wandPtr.address, factor),
      );

  /// `magickBlurImage()` blurs an image. We convolve the image with a gaussian
  /// operator of the given radius and standard deviation (sigma). For
  /// reasonable results, the radius should be larger than sigma.
  /// Use a radius of 0 and BlurImage() selects a suitable radius for you.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [radius] : the radius of the Gaussian, in pixels, not counting the
  /// center pixel.
  /// - [sigma] : the standard deviation of the Gaussian, in pixels.
  Future<bool> magickBlurImage({
    required double radius,
    required double sigma,
  }) async =>
      await _magickCompute(
        _magickBlurImage,
        _MagickBlurImageParams(_wandPtr.address, radius, sigma),
      );

  /// `magickBorderImage()` surrounds the image with a border of the color
  /// defined by the bordercolor pixel wand.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [borderColorWand] : the border color pixel wand.
  /// - [width] : the border width.
  /// - [height] : the border height.
  /// - [compose] : the composite operator.
  Future<bool> magickBorderImage({
    required PixelWand borderColorWand,
    required int width,
    required int height,
    required CompositeOperator compose,
  }) async =>
      await _magickCompute(
        _magickBorderImage,
        _MagickBorderImageParams(
          _wandPtr.address,
          borderColorWand._wandPtr.address,
          width,
          height,
          compose.index,
        ),
      );

  /// Use `magickBrightnessContrastImage()` to change the brightness and/or
  /// contrast of an image.
  /// It converts the brightness and contrast parameters into slope and
  /// intercept and calls a polynomial function to apply to the image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [brightness] : the brightness percent (-100 .. 100).
  /// - [contrast] : the contrast percent (-100 .. 100).
  Future<bool> magickBrightnessContrastImage({
    required double brightness,
    required double contrast,
  }) async =>
      await _magickCompute(
        _magickBrightnessContrastImage,
        _MagickBrightnessContrastImageParams(
          _wandPtr.address,
          brightness,
          contrast,
        ),
      );

  /// `magickCannyEdgeImage()` uses a multi-stage algorithm to detect a wide
  /// range of edges in images.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [radius] : the radius of the gaussian smoothing filter.
  /// - [sigma] : the sigma of the gaussian smoothing filter.
  /// - [lowerPercent] : percentage of edge pixels in the lower threshold.
  /// - [upperPercent] : percentage of edge pixels in the upper threshold.
  Future<bool> magickCannyEdgeImage({
    required double radius,
    required double sigma,
    required double lowerPercent,
    required double upperPercent,
  }) async =>
      await _magickCompute(
        _magickCannyEdgeImage,
        _MagickCannyEdgeImageParams(
          _wandPtr.address,
          radius,
          sigma,
          lowerPercent,
          upperPercent,
        ),
      );

  /// `magickChannelFxImage()` applies a channel expression to the specified
  /// image. The expression consists of one or more channels, either mnemonic
  /// or numeric (e.g. red, 1), separated by actions as follows:
  /// <=> exchange two channels (e.g. red<=>blue) => transfer a channel to
  /// another (e.g. red=>green) , separate channel operations (e.g. red, green)
  /// | read channels from next input image (e.g. red | green) ; write channels
  /// to next output image (e.g. red; green; blue) A channel without a operation
  /// symbol implies extract. For example, to create 3 grayscale images from the
  /// red, green, and blue channels of an image, use: -channel-fx "red; green;
  /// blue".
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [expression] : the expression.
  ///
  /// {@template magick_wand.invalid_params_crash_the_app}
  /// <b>Sending invalid parameters will cause an invalid state and may crash
  /// the app, so you should make sure to validate the input to this method.</b>
  /// {@endtemplate}
  Future<MagickWand?> magickChannelFxImage(String expression) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickChannelFxImage,
          _MagickChannelFxImageParams(_wandPtr.address, expression),
        ),
      );

  /// Simulates a charcoal drawing.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [radius] : the radius of the Gaussian, in pixels, not counting the
  /// center pixel.
  /// - [sigma] : the standard deviation of the Gaussian, in pixels.
  Future<bool> magickCharcoalImage(
          {required double radius, required double sigma}) async =>
      await _magickCompute(
        _magickCharcoalImage,
        _MagickCharcoalImageParams(_wandPtr.address, radius, sigma),
      );

  /// Removes a region of an image and collapses the image to occupy the
  /// removed portion.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [width] : the width of the region.
  /// - [height] : the height of the region.
  /// - [x] : the x offset of the region.
  /// - [y] : the y offset of the region.
  Future<bool> magickChopImage({
    required int width,
    required int height,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickChopImage,
        _MagickChopImageParams(
          _wandPtr.address,
          width,
          height,
          x,
          y,
        ),
      );

  /// `magickCLAHEImage()` is a variant of adaptive histogram equalization in
  /// which the contrast amplification is limited, so as to reduce this problem
  /// of noise amplification.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [width] : the width of the tile divisions to use in horizontal
  /// direction.
  /// - [height] : the height of the tile divisions to use in vertical
  /// direction.
  /// - [numberBins] : number of bins for histogram ("dynamic range").
  /// Although parameter is currently
  /// a double, it is cast to size_t internally.
  /// - [clipLimit] : contrast limit for localised changes in contrast.
  /// A limit less than 1 results in
  /// standard non-contrast limited AHE.
  Future<bool> magickClaheImage({
    required int width,
    required int height,
    required double numberBins,
    required double clipLimit,
  }) async =>
      await _magickCompute(
        _magickCLAHEImage,
        _MagickCLAHEImageParams(
          _wandPtr.address,
          width,
          height,
          numberBins,
          clipLimit,
        ),
      );

  /// Restricts the color range from 0 to the quantum depth.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickClampImage() async =>
      await _magickCompute(_magickClampImage, _wandPtr.address);

  /// Clips along the first path from the 8BIM profile, if present.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickClipImage() async =>
      await _magickCompute(_magickClipImage, _wandPtr.address);

  /// Clips along the named paths from the 8BIM profile, if present.
  /// Later operations take effect inside the path. Id may be a number if
  /// preceded with #, to work on a numbered path, e.g., "#1" to use the first
  /// path.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [pathName] : name of clipping path resource. If name is preceded by #,
  /// use clipping path numbered
  /// by name.
  /// - [inside] : if non-zero, later operations take effect inside clipping
  /// path. Otherwise later operations
  /// take effect outside clipping path.
  Future<bool> magickClipImagePath(
          {required String pathName, required bool inside}) async =>
      await _magickCompute(
        _magickClipImagePath,
        _MagickClipImagePathParams(_wandPtr.address, pathName, inside),
      );

  /// Replaces colors in the image from a color lookup table.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [clutImage] : the clut image.
  /// - [method] : the pixel interpolation method.
  Future<bool> magickClutImage(
          {required MagickWand clutImage,
          required PixelInterpolateMethod method}) async =>
      await _magickCompute(
        _magickClutImage,
        _MagickClutImageParams(
          _wandPtr.address,
          clutImage._wandPtr.address,
          method.index,
        ),
      );

  /// `magickCoalesceImages()` composites a set of images while respecting any
  /// page offsets and disposal methods. GIF, MIFF, and MNG animation sequences
  /// typically start with an image background and each subsequent image varies
  /// in size and offset. `magickCoalesceImages()` returns a new sequence where
  /// each image in the sequence is the same size as the first and composited
  /// with the next image in the sequence.
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<MagickWand?> magickCoalesceImages() async => MagickWand._fromAddress(
        await _magickCompute(_magickCoalesceImages, _wandPtr.address),
      );

  // ignore: slash_for_doc_comments
  /**`magickColorDecisionListImage()` accepts a lightweight Color Correction
      Collection (CCC) file which
      solely contains one or more color corrections and applies the color
      correction to the image. Here is
      a sample CCC file:
      <ColorCorrectionCollection xmlns="urn:ASC:CDL:v1.2">
      <ColorCorrection id="cc03345">
      <SOPNode>
      <Slope> 0.9 1.2 0.5 </Slope>
      <Offset> 0.4 -0.5 0.6 </Offset>
      <Power> 1.0 0.8 1.5 </Power>
      </SOPNode>
      <SATNode>
      <Saturation> 0.85 </Saturation>
      </SATNode>
      </ColorCorrection>
      </ColorCorrectionCollection>
      which includes the offset, slope, and power for each of the RGB channels
      as well as the saturation.

      {@macro magick_wand.method_runs_in_different_isolate}
      - [colorCorrectionCollection] : the color correction collection in XML.*/
  Future<bool> magickColorDecisionListImage(
          String colorCorrectionCollection) async =>
      await _magickCompute(
        _magickColorDecisionListImage,
        _MagickColorDecisionListImageParams(
          _wandPtr.address,
          colorCorrectionCollection,
        ),
      );

  /// Blends the fill color with each pixel in the image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [colorize] : the colorize pixel wand.
  /// - [blend] : the alpha pixel wand.
  Future<bool> magickColorizeImage(
          {required PixelWand colorize, required PixelWand blend}) async =>
      await _magickCompute(
        _magickColorizeImage,
        _MagickColorizeImageParams(
          _wandPtr.address,
          colorize._wandPtr.address,
          blend._wandPtr.address,
        ),
      );

  /// Apply color transformation to an image. The method permits saturation
  /// changes, hue rotation, luminance to alpha, and various other effects.
  /// Although variable-sized transformation matrices can be used, typically one
  /// uses a 5x5 matrix for an RGBA image and a 6x6 for CMYKA (or RGBA with
  /// offsets). The matrix is similar to those used by Adobe Flash except
  /// offsets are in column 6 rather than 5 (in support of CMYKA images) and
  /// offsets are normalized (divide Flash offset by 255).
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [colorMatrix] : the color matrix.
  Future<bool> magickColorMatrixImage(
          {required KernelInfo colorMatrix}) async =>
      await _magickCompute(
        _magickColorMatrixImage,
        _MagickColorMatrixImageParams(
          _wandPtr.address,
          colorMatrix,
        ),
      );

  /// Forces all pixels in the color range to white otherwise black.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [startColor] : the start color pixel wand.
  /// - [stopColor] : the stop color pixel wand.
  Future<bool> magickColorThresholdImage(
          {required PixelWand startColor,
          required PixelWand stopColor}) async =>
      await _magickCompute(
        _magickColorThresholdImage,
        _MagickColorThresholdImageParams(
          _wandPtr.address,
          startColor._wandPtr.address,
          stopColor._wandPtr.address,
        ),
      );

  /// `magickCombineImages()` combines one or more images into a single image.
  /// The grayscale value of the pixels of each image in the sequence is
  /// assigned in order to the specified channels of the combined image.
  /// The typical ordering would be image 1 => Red, 2 => Green, 3 => Blue, etc.
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [colorSpace]: the colorspace.
  Future<MagickWand?> magickCombineImages(ColorspaceType colorSpace) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickCombineImages,
          _MagickCombineImagesParams(_wandPtr.address, colorSpace.index),
        ),
      );

  /// `magickCommentImage()` adds a comment to your image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [comment]: the image comment.
  Future<bool> magickCommentImage(String comment) async => await _magickCompute(
        _magickCommentImage,
        _MagickCommentImageParams(_wandPtr.address, comment),
      );

  /// `magickCompareImagesLayers()` compares each image with the next in a
  /// sequence and returns the maximum bounding region of any pixel differences
  /// it discovers.
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [method] : the compare method.
  Future<MagickWand?> magickCompareImagesLayers(LayerMethod method) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickCompareImagesLayers,
          _MagickCompareImagesLayersParams(_wandPtr.address, method.index),
        ),
      );

  /// Compares an image to a reconstructed image and returns the specified
  /// difference image.
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [reference] : the reference wand.
  /// - [metric] : the metric.
  /// - [distortion] : the computed distortion between the images.
  Future<MagickWand?> magickCompareImages({
    required MagickWand reference,
    required MetricType metric,
    required Float64List distortion,
  }) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickCompareImages,
          _MagickCompareImagesParams(
            _wandPtr.address,
            reference._wandPtr.address,
            metric.index,
            distortion,
          ),
        ),
      );

  /// Performs complex mathematics on an image sequence.
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [operator]: A complex operator.
  Future<MagickWand?> magickComplexImages(ComplexOperator operator) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickComplexImages,
          _MagickComplexImagesParams(_wandPtr.address, operator.index),
        ),
      );

  /// Composite one image onto another at the specified offset.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [sourceImage]: the magick wand holding source image
  /// - [compose]: This operator affects how the composite is applied to the
  /// image.
  /// The default is Over. These are some of the compose methods available.
  /// - [clipToSelf]: set to true to limit composition to area composed.
  /// - [x]: the column offset of the composited image.
  /// - [y]: the row offset of the composited image.
  Future<bool> magickCompositeImage({
    required MagickWand sourceImage,
    required CompositeOperator compose,
    required bool clipToSelf,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickCompositeImage,
        _MagickCompositeImageParams(
          _wandPtr.address,
          sourceImage._wandPtr.address,
          compose.index,
          clipToSelf,
          x,
          y,
        ),
      );

  /// Composite one image onto another using the specified gravity.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///  - [sourceWand]: the magick wand holding source image.
  ///  - [compose]: This operator affects how the composite is applied to the
  ///  image.
  ///  The default is Over.
  ///  - [gravity]: positioning gravity.
  Future<bool> magickCompositeImageGravity({
    required MagickWand sourceWand,
    required CompositeOperator compose,
    required GravityType gravity,
  }) async =>
      await _magickCompute(
        _magickCompositeImageGravity,
        _MagickCompositeImageGravityParams(
          _wandPtr.address,
          sourceWand._wandPtr.address,
          compose.index,
          gravity.value,
        ),
      );

  /// `magickCompositeLayers()` composite the images in the source wand over
  /// the images in the destination wand in sequence, starting with the current
  /// image in both lists. Each layer from the two image lists are composted
  /// together until the end of one of the image lists is reached. The offset
  /// of each composition is also adjusted to match the virtual canvas offsets
  /// of each layer. As such the given offset is relative to the virtual canvas,
  /// and not the actual image. Composition uses given x and y offsets, as the
  /// 'origin' location of the source images virtual canvas (not the real
  /// image) allowing you to compose a list of 'layer images' into the
  /// destination images. This makes it well suitable for directly composing
  /// 'Clears Frame Animations' or 'Coalesced Animations' onto a static or
  /// other 'Coalesced Animation' destination image list. GIF disposal handling
  /// is not looked at. Special case:- If one of the image sequences is the
  /// last image (just a single image remaining), that image is repeatedly
  /// composed with all the images in the other image list. Either the source
  /// or destination lists may be the single image, for this situation. In the
  /// case of a single destination image (or last image given), that image will
  /// be cloned to match the number of images remaining in the source image
  /// list. This is equivalent to the "-layer Composite" Shell API operator.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [sourceWand]: the magick wand holding source image.
  /// - Compose, x, and y are the compose arguments.
  Future<bool> magickCompositeLayers({
    required MagickWand sourceWand,
    required CompositeOperator compose,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickCompositeLayers,
        _MagickCompositeLayersParams(
          _wandPtr.address,
          sourceWand._wandPtr.address,
          compose.index,
          x,
          y,
        ),
      );

  /// Enhances the intensity differences between the lighter and darker
  /// elements of the image. Set sharpen to a value other than 0 to increase
  /// the image contrast otherwise the contrast is reduced.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [sharpen]: Increase or decrease image contrast.
  Future<bool> magickContrastImage(bool sharpen) async => await _magickCompute(
        _magickContrastImage,
        _MagickContrastImageParams(_wandPtr.address, sharpen),
      );

  /// Enhances the contrast of a color image by adjusting the pixels color to
  /// span the entire range of colors available. You can also reduce the
  /// influence of a particular channel with a gamma value of 0.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [blackPoint]: the black point.
  /// - [whitePoint]: the white point.
  Future<bool> magickContrastStretchImage(
          {required double whitePoint, required double blackPoint}) async =>
      await _magickCompute(
        _magickContrastStretchImage,
        _MagickContrastStretchImageParams(
          _wandPtr.address,
          whitePoint,
          blackPoint,
        ),
      );

  /// Applies a custom convolution kernel to the image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [kernel]: An array of doubles representing the convolution kernel.
  Future<bool> magickConvolveImage({required KernelInfo kernel}) async =>
      await _magickCompute(
        _magickConvolveImage,
        _MagickConvolveImageParams(_wandPtr.address, kernel),
      );

  /// Extracts a region of the image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [width]: the region width.
  /// - [height]: the region height.
  /// - [x]: the region x offset.
  /// - [y]: the region y offset.
  Future<bool> magickCropImage({
    required int width,
    required int height,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickCropImage,
        _MagickCropImageParams(_wandPtr.address, width, height, x, y),
      );

  /// Displaces an image's colormap by a given number of positions. If you
  /// cycle the colormap a number of times you can produce a psychodelic effect.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickCycleColormapImage(int displace) async =>
      await _magickCompute(
        _magickCycleColormapImage,
        _MagickCycleColormapImageParams(_wandPtr.address, displace),
      );

  /// Adds an image to the wand comprised of the pixel data you supply. The
  /// pixel data must be in scanline order top-to-bottom. For example, to create
  /// a 640x480 image from unsigned red-green-blue character data, in the C API,
  /// you would use
  ///
  /// ```
  /// MagickConstituteImage(wand,640,480,"RGB",CharPixel,pixels);
  /// ```
  ///
  /// And the equivalent dart code here would be
  ///
  /// ```
  /// wand.MagickConstituteImageFromCharPixel(640,640,'RGB',pixels)
  /// ```
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [columns]: width in pixels of the image.
  /// - [rows]: height in pixels of the image.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue,
  /// A = alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y =
  /// yellow, M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: A Uint8List of values contain the pixel components as defined
  /// by map.
  ///
  /// - See also: [magickExportImageCharPixels].
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<bool> magickConstituteImageFromCharPixel({
    required int columns,
    required int rows,
    required String map,
    required Uint8List pixels,
  }) async =>
      await _magickCompute(
        _magickConstituteImage,
        _MagickConstituteImageParams(
          _wandPtr.address,
          columns,
          rows,
          map,
          _StorageType.CharPixel,
          pixels,
        ),
      );

  /// Adds an image to the wand comprised of the pixel data you supply. The
  /// pixel data must be in scanline order top-to-bottom.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [columns]: width in pixels of the image.
  /// - [rows]: height in pixels of the image.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue,
  /// A = alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y =
  /// yellow, M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: A Float64List of values contain the pixel components as
  /// defined  by map.
  ///
  /// - See also: [magickExportImageDoublePixels].
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<bool> magickConstituteImageFromDoublePixel({
    required int columns,
    required int rows,
    required String map,
    required Float64List pixels,
  }) async =>
      await _magickCompute(
        _magickConstituteImage,
        _MagickConstituteImageParams(
          _wandPtr.address,
          columns,
          rows,
          map,
          _StorageType.DoublePixel,
          pixels,
        ),
      );

  /// Adds an image to the wand comprised of the pixel data you supply. The
  /// pixel data must be in scanline order top-to-bottom.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [columns]: width in pixels of the image.
  /// - [rows]: height in pixels of the image.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue,
  /// A = alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y =
  /// yellow, M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: A Float32List of values contain the pixel components as defined
  /// by map.
  ///
  /// - See also: [magickExportImageFloatPixels].
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<bool> magickConstituteImageFromFloatPixel({
    required int columns,
    required int rows,
    required String map,
    required Float32List pixels,
  }) async =>
      await _magickCompute(
        _magickConstituteImage,
        _MagickConstituteImageParams(
          _wandPtr.address,
          columns,
          rows,
          map,
          _StorageType.FloatPixel,
          pixels,
        ),
      );

  /// Adds an image to the wand comprised of the pixel data you supply. The
  /// pixel data must be in scanline order top-to-bottom.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [columns]: width in pixels of the image.
  /// - [rows]: height in pixels of the image.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue,
  /// A = alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y =
  /// yellow, M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: A Uint32List of values contain the pixel components as defined
  /// by map.
  ///
  /// - See also: [magickExportImageLongPixels].
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<bool> magickConstituteImageFromLongPixel({
    required int columns,
    required int rows,
    required String map,
    required Uint32List pixels,
  }) async =>
      await _magickCompute(
        _magickConstituteImage,
        _MagickConstituteImageParams(
          _wandPtr.address,
          columns,
          rows,
          map,
          _StorageType.LongPixel,
          pixels,
        ),
      );

  /// Adds an image to the wand comprised of the pixel data you supply. The
  /// pixel data must be in scanline order top-to-bottom.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [columns]: width in pixels of the image.
  /// - [rows]: height in pixels of the image.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue,
  /// A = alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y =
  /// yellow, M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: A Uint64List of values contain the pixel components as defined
  /// by map.
  ///
  /// - See also: [magickExportImageLongLongPixels].
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<bool> magickConstituteImageFromLongLongPixel({
    required int columns,
    required int rows,
    required String map,
    required Uint64List pixels,
  }) async =>
      await _magickCompute(
        _magickConstituteImage,
        _MagickConstituteImageParams(
          _wandPtr.address,
          columns,
          rows,
          map,
          _StorageType.LongLongPixel,
          pixels,
        ),
      );

  /// Adds an image to the wand comprised of the pixel data you supply. The
  /// pixel data must be in scanline order top-to-bottom.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [columns]: width in pixels of the image.
  /// - [rows]: height in pixels of the image.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue,
  /// A = alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y =
  /// yellow, M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: A Uint16List of values contain the pixel components as defined
  /// by map.
  ///
  /// - See also: [magickExportImageShortPixels].
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<bool> magickConstituteImageFromShortPixel({
    required int columns,
    required int rows,
    required String map,
    required Uint16List pixels,
  }) async =>
      await _magickCompute(
        _magickConstituteImage,
        _MagickConstituteImageParams(
          _wandPtr.address,
          columns,
          rows,
          map,
          _StorageType.ShortPixel,
          pixels,
        ),
      );

  /// Converts cipher pixels to plain pixels.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [passphrase]: the passphrase
  Future<bool> magickDecipherImage(String passphrase) async =>
      await _magickCompute(
        _magickDecipherImage,
        _MagickDecipherImageParams(_wandPtr.address, passphrase),
      );

  /// Compares each image with the next in a sequence and returns the maximum
  /// bounding region of any pixel differences it discovers.
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<MagickWand?> magickDeconstructImages() async =>
      MagickWand._fromAddress(
        await _magickCompute(_magickDeconstructImages, _wandPtr.address),
      );

  /// Removes skew from the image. Skew is an artifact that occurs in scanned
  /// images because of the camera being misaligned, imperfections in the
  /// scanning or surface, or simply because the paper was not placed
  /// completely flat when scanned.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [threshold]: separate background from foreground.
  Future<bool> magickDeskewImage(double threshold) async =>
      await _magickCompute(
        _magickDeskewImage,
        _MagickDeskewImageParams(_wandPtr.address, threshold),
      );

  /// Reduces the speckle noise in an image while preserving the edges of the
  /// original image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickDespeckleImage() async => await _magickCompute(
        _magickDespeckleImage,
        _wandPtr.address,
      );

  /// Distorts an image using various distortion methods, by mapping color
  /// lookups of the source image to a new destination image usually of the
  /// same size as the source image, unless 'bestfit' is set to true.
  ///
  /// If 'bestfit' is enabled, and distortion allows it, the destination image
  /// is adjusted to ensure the whole source 'image' will just fit within the
  /// final destination image, which will be sized and offset accordingly.
  /// Also in many cases the virtual offset of the source image will be taken
  /// into account in the mapping.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [method]: the method of image distortion.
  ///
  /// ArcDistortion always ignores the source image offset, and always 'bestfit'
  /// the destination image with the top left corner offset relative to the
  /// polar mapping center.
  ///
  /// Bilinear has no simple inverse mapping so it does not allow 'bestfit'
  /// style of image distortion.
  ///
  /// Affine, Perspective, and Bilinear, do least squares fitting of the
  /// distortion when more than the minimum number of control point pairs are
  /// provided.
  ///
  /// Perspective, and Bilinear, falls back to a Affine distortion when less
  /// that 4 control point pairs are provided. While Affine distortions let you
  /// use any number of control point pairs, that is Zero pairs is a no-Op
  /// (viewport only) distortion, one pair is a translation and two pairs of
  /// control points do a scale-rotate-translate, without any shearing.
  /// - [arguments]: the arguments for this distortion method.
  /// - [bestFit]: Attempt to resize destination to fit distorted source.
  Future<bool> magickDistortImage({
    required DistortMethod method,
    required Float64List arguments,
    required bool bestFit,
  }) async =>
      await _magickCompute(
        _magickDistortImage,
        _MagickDistortImageParams(
          _wandPtr.address,
          method,
          arguments,
          bestFit,
        ),
      );

  /// Renders the drawing wand on the current image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickDrawImage(DrawingWand drawWand) async =>
      await _magickCompute(
        _magickDrawImage,
        _MagickDrawImageParams(_wandPtr.address, drawWand._wandPtr.address),
      );

  /// Enhance edges within the image with a convolution filter of the given
  /// radius. Use a radius of 0 and Edge() selects a suitable radius for you.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [radius]: the radius of the pixel neighborhood.
  Future<bool> magickEdgeImage(double radius) async => await _magickCompute(
        _magickEdgeImage,
        _MagickEdgeImageParams(_wandPtr.address, radius),
      );

  /// MagickEmbossImage() returns a grayscale image with a three-dimensional
  /// effect. We convolve the image with a Gaussian operator of the given radius
  /// and standard deviation (sigma). For reasonable results, radius should be
  /// larger than sigma. Use a radius of 0 and Emboss() selects a suitable
  /// radius for you.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [radius]: the radius of the Gaussian, in pixels, not counting the center
  /// pixel.
  /// - [sigma]: the standard deviation of the Gaussian, in pixels.
  Future<bool> magickEmbossImage({
    required double radius,
    required double sigma,
  }) async =>
      await _magickCompute(
        _magickEmbossImage,
        _MagickEmbossImageParams(_wandPtr.address, radius, sigma),
      );

  /// MagickEncipherImage() converts plaint pixels to cipher pixels.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [passphrase]: the passphrase
  Future<bool> magickEncipherImage(String passphrase) async =>
      await _magickCompute(
        _magickEncipherImage,
        _MagickEncipherImageParams(_wandPtr.address, passphrase),
      );

  /// MagickEnhanceImage() applies a digital filter that improves the quality
  /// of a noisy image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickEnhanceImage() async => await _magickCompute(
        _magickEnhanceImage,
        _wandPtr.address,
      );

  /// MagickEqualizeImage() equalizes the image histogram.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickEqualizeImage() async => await _magickCompute(
        _magickEqualizeImage,
        _wandPtr.address,
      );

  /// MagickEvaluateImage() applies an arithmetic, relational, or logical
  /// expression to an image. Use these operators to lighten or darken an image,
  /// to increase or decrease contrast in an image, or to produce the "negative"
  /// of an image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [operator]: the operator channel.
  Future<bool> magickEvaluateImage({
    required MagickEvaluateOperator operator,
    required double value,
  }) async =>
      await _magickCompute(
        _magickEvaluateImage,
        _MagickEvaluateImageParams(_wandPtr.address, operator, value),
      );

  /// Extracts pixel data from an image and returns it to you.
  /// The data is returned as in the order specified by map.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  ///
  /// - See also: [magickConstituteImageFromCharPixel]
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<Uint8List?> magickExportImageCharPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
  }) async =>
      await _magickCompute(
        _magickExportImageCharPixels,
        _MagickExportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
        ),
      );

  /// Extracts pixel data from an image and returns it to you.
  /// The data is returned as in the order specified by map.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  ///
  /// - See also: [magickConstituteImageFromDoublePixel]
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<Float64List?> magickExportImageDoublePixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
  }) async =>
      await _magickCompute(
        _magickExportImageDoublePixels,
        _MagickExportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
        ),
      );

  /// Extracts pixel data from an image and returns it to you.
  /// The data is returned as in the order specified by map.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  ///
  /// - See also: [magickConstituteImageFromFloatPixel]
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<Float32List?> magickExportImageFloatPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
  }) async =>
      await _magickCompute(
        _magickExportImageFloatPixels,
        _MagickExportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
        ),
      );

  /// Extracts pixel data from an image and returns it to you.
  /// The data is returned as in the order specified by map.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  ///
  /// - See also: [magickConstituteImageFromLongPixel]
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<Uint32List?> magickExportImageLongPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
  }) async =>
      await _magickCompute(
        _magickExportImageLongPixels,
        _MagickExportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
        ),
      );

  /// Extracts pixel data from an image and returns it to you.
  /// The data is returned as in the order specified by map.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  ///
  /// - See also: [magickConstituteImageFromLongLongPixel]
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<Uint64List?> magickExportImageLongLongPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
  }) async =>
      await _magickCompute(
        _magickExportImageLongLongPixels,
        _MagickExportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
        ),
      );

  /// Extracts pixel data from an image and returns it to you.
  /// The data is returned as in the order specified by map.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  ///
  /// - See also: [magickConstituteImageFromShortPixel]
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<Uint16List?> magickExportImageShortPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
  }) async =>
      await _magickCompute(
        _magickExportImageShortPixels,
        _MagickExportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
        ),
      );

  /// Extends the image as defined by the geometry, gravity, and wand background
  /// color. Set the (x,y) offset of the geometry to move the original wand
  /// relative to the extended wand.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [width]: the region width.
  /// - [height]: the region height.
  /// - [x]: the region x offset.
  /// - [y]: the region y offset.
  Future<bool> magickExtentImage({
    required int width,
    required int height,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickExtentImage,
        _MagickExtentImageParams(
          _wandPtr.address,
          width,
          height,
          x,
          y,
        ),
      );

  /// Creates a vertical mirror image by reflecting the pixels around the
  /// central x-axis.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickFlipImage() async => await _magickCompute(
        _magickFlipImage,
        _wandPtr.address,
      );

  /// Changes the color value of any pixel that matches target and is an
  /// immediate neighbor. If the method FillToBorderMethod is specified, the
  /// color value is changed for any neighbor pixel that does not match the
  /// bordercolor member of image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [fill]: the floodfill color pixel wand.
  /// - [fuzz]: By default target must match a particular pixel color exactly.
  /// However, in many cases two colors may differ by a small amount. The fuzz
  /// member of image defines how much tolerance is acceptable to consider two
  /// colors as the same. For example, set fuzz to 10 and the color red at
  /// intensities of 100 and 102 respectively are now interpreted as the same
  /// color for the purposes of the floodfill.
  /// - [bordercolor]: the border color pixel wand.
  /// - [x]: the x starting location of the operation.
  /// - [y]: the y starting location of the operation.
  /// - [invert]:  paint any pixel that does not match the target color.
  Future<bool> magickFloodfillPaintImage({
    required PixelWand fill,
    required double fuzz,
    required PixelWand bordercolor,
    required int x,
    required int y,
    required bool invert,
  }) async =>
      await _magickCompute(
        _magickFloodfillPaintImage,
        _MagickFloodfillPaintImageParams(
          _wandPtr.address,
          fill._wandPtr.address,
          fuzz,
          bordercolor._wandPtr.address,
          x,
          y,
          invert,
        ),
      );

  /// Creates a horizontal mirror image by reflecting the pixels around the
  /// central y-axis.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickFlopImage() async => await _magickCompute(
        _magickFlopImage,
        _wandPtr.address,
      );

  /// Adds a simulated three-dimensional border around the image. The width and
  /// height specify the border width of the vertical and horizontal sides of
  /// the frame. The inner and outer bevels indicate the width of the inner and
  /// outer shadows of the frame.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [matteColor]: the frame color pixel wand.
  /// - [width]: the border width.
  /// - [height]: the border height.
  /// - [innerBevel]: the inner bevel width.
  /// - [outerBevel]: the outer bevel width.
  /// - [compose]: the composite operator.
  Future<bool> magickFrameImage({
    required PixelWand matteColor,
    required int width,
    required int height,
    required int innerBevel,
    required int outerBevel,
    required CompositeOperator compose,
  }) async =>
      await _magickCompute(
        _magickFrameImage,
        _MagickFrameImageParams(
          _wandPtr.address,
          matteColor._wandPtr.address,
          width,
          height,
          innerBevel,
          outerBevel,
          compose,
        ),
      );

  /// Applies an arithmetic, relational, or logical expression to an image. Use
  /// these operators to lighten or darken an image, to increase or decrease
  /// contrast in an image, or to produce the "negative" of an image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [function]: the image function.
  /// - [arguments]: the function arguments.
  Future<bool> magickFunctionImage({
    required MagickFunctionType function,
    required Float64List arguments,
  }) async =>
      await _magickCompute(
        _magickFunctionImage,
        _MagickFunctionImageParams(
          _wandPtr.address,
          function,
          arguments,
        ),
      );

  /// Evaluate expression for each pixel in the image.
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [expression]: the expression.
  Future<MagickWand?> magickFxImage(String expression) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickFxImage,
          _MagickFxImageParams(
            _wandPtr.address,
            expression,
          ),
        ),
      );

  /// Gamma-corrects an image. The same image viewed on different devices will
  /// have perceptual differences in the way the image's intensities are
  /// represented on the screen. Specify individual gamma levels for the red,
  /// green, and blue channels, or adjust all three with the gamma parameter.
  /// Values typically range from 0.8 to 2.3.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [level]: defines the level of gamma correction.
  Future<bool> magickGammaImage(double level) async => await _magickCompute(
        _magickGammaImage,
        _MagickGammaImageParams(
          _wandPtr.address,
          level,
        ),
      );

  /// Blurs an image. We convolve the image with a Gaussian operator of the
  /// given radius and standard deviation (sigma). For reasonable results, the
  /// radius should be larger than sigma. Use a radius of 0 and
  /// `magickGaussianBlurImage()` selects a suitable radius for you.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [radius]: the radius of the, in pixels, not counting the center pixel.
  /// - [sigma]: the standard deviation of the, in pixels.
  Future<bool> magickGaussianBlurImage({
    required double radius,
    required double sigma,
  }) async =>
      await _magickCompute(
        _magickGaussianBlurImage,
        _MagickGaussianBlurImageParams(
          _wandPtr.address,
          radius,
          sigma,
        ),
      );

  /// Gets the image at the current image index.
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<MagickWand?> magickGetImage() async => MagickWand._fromAddress(
        await _magickCompute(
          _magickGetImage,
          _wandPtr.address,
        ),
      );

  /// Returns false if the image alpha channel is not activated. That is, the
  /// image is RGB rather than RGBA or CMYK rather than CMYKA.
  bool magickGetImageAlphaChannel() =>
      _magickWandBindings.MagickGetImageAlphaChannel(_wandPtr).toBool();

  /// Gets the image clip mask at the current image index.
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [clipMask]: the type of the clip mask.
  Future<MagickWand?> magickGetImageMask(PixelMask type) async =>
      MagickWand._fromAddress(await _magickCompute(
        _magickGetImageMask,
        _MagickGetImageMaskParams(
          _wandPtr.address,
          type,
        ),
      ));

  /// Returns the image background color.
  bool magickGetImageBackgroundColor(PixelWand backgroundColor) =>
      _magickWandBindings.MagickGetImageBackgroundColor(
        _wandPtr,
        backgroundColor._wandPtr,
      ).toBool();

  /// Implements direct to memory image formats. It returns the image as a blob
  /// (a formatted "file" in memory), starting from the current
  /// position in the image sequence. Use MagickSetImageFormat() to set the
  /// format to write to the blob (GIF, JPEG, PNG, etc.).
  /// Utilize `magickResetIterator()` to ensure the write is from the beginning
  /// of the image sequence.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<Uint8List?> magickGetImageBlob() async => await _magickCompute(
        _magickGetImageBlob,
        _wandPtr.address,
      );

  /// Implements direct to memory image formats. It returns the image sequence
  /// as a blob and its length. The format of the image determines the format
  /// of the returned blob (GIF, JPEG, PNG, etc.). To return a different image
  /// format, use MagickSetImageFormat().
  ///
  /// Note, some image formats do not permit multiple images to the same image
  /// stream (e.g. JPEG). in this instance, just the first image of the sequence
  /// is returned as a blob.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<Uint8List?> magickGetImagesBlob() async => await _magickCompute(
        _magickGetImagesBlob,
        _wandPtr.address,
      );

  /// Returns the chromaticity blue primary point for the image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  MagickGetImageBluePrimaryResult? magickGetImageBluePrimary() => using(
        (Arena arena) {
          final Pointer<Double> xPtr = arena();
          final Pointer<Double> yPtr = arena();
          final Pointer<Double> zPtr = arena();
          bool result = _magickWandBindings.MagickGetImageBluePrimary(
            _wandPtr,
            xPtr,
            yPtr,
            zPtr,
          ).toBool();
          if (!result) {
            return null;
          }
          return MagickGetImageBluePrimaryResult(
            xPtr.value,
            yPtr.value,
            zPtr.value,
          );
        },
      );

  /// Returns the image border color.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [borderColor]: the border color.
  bool magickGetImageBorderColor(PixelWand borderColor) =>
      _magickWandBindings.MagickGetImageBorderColor(
        _wandPtr,
        borderColor._wandPtr,
      ).toBool();

  /// Returns features for each channel in the image in each of four directions
  /// (horizontal, vertical, left and right diagonals) for the specified
  /// distance. The features include the angular second moment, contrast,
  /// correlation, sum of squares: variance, inverse difference moment, sum
  /// average, sum variance, sum entropy, entropy, difference variance,
  /// difference entropy, information measures of correlation 1, information
  /// measures of correlation 2, and maximum correlation coefficient.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<ChannelFeatures?> magickGetImageFeatures(int distance) async =>
      await _magickCompute(
        _magickGetImageFeatures,
        _MagickGetImageFeaturesParams(
          _wandPtr.address,
          distance,
        ),
      );

  /// Gets the kurtosis and skewness of one or more image channels.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<MagickGetImageKurtosisResult?> magickGetImageKurtosis() async =>
      await _magickCompute(
        _magickGetImageKurtosis,
        _wandPtr.address,
      );

  /// Gets the mean and standard deviation of one or more image channels.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<MagickGetImageMeanResult?> magickGetImageMean() async =>
      await _magickCompute(
        _magickGetImageMean,
        _wandPtr.address,
      );

  /// Gets the range for one or more image channels.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<MagickGetImageRangeResult?> magickGetImageRange() async =>
      await _magickCompute(
        _magickGetImageRange,
        _wandPtr.address,
      );

  /// Returns statistics for each channel in the image. The statistics include
  /// the channel depth, its minima and maxima, the mean, the standard
  /// deviation, the kurtosis and the skewness.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<ChannelStatistics?> magickGetImageStatistics() async =>
      await _magickCompute(
        _magickGetImageStatistics,
        _wandPtr.address,
      );

  /// Returns the color of the specified colormap index.
  ///
  /// - [index]: the offset into the image colormap.
  /// - [color]: the colormap color in this wand.
  bool magickGetImageColormapColor(int index, PixelWand color) =>
      _magickWandBindings.MagickGetImageColormapColor(
        _wandPtr,
        index,
        color._wandPtr,
      ).toBool();

  /// Gets the number of unique colors in the image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<int> magickGetImageColors() async => await _magickCompute(
        _magickGetImageColors,
        _wandPtr.address,
      );

  /// Gets the image colorspace.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ColorspaceType magickGetImageColorspace() => ColorspaceType
      .values[_magickWandBindings.MagickGetImageColorspace(_wandPtr)];

  /// MagickGetImageCompose() returns the composite operator associated with the
  /// image.
  CompositeOperator magickGetImageCompose() => CompositeOperator
      .values[_magickWandBindings.MagickGetImageCompose(_wandPtr)];

  /// MagickGetImageCompression() gets the image compression.
  CompressionType magickGetImageCompression() => CompressionType
      .values[_magickWandBindings.MagickGetImageCompression(_wandPtr)];

  /// MagickGetImageCompressionQuality() gets the image compression quality.
  int magickGetImageCompressionQuality() =>
      _magickWandBindings.MagickGetImageCompressionQuality(_wandPtr);

  /// MagickGetImageDelay() gets the image delay.
  int magickGetImageDelay() =>
      _magickWandBindings.MagickGetImageDelay(_wandPtr);

  /// MagickGetImageDepth() gets the image depth.
  int magickGetImageDepth() =>
      _magickWandBindings.MagickGetImageDepth(_wandPtr);

  /// MagickGetImageDispose() gets the image disposal method.
  DisposeType magickGetImageDispose() => DisposeType.fromValue(
      _magickWandBindings.MagickGetImageDispose(_wandPtr));

  /// MagickGetImageEndian() gets the image endian.
  EndianType magickGetImageEndian() =>
      EndianType.values[_magickWandBindings.MagickGetImageEndian(_wandPtr)];

  /// MagickGetImageFilename() returns the filename of a particular image in a
  /// sequence.
  String magickGetImageFilename() {
    final Pointer<Char> filenamePtr =
        _magickWandBindings.MagickGetImageFilename(_wandPtr);
    final String filename = filenamePtr.toNullableString()!;
    _magickRelinquishMemory(filenamePtr.cast());
    return filename;
  }

  /// MagickGetImageFormat() returns the format of a particular image in a
  /// sequence.
  String magickGetImageFormat() {
    final Pointer<Char> formatPtr =
        _magickWandBindings.MagickGetImageFormat(_wandPtr);
    final String format = formatPtr.toNullableString()!;
    _magickRelinquishMemory(formatPtr.cast());
    return format;
  }

  /// MagickGetImageFuzz() gets the image fuzz.
  double magickGetImageFuzz() =>
      _magickWandBindings.MagickGetImageFuzz(_wandPtr);

  /// MagickGetImageGamma() gets the image gamma.
  double magickGetImageGamma() =>
      _magickWandBindings.MagickGetImageGamma(_wandPtr);

  /// MagickGetImageGravity() gets the image gravity.
  GravityType magickGetImageGravity() => GravityType.fromValue(
      _magickWandBindings.MagickGetImageGravity(_wandPtr));

  /// MagickGetImageGreenPrimary() returns the chromaticity green primary point.
  MagickGetImageGreenPrimaryResult? magickGetImageGreenPrimary() => using(
        (Arena arena) {
          final Pointer<Double> xPtr = arena();
          final Pointer<Double> yPtr = arena();
          final Pointer<Double> zPtr = arena();
          final bool result = _magickWandBindings.MagickGetImageGreenPrimary(
                  _wandPtr, xPtr, yPtr, zPtr)
              .toBool();
          if (!result) {
            return null;
          }
          return MagickGetImageGreenPrimaryResult(
            xPtr.value,
            yPtr.value,
            zPtr.value,
          );
        },
      );

  /// MagickGetImageHeight() returns the image height.
  int magickGetImageHeight() =>
      _magickWandBindings.MagickGetImageHeight(_wandPtr);

  /// MagickGetImageHistogram() returns the image histogram as an array of
  /// PixelWand wands.
  ///
  /// Don't forget to call [destroyPixelWand] on the returned [PixelWand]s when
  /// done.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<List<PixelWand>?> magickGetImageHistogram() async {
    List<int> pixelWandsPtrsAddresses = await _magickCompute(
      _magickGetImageHistogram,
      _wandPtr.address,
    );
    if (pixelWandsPtrsAddresses.isEmpty) {
      return null;
    }
    return pixelWandsPtrsAddresses
        .map((address) =>
            PixelWand._(Pointer<mwbg.PixelWand>.fromAddress(address)))
        .toList();
  }

  /// MagickGetImageInterlaceScheme() gets the image interlace scheme.
  InterlaceType magickGetImageInterlaceScheme() => InterlaceType
      .values[_magickWandBindings.MagickGetImageInterlaceScheme(_wandPtr)];

  /// MagickGetImageInterpolateMethod() returns the interpolation method for the
  /// specified image.
  PixelInterpolateMethod magickGetImageInterpolateMethod() =>
      PixelInterpolateMethod.values[
          _magickWandBindings.MagickGetImageInterpolateMethod(_wandPtr)];

  /// MagickGetImageIterations() gets the image iterations.
  int magickGetImageIterations() =>
      _magickWandBindings.MagickGetImageIterations(_wandPtr);

  /// MagickGetImageLength() returns the image length in bytes.
  int? magickGetImageLength() => using(
        (Arena arena) {
          final Pointer<Size> lengthPtr = arena();
          final bool result =
              _magickWandBindings.MagickGetImageLength(_wandPtr, lengthPtr)
                  .toBool();
          if (!result) {
            return null;
          }
          return lengthPtr.value;
        },
      );

  /// MagickGetImageMatteColor() returns the image matte color.
  bool magickGetImageMatteColor(PixelWand pixelWand) =>
      _magickWandBindings.MagickGetImageMatteColor(_wandPtr, pixelWand._wandPtr)
          .toBool();

  /// MagickGetImageOrientation() returns the image orientation.
  OrientationType magickGetImageOrientation() => OrientationType
      .values[_magickWandBindings.MagickGetImageOrientation(_wandPtr)];

  /// MagickGetImagePage() returns the page geometry associated with the image.
  MagickGetImagePageResult? magickGetImagePage() => using(
        (Arena arena) {
          final Pointer<Size> widthPtr = arena();
          final Pointer<Size> heightPtr = arena();
          final Pointer<mwbg.ssize_t> xPtr = arena();
          final Pointer<mwbg.ssize_t> yPtr = arena();
          final bool result = _magickWandBindings.MagickGetImagePage(
                  _wandPtr, widthPtr, heightPtr, xPtr, yPtr)
              .toBool();
          if (!result) {
            return null;
          }
          return MagickGetImagePageResult(
            widthPtr.value,
            heightPtr.value,
            xPtr.value,
            yPtr.value,
          );
        },
      );

  /// MagickGetImagePixelColor() gets the color of the specified pixel.
  /// - [x]: the x offset.
  /// - [y]: the y offset.
  bool magickGetImagePixelColor({
    required int x,
    required int y,
    required PixelWand pixelWand,
  }) =>
      _magickWandBindings.MagickGetImagePixelColor(
              _wandPtr, x, y, pixelWand._wandPtr)
          .toBool();

  /// MagickGetImageRedPrimary() returns the chromaticity red primary point.
  MagickGetImageRedPrimaryResult? magickGetImageRedPrimary() => using(
        (Arena arena) {
          final Pointer<Double> xPtr = arena();
          final Pointer<Double> yPtr = arena();
          final Pointer<Double> zPtr = arena();
          final bool result = _magickWandBindings.MagickGetImageRedPrimary(
                  _wandPtr, xPtr, yPtr, zPtr)
              .toBool();
          if (!result) {
            return null;
          }
          return MagickGetImageRedPrimaryResult(
            xPtr.value,
            yPtr.value,
            zPtr.value,
          );
        },
      );

  /// MagickGetImageRegion() extracts a region of the image and returns it as a
  /// new wand.
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [width]: the region width.
  /// - [height]: the region height.
  /// - [x]: the region x offset.
  /// - [y]: the region y offset.
  Future<MagickWand?> magickGetImageRegion({
    required int width,
    required int height,
    required int x,
    required int y,
  }) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickGetImageRegion,
          _MagickGetImageRegionParams(
            _wandPtr.address,
            width,
            height,
            x,
            y,
          ),
        ),
      );

  /// MagickGetImageRenderingIntent() gets the image rendering intent.
  RenderingIntent magickGetImageRenderingIntent() => RenderingIntent
      .values[_magickWandBindings.MagickGetImageRenderingIntent(_wandPtr)];

  /// MagickGetImageResolution() gets the image X and Y resolution.
  MagickGetImageResolutionResult? magickGetImageResolution() => using(
        (Arena arena) {
          final Pointer<Double> xResolutionPtr = arena();
          final Pointer<Double> yResolutionPtr = arena();
          final bool result = _magickWandBindings.MagickGetImageResolution(
                  _wandPtr, xResolutionPtr, yResolutionPtr)
              .toBool();
          if (!result) {
            return null;
          }
          return MagickGetImageResolutionResult(
            xResolutionPtr.value,
            yResolutionPtr.value,
          );
        },
      );

  /// MagickGetImageScene() gets the image scene.
  int magickGetImageScene() =>
      _magickWandBindings.MagickGetImageScene(_wandPtr);

  /// MagickGetImageSignature() generates an SHA-256 message digest for the
  /// image pixel stream.
  String? magickGetImageSignature() => using(
        (Arena arena) {
          final Pointer<Char> signaturePtr =
              _magickWandBindings.MagickGetImageSignature(_wandPtr);
          String? signature = signaturePtr.toNullableString();
          _magickRelinquishMemory(signaturePtr.cast());
          return signature;
        },
      );

  /// MagickGetImageTicksPerSecond() gets the image ticks-per-second.
  int magickGetImageTicksPerSecond() =>
      _magickWandBindings.MagickGetImageTicksPerSecond(_wandPtr);

  /// MagickGetImageType() gets the potential image type.
  ImageType magickGetImageType() =>
      ImageType.values[_magickWandBindings.MagickGetImageType(_wandPtr)];

  /// MagickGetImageUnits() gets the image units of resolution.
  ResolutionType magickGetImageUnits() =>
      ResolutionType.values[_magickWandBindings.MagickGetImageUnits(_wandPtr)];

  /// MagickGetImageVirtualPixelMethod() returns the virtual pixel method for
  /// the specified image.
  VirtualPixelMethod magickGetImageVirtualPixelMethod() => VirtualPixelMethod
      .values[_magickWandBindings.MagickGetImageVirtualPixelMethod(_wandPtr)];

  /// MagickGetImageWhitePoint() returns the chromaticity white point.
  MagickGetImageWhitePointResult? magickGetImageWhitePoint() => using(
        (Arena arena) {
          final Pointer<Double> xPtr = arena();
          final Pointer<Double> yPtr = arena();
          final Pointer<Double> zPtr = arena();
          final bool result = _magickWandBindings.MagickGetImageWhitePoint(
                  _wandPtr, xPtr, yPtr, zPtr)
              .toBool();
          if (!result) {
            return null;
          }
          return MagickGetImageWhitePointResult(
            xPtr.value,
            yPtr.value,
            zPtr.value,
          );
        },
      );

  /// MagickGetImageWidth() returns the image width.
  int magickGetImageWidth() =>
      _magickWandBindings.MagickGetImageWidth(_wandPtr);

  /// MagickGetNumberImages() returns the number of images associated with a
  /// magick wand.
  int magickGetNumberImages() =>
      _magickWandBindings.MagickGetNumberImages(_wandPtr);

  /// MagickGetImageTotalInkDensity() gets the image total ink density.
  Future<double> magickGetImageTotalInkDensity() async => await _magickCompute(
        _magickGetImageTotalInkDensity,
        _wandPtr.address,
      );

  /// MagickHaldClutImage() replaces colors in the image from a Hald color
  /// lookup table. A Hald color lookup table is a 3-dimensional color cube
  /// mapped to 2 dimensions. Create it with the HALD coder. You can apply any
  /// color transformation to the Hald image and then use this method to apply
  /// the transform to the image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [haldWand]: the Hald CLUT image.
  Future<bool> magickHaldClutImage(MagickWand haldWand) async =>
      await _magickCompute(
        _magickHaldClutImage,
        _MagickHaldClutImageParams(
          _wandPtr.address,
          haldWand._wandPtr.address,
        ),
      );

  /// MagickHasNextImage() returns true if the wand has more images when
  /// traversing the list in the forward direction
  bool magickHasNextImage() =>
      _magickWandBindings.MagickHasNextImage(_wandPtr).toBool();

  /// MagickHasPreviousImage() returns true if the wand has more images
  /// when traversing the list in the reverse direction.
  bool magickHasPreviousImage() =>
      _magickWandBindings.MagickHasPreviousImage(_wandPtr).toBool();

  /// MagickHoughLineImage() can be used in conjunction with any binary edge
  /// extracted image (we recommend Canny) to identify lines in the image. The
  /// algorithm accumulates counts for every white pixel for every possible
  /// orientation (for angles from 0 to 179 in 1 degree increments) and
  /// distance from the center of the image to the corner (in 1 px increments)
  /// and stores the counts in an accumulator matrix of angle vs distance. The
  /// size of the accumulator is 180x(diagonal/2). Next it searches this space
  /// for peaks in counts and converts the locations of the peaks to slope and
  /// intercept in the normal x,y input image space. Use the slope/intercepts
  /// to find the endpoints clipped to the bounds of the image. The lines are
  /// then drawn. The counts are a measure of the length of the lines.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [width]: find line pairs as local maxima in this neighborhood.
  /// - [height]: find line pairs as local maxima in this neighborhood.
  /// - [threshold]: the line count threshold.
  Future<bool> magickHoughLineImage(
          int width, int height, int threshold) async =>
      await _magickCompute(
        _magickHoughLineImage,
        _MagickHoughLineImageParams(
          _wandPtr.address,
          width,
          height,
          threshold,
        ),
      );

  /// MagickIdentifyImage() identifies an image by its attributes. Attributes
  /// include the image width, height, size, and others.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<String?> magickIdentifyImage() async => await _magickCompute(
        _magickIdentifyImage,
        _wandPtr.address,
      );

  /// MagickIdentifyImageType() gets the potential image type:
  ///
  /// To ensure the image type matches its potential, use MagickSetImageType().
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<ImageType> magickIdentifyImageType() async => await _magickCompute(
        _magickIdentifyImageType,
        _wandPtr.address,
      );

  /// MagickImplodeImage() creates a new image that is a copy of an existing
  /// one with the image pixels "implode" by the specified percentage.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [amount]: Define the extent of the implosion.
  /// - [method]: the pixel interpolation method.
  Future<bool> magickImplodeImage({
    required double amount,
    required PixelInterpolateMethod method,
  }) =>
      _magickCompute(
        _magickImplodeImage,
        _MagickImplodeImageParams(
          _wandPtr.address,
          amount,
          method,
        ),
      );

  /// MagickImportImageCharPixels() accepts pixel data and stores it in the
  /// image at the location you specify. The method returns true on success
  /// otherwise false if an error is encountered. The pixel data should be as
  /// the order specified by [map].
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: The pixel data.
  ///
  /// - See also: [magickExportImageCharPixels]
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<bool> magickImportImageCharPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
    required Uint8List pixels,
  }) async =>
      await _magickCompute(
        _magickImportImagePixels,
        _MagickImportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
          _StorageType.CharPixel,
          pixels,
        ),
      );

  /// MagickImportImageDoublePixels() accepts pixel data and stores it in the
  /// image at the location you specify. The method returns true on success
  /// otherwise false if an error is encountered. The pixel data should be as
  /// the order specified by [map].
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: The pixel data.
  ///
  /// - See also: [magickExportImageDoublePixels]
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<bool> magickImportImageDoublePixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
    required Float64List pixels,
  }) async =>
      await _magickCompute(
        _magickImportImagePixels,
        _MagickImportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
          _StorageType.DoublePixel,
          pixels,
        ),
      );

  /// MagickImportImageFloatPixels() accepts pixel data and stores it in the
  /// image at the location you specify. The method returns true on success
  /// otherwise false if an error is encountered. The pixel data should be as
  /// the order specified by [map].
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: The pixel data.
  ///
  /// - See also: [magickExportImageFloatPixels]
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<bool> magickImportImageFloatPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
    required Float32List pixels,
  }) async =>
      await _magickCompute(
        _magickImportImagePixels,
        _MagickImportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
          _StorageType.FloatPixel,
          pixels,
        ),
      );

  /// MagickImportImageLongPixels() accepts pixel data and stores it in the
  /// image at the location you specify. The method returns true on success
  /// otherwise false if an error is encountered. The pixel data should be as
  /// the order specified by [map].
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: The pixel data.
  ///
  /// - See also: [magickExportImageLongPixels]
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<bool> magickImportImageLongPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
    required Uint32List pixels,
  }) async =>
      await _magickCompute(
        _magickImportImagePixels,
        _MagickImportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
          _StorageType.LongPixel,
          pixels,
        ),
      );

  /// MagickImportImageLongLongPixels() accepts pixel data and stores it in the
  /// image at the location you specify. The method returns true on success
  /// otherwise false if an error is encountered. The pixel data should be as
  /// the order specified by [map].
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: The pixel data.
  ///
  /// - See also: [magickExportImageLongLongPixels]
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<bool> magickImportImageLongLongPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
    required Uint64List pixels,
  }) async =>
      await _magickCompute(
        _magickImportImagePixels,
        _MagickImportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
          _StorageType.LongLongPixel,
          pixels,
        ),
      );

  /// MagickImportImageShortPixels() accepts pixel data and stores it in the
  /// image at the location you specify. The method returns true on success
  /// otherwise false if an error is encountered. The pixel data should be as
  /// the order specified by [map].
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [x]: The region x offset.
  /// - [y]: The region y offset.
  /// - [columns]: The region width.
  /// - [rows]: The region height.
  /// - [map]: This string reflects the expected ordering of the pixel array.
  /// It can be any combination or order of R = red, G = green, B = blue, A =
  /// alpha (0 is transparent), O = alpha (0 is opaque), C = cyan, Y = yellow,
  /// M = magenta, K = black, I = intensity (for grayscale), P = pad.
  /// - [pixels]: The pixel data.
  ///
  /// - See also: [magickExportImageShortPixels]
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<bool> magickImportImageShortPixels({
    required int x,
    required int y,
    required int columns,
    required int rows,
    required String map,
    required Uint16List pixels,
  }) async =>
      await _magickCompute(
        _magickImportImagePixels,
        _MagickImportImagePixelsParams(
          _wandPtr.address,
          x,
          y,
          columns,
          rows,
          map,
          _StorageType.ShortPixel,
          pixels,
        ),
      );

  /// MagickInterpolativeResizeImage() resize image using a interpolative
  /// method.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickInterpolativeResizeImage({
    required int columns,
    required int rows,
    required PixelInterpolateMethod method,
  }) async =>
      await _magickCompute(
        _magickInterpolativeResizeImage,
        _MagickInterpolativeResizeImageParams(
          _wandPtr.address,
          columns,
          rows,
          method,
        ),
      );

  /// MagickKmeansImage() applies k-means color reduction to an image. This is
  /// a colorspace clustering or segmentation technique.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [numberColors]: number of colors to use as seeds.
  /// - [maxIterations]: maximum number of iterations while converging.
  /// - [tolerance]: the maximum tolerance.
  Future<bool> magickKmeansImage({
    required int numberColors,
    required int maxIterations,
    required double tolerance,
  }) async =>
      await _magickCompute(
        _magickKmeansImage,
        _MagickKmeansImageParams(
          _wandPtr.address,
          numberColors,
          maxIterations,
          tolerance,
        ),
      );

  /// Use MagickKuwaharaImage() is an edge preserving noise reduction filter.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [radius]: the square window radius.
  /// - [sigma]: the standard deviation of the Gaussian, in pixels.
  Future<bool> magickKuwaharaImage({
    required double radius,
    required double sigma,
  }) async =>
      await _magickCompute(
        _magickKuwaharaImage,
        _MagickKuwaharaImageParams(
          _wandPtr.address,
          radius,
          sigma,
        ),
      );

  /// MagickLabelImage() adds a label to your image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  Future<bool> magickLabelImage(String label) async => await _magickCompute(
        _magickLabelImage,
        _MagickLabelImageParams(_wandPtr.address, label),
      );

  /// MagickLevelImage() adjusts the levels of an image by scaling the colors
  /// falling between specified white and black points to the full available
  /// quantum range. The parameters provided represent the black, mid, and
  /// white points. The black point specifies the darkest color in the image.
  /// Colors darker than the black point are set to zero. Mid point specifies a
  /// gamma correction to apply to the image. White point specifies the lightest
  /// color in the image. Colors brighter than the white point are set to the
  /// maximum quantum value.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [blackPoint]: the black point.
  /// - [gamma]: the gamma.
  /// - [whitePoint]: the white point.
  Future<bool> magickLevelImage({
    required double blackPoint,
    required double gamma,
    required double whitePoint,
  }) async =>
      await _magickCompute(
        _magickLevelImage,
        _MagickLevelImageParams(
          _wandPtr.address,
          blackPoint,
          gamma,
          whitePoint,
        ),
      );

  /// MagickLevelImageColors() maps the given color to "black" and "white"
  /// values, linearly spreading out the colors, and level values on a channel
  /// by channel bases, as per LevelImage(). The given colors allows you to
  /// specify different level ranges for each of the color channels separately.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [blackColor]: the black color.
  /// - [whiteColor]: the white color.
  ///- [invert]: if true map the colors (levelize), rather than from (level)
  Future<bool> magickLevelImageColors({
    required PixelWand blackColor,
    required PixelWand whiteColor,
    required bool invert,
  }) async =>
      await _magickCompute(
        _magickLevelImageColors,
        _MagickLevelImageColorsParams(
          _wandPtr.address,
          blackColor._wandPtr.address,
          whiteColor._wandPtr.address,
          invert,
        ),
      );

  /// MagickLevelizeImage() applies the reversed MagickLevelImage(). It
  /// compresses the full range of color values, so that they lie between
  /// the given black and white points. Gamma is applied before the values
  /// are mapped. It can be used to de-contrast a greyscale image to the exact
  /// levels specified.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [blackPoint]: The level to map zero (black) to.
  /// - [whitePoint]: The level to map QuantumRange (white) to.
  /// - [gamma]: adjust gamma by this factor before mapping values.
  Future<bool> magickLevelizeImage({
    required double blackPoint,
    required double whitePoint,
    required double gamma,
  }) async =>
      await _magickCompute(
        _magickLevelizeImage,
        _MagickLevelizeImageParams(
          _wandPtr.address,
          blackPoint,
          whitePoint,
          gamma,
        ),
      );

  /// MagickLinearStretchImage() stretches with saturation the image intensity.
  /// You can also reduce the influence of a particular channel with a gamma
  /// value of 0.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [blackPoint]: the black point.
  /// - [whitePoint]: the white point.
  Future<bool> magickLinearStretchImage({
    required double blackPoint,
    required double whitePoint,
  }) async =>
      await _magickCompute(
        _magickLinearStretchImage,
        _MagickLinearStretchImageParams(
          _wandPtr.address,
          blackPoint,
          whitePoint,
        ),
      );

  /// MagickLiquidRescaleImage() rescales image with seam carving.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [columns]: the number of columns in the scaled image.
  /// - [rows]: the number of rows in the scaled image.
  /// - [deltaX]: maximum seam transversal step (0 means straight seams).
  /// - [rigidity]: introduce a bias for non-straight seams (typically 0).
  Future<bool> magickLiquidRescaleImage({
    required int columns,
    required int rows,
    required double deltaX,
    required double rigidity,
  }) async =>
      await _magickCompute(
        _magickLiquidRescaleImage,
        _MagickLiquidRescaleImageParams(
          _wandPtr.address,
          columns,
          rows,
          deltaX,
          rigidity,
        ),
      );

  /// MagickLocalContrastImage() attempts to increase the appearance of
  /// large-scale light-dark transitions. Local contrast enhancement works
  /// similarly to sharpening with an unsharp mask, however the mask is instead
  /// created using an image with a greater blur distance.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [radius]: the radius of the Gaussian, in pixels, not counting the center
  /// pixel.
  /// - [strength]: the strength of the blur mask in percent.
  Future<bool> magickLocalContrastImage({
    required double radius,
    required double strength,
  }) async =>
      await _magickCompute(
        _magickLocalContrastImage,
        _MagickLocalContrastImageParams(
          _wandPtr.address,
          radius,
          strength,
        ),
      );

  /// MagickMagnifyImage() is a convenience method that scales an image
  /// proportionally to twice its original size.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickMagnifyImage() async =>
      await _magickCompute(_magickMagnifyImage, _wandPtr.address);

  /// MagickMeanShiftImage() delineate arbitrarily shaped clusters in the image.
  /// For each pixel, it visits all the pixels in the neighborhood specified by
  /// the window centered at the pixel and excludes those that are outside the
  /// radius=(window-1)/2 surrounding the pixel. From those pixels, it finds
  /// those that are within the specified color distance from the current mean,
  /// and computes a new x,y centroid from those coordinates and a new mean.
  /// This new x,y centroid is used as the center for a new window. This process
  /// iterates until it converges and the final mean is replaces the (original
  /// window center) pixel value. It repeats this process for the next pixel,
  /// etc., until it processes all pixels in the image. Results are typically
  /// better with colorspaces other than sRGB. We recommend YIQ, YUV or YCbCr.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [width]: the width of the neighborhood.
  /// - [height]: the height of the neighborhood.
  /// - [colorDistance]: the color distance.
  Future<bool> magickMeanShiftImage({
    required int width,
    required int height,
    required double colorDistance,
  }) async =>
      await _magickCompute(
        _magickMeanShiftImage,
        _MagickMeanShiftImageParams(
          _wandPtr.address,
          width,
          height,
          colorDistance,
        ),
      );

  /// MagickMergeImageLayers() composes all the image layers from the current
  /// given image onward to produce a single image of the merged layers. The
  /// inital canvas's size depends on the given LayerMethod, and is initialized
  /// using the first images background color. The images are then composited
  /// onto that image in sequence using the given composition that has been
  ///  assigned to each individual image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// - [method]: the method of selecting the size of the initial canvas.
  Future<MagickWand?> magickMergeImageLayers(LayerMethod method) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickMergeImageLayers,
          _MagickMergeImageLayersParams(
            _wandPtr.address,
            method,
          ),
        ),
      );

  /// MagickMinifyImage() is a convenience method that scales an image
  /// proportionally to one-half its original size
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickMinifyImage() async =>
      await _magickCompute(_magickMinifyImage, _wandPtr.address);

  /// MagickModulateImage() lets you control the brightness, saturation, and
  ///  hue of an image. Hue is the percentage of absolute rotation from the
  /// current position. For example 50 results in a counter-clockwise rotation
  ///  of 90 degrees, 150 results in a clockwise rotation of 90 degrees, with
  ///  0 and 200 both resulting in a rotation of 180 degrees.
  /// To increase the color brightness by 20 and decrease the color saturation
  ///  by 10 and leave the hue unchanged, use: 120,90,100.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [brightness]: the percent change in brightness.
  /// - [saturation]: the percent change in saturation.
  /// - [hue]:the percent change in hue.
  Future<bool> magickModulateImage({
    required double brightness,
    required double saturation,
    required double hue,
  }) async =>
      await _magickCompute(
        _magickModulateImage,
        _MagickModulateImageParams(
          _wandPtr.address,
          brightness,
          saturation,
          hue,
        ),
      );

  /// MagickMontageImage() creates a composite image by combining several
  /// separate images. The images are tiled on the composite image with the
  /// name of the image optionally appearing just below the individual tile.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [drawingWand]: the drawing wand. The font name, size, and color are
  /// obtained from this wand.
  /// - [tileGeometry]: the number of tiles per row and page (e.g. 6x4+0+0).
  /// - [thumbnailGeometry]: Preferred image size and border size of each
  /// thumbnail (e.g. 120x120+4+3>).
  /// - [mode]: Thumbnail framing mode: Frame, Unframe, or Concatenate.
  /// - [frame]: Surround the image with an ornamental border (e.g. 15x15+3+3).
  /// The frame color is that of the thumbnail's matte color.
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  Future<MagickWand?> magickMontageImage({
    required DrawingWand drawingWand,
    required String tileGeometry,
    required String thumbnailGeometry,
    required MontageMode mode,
    required String frame,
  }) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickMontageImage,
          _MagickMontageImageParams(
            _wandPtr.address,
            drawingWand._wandPtr.address,
            tileGeometry,
            thumbnailGeometry,
            mode,
            frame,
          ),
        ),
      );

  /// MagickMorphImages() method morphs a set of images. Both the image pixels
  ///  and size are linearly interpolated to give the appearance of a
  /// meta-morphosis from one image to the next.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// - [numberFrames]: the number of in-between images to generate.
  Future<MagickWand?> magickMorphImages(int numberFrames) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickMorphImages,
          _MagickMorphImagesParams(
            _wandPtr.address,
            numberFrames,
          ),
        ),
      );

  /// MagickMorphologyImage() applies a user supplied kernel to the image
  ///  according to the given morphology method.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  ///
  /// - [method]: the morphology method to be applied.
  /// - [iterations]: apply the operation this many times (or no change). A
  /// value of -1 means loop until no change found. How this is applied may
  /// depend on the morphology method. Typically this is a value of 1.
  /// - [kernel]: An array of doubles representing the morphology kernel.
  Future<bool> magickMorphologyImage({
    required MorphologyMethod method,
    required int iterations,
    required KernelInfo kernel,
  }) async =>
      await _magickCompute(
        _magickMorphologyImage,
        _MagickMorphologyImageParams(
          _wandPtr.address,
          method,
          iterations,
          kernel,
        ),
      );

  /// MagickMotionBlurImage() simulates motion blur. We convolve the image with
  ///  a Gaussian operator of the given radius and standard deviation (sigma).
  ///  For reasonable results, radius should be larger than sigma. Use a radius
  ///  of 0 and MotionBlurImage() selects a suitable radius for you. Angle gives
  ///  the angle of the blurring motion.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [radius]: the radius of the Gaussian, in pixels, not counting the center
  /// pixel.
  /// - [sigma]: the standard deviation of the Gaussian, in pixels.
  /// - [angle]: Apply the effect along this angle.
  Future<bool> magickMotionBlurImage({
    required double radius,
    required double sigma,
    required double angle,
  }) async =>
      await _magickCompute(
        _magickMotionBlurImage,
        _MagickMotionBlurImageParams(
          _wandPtr.address,
          radius,
          sigma,
          angle,
        ),
      );

  /// MagickNegateImage() negates the colors in the reference image. The
  ///  Grayscale option means that only grayscale values within the image are
  /// negated.
  ///
  /// You can also reduce the influence of a particular channel with a gamma
  /// value of 0.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [gray]: If true, only negate grayscale pixels within the image.
  Future<bool> magickNegateImage(bool gray) async => await _magickCompute(
        _magickNegateImage,
        _MagickNegateImageParams(
          _wandPtr.address,
          gray,
        ),
      );

  /// MagickNewImage() adds a blank image canvas of the specified size and
  /// background color to the wand.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [width]: the image width.
  /// - [height]: the image height.
  /// - [background]: the image background color.
  Future<bool> magickNewImage({
    required int width,
    required int height,
    required PixelWand background,
  }) async =>
      await _magickCompute(
        _magickNewImage,
        _MagickNewImageParams(
          _wandPtr.address,
          width,
          height,
          background._wandPtr.address,
        ),
      );

  /// MagickNextImage() sets the next image in the wand as the current image.
  /// It is typically used after MagickResetIterator(), after which its first
  /// use will set the first image as the current image (unless the wand is
  /// empty). It will return false when no more images are left to be
  /// returned which happens when the wand is empty, or the current image is the
  /// last image. When the above condition (end of image list) is reached, the
  /// iterator is automatically set so that you can start using
  /// MagickPreviousImage() to again iterate over the images in the reverse
  /// direction, starting with the last image (again). You can jump to this
  /// condition immediately using MagickSetLastIterator().
  bool magickNextImage() =>
      _magickWandBindings.MagickNextImage(_wandPtr).toBool();

  /// MagickNormalizeImage() enhances the contrast of a color image by adjusting
  /// the pixels color to span the entire range of colors available.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickNormalizeImage() async => await _magickCompute(
        _magickNormalizeImage,
        _wandPtr.address,
      );

  /// MagickOilPaintImage() applies a special effect filter that simulates an
  /// oil painting. Each pixel is replaced by the most frequent color occurring
  /// in a circular region defined by radius.
  ///
  ///  {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [radius]: the radius of the circular neighborhood.
  /// - [sigma]: the standard deviation of the Gaussian, in pixels.
  Future<bool> magickOilPaintImage({
    required double radius,
    required double sigma,
  }) async =>
      await _magickCompute(
        _magickOilPaintImage,
        _MagickOilPaintImageParams(
          _wandPtr.address,
          radius,
          sigma,
        ),
      );

  /// MagickOpaquePaintImage() changes any pixel that matches color with the
  /// color defined by fill.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [target]: Change this target color to the fill color within the image.
  /// - [fill]: the fill pixel wand.
  /// - [fuzz]: By default target must match a particular pixel color exactly.
  ///  However, in many cases two colors may differ by a small amount. The fuzz
  ///  member of image defines how much tolerance is acceptable to consider two
  ///  colors as the same. For example, set fuzz to 10 and the color red at
  ///  intensities of 100 and 102 respectively are now interpreted as the same
  ///  color for the purposes of the floodfill.
  /// - [invert]: paint any pixel that does not match the target color.
  Future<bool> magickOpaquePaintImage({
    required PixelWand target,
    required PixelWand fill,
    required double fuzz,
    required bool invert,
  }) async =>
      await _magickCompute(
        _magickOpaquePaintImage,
        _MagickOpaquePaintImageParams(
          _wandPtr.address,
          target._wandPtr.address,
          fill._wandPtr.address,
          fuzz,
          invert,
        ),
      );

  /// MagickOptimizeImageLayers() compares each image the GIF disposed forms of
  ///  the previous image in the sequence. From this it attempts to select the
  ///  smallest cropped image to replace each frame, while preserving the
  ///  results of the animation.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  Future<MagickWand?> magickOptimizeImageLayers() async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickOptimizeImageLayers,
          _wandPtr.address,
        ),
      );

  /// MagickOptimizeImageTransparency() takes a frame optimized GIF animation,
  /// and compares the overlayed pixels against the disposal image resulting
  /// from all the previous frames in the animation. Any pixel that does not
  /// change the disposal image (and thus does not effect the outcome of an
  /// overlay) is made transparent.
  ///
  /// WARNING: This modifies the current images directly, rather than generate a
  /// new image sequence.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickOptimizeImageTransparency() async => await _magickCompute(
        _magickOptimizeImageTransparency,
        _wandPtr.address,
      );

  /// MagickOrderedDitherImage() performs an ordered dither based on a number
  ///  of pre-defined dithering threshold maps, but over multiple intensity
  /// levels, which can be different for different channels, according to the
  /// input arguments.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// {@macro magick_wand.invalid_params_crash_the_app}
  ///
  /// - [thresholdMap] : A string containing the name of the threshold dither
  /// map to use, followed by zero or more numbers representing the number of
  /// color levels tho dither between.
  /// Any level number less than 2 is equivalent to 2, and means only binary
  ///  dithering will be applied to each color channel.
  /// No numbers also means a 2 level (bitmap) dither will be applied to all
  ///  channels, while a single number is the number of levels applied to each
  ///  channel in sequence. More numbers will be applied in turn to each of the
  ///  color channels.
  /// For example: "o3x3,6" generates a 6 level posterization of the image with
  ///  a ordered 3x3 diffused pixel dither being applied between each level.
  /// While checker,8,8,4 will produce a 332 colormaped image with only a single
  ///  checkerboard hash pattern (50 grey) between each color level, to
  ///  basically double the number of color levels with a bare minimum of
  ///  dithering.
  Future<bool> magickOrderedDitherImage(String thresholdMap) async =>
      await _magickCompute(
        _magickOrderedDitherImage,
        _MagickOrderedDitherImageParams(
          _wandPtr.address,
          thresholdMap,
        ),
      );

  /// MagickPingImage() is the same as MagickReadImage() except the only valid
  ///  information returned is the image width, height, size, and format. It is
  ///  designed to efficiently obtain this information from a file without
  /// reading the entire image sequence into memory.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [fileName]: The image filename.
  Future<bool> magickPingImage(String fileName) async => await _magickCompute(
        _magickPingImage,
        _MagickPingImageParams(
          _wandPtr.address,
          fileName,
        ),
      );

  /// MagickPolaroidImage() simulates a Polaroid picture.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [drawingWand]: the draw wand.
  /// - [caption]: the Polaroid caption.
  /// - [angle]: Apply the effect along this angle.
  /// - [method]: the pixel interpolation method.
  Future<bool> magickPolaroidImage({
    required DrawingWand drawingWand,
    required String caption,
    required double angle,
    required PixelInterpolateMethod method,
  }) async =>
      await _magickCompute(
        _magickPolaroidImage,
        _MagickPolaroidImageParams(
          _wandPtr.address,
          drawingWand._wandPtr.address,
          caption,
          angle,
          method,
        ),
      );

  /// MagickPosterizeImage() reduces the image to a limited number of color
  /// level.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [levels]: Number of color levels allowed in each channel. Very low
  /// values (2, 3, or 4) have the most visible effect.
  /// - [method]: chooses the dither method.
  Future<bool> magickPosterizeImage({
    required int levels,
    required DitherMethod method,
  }) async =>
      await _magickCompute(
        _magickPosterizeImage,
        _MagickPosterizeImageParams(
          _wandPtr.address,
          levels,
          method,
        ),
      );

  /// MagickPreviewImages() tiles 9 thumbnails of the specified image with an
  ///  image processing operation applied at varying strengths. This helpful to
  ///  quickly pin-point an appropriate parameter for an image processing
  ///  operation.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// - [preview]: the image processing operation.
  Future<MagickWand?> magickPreviewImages(PreviewType preview) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickPreviewImages,
          _MagickPreviewImagesParams(
            _wandPtr.address,
            preview,
          ),
        ),
      );

  /// MagickPreviousImage() sets the previous image in the wand as the current
  /// image.
  /// It is typically used after magickSetLastIterator(), after which its first
  /// use will set the last image as the current image (unless the wand is
  /// empty).
  /// It will return false when no more images are left to be returned which
  /// happens when the wand is empty, or the current image is the first image.
  /// At that point the iterator is than reset to again process images in the
  /// forward direction, again starting with the first image in list. Images
  /// added at this point are prepended.
  /// Also at that point any images added to the wand using
  /// magickAddImages() or magickReadImages() will be prepended before the first
  /// image. In this sense the condition is not quite exactly the same as
  /// magickResetIterator().
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  bool magickPreviousImage() =>
      _magickWandBindings.MagickPreviousImage(_wandPtr).toBool();

  /// MagickQuantizeImage() analyzes the colors within a reference image and
  ///  chooses a fixed number of colors to represent the image. The goal of the
  ///  algorithm is to minimize the color difference between the input and
  ///  output image while minimizing the processing time.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [numberColors]: the number of colors.
  /// - [colorspace]: perform color reduction in this colorspace, typically
  /// RGBColorspace.
  /// - [treeDepth]: Normally, this integer value is zero or one. A zero or one
  /// tells Quantize to choose a optimal tree depth of Log4(number_colors). A
  /// tree of this depth generally allows the best representation of the
  /// reference image with the least amount of memory and the fastest
  /// computational speed. In some cases, such as an image with low color
  /// dispersion (a few number of colors), a value other than
  /// Log4(number_colors) is required. To expand the color tree completely, use
  /// a value of 8.
  /// - [ditherMethod]: choose from UndefinedDitherMethod, NoDitherMethod,
  /// RiemersmaDitherMethod, FloydSteinbergDitherMethod.
  /// - [measureError]: A value other than zero measures the difference between
  /// the original and quantized images. This difference is the total
  /// quantization error. The error is computed by summing over all pixels in an
  /// image the distance squared in RGB space between each reference pixel value
  /// and its quantized value.
  Future<bool> magickQuantizeImage({
    required int numberColors,
    required ColorspaceType colorspace,
    required int treeDepth,
    required DitherMethod ditherMethod,
    required bool measureError,
  }) async =>
      await _magickCompute(
        _magickQuantizeImage,
        _MagickQuantizeImageParams(
          _wandPtr.address,
          numberColors,
          colorspace,
          treeDepth,
          ditherMethod,
          measureError,
        ),
      );

  /// MagickRangeThresholdImage() applies soft and hard thresholding.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickRangeThresholdImage({
    required double lowBlack,
    required double lowWhite,
    required double highWhite,
    required double highBlack,
  }) async =>
      await _magickCompute(
        _magickRangeThresholdImage,
        _MagickRangeThresholdImageParams(
          _wandPtr.address,
          lowBlack,
          lowWhite,
          highWhite,
          highBlack,
        ),
      );

  /// MagickRotationalBlurImage() rotational blurs an image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [angle]: the angle of the blurring effect in degrees.
  Future<bool> magickRotationalBlurImage(double angle) async =>
      await _magickCompute(
        _magickRotationalBlurImage,
        _MagickRotationalBlurImageParams(
          _wandPtr.address,
          angle,
        ),
      );

  /// MagickRaiseImage() creates a simulated three-dimensional button-like
  ///  effect by lightening and darkening the edges of the image. Members width
  ///  and height of raise_info define the width of the vertical and horizontal
  ///  edge of the effect.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [width]: the width of the area to raise.
  /// - [height]: the height of the area to raise.
  /// - [x]: the x offset of the area to raise.
  /// - [y]: the y offset of the area to raise.
  /// - [raise]: a value other than zero creates a 3-D raise effect, otherwise
  /// it has a lowered effect.
  Future<bool> magickRaiseImage({
    required int width,
    required int height,
    required int x,
    required int y,
    required bool raise,
  }) async =>
      await _magickCompute(
        _magickRaiseImage,
        _MagickRaiseImageParams(
          _wandPtr.address,
          width,
          height,
          x,
          y,
          raise,
        ),
      );

  /// MagickRandomThresholdImage() changes the value of individual pixels based
  ///  on the intensity of each pixel compared to threshold. The result is a
  ///  high-contrast, two color image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [low]: the low threshold. Ranges from 0 to QuantumRange.
  /// - [high]: the high threshold. Ranges from 0 to QuantumRange.
  Future<bool> magickRandomThresholdImage({
    required double low,
    required double high,
  }) async =>
      await _magickCompute(
        _magickRandomThresholdImage,
        _MagickRandomThresholdImageParams(
          _wandPtr.address,
          low,
          high,
        ),
      );

  /// Reads an image or image sequence. The images are inserted just before the
  /// current image pointer position. Use magickSetFirstIterator(), to insert
  /// new images before all the current images in the wand,
  /// magickSetLastIterator() to append add to the end,
  /// magickSetIteratorIndex() to place images just after the given index.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickReadImage(String imageFilePath) async =>
      await _magickCompute(
        _magickReadImage,
        _MagickReadImageParams(_wandPtr.address, imageFilePath),
      );

  /// MagickReadImageBlob() reads an image or image sequence from a blob. In all
  ///  other respects it is like MagickReadImage().
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickReadImageBlob(Uint8List blob) async =>
      await _magickCompute(
        _magickReadImageBlob,
        _MagickReadImageBlobParams(
          _wandPtr.address,
          blob,
        ),
      );

  /// MagickRemapImage() replaces the colors of an image with the closest color
  /// from a reference image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [remapWand]: the remap wand.
  /// - [ditherMethod]: the dither method.
  Future<bool> magickRemapImage({
    required MagickWand remapWand,
    required DitherMethod ditherMethod,
  }) async =>
      await _magickCompute(
        _magickRemapImage,
        _MagickRemapImageParams(
          _wandPtr.address,
          remapWand._wandPtr.address,
          ditherMethod,
        ),
      );

  /// MagickRemoveImage() removes an image from the image list.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickRemoveImage() async => await _magickCompute(
        _magickRemoveImage,
        _wandPtr.address,
      );

  /// MagickResampleImage() resample image to desired resolution.
  /// Bessel Blackman Box Catrom Cubic Gaussian Hanning Hermite Lanczos Mitchell
  ///  Point Quadratic Sinc Triangle
  /// Most of the filters are FIR (finite impulse response), however, Bessel,
  /// Gaussian, and Sinc are IIR (infinite impulse response). Bessel and Sinc
  /// are windowed (brought down to zero) with the Blackman filter.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickResampleImage({
    required double xResolution,
    required double yResolution,
    required FilterType filter,
  }) async =>
      await _magickCompute(
        _magickResampleImage,
        _MagickResampleImageParams(
          _wandPtr.address,
          xResolution,
          yResolution,
          filter,
        ),
      );

  /// MagickResetImagePage() resets the Wand page canvas and position.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [page]: the relative page specification.
  Future<bool> magickResetImagePage(String page) async => await _magickCompute(
        _magickResetImagePage,
        _MagickResetImagePageParams(
          _wandPtr.address,
          page,
        ),
      );

  /// MagickResizeImage() scales an image to the desired dimensions with one of
  /// these filters:
  /// ```
  ///  Bessel   Blackman   Box
  ///  Catrom   CubicGaussian
  ///  Hanning  Hermite    Lanczos
  ///  Mitchell PointQuadratic
  ///  Sinc     Triangle
  /// ```
  ///
  /// Most of the filters are FIR (finite impulse response), however, Bessel,
  /// Gaussian, and Sinc are IIR (infinite impulse response). Bessel and Sinc
  /// are windowed (brought down to zero) with the Blackman filter.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [columns]: the number of columns in the scaled image.
  /// - [rows]: the number of rows in the scaled image.
  /// - [filter]: the filter to use.
  Future<bool> magickResizeImage({
    required int columns,
    required int rows,
    required FilterType filter,
  }) async =>
      await _magickCompute(
        _magickResizeImage,
        _MagickResizeImageParams(
          _wandPtr.address,
          columns,
          rows,
          filter,
        ),
      );

  /// MagickRollImage() offsets an image as defined by x and y.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// - [x]: the x offset.
  /// - [y]: the y offset.
  Future<bool> magickRollImage({
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickRollImage,
        _MagickRollImageParams(
          _wandPtr.address,
          x,
          y,
        ),
      );

  /// MagickRotateImage() rotates an image the specified number of degrees.
  /// Empty triangles left over from rotating the image are filled with the
  /// background color.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [background]: the background pixel wand.
  /// - [degrees]: the number of degrees to rotate the image.
  Future<bool> magickRotateImage({
    required PixelWand background,
    required double degrees,
  }) async =>
      await _magickCompute(
        _magickRotateImage,
        _MagickRotateImageParams(
          _wandPtr.address,
          background._wandPtr.address,
          degrees,
        ),
      );

  /// MagickSampleImage() scales an image to the desired dimensions with pixel
  /// sampling. Unlike other scaling methods, this method does not introduce any
  /// additional color into the scaled image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [columns]: the number of columns in the scaled image.
  /// - [rows]: the number of rows in the scaled image.
  Future<bool> magickSampleImage({
    required int columns,
    required int rows,
  }) async =>
      await _magickCompute(
        _magickSampleImage,
        _MagickSampleImageParams(
          _wandPtr.address,
          columns,
          rows,
        ),
      );

  /// MagickScaleImage() scales the size of an image to the given dimensions.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [columns]: the number of columns in the scaled image.
  /// - [rows]: the number of rows in the scaled image.
  Future<bool> magickScaleImage({
    required int columns,
    required int rows,
  }) async =>
      await _magickCompute(
        _magickScaleImage,
        _MagickScaleImageParams(
          _wandPtr.address,
          columns,
          rows,
        ),
      );

  /// MagickSegmentImage() segments an image by analyzing the histograms of the
  /// color components and identifying units that are homogeneous with the fuzzy
  /// C-means technique.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [colorspace]: the image colorspace.
  /// - [verbose]: Set to true to print detailed information about the
  /// identified classes.
  /// - [clusterThreshold]: This represents the minimum number of pixels
  /// contained in a hexahedra before it can be considered valid (expressed as a
  /// percentage).
  /// - [smoothThreshold]: the smoothing threshold eliminates noise in the
  /// second derivative of the histogram. As the value is increased, you can
  /// expect a smoother second derivative.
  Future<bool> magickSegmentImage({
    required ColorspaceType colorspace,
    required bool verbose,
    required double clusterThreshold,
    required double smoothThreshold,
  }) async =>
      await _magickCompute(
        _magickSegmentImage,
        _MagickSegmentImageParams(
          _wandPtr.address,
          colorspace,
          verbose,
          clusterThreshold,
          smoothThreshold,
        ),
      );

  /// MagickSelectiveBlurImage() selectively blur an image within a contrast
  /// threshold. It is similar to the unsharpen mask that sharpens everything with
  /// contrast above a certain threshold.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [radius]: the radius of the gaussian, in pixels, not counting the center
  /// pixel.
  /// - [sigma]: the standard deviation of the gaussian, in pixels.
  /// - [threshold]: only pixels within this contrast threshold are included in
  /// the blur operation.
  Future<bool> magickSelectiveBlurImage({
    required double radius,
    required double sigma,
    required double threshold,
  }) async =>
      await _magickCompute(
        _magickSelectiveBlurImage,
        _MagickSelectiveBlurImageParams(
          _wandPtr.address,
          radius,
          sigma,
          threshold,
        ),
      );

  /// MagickSeparateImage() separates a channel from the image and returns a
  /// grayscale image. A channel is a particular color component of each pixel
  /// in the image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [channel]: the channel.
  Future<bool> magickSeparateImage(ChannelType channel) async =>
      await _magickCompute(
        _magickSeparateImage,
        _MagickSeparateImageParams(
          _wandPtr.address,
          channel,
        ),
      );

  /// MagickSepiaToneImage() applies a special effect to the image, similar to
  /// the effect achieved in a photo darkroom by sepia toning. Threshold ranges
  /// from 0 to QuantumRange and is a measure of the extent of the sepia toning.
  /// A threshold of 80 is a good starting point for a reasonable tone.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [threshold]: Define the extent of the sepia toning.
  Future<bool> magickSepiaToneImage(double threshold) async =>
      await _magickCompute(
        _magickSepiaToneImage,
        _MagickSepiaToneImageParams(
          _wandPtr.address,
          threshold,
        ),
      );

  /// MagickSetImage() replaces the last image returned by
  /// MagickSetIteratorIndex(), MagickNextImage(), MagickPreviousImage() with
  /// the images from the specified wand.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [setWand]: the set_wand wand.
  Future<bool> magickSetImage(MagickWand setWand) async => await _magickCompute(
        _magickSetImage,
        _MagickSetImageParams(
          _wandPtr.address,
          setWand._wandPtr.address,
        ),
      );

  /// MagickSetImageAlphaChannel() activates, deactivates, resets, or sets the
  /// alpha channel.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [alphaType]: the alpha channel type: ActivateAlphaChannel,
  /// DeactivateAlphaChannel, OpaqueAlphaChannel, or SetAlphaChannel.
  Future<bool> magickSetImageAlphaChannel(AlphaChannelOption alphaType) async =>
      await _magickCompute(
        _magickSetImageAlphaChannel,
        _MagickSetImageAlphaChannelParams(
          _wandPtr.address,
          alphaType,
        ),
      );

  /// MagickSetImageBackgroundColor() sets the image background color.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [background]: the background pixel wand.
  bool magickSetImageBackgroundColor(PixelWand background) =>
      _magickWandBindings.MagickSetImageBackgroundColor(
        _wandPtr,
        background._wandPtr,
      ).toBool();

  /// MagickSetImageBluePrimary() sets the image chromaticity blue primary
  /// point.
  /// - [x]: the blue primary x-point.
  /// - [y]: the blue primary y-point.
  /// - [z]: the blue primary z-point.
  bool magickSetImageBluePrimary({
    required double x,
    required double y,
    required double z,
  }) =>
      _magickWandBindings.MagickSetImageBluePrimary(_wandPtr, x, y, z).toBool();

  /// MagickSetImageBorderColor() sets the image border color.
  /// - [border]: the border pixel wand.
  bool magickSetImageBorderColor(PixelWand border) =>
      _magickWandBindings.MagickSetImageBorderColor(
        _wandPtr,
        border._wandPtr,
      ).toBool();

  /// MagickSetImageChannelMask() sets image channel mask.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickSetImageChannelMask(ChannelType channelMask) async =>
      await _magickCompute(
        _magickSetImageChannelMask,
        _MagickSetImageChannelMaskParams(
          _wandPtr.address,
          channelMask,
        ),
      );

  /// MagickSetImageMask() sets image clip mask.
  /// - [type]: type of mask, ReadPixelMask or WritePixelMask.
  /// - [clipMask]: the clip_mask wand.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickSetImageMask({
    required PixelMask type,
    required MagickWand clipMask,
  }) async =>
      await _magickCompute(
        _magickSetImageMask,
        _MagickSetImageMaskParams(
          _wandPtr.address,
          type,
          clipMask._wandPtr.address,
        ),
      );

  /// MagickSetImageColor() set the entire wand canvas to the specified color.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [background]: the image color.
  Future<bool> magickSetImageColor(PixelWand background) async =>
      await _magickCompute(
        _magickSetImageColor,
        _MagickSetImageColorParams(
          _wandPtr.address,
          background._wandPtr.address,
        ),
      );

  /// MagickSetImageColormapColor() sets the color of the specified colormap
  /// index.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [index]: the offset into the image colormap.
  /// - [color]: Return the colormap color in this wand.
  Future<bool> magickSetImageColormapColor({
    required int index,
    required PixelWand color,
  }) async =>
      await _magickCompute(
        _magickSetImageColormapColor,
        _MagickSetImageColormapColorParams(
          _wandPtr.address,
          index,
          color._wandPtr.address,
        ),
      );

  /// MagickSetImageColorspace() sets the image colorspace. But does not modify
  /// the image data.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [colorspace]: the image colorspace.
  Future<bool> magickSetImageColorspace(ColorspaceType colorspace) async =>
      await _magickCompute(
        _magickSetImageColorspace,
        _MagickSetImageColorspaceParams(
          _wandPtr.address,
          colorspace,
        ),
      );

  /// MagickSetImageCompose() sets the image composite operator, useful for
  /// specifying how to composite the image thumbnail when using the
  /// MagickMontageImage() method.
  ///
  /// - [compose]: the image composite operator.
  bool magickSetImageCompose(CompositeOperator compose) =>
      _magickWandBindings.MagickSetImageCompose(
        _wandPtr,
        compose.index,
      ).toBool();

  /// MagickSetImageCompression() sets the image compression.
  /// - [compression]: the image compression type.
  bool magickSetImageCompression(CompressionType compression) =>
      _magickWandBindings.MagickSetImageCompression(
        _wandPtr,
        compression.index,
      ).toBool();

  /// MagickSetImageCompressionQuality() sets the image compression quality.
  /// - [quality]: the image compression quality.
  bool magickSetImageCompressionQuality(int quality) =>
      _magickWandBindings.MagickSetImageCompressionQuality(
        _wandPtr,
        quality,
      ).toBool();

  /// MagickSetImageDelay() sets the image delay.
  /// - [delay]: the image delay in ticks-per-second units.
  bool magickSetImageDelay(int delay) =>
      _magickWandBindings.MagickSetImageDelay(
        _wandPtr,
        delay,
      ).toBool();

  /// MagickSetImageDepth() sets the image depth.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [depth]: the image depth in bits: 8, 16, or 32.
  Future<bool> magickSetImageDepth(int depth) async => await _magickCompute(
        _magickSetImageDepth,
        _MagickSetImageDepthParams(
          _wandPtr.address,
          depth,
        ),
      );

  /// MagickSetImageDispose() sets the image disposal method.
  /// - [dispose]: the image disposal type.
  bool magickSetImageDispose(DisposeType dispose) =>
      _magickWandBindings.MagickSetImageDispose(
        _wandPtr,
        dispose.value,
      ).toBool();

  /// MagickSetImageEndian() sets the image endian method.
  /// - [endian]: the image endian type.
  bool magickSetImageEndian(EndianType endian) =>
      _magickWandBindings.MagickSetImageEndian(
        _wandPtr,
        endian.index,
      ).toBool();

  /// MagickSetImageExtent() sets the image size (i.e. columns & rows).
  /// - [columns]: the image width in pixels.
  /// - [rows]: the image height in pixels.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickSetImageExtent({
    required int columns,
    required int rows,
  }) async =>
      await _magickCompute(
        _magickSetImageExtent,
        _MagickSetImageExtentParams(
          _wandPtr.address,
          columns,
          rows,
        ),
      );

  /// MagickSetImageFilename() sets the filename of a particular image in a
  /// sequence.
  /// - [filename]: the image filename.
  bool magickSetImageFilename(String filename) =>
      using((Arena arena) => _magickWandBindings.MagickSetImageFilename(
            _wandPtr,
            filename.toNativeUtf8(allocator: arena).cast(),
          )).toBool();

  /// MagickSetImageFormat() sets the format of a particular image in a
  /// sequence.
  /// - [format]: the image format.
  bool magickSetImageFormat(String format) =>
      using((Arena arena) => _magickWandBindings.MagickSetImageFormat(
            _wandPtr,
            format.toNativeUtf8(allocator: arena).cast(),
          )).toBool();

  /// MagickSetImageFuzz() sets the image fuzz.
  /// - [fuzz]: the image fuzz.
  bool magickSetImageFuzz(double fuzz) =>
      _magickWandBindings.MagickSetImageFuzz(
        _wandPtr,
        fuzz,
      ).toBool();

  /// MagickSetImageGamma() sets the image gamma.
  /// - [gamma]: the image gamma.
  bool magickSetImageGamma(double gamma) =>
      _magickWandBindings.MagickSetImageGamma(
        _wandPtr,
        gamma,
      ).toBool();

  /// MagickSetImageGravity() sets the image gravity type.
  /// - [gravity]: the image gravity type.
  bool magickSetImageGravity(GravityType gravity) =>
      _magickWandBindings.MagickSetImageGravity(
        _wandPtr,
        gravity.value,
      ).toBool();

  /// MagickSetImageGreenPrimary() sets the image chromaticity green primary
  /// point.
  /// - [x]: the green primary x-point.
  /// - [y]: the green primary y-point.
  /// - [z]: the green primary z-point.
  bool magickSetImageGreenPrimary(double x, double y, double z) =>
      _magickWandBindings.MagickSetImageGreenPrimary(
        _wandPtr,
        x,
        y,
        z,
      ).toBool();

  /// MagickSetImageInterlaceScheme() sets the image interlace scheme.
  /// - [interlace]: the image interlace scheme.
  bool magickSetImageInterlaceScheme(InterlaceType interlace) =>
      _magickWandBindings.MagickSetImageInterlaceScheme(
        _wandPtr,
        interlace.index,
      ).toBool();

  /// MagickSetImageInterpolateMethod() sets the image interpolate pixel method.
  /// - [interpolate]: the image interpolate pixel method.
  bool magickSetImageInterpolateMethod(PixelInterpolateMethod interpolate) =>
      _magickWandBindings.MagickSetImageInterpolateMethod(
        _wandPtr,
        interpolate.index,
      ).toBool();

  /// MagickSetImageIterations() sets the image iterations.
  /// - [delay]: the image delay in 1/100th of a second.
  bool magickSetImageIterations(int iterations) =>
      _magickWandBindings.MagickSetImageIterations(
        _wandPtr,
        iterations,
      ).toBool();

  /// MagickSetImageMatte() sets the image matte channel.
  /// - [matte]: Set to true to enable the image matte channel otherwise
  /// false.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickSetImageMatte(bool matte) async => await _magickCompute(
        _magickSetImageMatte,
        _MagickSetImageMatteParams(
          _wandPtr.address,
          matte,
        ),
      );

  /// MagickSetImageMatteColor() sets the image alpha color.
  /// - [matte]: the alpha pixel wand.
  bool magickSetImageMatteColor(PixelWand matte) =>
      _magickWandBindings.MagickSetImageMatteColor(
        _wandPtr,
        matte._wandPtr,
      ).toBool();

  /// MagickSetImageAlpha() sets the image to the specified alpha level.
  /// - [alpha]: the level of transparency: 1.0 is fully opaque and 0.0 is fully
  /// transparent.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickSetImageAlpha(double alpha) async => await _magickCompute(
        _magickSetImageAlpha,
        _MagickSetImageAlphaParams(
          _wandPtr.address,
          alpha,
        ),
      );

  /// MagickSetImageOrientation() sets the image orientation.
  /// - [orientation]: the image orientation type.
  bool magickSetImageOrientation(OrientationType orientation) =>
      _magickWandBindings.MagickSetImageOrientation(
        _wandPtr,
        orientation.index,
      ).toBool();

  /// MagickSetImagePage() sets the page geometry of the image.
  /// - [width]: the page width.
  /// - [height]: the page height.
  /// - [x]: the page x-offset.
  /// - [y]: the page y-offset.
  bool magickSetImagePage({
    required int width,
    required int height,
    required int x,
    required int y,
  }) =>
      _magickWandBindings.MagickSetImagePage(
        _wandPtr,
        width,
        height,
        x,
        y,
      ).toBool();

  /// MagickSetImagePixelColor() sets the color of the specified pixel.
  /// - [x]: the x offset into the image.
  /// - [y]: the y offset into the image.
  /// - [color]: Return the colormap color in this wand.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickSetImagePixelColor({
    required int x,
    required int y,
    required PixelWand color,
  }) async =>
      await _magickCompute(
        _magickSetImagePixelColor,
        _MagickSetImagePixelColorParams(
          _wandPtr.address,
          x,
          y,
          color._wandPtr.address,
        ),
      );

  /// MagickSetImageRedPrimary() sets the image chromaticity red primary point.
  /// - [x]: the red primary x-point.
  /// - [y]: the red primary y-point.
  /// - [z]: the red primary z-point.
  bool magickSetImageRedPrimary({
    required double x,
    required double y,
    required double z,
  }) =>
      _magickWandBindings.MagickSetImageRedPrimary(
        _wandPtr,
        x,
        y,
        z,
      ).toBool();

  /// MagickSetImageRenderingIntent() sets the image rendering intent.
  /// - [renderingIntent]: the image rendering intent.
  bool magickSetImageRenderingIntent(RenderingIntent renderingIntent) =>
      _magickWandBindings.MagickSetImageRenderingIntent(
        _wandPtr,
        renderingIntent.index,
      ).toBool();

  /// MagickSetImageResolution() sets the image resolution.
  /// - [xResolution]: the image x resolution.
  /// - [yResolution]: the image y resolution.
  bool magickSetImageResolution({
    required double xResolution,
    required double yResolution,
  }) =>
      _magickWandBindings.MagickSetImageResolution(
        _wandPtr,
        xResolution,
        yResolution,
      ).toBool();

  /// MagickSetImageScene() sets the image scene.
  /// - [scene]: the image scene number.
  bool magickSetImageScene(int scene) =>
      _magickWandBindings.MagickSetImageScene(
        _wandPtr,
        scene,
      ).toBool();

  /// MagickSetImageTicksPerSecond() sets the image ticks-per-second.
  /// - [ticksPerSecond]: the units to use for the image delay.
  bool magickSetImageTicksPerSecond(int ticksPerSecond) =>
      _magickWandBindings.MagickSetImageTicksPerSecond(
        _wandPtr,
        ticksPerSecond,
      ).toBool();

  /// MagickSetImageType() sets the image type.
  /// - [imageType]: the image type.
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickSetImageType(ImageType imageType) async =>
      await _magickCompute(
        _magickSetImageType,
        _MagickSetImageTypeParams(
          _wandPtr.address,
          imageType,
        ),
      );

  /// MagickSetImageUnits() sets the image units of resolution.
  /// - [units]: the image units of resolution.
  bool magickSetImageUnits(ResolutionType units) =>
      _magickWandBindings.MagickSetImageUnits(
        _wandPtr,
        units.index,
      ).toBool();

  /// MagickSetImageVirtualPixelMethod() sets the image virtual pixel method.
  /// - [method]: the image virtual pixel method.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickSetImageVirtualPixelMethod(
    VirtualPixelMethod method,
  ) async =>
      await _magickCompute(
        _magickSetImageVirtualPixelMethod,
        _MagickSetImageVirtualPixelMethodParams(
          _wandPtr.address,
          method,
        ),
      );

  /// MagickSetImageWhitePoint() sets the image chromaticity white point.
  /// - [x]: the white x-point.
  /// - [y]: the white y-point.
  /// - [z]: the white z-point.
  bool magickSetImageWhitePoint({
    required double x,
    required double y,
    required double z,
  }) =>
      _magickWandBindings.MagickSetImageWhitePoint(
        _wandPtr,
        x,
        y,
        z,
      ).toBool();

  /// MagickShadeImage() shines a distant light on an image to create a
  /// three-dimensional effect. You control the positioning of the light with
  /// azimuth and elevation; azimuth is measured in degrees off the x axis and
  /// elevation is measured in pixels above the Z axis.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [gray]: A value other than zero shades the intensity of each pixel.
  /// - [azimuth]: Define the light source direction.
  /// - [elevation]: Define the light source direction.
  Future<bool> magickShadeImage({
    required bool gray,
    required double azimuth,
    required double elevation,
  }) async =>
      await _magickCompute(
        _magickShadeImage,
        _MagickShadeImageParams(
          _wandPtr.address,
          gray,
          azimuth,
          elevation,
        ),
      );

  /// MagickShadowImage() simulates an image shadow.
  /// - [alpha]: percentage transparency.
  /// - [sigma]: the standard deviation of the Gaussian, in pixels.
  /// - [x]: the shadow x-offset.
  /// - [y]: the shadow y-offset.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickShadowImage({
    required double alpha,
    required double sigma,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickShadowImage,
        _MagickShadowImageParams(
          _wandPtr.address,
          alpha,
          sigma,
          x,
          y,
        ),
      );

  /// MagickSharpenImage() sharpens an image. We convolve the image with a
  /// Gaussian operator of the given radius and standard deviation (sigma). For
  /// reasonable results, the radius should be larger than sigma. Use a radius
  /// of 0 and MagickSharpenImage() selects a suitable radius for you.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [radius]: the radius of the Gaussian, in pixels, not counting the center
  ///  pixel.
  /// - [sigma]: the standard deviation of the Gaussian, in pixels.
  Future<bool> magickSharpenImage({
    required double radius,
    required double sigma,
  }) async =>
      await _magickCompute(
        _magickSharpenImage,
        _MagickSharpenImageParams(
          _wandPtr.address,
          radius,
          sigma,
        ),
      );

  /// MagickShaveImage() shaves pixels from the image edges.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [columns]: the number of columns in the scaled image.
  /// - [rows]: the number of rows in the scaled image.
  Future<bool> magickShaveImage({
    required int columns,
    required int rows,
  }) async =>
      await _magickCompute(
        _magickShaveImage,
        _MagickShaveImageParams(
          _wandPtr.address,
          columns,
          rows,
        ),
      );

  /// MagickShearImage() slides one edge of an image along the X or Y axis,
  /// creating a parallelogram. An X direction shear slides an edge along the X
  /// axis, while a Y direction shear slides an edge along the Y axis. The
  /// amount of the shear is controlled by a shear angle. For X direction
  /// shears, x_shear is measured relative to the Y axis, and similarly, for Y
  /// direction shears y_shear is measured relative to the X axis. Empty
  /// triangles left over from shearing the image are filled with the
  /// background color.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [background]: the background pixel wand.
  /// - [xShear]: the number of degrees to shear the image.
  /// - [yShear]: the number of degrees to shear the image.
  Future<bool> magickShearImage({
    required PixelWand background,
    required double xShear,
    required double yShear,
  }) async =>
      await _magickCompute(
        _magickShearImage,
        _MagickShearImageParams(
          _wandPtr.address,
          background._wandPtr.address,
          xShear,
          yShear,
        ),
      );

  /// MagickSigmoidalContrastImage() adjusts the contrast of an image with a
  /// non-linear sigmoidal contrast algorithm. Increase the contrast of the image
  /// using a sigmoidal transfer function without saturating highlights or
  /// shadows. Contrast indicates how much to increase the contrast (0 is none;
  /// 3 is typical; 20 is pushing it); mid-point indicates where midtones fall in
  /// the resultant image (0 is white; 50 is middle-gray; 100 is black). Set
  /// sharpen to true to increase the image contrast otherwise the contrast
  /// is reduced.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [sharpen]: Increase or decrease image contrast.
  /// - [alpha]: strength of the contrast, the larger the number the more
  /// 'threshold-like' it becomes.
  /// - [beta]: midpoint of the function as a color value 0 to QuantumRange.
  Future<bool> magickSigmoidalContrastImage({
    required bool sharpen,
    required double alpha,
    required double beta,
  }) async =>
      await _magickCompute(
        _magickSigmoidalContrastImage,
        _MagickSigmoidalContrastImageParams(
          _wandPtr.address,
          sharpen,
          alpha,
          beta,
        ),
      );

  /// MagickSketchImage() simulates a pencil sketch. We convolve the image with
  /// a Gaussian operator of the given radius and standard deviation (sigma).
  /// For reasonable results, radius should be larger than sigma. Use a radius
  /// of 0 and SketchImage() selects a suitable radius for you. Angle gives the
  /// angle of the blurring motion.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [radius]: the radius of the Gaussian, in pixels, not counting the center
  /// pixel.
  /// - [sigma]: the standard deviation of the Gaussian, in pixels.
  /// - [angle]: apply the effect along this angle.
  Future<bool> magickSketchImage({
    required double radius,
    required double sigma,
    required double angle,
  }) async =>
      await _magickCompute(
        _magickSketchImage,
        _MagickSketchImageParams(
          _wandPtr.address,
          radius,
          sigma,
          angle,
        ),
      );

  /// MagickSmushImages() takes all images from the current image pointer to the
  /// end of the image list and smushes them to each other top-to-bottom if the
  /// stack parameter is true, otherwise left-to-right.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// - [stack]: By default, images are stacked left-to-right. Set stack to
  /// true to stack them top-to-bottom.
  /// - [offset]: minimum distance in pixels between images.
  Future<MagickWand?> magickSmushImages({
    required bool stack,
    required int offset,
  }) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickSmushImages,
          _MagickSmushImagesParams(
            _wandPtr.address,
            stack,
            offset,
          ),
        ),
      );

  /// MagickSolarizeImage() applies a special effect to the image, similar to
  /// the effect achieved in a photo darkroom by selectively exposing areas of
  /// photo sensitive paper to light. Threshold ranges from 0 to QuantumRange
  /// and is a measure of the extent of the solarization.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [threshold]: Define the extent of the solarization.
  Future<bool> magickSolarizeImage(double threshold) async =>
      await _magickCompute(
        _magickSolarizeImage,
        _MagickSolarizeImageParams(
          _wandPtr.address,
          threshold,
        ),
      );

  /// MagickSparseColorImage() given a set of coordinates, interpolates the
  /// colors found at those coordinates, across the whole image, using various
  /// methods.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [method]: the method of image sparseion.
  /// ArcSparseColorion will always ignore source image offset, and always
  /// 'bestfit' the destination image with the top left corner offset relative
  /// to the polar mapping center.
  ///
  /// Bilinear has no simple inverse mapping so will not allow 'bestfit' style
  /// of image sparseion.
  ///
  /// Affine, Perspective, and Bilinear, will do least squares fitting of the
  /// distortion when more than the minimum number of control point pairs are
  /// provided.
  ///
  /// Perspective, and Bilinear, will fall back to a Affine sparseion when
  /// less than 4 control point pairs are provided. While Affine sparseions
  /// will let you use any number of control point pairs, that is Zero pairs
  /// is a No-Op (viewport only) distortion, one pair is a translation and two
  /// pairs of control points will do a scale-rotate-translate, without any
  /// shearing.
  /// - [arguments]: the arguments for this sparseion method.
  Future<bool> magickSparseColorImage({
    required SparseColorMethod method,
    required Float64List arguments,
  }) async =>
      await _magickCompute(
        _magickSparseColorImage,
        _MagickSparseColorImageParams(
          _wandPtr.address,
          method,
          arguments,
        ),
      );

  /// MagickSpliceImage() splices a solid color into the image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [width]: the region width.
  /// - [height]: the region height.
  /// - [x]: the region x offset.
  /// - [y]: the region y offset.
  Future<bool> magickSpliceImage({
    required int width,
    required int height,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickSpliceImage,
        _MagickSpliceImageParams(
          _wandPtr.address,
          width,
          height,
          x,
          y,
        ),
      );

  /// MagickSpreadImage() is a special effects method that randomly displaces
  /// each pixel in a block defined by the radius parameter.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [method]: interpolation method.
  /// - [radius]: Choose a random pixel in a neighborhood of this extent.
  Future<bool> magickSpreadImage({
    required PixelInterpolateMethod method,
    required double radius,
  }) async =>
      await _magickCompute(
        _magickSpreadImage,
        _MagickSpreadImageParams(
          _wandPtr.address,
          method,
          radius,
        ),
      );

  /// MagickStatisticImage() replace each pixel with corresponding statistic
  /// from the neighborhood of the specified width and height.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [type]: the statistic type (e.g. median, mode, etc.).
  /// - [width]: the width of the pixel neighborhood.
  /// - [height]: the height of the pixel neighborhood.
  Future<bool> magickStatisticImage({
    required StatisticType type,
    required int width,
    required int height,
  }) async =>
      await _magickCompute(
        _magickStatisticImage,
        _MagickStatisticImageParams(
          _wandPtr.address,
          type,
          width,
          height,
        ),
      );

  /// MagickSteganoImage() hides a digital watermark within the image. Recover
  /// the hidden watermark later to prove that the authenticity of an image.
  /// Offset defines the start position within the image to hide the watermark.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  ///
  /// - [watermarkWand] : the watermark wand.
  /// - [offset] : Start hiding at this offset into the image.
  Future<MagickWand?> magickSteganoImage({
    required MagickWand watermarkWand,
    required int offset,
  }) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickSteganoImage,
          _MagickSteganoImageParams(
            _wandPtr.address,
            watermarkWand._wandPtr.address,
            offset,
          ),
        ),
      );

  /// MagickStereoImage() composites two images and produces a single image
  /// that is the composite of a left and right image of a stereo pair.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  /// - [offsetWand]: Another image wand.
  Future<MagickWand?> magickStereoImage(MagickWand offsetWand) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickStereoImage,
          _MagickStereoImageParams(
            _wandPtr.address,
            offsetWand._wandPtr.address,
          ),
        ),
      );

  /// MagickStripImage() strips an image of all profiles and comments.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickStripImage() async => await _magickCompute(
        _magickStripImage,
        _wandPtr.address,
      );

  /// MagickSwirlImage() swirls the pixels about the center of the image, where
  /// degrees indicates the sweep of the arc through which each pixel is moved.
  /// You get a more dramatic effect as the degrees move from 1 to 360.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [degrees]: Define the tightness of the swirling effect.
  /// - [method]: the pixel interpolation method.
  Future<bool> magickSwirlImage({
    required double degrees,
    required PixelInterpolateMethod method,
  }) async =>
      await _magickCompute(
        _magickSwirlImage,
        _MagickSwirlImageParams(
          _wandPtr.address,
          degrees,
          method,
        ),
      );

  /// MagickTextureImage() repeatedly tiles the texture image across and down
  /// the image canvas.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  ///
  /// {@macro magick_wand.do_not_forget_to_destroy_returned_wand}
  /// - [textureWand]: the texture wand.
  Future<MagickWand?> magickTextureImage(MagickWand textureWand) async =>
      MagickWand._fromAddress(
        await _magickCompute(
          _magickTextureImage,
          _MagickTextureImageParams(
            _wandPtr.address,
            textureWand._wandPtr.address,
          ),
        ),
      );

  /// MagickThresholdImage() changes the value of individual pixels based on
  /// the intensity of each pixel compared to threshold. The result is a
  /// high-contrast, two color image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [threshold]: Define the threshold value.
  Future<bool> magickThresholdImage(double threshold) async =>
      await _magickCompute(
        _magickThresholdImage,
        _MagickThresholdImageParams(
          _wandPtr.address,
          threshold,
        ),
      );

  /// MagickThresholdImageChannel() changes the value of individual pixels based
  ///  on the intensity of each pixel compared to threshold. The result is a
  /// high-contrast, two color image. It differs from MagickThresholdImage() in
  /// that it lets you specify a channel.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [channel]: the channel.
  /// - [threshold]: Define the threshold value.
  Future<bool> magickThresholdImageChannel({
    required ChannelType channel,
    required double threshold,
  }) async =>
      await _magickCompute(
        _magickThresholdImageChannel,
        _MagickThresholdImageChannelParams(
          _wandPtr.address,
          channel,
          threshold,
        ),
      );

  /// MagickThumbnailImage() changes the size of an image to the given
  /// dimensions and removes any associated profiles. The goal is to produce
  /// small low cost thumbnail images suited for display on the Web.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [columns]: the number of columns in the scaled image.
  /// - [rows]: the number of rows in the scaled image.
  Future<bool> magickThumbnailImage({
    required int columns,
    required int rows,
  }) async =>
      await _magickCompute(
        _magickThumbnailImage,
        _MagickThumbnailImageParams(
          _wandPtr.address,
          columns,
          rows,
        ),
      );

  /// MagickTintImage() applies a color vector to each pixel in the image. The
  /// length of the vector is 0 for black and white and at its maximum for the
  /// midtones. The vector weighting function is
  /// f(x)=(1-(4.0*((x-0.5)*(x-0.5)))).
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [tint]: the tint pixel wand.
  /// - [blend]: the blend pixel wand.
  Future<bool> magickTintImage({
    required PixelWand tint,
    required PixelWand blend,
  }) async =>
      await _magickCompute(
        _magickTintImage,
        _MagickTintImageParams(
          _wandPtr.address,
          tint._wandPtr.address,
          blend._wandPtr.address,
        ),
      );

  /// MagickTransformImageColorspace() transform the image colorspace, setting
  ///  the images colorspace while transforming the images data to that
  ///  colorspace.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [colorspace]: the image colorspace.
  Future<bool> magickTransformImageColorspace(
          ColorspaceType colorspace) async =>
      await _magickCompute(
        _magickTransformImageColorspace,
        _MagickTransformImageColorspaceParams(
          _wandPtr.address,
          colorspace,
        ),
      );

  /// MagickTransparentPaintImage() changes any pixel that matches color with
  /// the color defined by fill.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [target]: Change this target color to specified alpha value within the
  /// image.
  /// - [alpha]: the level of transparency: 1.0 is fully opaque and 0.0 is fully
  /// transparent.
  /// - [fuzz]: By default target must match a particular pixel color exactly.
  /// However, in many cases two colors may differ by a small amount. The fuzz
  /// member of image defines how much tolerance is acceptable to consider two
  /// colors as the same. For example, set fuzz to 10 and the color red at
  /// intensities of 100 and 102 respectively are now interpreted as the same
  /// color for the purposes of the floodfill.
  /// - [invert]: paint any pixel that does not match the target color.
  Future<bool> magickTransparentPaintImage({
    required PixelWand target,
    required double alpha,
    required double fuzz,
    required bool invert,
  }) async =>
      await _magickCompute(
        _magickTransparentPaintImage,
        _MagickTransparentPaintImageParams(
          _wandPtr.address,
          target._wandPtr.address,
          alpha,
          fuzz,
          invert,
        ),
      );

  /// MagickTransposeImage() creates a vertical mirror image by reflecting the
  /// pixels around the central x-axis while rotating them 90-degrees.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickTransposeImage() async => await _magickCompute(
        _magickTransposeImage,
        _wandPtr.address,
      );

  /// MagickTransverseImage() creates a horizontal mirror image by reflecting
  ///  the pixels around the central y-axis while rotating them 270-degrees.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickTransverseImage() async => await _magickCompute(
        _magickTransverseImage,
        _wandPtr.address,
      );

  /// MagickTrimImage() remove edges that are the background color from the
  /// image.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [fuzz]: By default target must match a particular pixel color exactly.
  /// However, in many cases two colors may differ by a small amount. The fuzz
  /// member of image defines how much tolerance is acceptable to consider two
  /// colors as the same. For example, set fuzz to 10 and the color red at
  /// intensities of 100 and 102 respectively are now interpreted as the same
  /// color for the purposes of the floodfill.
  Future<bool> magickTrimImage(double fuzz) async => await _magickCompute(
        _magickTrimImage,
        _MagickTrimImageParams(_wandPtr.address, fuzz),
      );

  /// MagickUniqueImageColors() discards all but one of any pixel color.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickUniqueImageColors() async => await _magickCompute(
        _magickUniqueImageColors,
        _wandPtr.address,
      );

  /// MagickUnsharpMaskImage() sharpens an image. We convolve the image with a
  /// Gaussian operator of the given radius and standard deviation (sigma). For
  /// reasonable results, radius should be larger than sigma. Use a radius of 0
  /// and UnsharpMaskImage() selects a suitable radius for you.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [radius]: the radius of the Gaussian, in pixels, not counting the center
  /// pixel.
  /// - [sigma]: the standard deviation of the Gaussian, in pixels.
  /// - [gain]: the percentage of the difference between the original and the
  /// blur image that is added back into the original.
  /// - [threshold]: the threshold in pixels needed to apply the difference gain.
  Future<bool> magickUnsharpMaskImage({
    required double radius,
    required double sigma,
    required double gain,
    required double threshold,
  }) async =>
      await _magickCompute(
        _magickUnsharpMaskImage,
        _MagickUnsharpMaskImageParams(
          _wandPtr.address,
          radius,
          sigma,
          gain,
          threshold,
        ),
      );

  /// MagickVignetteImage() softens the edges of the image in vignette style.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [radius]: the radius.
  /// - [sigma]: the sigma.
  /// - [x]: Define the x ellipse offset.
  /// - [y]: Define the y ellipse offset.
  Future<bool> magickVignetteImage({
    required double radius,
    required double sigma,
    required int x,
    required int y,
  }) async =>
      await _magickCompute(
        _magickVignetteImage,
        _MagickVignetteImageParams(
          _wandPtr.address,
          radius,
          sigma,
          x,
          y,
        ),
      );

  /// MagickWaveImage() creates a "ripple" effect in the image by shifting the
  /// pixels vertically along a sine wave whose amplitude and wavelength is
  /// specified by the given parameters.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [amplitude]: Define the amplitude of the sine wave.
  /// - [waveLength]: Define the wave length of the sine wave.
  /// - [method]: the pixel interpolation method.
  Future<bool> magickWaveImage({
    required double amplitude,
    required double waveLength,
    required PixelInterpolateMethod method,
  }) async =>
      await _magickCompute(
        _magickWaveImage,
        _MagickWaveImageParams(
          _wandPtr.address,
          amplitude,
          waveLength,
          method,
        ),
      );

  /// MagickWaveletDenoiseImage() removes noise from the image using a wavelet
  /// transform. The wavelet transform is a fast hierarchical scheme for
  /// processing an image using a set of consecutive lowpass and high_pass
  /// filters, followed by a decimation. This results in a decomposition into
  /// different scales which can be regarded as different “frequency bands”,
  /// determined by the mother wavelet.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [threshold]: set the threshold for smoothing.
  /// - [softness]: attenuate the smoothing threshold.
  Future<bool> magickWaveletDenoiseImage({
    required double threshold,
    required double softness,
  }) async =>
      await _magickCompute(
        _magickWaveletDenoiseImage,
        _MagickWaveletDenoiseImageParams(
          _wandPtr.address,
          threshold,
          softness,
        ),
      );

  /// MagickWhiteBalanceImage() applies white balancing to an image according to
  /// a grayworld assumption in the LAB colorspace.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickWhiteBalanceImage() async => await _magickCompute(
        _magickWhiteBalanceImage,
        _wandPtr.address,
      );

  /// MagickWhiteThresholdImage() is like ThresholdImage() but force all pixels
  /// above the threshold into white while leaving all pixels below the
  /// threshold unchanged.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [threshold]: the threshold color.
  Future<bool> magickWhiteThresholdImage(PixelWand threshold) async =>
      await _magickCompute(
        _magickWhiteThresholdImage,
        _MagickWhiteThresholdImageParams(
          _wandPtr.address,
          threshold._wandPtr.address,
        ),
      );

  /// Writes an image to the specified filename. If the filename parameter is
  /// NULL, the image is written to the filename set by magickReadImage() or
  /// magickSetImageFilename().
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  Future<bool> magickWriteImage(String imageFilePath) async =>
      await _magickCompute(
        _magickWriteImage,
        _MagickWriteImageParams(_wandPtr.address, imageFilePath),
      );

  /// MagickWriteImages() writes an image or image sequence.
  ///
  /// {@macro magick_wand.method_runs_in_different_isolate}
  /// - [imageFilePath]: the image filename.
  /// - [adjoin]: join images into a single multi-image file.
  Future<bool> magickWriteImages(String imageFilePath, bool adjoin) async =>
      await _magickCompute(
        _magickWriteImages,
        _MagickWriteImagesParams(
          _wandPtr.address,
          imageFilePath,
          adjoin,
        ),
      );
}
