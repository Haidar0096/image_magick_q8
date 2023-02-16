part of 'image_magick_q8.dart';

/// PixelWand is used to manage and control pixels in an image.
///
/// Create a new PixelWand with [newPixelWand] or with the other available
/// constructors.
///
/// When done with a PixelWand, destroy it with [destroyPixelWand].
class PixelWand {
  final Pointer<mwbg.PixelWand> _wandPtr;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PixelWand &&
          runtimeType == other.runtimeType &&
          _wandPtr == other._wandPtr;

  @override
  int get hashCode => _wandPtr.hashCode;

  const PixelWand._(this._wandPtr);

  static PixelWand? _fromAddress(int address) => address == 0
      ? null
      : PixelWand._(Pointer<mwbg.PixelWand>.fromAddress(address));

  /// ClearPixelWand() clears resources associated with the PixelWand.
  void clearPixelWand() => _magickWandBindings.ClearPixelWand(_wandPtr);

  /// ClonePixelWand() makes an exact copy of the specified wand.
  ///
  /// {@template pixel_wand.don't_forget_to_destroy}
  /// Don't forget to destroy the returned PixelWand with [destroyPixelWand].
  /// {@endtemplate}
  PixelWand clonePixelWand() =>
      PixelWand._(_magickWandBindings.ClonePixelWand(_wandPtr));

  /// DestroyPixelWand() deallocates resources associated with a PixelWand.
  ///
  /// <strong> Never use a PixelWand after it has been destroyed. </strong>
  void destroyPixelWand() => _magickWandBindings.DestroyPixelWand(_wandPtr);

  /// IsPixelWandSimilar() returns MagickTrue if the distance between two colors
  ///  is less than the specified distance.
  /// - [other] the other pixel wand.
  /// - [fuzz] any two colors that are less than or equal to this distance
  ///  squared are consider similar.
  bool isPixelWandSimilar({
    required PixelWand other,
    required double fuzz,
  }) =>
      _magickWandBindings.IsPixelWandSimilar(
        _wandPtr,
        other._wandPtr,
        fuzz,
      ).toBool();

  /// IsPixelWand() returns true if the wand is verified as a pixel wand.
  bool isPixelWand() => _magickWandBindings.IsPixelWand(_wandPtr).toBool();

  /// NewPixelWand() returns a new pixel wand.
  factory PixelWand.newPixelWand() =>
      PixelWand._(_magickWandBindings.NewPixelWand());

  /// NewPixelWands() returns a list of pixel wands.
  static List<PixelWand> newPixelWands(int count) {
    final Pointer<Pointer<mwbg.PixelWand>> wandsPtrs =
        _magickWandBindings.NewPixelWands(count);
    final List<PixelWand> wands = [];
    for (int i = 0; i < count; i++) {
      wands.add(PixelWand._(wandsPtrs[i]));
    }
    return wands;
  }

  /// PixelClearException() clear any exceptions associated with the iterator.
  bool pixelClearException() =>
      _magickWandBindings.PixelClearException(_wandPtr).toBool();

  /// PixelGetAlpha() returns the normalized alpha value of the pixel wand.
  double pixelGetAlpha() => _magickWandBindings.PixelGetAlpha(_wandPtr);

  /// PixelGetBlack() returns the normalized black color of the pixel wand.
  double pixelGetBlack() => _magickWandBindings.PixelGetBlack(_wandPtr);

  /// PixelGetBlue() returns the normalized blue color of the pixel wand.
  double pixelGetBlue() => _magickWandBindings.PixelGetBlue(_wandPtr);

  /// PixelGetColorAsString() returns the color of the pixel wand as a string.
  String? pixelGetColorAsString() {
    final Pointer<Char> colorPtr =
        _magickWandBindings.PixelGetColorAsString(_wandPtr);
    String? color = colorPtr.toNullableString();
    _magickRelinquishMemory(colorPtr.cast());
    return color;
  }

  /// PixelGetColorAsNormalizedString() returns the normalized color of the
  /// pixel wand as a string.
  String? pixelGetColorAsNormalizedString() {
    final Pointer<Char> colorPtr =
        _magickWandBindings.PixelGetColorAsNormalizedString(_wandPtr);
    String? color = colorPtr.toNullableString();
    _magickRelinquishMemory(colorPtr.cast());
    return color;
  }

  /// PixelGetColorCount() returns the color count associated with this color.
  int pixelGetColorCount() => _magickWandBindings.PixelGetColorCount(_wandPtr);

  /// PixelGetCyan() returns the normalized cyan color of the pixel wand.
  double pixelGetCyan() => _magickWandBindings.PixelGetCyan(_wandPtr);

  /// PixelGetException() returns the severity, reason, and description of any
  /// error that occurs when using other methods in this API.
  PixelGetExceptionResult pixelGetException() => using(
        (Arena arena) {
          final Pointer<Int32> severityPtr = arena();
          final Pointer<Char> descriptionPtr =
              _magickWandBindings.PixelGetException(
            _wandPtr,
            severityPtr,
          );
          final PixelGetExceptionResult result = PixelGetExceptionResult(
            ExceptionType.fromValue(severityPtr.value),
            descriptionPtr.toNullableString()!,
          );
          _magickRelinquishMemory(descriptionPtr.cast());
          return result;
        },
      );

  /// PixelGetExceptionType() the exception type associated with the wand. If
  /// no exception has occurred, UndefinedExceptionType is returned.
  ExceptionType pixelGetExceptionType() => ExceptionType.fromValue(
      _magickWandBindings.PixelGetExceptionType(_wandPtr));

  /// PixelGetFuzz() returns the normalized fuzz value of the pixel wand.
  double pixelGetFuzz() => _magickWandBindings.PixelGetFuzz(_wandPtr);

  /// PixelGetGreen() returns the normalized green color of the pixel wand.
  double pixelGetGreen() => _magickWandBindings.PixelGetGreen(_wandPtr);

  /// PixelGetHSL() returns the normalized HSL color of the pixel wand.
  PixelGetHSLResult pixelGetHSL() => using(
        (Arena arena) {
          final Pointer<Double> huePtr = arena();
          final Pointer<Double> saturationPtr = arena();
          final Pointer<Double> lightnessPtr = arena();
          _magickWandBindings.PixelGetHSL(
            _wandPtr,
            huePtr,
            saturationPtr,
            lightnessPtr,
          );
          return PixelGetHSLResult(
            huePtr.value,
            saturationPtr.value,
            lightnessPtr.value,
          );
        },
      );

  /// PixelGetMagenta() returns the normalized magenta color of the pixel wand.
  double pixelGetMagenta() => _magickWandBindings.PixelGetMagenta(_wandPtr);

  /// PixelGetMagickColor() gets the magick color of the pixel wand.
  PixelInfo pixelGetMagickColor() => using(
        (Arena arena) {
          final Pointer<mwbg.PixelInfo> pixelInfoPtr = arena();
          _magickWandBindings.PixelGetMagickColor(_wandPtr, pixelInfoPtr);
          return PixelInfo._fromPixelInfoStructPointer(pixelInfoPtr)!;
        },
      );

  /// PixelGetPixel() returns the pixel wand pixel.
  PixelInfo pixelGetPixel() => PixelInfo._fromPixelInfoStruct(
        _magickWandBindings.PixelGetPixel(_wandPtr),
      );

  /// PixelGetQuantumPacket() gets the packet of the pixel wand as a PixelInfo.
  PixelInfo pixelGetQuantumPacket() => using(
        (Arena arena) {
          final Pointer<mwbg.PixelInfo> pixelInfoPtr = arena();
          _magickWandBindings.PixelGetQuantumPacket(_wandPtr, pixelInfoPtr);
          return PixelInfo._fromPixelInfoStructPointer(pixelInfoPtr)!;
        },
      );

  /// PixelGetRed() returns the normalized red color of the pixel wand.
  double pixelGetRed() => _magickWandBindings.PixelGetRed(_wandPtr);

  /// PixelGetYellow() returns the normalized yellow color of the pixel wand.
  double pixelGetYellow() => _magickWandBindings.PixelGetYellow(_wandPtr);

  /// PixelSetAlpha() sets the normalized alpha value of the pixel wand.
  void pixelSetAlpha(double alpha) =>
      _magickWandBindings.PixelSetAlpha(_wandPtr, alpha);

  /// PixelSetBlack() sets the normalized black color of the pixel wand.
  void pixelSetBlack(double black) =>
      _magickWandBindings.PixelSetBlack(_wandPtr, black);

  /// PixelSetBlue() sets the normalized blue color of the pixel wand.
  void pixelSetBlue(double blue) =>
      _magickWandBindings.PixelSetBlue(_wandPtr, blue);

  /// PixelSetColor() sets the color of the pixel wand with a string (e.g.
  /// "blue", "#0000ff", "rgb(0,0,255)", "cmyk(100,100,100,10)", etc.).
  bool pixelSetColor(String color) => using(
        (Arena arena) => _magickWandBindings.PixelSetColor(
          _wandPtr,
          color.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// PixelSetColorCount() sets the color count of the pixel wand.
  void pixelSetColorCount(int colorCount) =>
      _magickWandBindings.PixelSetColorCount(_wandPtr, colorCount);

  /// PixelSetColorFromWand() sets the color of the pixel wand.
  /// - [color] set the pixel wand color here
  void pixelSetColorFromWand(PixelWand color) =>
      _magickWandBindings.PixelSetColorFromWand(_wandPtr, color._wandPtr);

  /// PixelSetCyan() sets the normalized cyan color of the pixel wand.
  void pixelSetCyan(double cyan) =>
      _magickWandBindings.PixelSetCyan(_wandPtr, cyan);

  /// PixelSetFuzz() sets the fuzz value of the pixel wand.
  void pixelSetFuzz(double fuzz) =>
      _magickWandBindings.PixelSetFuzz(_wandPtr, fuzz);

  /// PixelSetGreen() sets the normalized green color of the pixel wand.
  void pixelSetGreen(double green) =>
      _magickWandBindings.PixelSetGreen(_wandPtr, green);

  /// PixelSetHSL() sets the normalized HSL color of the pixel wand.
  void pixelSetHSL({
    required double hue,
    required double saturation,
    required double lightness,
  }) =>
      _magickWandBindings.PixelSetHSL(
        _wandPtr,
        hue,
        saturation,
        lightness,
      );

  /// PixelSetMagenta() sets the normalized magenta color of the pixel wand.
  void pixelSetMagenta(double magenta) =>
      _magickWandBindings.PixelSetMagenta(_wandPtr, magenta);

  /// PixelSetPixelColor() sets the color of the pixel wand.
  /// - [color] the pixel wand color
  void pixelSetPixelColor(PixelInfo color) => using(
        (Arena arena) => _magickWandBindings.PixelSetPixelColor(
          _wandPtr,
          color._toPixelInfoStructPointer(allocator: arena),
        ),
      );

  /// PixelSetRed() sets the normalized red color of the pixel wand.
  void pixelSetRed(double red) =>
      _magickWandBindings.PixelSetRed(_wandPtr, red);

  /// PixelSetYellow() sets the normalized yellow color of the pixel wand.
  void pixelSetYellow(double yellow) =>
      _magickWandBindings.PixelSetYellow(_wandPtr, yellow);
}
