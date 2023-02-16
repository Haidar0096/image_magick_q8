part of 'image_magick_q8.dart';

/// A DrawingWand is a wand that contains vector drawing methods.
///
/// For example you can apply the [DrawingWand] to a [MagickWand] using
/// [MagickDrawImage] method from [MagickWand] class.
///
/// Create a new DrawingWand object with [newDrawingWand].
///
/// Dispose of a DrawingWand object with [destroyDrawingWand].
class DrawingWand {
  final Pointer<mwbg.DrawingWand> _wandPtr;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawingWand &&
          runtimeType == other.runtimeType &&
          _wandPtr == other._wandPtr;

  @override
  int get hashCode => _wandPtr.hashCode;

  const DrawingWand._(this._wandPtr);

  /// ClearDrawingWand() clears resources associated with the drawing wand.
  void clearDrawingWand() => _magickWandBindings.ClearDrawingWand(_wandPtr);

  /// CloneDrawingWand() makes an exact copy of the specified wand.
  DrawingWand cloneDrawingWand() =>
      DrawingWand._(_magickWandBindings.CloneDrawingWand(_wandPtr));

  /// DestroyDrawingWand() disposes the drawing wand.
  ///
  /// Once disposed, the wand should not be used.
  void destroyDrawingWand() => _magickWandBindings.DestroyDrawingWand(_wandPtr);

  /// DrawAffine() adjusts the current affine transformation matrix with the
  /// specified affine transformation matrix. Note that the current affine
  /// transform is adjusted rather than replaced.
  void drawAffine(AffineMatrix affineMatrix) => using(
        (Arena arena) => _magickWandBindings.DrawAffine(
          _wandPtr,
          affineMatrix._toAffineMatrixStructPointer(allocator: arena),
        ),
      );

  /// DrawAlpha() paints on the image's alpha channel in order to set effected
  /// pixels to transparent.
  /// The available paint methods are:
  /// * PointMethod: Select the target pixel
  /// * ReplaceMethod: Select any pixel that matches the target pixel.
  /// * FloodfillMethod: Select the target pixel and matching neighbors.
  /// * FillToBorderMethod: Select the target pixel and neighbors not matching
  /// border color.
  /// * ResetMethod: Select all pixels.
  ///
  /// - [x] : x ordinate
  /// - [y] : y ordinate
  /// - [paintMethod] paint method.
  void drawAlpha({
    required double x,
    required double y,
    required PaintMethod paintMethod,
  }) =>
      _magickWandBindings.DrawAlpha(
        _wandPtr,
        x,
        y,
        paintMethod.index,
      );

  /// DrawAnnotation() draws text on the image.
  ///
  /// - [x] : x ordinate to left of text
  /// - [y] : y ordinate to text baseline
  /// - [text] : text to draw
  void drawAnnotation({
    required double x,
    required double y,
    required String text,
  }) =>
      using(
        (Arena arena) => _magickWandBindings.DrawAnnotation(
          _wandPtr,
          x,
          y,
          text.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// DrawArc() draws an arc falling within a specified bounding rectangle on
  /// the image.
  /// - [sx] : starting x ordinate of bounding rectangle
  /// - [sy] : starting y ordinate of bounding rectangle
  /// - [ex] : ending x ordinate of bounding rectangle
  /// - [ey] : ending y ordinate of bounding rectangle
  /// - [sd] : starting degrees of rotation
  /// - [ed] : ending degrees of rotation
  void drawArc({
    required double sx,
    required double sy,
    required double ex,
    required double ey,
    required double sd,
    required double ed,
  }) =>
      _magickWandBindings.DrawArc(
        _wandPtr,
        sx,
        sy,
        ex,
        ey,
        sd,
        ed,
      );

  /// DrawBezier() draws a bezier curve through a set of points on the image.
  /// - [coordinates] : coordinates
  void drawBezier(List<PointInfo> coordinates) => using(
        (Arena arena) {
          if (coordinates.isEmpty) return;
          Pointer<mwbg.PointInfo> coordinatesPointer =
              arena(coordinates.length);
          for (int i = 0; i < coordinates.length; i++) {
            coordinatesPointer[i] =
                coordinates[i]._toPointInfoStructPointer(allocator: arena).ref;
          }
          _magickWandBindings.DrawBezier(
            _wandPtr,
            coordinates.length,
            coordinatesPointer,
          );
        },
      );

  /// DrawCircle() draws a circle on the image.
  /// - [ox] : origin x ordinate
  /// - [oy] : origin y ordinate
  /// - [px] : perimeter x ordinate
  /// - [py] : perimeter y ordinate
  void drawCircle({
    required double ox,
    required double oy,
    required double px,
    required double py,
  }) =>
      _magickWandBindings.DrawCircle(
        _wandPtr,
        ox,
        oy,
        px,
        py,
      );

  /// DrawClearException() clear any exceptions associated with the wand.
  bool drawClearException() =>
      _magickWandBindings.DrawClearException(_wandPtr).toBool();

  /// DrawColor() draws color on image using the current fill color, starting at
  /// specified position, and using specified paint method. The available paint
  /// methods are:
  /// * PointMethod: Recolors the target pixel
  /// * ReplaceMethod: Recolor any pixel that matches the target pixel.
  /// * FloodfillMethod: Recolors target pixels and matching neighbors.
  /// * ResetMethod: Recolor all pixels.
  /// - [x] : x ordinate
  /// - [y] : y ordinate
  /// - [paintMethod] paint method.
  void drawColor({
    required double x,
    required double y,
    required PaintMethod paintMethod,
  }) =>
      _magickWandBindings.DrawColor(
        _wandPtr,
        x,
        y,
        paintMethod.index,
      );

  /// DrawComposite() composites an image onto the current image, using the
  /// specified composition operator, specified position, and at the specified
  /// size.
  ///
  /// {@template drawing_wand.runs_in_different_isolate}
  /// This method runs in a different isolate than the main isolate.
  /// {@endtemplate}
  ///
  /// - [compose] : composition operator
  /// - [x] : x ordinate of top left corner
  /// - [y] : y ordinate of top left corner
  /// - [width] : Width to resize image to prior to compositing. Specify zero to
  /// use existing width.
  /// - [height] : Height to resize image to prior to compositing. Specify zero
  /// to use existing height.
  /// - [magickWand] : Image to composite is obtained from this wand.
  Future<void> drawComposite({
    required CompositeOperator compose,
    required double x,
    required double y,
    required double width,
    required double height,
    required MagickWand magickWand,
  }) async =>
      await _magickCompute(
        _drawComposite,
        _DrawCompositeParams(
          _wandPtr.address,
          compose,
          x,
          y,
          width,
          height,
          magickWand._wandPtr.address,
        ),
      );

  /// DrawComment() adds a comment to a vector output stream.
  void drawComment(String comment) => using(
        (Arena arena) => _magickWandBindings.DrawComment(
          _wandPtr,
          comment.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// DrawEllipse() draws an ellipse on the image.
  /// - [ox] : origin x ordinate
  /// - [oy] : origin y ordinate
  /// - [rx] : radius in x
  /// - [ry] : radius in y
  /// - [start] : starting rotation in degrees
  /// - [end] : ending rotation in degrees
  void drawEllipse({
    required double ox,
    required double oy,
    required double rx,
    required double ry,
    required double start,
    required double end,
  }) =>
      _magickWandBindings.DrawEllipse(
        _wandPtr,
        ox,
        oy,
        rx,
        ry,
        start,
        end,
      );

  /// DrawGetBorderColor() returns the border color used for drawing bordered
  /// objects.
  /// - [pixelWand] : Return the border color.
  void drawGetBorderColor(PixelWand pixelWand) =>
      _magickWandBindings.DrawGetBorderColor(
        _wandPtr,
        pixelWand._wandPtr,
      );

  /// DrawGetClipPath() obtains the current clipping path ID. The value returned
  /// must be deallocated by the user when it is no longer needed.
  String? drawGetClipPath() {
    final Pointer<Char> resultPtr =
        _magickWandBindings.DrawGetClipPath(_wandPtr);
    final String? result = resultPtr.toNullableString();
    _magickRelinquishMemory(resultPtr.cast());
    return result;
  }

  /// DrawGetClipRule() returns the current polygon fill rule to be used by the
  /// clipping path.
  FillRule drawGetClipRule() =>
      FillRule.values[_magickWandBindings.DrawGetClipRule(_wandPtr)];

  /// DrawGetClipUnits() returns the interpretation of clip path units.
  ClipPathUnits drawGetClipUnits() =>
      ClipPathUnits.values[_magickWandBindings.DrawGetClipUnits(_wandPtr)];

  /// DrawGetDensity() obtains the vertical and horizontal resolution.
  String? drawGetDensity() {
    final Pointer<Char> resultPtr =
        _magickWandBindings.DrawGetDensity(_wandPtr);
    final String? result = resultPtr.toNullableString();
    _magickRelinquishMemory(resultPtr.cast());
    return result;
  }

  /// DrawGetException() returns the severity, reason, and description of any
  /// error that occurs when using other methods in this API.
  DrawGetExceptionResult drawGetException() => using(
        (Arena arena) {
          final Pointer<Int32> severityPtr = arena();
          final Pointer<Char> descriptionPtr =
              _magickWandBindings.DrawGetException(
            _wandPtr,
            severityPtr,
          );
          final String description = descriptionPtr.toNullableString()!;
          _magickRelinquishMemory(descriptionPtr.cast());
          return DrawGetExceptionResult(
            ExceptionType.fromValue(severityPtr.value),
            description,
          );
        },
      );

  /// DrawGetExceptionType() returns the exception type associated with the
  /// wand. If no exception has occurred, [ExceptionType.undefined] is
  /// returned.
  ExceptionType drawGetExceptionType() => ExceptionType.fromValue(
      _magickWandBindings.DrawGetExceptionType(_wandPtr));

  /// DrawGetFillColor() returns the fill color used for drawing filled objects.
  /// - [pixelWand] : Return the fill color.
  void drawGetFillColor(PixelWand pixelWand) =>
      _magickWandBindings.DrawGetFillColor(
        _wandPtr,
        pixelWand._wandPtr,
      );

  /// DrawGetFillOpacity() returns the alpha used when drawing using the fill
  /// color or fill texture. Fully opaque is 1.0.
  double drawGetFillOpacity() =>
      _magickWandBindings.DrawGetFillOpacity(_wandPtr);

  /// DrawGetFillRule() returns the fill rule used while drawing polygons.
  FillRule drawGetFillRule() =>
      FillRule.values[_magickWandBindings.DrawGetFillRule(_wandPtr)];

  /// DrawGetFont() returns a string specifying the font used
  /// when annotating with text.
  String? drawGetFont() {
    final Pointer<Char> resultPtr = _magickWandBindings.DrawGetFont(_wandPtr);
    final String? result = resultPtr.toNullableString();
    _magickRelinquishMemory(resultPtr.cast());
    return result;
  }

  /// DrawGetFontFamily() returns the font family to use when annotating with
  /// text.
  String? drawGetFontFamily() {
    final Pointer<Char> resultPtr =
        _magickWandBindings.DrawGetFontFamily(_wandPtr);
    final String? result = resultPtr.toNullableString();
    _magickRelinquishMemory(resultPtr.cast());
    return result;
  }

  /// DrawGetFontResolution() gets the image X and Y resolution.
  DrawGetFontResolutionResult? drawGetFontResolution() => using(
        (Arena arena) {
          final Pointer<Double> xPtr = arena();
          final Pointer<Double> yPtr = arena();
          final bool result = _magickWandBindings.DrawGetFontResolution(
            _wandPtr,
            xPtr,
            yPtr,
          ).toBool();
          if (!result) return null;
          return DrawGetFontResolutionResult(
            xPtr.value,
            yPtr.value,
          );
        },
      );

  /// DrawGetFontSize() returns the font pointsize used when annotating with
  /// text.
  double drawGetFontSize() => _magickWandBindings.DrawGetFontSize(_wandPtr);

  /// DrawGetFontStretch() returns the font stretch used when annotating with
  /// text.
  StretchType drawGetFontStretch() =>
      StretchType.values[_magickWandBindings.DrawGetFontStretch(_wandPtr)];

  /// DrawGetFontStyle() returns the font style used when annotating with text.
  StyleType drawGetFontStyle() =>
      StyleType.values[_magickWandBindings.DrawGetFontStyle(_wandPtr)];

  /// DrawGetFontWeight() returns the font weight used when annotating with
  /// text.
  int drawGetFontWeight() => _magickWandBindings.DrawGetFontWeight(_wandPtr);

  /// DrawGetGravity() returns the text placement gravity used when annotating
  /// with text.
  GravityType drawGetGravity() =>
      GravityType.fromValue(_magickWandBindings.DrawGetGravity(_wandPtr));

  /// DrawGetOpacity() returns the alpha used when drawing with the fill or
  /// stroke color or texture. Fully opaque is 1.0.
  double drawGetOpacity() => _magickWandBindings.DrawGetOpacity(_wandPtr);

  /// DrawGetStrokeAntialias() returns the current stroke antialias setting.
  /// Stroked outlines are antialiased by default. When antialiasing is disabled
  /// stroked pixels are thresholded to determine if the stroke color or
  /// underlying canvas color should be used.
  bool drawGetStrokeAntialias() =>
      _magickWandBindings.DrawGetStrokeAntialias(_wandPtr).toBool();

  /// DrawGetStrokeColor() returns the color used for stroking object outlines.
  ///
  /// - [strokeColor] : Return the stroke color.
  void drawGetStrokeColor(PixelWand strokeColor) =>
      _magickWandBindings.DrawGetStrokeColor(_wandPtr, strokeColor._wandPtr);

  /// DrawGetStrokeDashArray() returns an array representing the pattern of
  /// dashes and gaps used to stroke paths (see DrawSetStrokeDashArray)
  Float64List? drawGetStrokeDashArray() => using(
        (Arena arena) {
          final Pointer<Size> numberElementsPtr = arena();
          final Pointer<Double> arrayPtr =
              _magickWandBindings.DrawGetStrokeDashArray(
            _wandPtr,
            numberElementsPtr,
          );
          Float64List? array = arrayPtr.toFloat64List(numberElementsPtr.value);
          _magickRelinquishMemory(arrayPtr.cast());
          return array;
        },
      );

  /// DrawGetStrokeDashOffset() returns the offset into the dash pattern to
  /// start the dash.
  double drawGetStrokeDashOffset() =>
      _magickWandBindings.DrawGetStrokeDashOffset(_wandPtr);

  /// DrawGetStrokeLineCap() returns the shape to be used at the end of open
  /// subpaths when they are stroked.
  /// Values of LineCap are UndefinedCap, ButtCap, RoundCap, and SquareCap.
  LineCap drawGetStrokeLineCap() =>
      LineCap.values[_magickWandBindings.DrawGetStrokeLineCap(_wandPtr)];

  /// DrawGetStrokeLineJoin() returns the shape to be used at the corners of
  /// paths (or other vector shapes) when they are stroked.
  /// Values of LineJoin are UndefinedJoin, MiterJoin, RoundJoin, and BevelJoin.
  LineJoin drawGetStrokeLineJoin() =>
      LineJoin.values[_magickWandBindings.DrawGetStrokeLineJoin(_wandPtr)];

  /// DrawGetStrokeMiterLimit() returns the miter limit. When two line segments
  /// meet at a sharp angle and miter joins have been specified for 'lineJoin',
  /// it is possible for the miter to extend far beyond the thickness of the
  /// line stroking the path. The miterLimit' imposes a limit on the ratio of
  /// the miter length to the 'lineWidth'.
  int drawGetStrokeMiterLimit() =>
      _magickWandBindings.DrawGetStrokeMiterLimit(_wandPtr);

  /// DrawGetStrokeOpacity() returns the alpha of stroked object outlines.
  double drawGetStrokeOpacity() =>
      _magickWandBindings.DrawGetStrokeOpacity(_wandPtr);

  /// DrawGetStrokeWidth() returns the width of the stroke used to draw object
  /// outlines.
  double drawGetStrokeWidth() =>
      _magickWandBindings.DrawGetStrokeWidth(_wandPtr);

  /// DrawGetTextAlignment() returns the alignment applied when annotating with
  /// text.
  AlignType drawGetTextAlignment() =>
      AlignType.values[_magickWandBindings.DrawGetTextAlignment(_wandPtr)];

  /// DrawGetTextAntialias() returns the current text antialias setting, which
  /// determines whether text is antialiased. Text is antialiased by default.
  bool drawGetTextAntiAlias() =>
      _magickWandBindings.DrawGetTextAntialias(_wandPtr).toBool();

  /// DrawGetTextDecoration() returns the decoration applied when annotating
  /// with text.
  DecorationType drawGetTextDecoration() => DecorationType
      .values[_magickWandBindings.DrawGetTextDecoration(_wandPtr)];

  /// DrawGetTextDirection() returns the direction that will be used when
  /// annotating with text.
  DirectionType drawGetTextDirection() =>
      DirectionType.values[_magickWandBindings.DrawGetTextDirection(_wandPtr)];

  /// DrawGetTextEncoding() returns a null-terminated string which specifies the
  /// code set used for text annotations. The string must be freed by the user
  /// once it is no longer required.
  String? drawGetTextEncoding() {
    final Pointer<Char> encodingPtr =
        _magickWandBindings.DrawGetTextEncoding(_wandPtr);
    final String? encoding = encodingPtr.toNullableString();
    _magickRelinquishMemory(encodingPtr.cast());
    return encoding;
  }

  /// DrawGetTextKerning() gets the spacing between characters in text.
  double drawGetTextKerning() =>
      _magickWandBindings.DrawGetTextKerning(_wandPtr);

  /// DrawGetTextInterlineSpacing() gets the spacing between lines in text.
  double drawGetTextInterlineSpacing() =>
      _magickWandBindings.DrawGetTextInterlineSpacing(_wandPtr);

  /// DrawGetTextInterwordSpacing() gets the spacing between words in text.
  double drawGetTextInterwordSpacing() =>
      _magickWandBindings.DrawGetTextInterwordSpacing(_wandPtr);

  /// DrawGetTypeMetrics() returns the following information for the specified
  /// font and text:
  /// - character width
  /// - character height
  /// - ascender
  /// - descender
  /// - text width
  /// - text height
  /// - maximum horizontal advance
  /// - bounds: x1
  /// - bounds: y1
  /// - bounds: x2
  /// - bounds: y2
  /// - origin: x
  /// - origin: y
  /// - underline position
  /// - underline thickness
  ///
  /// {@macro drawing_wand.runs_in_different_isolate}
  ///
  /// Parameters to this method are:
  /// - text: text to draw.
  /// - ignoreNewlines: indicates whether newlines should be ignored.
  Future<TypeMetric?> drawGetTypeMetrics({
    required String text,
    required bool ignoreNewlines,
  }) async =>
      await _magickCompute(
        _drawGetTypeMetrics,
        _DrawGetTypeMetricsParams(
          _wandPtr.address,
          text,
          ignoreNewlines,
        ),
      );

  /// DrawGetVectorGraphics() returns a string which specifies
  /// the vector graphics generated by any graphics calls made since the wand
  /// was instantiated.
  ///
  /// {@macro drawing_wand.runs_in_different_isolate}
  Future<String?> drawGetVectorGraphics() async => await _magickCompute(
        _drawGetVectorGraphics,
        _wandPtr.address,
      );

  /// DrawGetTextUnderColor() returns the color of a background rectangle to
  /// place under text annotations.
  void drawGetTextUnderColor(PixelWand pixelWand) =>
      _magickWandBindings.DrawGetTextUnderColor(_wandPtr, pixelWand._wandPtr);

  /// DrawLine() draws a line on the image using the current stroke color,
  /// stroke alpha, and stroke width.
  /// - [sx] starting x ordinate
  /// - [sy] starting y ordinate
  /// - [ex] ending x ordinate
  /// - [ey] ending y ordinate
  void drawLine({
    required double sx,
    required double sy,
    required double ex,
    required double ey,
  }) =>
      _magickWandBindings.DrawLine(
        _wandPtr,
        sx,
        sy,
        ex,
        ey,
      );

  /// DrawPathClose() adds a path element to the current path which closes the
  /// current subpath by drawing a straight line from the current point to the
  /// current subpath's most recent starting point (usually, the most recent
  /// moveto point).
  void drawPathClose() => _magickWandBindings.DrawPathClose(_wandPtr);

  /// DrawPathCurveToAbsolute() draws a cubic Bezier curve from the current
  /// point to (x,y) using (x1,y1) as the control point at the beginning of the
  /// curve and (x2,y2) as the control point at the end of the curve using
  /// absolute coordinates. At the end of the command, the new current point
  /// becomes the final (x,y) coordinate pair used in the polybezier.
  /// - [x1] x ordinate of control point for curve beginning
  /// - [y1] y ordinate of control point for curve beginning
  /// - [x2] x ordinate of control point for curve ending
  /// - [y2] y ordinate of control point for curve ending
  /// - [x] x ordinate of the end of the curve
  /// - [y] y ordinate of the end of the curve
  void drawPathCurveToAbsolute({
    required double x1,
    required double y1,
    required double x2,
    required double y2,
    required double x,
    required double y,
  }) =>
      _magickWandBindings.DrawPathCurveToAbsolute(
        _wandPtr,
        x1,
        y1,
        x2,
        y2,
        x,
        y,
      );

  /// DrawPathCurveToRelative() draws a cubic Bezier curve from the current
  /// point to (x,y) using (x1,y1) as the control point at the beginning of the
  /// curve and (x2,y2) as the control point at the end of the curve using
  /// relative coordinates. At the end of the command, the new current point
  /// becomes the final (x,y) coordinate pair used in the polybezier.
  /// - [x1] x ordinate of control point for curve beginning
  /// - [y1] y ordinate of control point for curve beginning
  /// - [x2] x ordinate of control point for curve ending
  /// - [y2] y ordinate of control point for curve ending
  /// - [x] x ordinate of the end of the curve
  /// - [y] y ordinate of the end of the curve
  void drawPathCurveToRelative({
    required double x1,
    required double y1,
    required double x2,
    required double y2,
    required double x,
    required double y,
  }) =>
      _magickWandBindings.DrawPathCurveToRelative(
        _wandPtr,
        x1,
        y1,
        x2,
        y2,
        x,
        y,
      );

  /// DrawPathCurveToQuadraticBezierAbsolute() draws a quadratic Bezier curve
  /// from the current point to (x,y) using (x1,y1) as the control point using
  /// absolute coordinates. At the end of the command, the new current point
  /// becomes the final (x,y) coordinate pair used in the polybezier.
  /// - [x1] x ordinate of the control point
  /// - [y1] y ordinate of the control point
  /// - [x] x ordinate of final point
  /// - [y] y ordinate of final point
  void drawPathCurveToQuadraticBezierAbsolute({
    required double x1,
    required double y1,
    required double x,
    required double y,
  }) =>
      _magickWandBindings.DrawPathCurveToQuadraticBezierAbsolute(
        _wandPtr,
        x1,
        y1,
        x,
        y,
      );

  /// DrawPathCurveToQuadraticBezierRelative() draws a quadratic Bezier curve
  /// from the current point to (x,y) using (x1,y1) as the control point using
  /// relative coordinates. At the end of the command, the new current point
  /// becomes the final (x,y) coordinate pair used in the polybezier.
  /// - [x1] x ordinate of the control point
  /// - [y1] y ordinate of the control point
  /// - [x] x ordinate of final point
  /// - [y] y ordinate of final point
  void drawPathCurveToQuadraticBezierRelative({
    required double x1,
    required double y1,
    required double x,
    required double y,
  }) =>
      _magickWandBindings.DrawPathCurveToQuadraticBezierRelative(
        _wandPtr,
        x1,
        y1,
        x,
        y,
      );

  /// DrawPathCurveToQuadraticBezierSmoothAbsolute() draws a quadratic Bezier
  /// curve (using absolute coordinates) from the current point to (x,y). The
  /// control point is assumed to be the reflection of the control point on the
  /// previous command relative to the current point. (If there is no previous
  /// command or if the previous command was not a
  /// DrawPathCurveToQuadraticBezierAbsolute,
  /// DrawPathCurveToQuadraticBezierRelative,
  /// DrawPathCurveToQuadraticBezierSmoothAbsolute or
  /// DrawPathCurveToQuadraticBezierSmoothRelative, assume the control point is
  /// coincident with the current point.). At the end of the command, the new
  /// current point becomes the final (x,y) coordinate pair used in the
  /// polybezier.
  /// - [x] x ordinate of final point
  /// - [y] y ordinate of final point
  void drawPathCurveToQuadraticBezierSmoothAbsolute({
    required double x,
    required double y,
  }) =>
      _magickWandBindings.DrawPathCurveToQuadraticBezierSmoothAbsolute(
        _wandPtr,
        x,
        y,
      );

  /// DrawPathCurveToQuadraticBezierSmoothRelative() draws a quadratic Bezier
  /// curve (using relative coordinates) from the current point to (x,y). The
  /// control point is assumed to be the reflection of the control point on the
  /// previous command relative to the current point. (If there is no previous
  /// command or if the previous command was not a
  /// DrawPathCurveToQuadraticBezierAbsolute,
  /// DrawPathCurveToQuadraticBezierRelative,
  /// DrawPathCurveToQuadraticBezierSmoothAbsolute or
  /// DrawPathCurveToQuadraticBezierSmoothRelative, assume the control point is
  /// coincident with the current point.). At the end of the command, the new
  /// current point becomes the final (x,y) coordinate pair used in the
  /// polybezier.
  /// - [x] x ordinate of final point
  /// - [y] y ordinate of final point
  void drawPathCurveToQuadraticBezierSmoothRelative({
    required double x,
    required double y,
  }) =>
      _magickWandBindings.DrawPathCurveToQuadraticBezierSmoothRelative(
        _wandPtr,
        x,
        y,
      );

  /// DrawPathCurveToSmoothAbsolute() draws a cubic Bezier curve from the
  /// current point to (x,y) using absolute coordinates. The first control point
  /// is assumed to be the reflection of the second control point on the
  /// previous command relative to the current point. (If there is no previous
  /// command or if the previous command was not an
  /// DrawPathCurveToAbsolute, DrawPathCurveToRelative,
  /// DrawPathCurveToSmoothAbsolute or DrawPathCurveToSmoothRelative, assume the
  /// first control point is coincident with the current point.) (x2,y2) is the
  /// second control point (i.e., the control point at the end of the curve). At
  /// the end of the command, the new current point becomes the final (x,y)
  /// coordinate pair used in the polybezier.
  /// - [x2] x ordinate of second control point
  /// - [y2] y ordinate of second control point
  /// - [x] x ordinate of termination point
  /// - [y] y ordinate of termination point
  void drawPathCurveToSmoothAbsolute({
    required double x2,
    required double y2,
    required double x,
    required double y,
  }) =>
      _magickWandBindings.DrawPathCurveToSmoothAbsolute(
        _wandPtr,
        x2,
        y2,
        x,
        y,
      );

  /// DrawPathCurveToSmoothRelative() draws a cubic Bezier curve from the
  /// current point to (x,y) using relative coordinates. The first control point
  /// is assumed to be the reflection of the second control point on the
  /// previous command relative to the current point. (If there is no previous
  /// command or if the previous command was not an
  /// DrawPathCurveToAbsolute, DrawPathCurveToRelative,
  /// DrawPathCurveToSmoothAbsolute or DrawPathCurveToSmoothRelative, assume the
  /// first control point is coincident with the current point.) (x2,y2) is the
  /// second control point (i.e., the control point at the end of the curve). At
  /// the end of the command, the new current point becomes the final (x,y)
  /// coordinate pair used in the polybezier.
  /// - [x2] x ordinate of second control point
  /// - [y2] y ordinate of second control point
  /// - [x] x ordinate of termination point
  /// - [y] y ordinate of termination point
  void drawPathCurveToSmoothRelative({
    required double x2,
    required double y2,
    required double x,
    required double y,
  }) =>
      _magickWandBindings.DrawPathCurveToSmoothRelative(
        _wandPtr,
        x2,
        y2,
        x,
        y,
      );

  /// DrawPathEllipticArcAbsolute() draws an elliptical arc from the current
  /// point to (x, y) using absolute coordinates. The size and orientation of
  /// the ellipse are defined by two radii (rx, ry) and an xAxisRotation, which
  /// indicates how the ellipse as a whole is rotated relative to the current
  /// coordinate system. The center (cx, cy) of the ellipse is calculated
  /// automagically to satisfy the constraints imposed by the other parameters.
  /// largeArcFlag and sweepFlag contribute to the automatic calculations and
  /// help determine how the arc is drawn. If largeArcFlag is true then draw the
  /// larger of the available arcs. If sweepFlag is true, then draw the arc
  /// matching a clock-wise rotation.
  /// - [rx] x radius
  /// - [ry] y radius
  /// - [xAxisRotation] indicates how the ellipse as a whole is rotated relative
  /// to the current coordinate system
  /// - [largeArcFlag] If true then draw the larger of the available
  /// arcs
  /// - [sweepFlag] If true then draw the arc matching a clock-wise
  /// rotation
  void drawPathEllipticArcAbsolute({
    required double rx,
    required double ry,
    required double xAxisRotation,
    required bool largeArcFlag,
    required bool sweepFlag,
    required double x,
    required double y,
  }) =>
      _magickWandBindings.DrawPathEllipticArcAbsolute(
        _wandPtr,
        rx,
        ry,
        xAxisRotation,
        largeArcFlag.toInt(),
        sweepFlag.toInt(),
        x,
        y,
      );

  /// DrawPathEllipticArcRelative() draws an elliptical arc from the current
  /// point to (x, y) using relative coordinates. The size and orientation of
  /// the ellipse are defined by two radii (rx, ry) and an xAxisRotation, which
  /// indicates how the ellipse as a whole is rotated relative to the current
  /// coordinate system. The center (cx, cy) of the ellipse is calculated
  /// automagically to satisfy the constraints imposed by the other parameters.
  /// largeArcFlag and sweepFlag contribute to the automatic calculations and
  /// help determine how the arc is drawn. If largeArcFlag is true then draw the
  /// larger of the available arcs. If sweepFlag is true, then draw the arc
  /// matching a clock-wise rotation.
  /// - [rx] x radius
  /// - [ry] y radius
  /// - [xAxisRotation] indicates how the ellipse as a whole is rotated relative
  /// to the current coordinate system
  /// - [largeArcFlag] If true then draw the larger of the available
  /// arcs
  /// - [sweepFlag] If true then draw the arc matching a clock-wise
  /// rotation
  void drawPathEllipticArcRelative({
    required double rx,
    required double ry,
    required double xAxisRotation,
    required bool largeArcFlag,
    required bool sweepFlag,
    required double x,
    required double y,
  }) =>
      _magickWandBindings.DrawPathEllipticArcRelative(
        _wandPtr,
        rx,
        ry,
        xAxisRotation,
        largeArcFlag.toInt(),
        sweepFlag.toInt(),
        x,
        y,
      );

  /// DrawPathFinish() terminates the current path.
  void drawPathFinish() => _magickWandBindings.DrawPathFinish(_wandPtr);

  /// DrawPathLineToAbsolute() draws a line path from the current point to the
  /// given coordinate using absolute coordinates. The coordinate then becomes
  /// the new current point.
  /// - [x] target x ordinate
  /// - [y] target y ordinate
  void drawPathLineToAbsolute({required double x, required double y}) =>
      _magickWandBindings.DrawPathLineToAbsolute(_wandPtr, x, y);

  /// DrawPathLineToRelative() draws a line path from the current point to the
  /// given coordinate using relative coordinates. The coordinate then becomes
  /// the new current point.
  /// - [x] target x ordinate
  /// - [y] target y ordinate
  void drawPathLineToRelative({required double x, required double y}) =>
      _magickWandBindings.DrawPathLineToRelative(_wandPtr, x, y);

  /// DrawPathLineToHorizontalAbsolute() draws a horizontal line path from the
  /// current point to the target point using absolute coordinates. The target
  /// point then becomes the new current point.
  /// - [x] target x ordinate
  /// - [y] target y ordinate
  void drawPathLineToHorizontalAbsolute({required double x}) =>
      _magickWandBindings.DrawPathLineToHorizontalAbsolute(_wandPtr, x);

  /// DrawPathLineToHorizontalRelative() draws a horizontal line path from the
  /// current point to the target point using relative coordinates. The target
  /// point then becomes the new current point.
  /// - [x] target x ordinate
  void drawPathLineToHorizontalRelative(double x) =>
      _magickWandBindings.DrawPathLineToHorizontalRelative(_wandPtr, x);

  /// DrawPathLineToVerticalAbsolute() draws a vertical line path from the
  /// current point to the target point using absolute coordinates. The target
  /// point then becomes the new current point.
  /// - [y] target y ordinate
  void drawPathLineToVerticalAbsolute(double y) =>
      _magickWandBindings.DrawPathLineToVerticalAbsolute(_wandPtr, y);

  /// DrawPathLineToVerticalRelative() draws a vertical line path from the
  /// current point to the target point using relative coordinates. The target
  /// point then becomes the new current point.
  /// - [y] target y ordinate
  void drawPathLineToVerticalRelative(double y) =>
      _magickWandBindings.DrawPathLineToVerticalRelative(_wandPtr, y);

  /// DrawPathMoveToAbsolute() starts a new sub-path at the given coordinate
  /// using absolute coordinates. The current point then becomes the specified
  /// coordinate.
  /// - [x] target x ordinate
  /// - [y] target y ordinate
  void drawPathMoveToAbsolute({required double x, required double y}) =>
      _magickWandBindings.DrawPathMoveToAbsolute(_wandPtr, x, y);

  /// DrawPathMoveToRelative() starts a new sub-path at the given coordinate
  /// using relative coordinates. The current point then becomes the specified
  /// coordinate.
  /// - [x] target x ordinate
  /// - [y] target y ordinate
  void drawPathMoveToRelative({required double x, required double y}) =>
      _magickWandBindings.DrawPathMoveToRelative(_wandPtr, x, y);

  /// DrawPathStart() declares the start of a path drawing list which is
  /// terminated by a matching DrawPathFinish() command. All other DrawPath
  /// commands must be enclosed between a DrawPathStart() and a DrawPathFinish()
  /// command. This is because path drawing commands are subordinate commands
  /// and they do not function by themselves.
  void drawPathStart() => _magickWandBindings.DrawPathStart(_wandPtr);

  /// DrawPoint() draws a point using the current fill color.
  /// - [x] target x coordinate
  /// - [y] target y coordinate
  void drawPoint({required double x, required double y}) =>
      _magickWandBindings.DrawPoint(_wandPtr, x, y);

  /// DrawPolygon() draws a polygon using the current stroke, stroke width, and
  /// fill color or texture, using the specified array of coordinates.
  /// - [coordinates] : the coordinates
  void drawPolygon(List<PointInfo> coordinates) => using(
        (Arena arena) {
          final Pointer<mwbg.PointInfo> coordinatesPtr =
              arena(coordinates.length);
          for (int i = 0; i < coordinates.length; i++) {
            coordinatesPtr[i] =
                coordinates[i]._toPointInfoStructPointer(allocator: arena).ref;
          }
          _magickWandBindings.DrawPolygon(
            _wandPtr,
            coordinates.length,
            coordinatesPtr,
          );
        },
      );

  /// DrawPolyline() draws a polyline using the current stroke, stroke width,
  /// and fill color or texture, using the specified array of coordinates.
  /// - [coordinates] : the coordinates
  void drawPolyline(List<PointInfo> coordinates) => using(
        (Arena arena) {
          final Pointer<mwbg.PointInfo> coordinatesPtr =
              arena(coordinates.length);
          for (int i = 0; i < coordinates.length; i++) {
            coordinatesPtr[i] =
                coordinates[i]._toPointInfoStructPointer(allocator: arena).ref;
          }
          _magickWandBindings.DrawPolyline(
            _wandPtr,
            coordinates.length,
            coordinatesPtr,
          );
        },
      );

  /// DrawPopClipPath() terminates a clip path definition.
  void drawPopClipPath() => _magickWandBindings.DrawPopClipPath(_wandPtr);

  /// DrawPopDefs() terminates a definition list.
  void drawPopDefs() => _magickWandBindings.DrawPopDefs(_wandPtr);

  /// DrawPopPattern() terminates a pattern definition.
  void drawPopPattern() => _magickWandBindings.DrawPopPattern(_wandPtr);

  /// DrawPushClipPath() starts a clip path definition which is comprized of
  /// any number of drawing commands and terminated by a DrawPopClipPath()
  /// command.
  void drawPushClipPath(String clipMaskId) => using(
        (Arena arena) => _magickWandBindings.DrawPushClipPath(
          _wandPtr,
          clipMaskId.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// DrawPushDefs() indicates that commands up to a terminating DrawPopDefs()
  /// command create named elements (e.g. clip-paths, textures, etc.) which may
  /// safely be processed earlier for the sake of efficiency.
  void drawPushDefs() => _magickWandBindings.DrawPushDefs(_wandPtr);

  /// DrawPushPattern() indicates that subsequent commands up to a
  /// DrawPopPattern() command comprise the definition of a named pattern. The
  /// pattern space is assigned top left corner coordinates, a width and height,
  /// and becomes its own drawing space. Anything which can be drawn may be used
  /// in a pattern definition. Named patterns may be used as stroke or brush
  /// definitions.
  /// - [patternId] : pattern identification for later reference
  /// - [x] : x ordinate of top left corner
  /// - [y] : y ordinate of top left corner
  /// - [width] : width of pattern space
  /// - [height] : height of pattern space
  bool drawPushPattern({
    required String patternId,
    required double x,
    required double y,
    required double width,
    required double height,
  }) =>
      using(
        (Arena arena) => _magickWandBindings.DrawPushPattern(
          _wandPtr,
          patternId.toNativeUtf8(allocator: arena).cast(),
          x,
          y,
          width,
          height,
        ),
      ).toBool();

  /// DrawRectangle() draws a rectangle given two coordinates and using the
  /// current stroke, stroke width, and fill settings.
  /// - [x1] : x ordinate of first coordinate
  /// - [y1] : y ordinate of first coordinate
  /// - [x2] : x ordinate of second coordinate
  /// - [y2] : y ordinate of second coordinate
  void drawRectangle({
    required double x1,
    required double y1,
    required double x2,
    required double y2,
  }) =>
      _magickWandBindings.DrawRectangle(_wandPtr, x1, y1, x2, y2);

  /// DrawResetVectorGraphics() resets the vector graphics associated with the
  /// specified wand.
  void drawResetVectorGraphics() =>
      _magickWandBindings.DrawResetVectorGraphics(_wandPtr);

  /// DrawRotate() applies the specified rotation to the current coordinate
  /// space.
  /// - [degrees] : degrees of rotation
  void drawRotate(double degrees) =>
      _magickWandBindings.DrawRotate(_wandPtr, degrees);

  /// DrawRoundRectangle() draws a rounded rectangle given two coordinates, x &
  /// y corner radiuses and using the current stroke, stroke width, and fill
  /// settings.
  /// - [x1] : x ordinate of first coordinate
  /// - [y1] : y ordinate of first coordinate
  /// - [x2] : x ordinate of second coordinate
  /// - [y2] : y ordinate of second coordinate
  /// - [rx] : radius of corner in horizontal direction
  /// - [ry] : radius of corner in vertical direction
  void drawRoundRectangle({
    required double x1,
    required double y1,
    required double x2,
    required double y2,
    required double rx,
    required double ry,
  }) =>
      _magickWandBindings.DrawRoundRectangle(_wandPtr, x1, y1, x2, y2, rx, ry);

  /// DrawScale() adjusts the scaling factor to apply in the horizontal and
  /// vertical directions to the current coordinate space.
  /// - [x] : horizontal scale factor
  /// - [y] : vertical scale factor
  void drawScale({
    required double x,
    required double y,
  }) =>
      _magickWandBindings.DrawScale(_wandPtr, x, y);

  /// DrawSetBorderColor() sets the border color to be used for drawing bordered
  /// objects.
  /// - [borderColor] : border color
  void drawSetBorderColor(PixelWand borderColor) =>
      _magickWandBindings.DrawSetBorderColor(_wandPtr, borderColor._wandPtr);

  /// DrawSetClipPath() associates a named clipping path with the image. Only
  /// the areas drawn on by the clipping path will be modified as ssize_t as it
  /// remains in effect.
  /// - [clipMaskId] : name of clipping path to associate with image
  bool drawSetClipPath(String clipMaskId) => using(
        (Arena arena) => _magickWandBindings.DrawSetClipPath(
          _wandPtr,
          clipMaskId.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// DrawSetClipRule() set the polygon fill rule to be used by the clipping
  /// path.
  /// - [fillRule] : fill rule (EvenOddRule or NonZeroRule)
  void drawSetClipRule(FillRule fillRule) =>
      _magickWandBindings.DrawSetClipRule(_wandPtr, fillRule.index);

  /// DrawSetClipUnits() sets the interpretation of clip path units.
  /// - [clipUnits] : units to use (UserSpace, UserSpaceOnUse, or
  /// ObjectBoundingBox)
  void drawSetClipUnits(ClipPathUnits clipUnits) =>
      _magickWandBindings.DrawSetClipUnits(_wandPtr, clipUnits.index);

  /// DrawSetDensity() sets the vertical and horizontal resolution.
  /// - [density] : the vertical and horizontal resolution
  bool drawSetDensity(String density) => using(
        (Arena arena) => _magickWandBindings.DrawSetDensity(
          _wandPtr,
          density.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// DrawSetFillColor() sets the fill color to be used for drawing filled
  /// objects.
  /// - [fillColor] : fill color
  void drawSetFillColor(PixelWand fillColor) =>
      _magickWandBindings.DrawSetFillColor(_wandPtr, fillColor._wandPtr);

  /// DrawSetFillOpacity() sets the alpha to use when drawing using the fill
  /// color or fill texture. Fully opaque is 1.0.
  /// - [fillOpacity] : fill opacity
  void drawSetFillOpacity(double fillOpacity) =>
      _magickWandBindings.DrawSetFillOpacity(_wandPtr, fillOpacity);

  /// DrawSetFontResolution() sets the image resolution.
  /// - [xResolution] : the image x resolution
  /// - [yResolution] : the image y resolution
  bool drawSetFontResolution({
    required double xResolution,
    required double yResolution,
  }) =>
      _magickWandBindings.DrawSetFontResolution(
              _wandPtr, xResolution, yResolution)
          .toBool();

  /// DrawSetOpacity() sets the alpha to use when drawing using the fill or
  /// stroke color or texture. Fully opaque is 1.0.
  /// - [opacity] : fill and stroke opacity. The value 1.0 is opaque.
  void drawSetOpacity(double opacity) =>
      _magickWandBindings.DrawSetOpacity(_wandPtr, opacity);

  /// DrawSetFillRule() sets the fill rule to use while drawing polygons.
  /// - [fillRule] : fill rule (EvenOddRule or NonZeroRule)
  void drawSetFillRule(FillRule fillRule) =>
      _magickWandBindings.DrawSetFillRule(_wandPtr, fillRule.index);

  /// DrawSetFont() sets the fully-specified font to use when annotating with
  /// text.
  /// - [fontName] : font name
  bool drawSetFont(String fontName) => using(
        (Arena arena) => _magickWandBindings.DrawSetFont(
          _wandPtr,
          fontName.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// DrawSetFontFamily() sets the font family to use when annotating with text.
  /// - [fontFamily] : font family
  bool drawSetFontFamily(String fontFamily) => using(
        (Arena arena) => _magickWandBindings.DrawSetFontFamily(
          _wandPtr,
          fontFamily.toNativeUtf8(allocator: arena).cast(),
        ),
      ).toBool();

  /// DrawSetFontSize() sets the font pointsize to use when annotating with
  /// text.
  /// - [pointSize] : text pointsize
  void drawSetFontSize(double pointSize) =>
      _magickWandBindings.DrawSetFontSize(_wandPtr, pointSize);

  /// DrawSetFontStretch() sets the font stretch to use when annotating with
  /// text.
  /// - [fontStretch] : font stretch
  void drawSetFontStretch(StretchType fontStretch) =>
      _magickWandBindings.DrawSetFontStretch(_wandPtr, fontStretch.index);

  /// DrawSetFontStyle() sets the font style to use when annotating with text.
  /// - [fontStyle] : font style
  void drawSetFontStyle(StyleType fontStyle) =>
      _magickWandBindings.DrawSetFontStyle(_wandPtr, fontStyle.index);

  /// DrawSetFontWeight() sets the font weight to use when annotating with text.
  /// - [fontWeight] : font weight
  void drawSetFontWeight(int fontWeight) =>
      _magickWandBindings.DrawSetFontWeight(_wandPtr, fontWeight);

  /// DrawSetGravity() sets the text placement gravity to use when annotating
  /// with text.
  /// - [gravity] : positioning gravity
  void drawSetGravity(GravityType gravity) =>
      _magickWandBindings.DrawSetGravity(_wandPtr, gravity.value);

  /// DrawSetStrokeColor() sets the color used for stroking object outlines.
  /// - [strokeWand] : the stroke wand
  void drawSetStrokeColor(PixelWand strokeWand) =>
      _magickWandBindings.DrawSetStrokeColor(_wandPtr, strokeWand._wandPtr);

  /// DrawSetStrokeAntialias() controls whether stroked outlines are
  /// antialiased. Stroked outlines are antialiased by default. When
  /// antialiasing is disabled stroked pixels are thresholded to determine if
  /// the stroke color or underlying canvas color should be used.
  /// - [strokeAntialias] : set to false to disable antialiasing
  void drawSetStrokeAntialias(bool strokeAntialias) =>
      _magickWandBindings.DrawSetStrokeAntialias(
        _wandPtr,
        strokeAntialias.toInt(),
      );

  /// DrawSetStrokeDashArray() specifies the pattern of dashes and gaps used to
  /// stroke paths. The stroke dash array represents an array of numbers that
  /// specify the lengths of alternating dashes and gaps in pixels. If an odd
  /// number of values is provided, then the list of values is repeated to yield
  /// an even number of values. To remove an existing dash array, pass a
  /// null dasharray. A typical stroke dash array might contain the members 5 3
  /// 2.
  /// - [dashArray] : dash array values
  void drawSetStrokeDashArray(Float64List? dashArray) => using(
        (Arena arena) => _magickWandBindings.DrawSetStrokeDashArray(
          _wandPtr,
          dashArray?.length ?? 0,
          dashArray?.toDoubleArrayPointer(allocator: arena) ?? nullptr,
        ),
      );

  /// DrawSetStrokeDashOffset() specifies the offset into the dash pattern to
  /// start the dash.
  /// - [dashOffset] : dash offset
  void drawSetStrokeDashOffset(double dashOffset) =>
      _magickWandBindings.DrawSetStrokeDashOffset(_wandPtr, dashOffset);

  /// DrawSetStrokeLineCap() specifies the shape to be used at the end of open
  /// subpaths when they are stroked.
  /// - [lineCap] : linecap style
  void drawSetStrokeLineCap(LineCap lineCap) =>
      _magickWandBindings.DrawSetStrokeLineCap(_wandPtr, lineCap.index);

  /// DrawSetStrokeLineJoin() specifies the shape to be used at the corners of
  /// paths (or other vector shapes) when they are stroked.
  /// - [lineJoin] : line join style
  void drawSetStrokeLineJoin(LineJoin lineJoin) =>
      _magickWandBindings.DrawSetStrokeLineJoin(_wandPtr, lineJoin.index);

  /// DrawSetStrokeMiterLimit() specifies the miter limit. When two line
  /// segments meet at a sharp angle and miter joins have been specified for
  /// 'lineJoin', it is possible for the miter to extend far beyond the
  /// thickness of the line stroking the path. The miterLimit' imposes a limit
  /// on the ratio of the miter length to the 'lineWidth'.
  ///  - [miterLimit] : the miter limit
  void drawSetStrokeMiterLimit(int miterLimit) =>
      _magickWandBindings.DrawSetStrokeMiterLimit(_wandPtr, miterLimit);

  /// DrawSetStrokeOpacity() specifies the alpha of stroked object outlines.
  /// - [opacity] : stroke opacity. The value 1.0 is opaque.
  void drawSetStrokeOpacity(double opacity) =>
      _magickWandBindings.DrawSetStrokeOpacity(_wandPtr, opacity);

  /// DrawSetStrokeWidth() sets the width of the stroke used to draw object
  /// outlines.
  /// - [strokeWidth] : the stroke width
  void drawSetStrokeWidth(double strokeWidth) =>
      _magickWandBindings.DrawSetStrokeWidth(_wandPtr, strokeWidth);

  /// DrawSetTextAlignment() specifies a text alignment to be applied when
  /// annotating with text.
  /// - [alignment] : text alignment
  void drawSetTextAlignment(AlignType alignment) =>
      _magickWandBindings.DrawSetTextAlignment(_wandPtr, alignment.index);

  /// DrawSetTextAntialias() controls whether text is antialiased. Text is
  /// antialiased by default.
  /// - [textAntialias] : antialias boolean. Set to false to disable
  ///  antialiasing.
  void drawSetTextAntialias(bool textAntialias) =>
      _magickWandBindings.DrawSetTextAntialias(
        _wandPtr,
        textAntialias.toInt(),
      );

  /// DrawSetTextDecoration() specifies a decoration to be applied when
  /// annotating with text.
  /// - [decoration] : the text decoration
  void drawSetTextDecoration(DecorationType decoration) =>
      _magickWandBindings.DrawSetTextDecoration(_wandPtr, decoration.index);

  /// DrawSetTextDirection() specifies the direction to be used when annotating
  /// with text.
  /// - [direction] : the text direction
  void drawSetTextDirection(DirectionType direction) =>
      _magickWandBindings.DrawSetTextDirection(_wandPtr, direction.index);

  /// DrawSetTextEncoding() specifies the code set to use for text annotations.
  /// The only character encoding which may be specified at this time is "UTF-8"
  /// for representing Unicode as a sequence of bytes. Specify an empty string
  /// to set text encoding to the system's default. Successful text annotation
  /// using Unicode may require fonts designed to support Unicode.
  /// - [encoding] : character string specifying text encoding
  void drawSetTextEncoding(String encoding) => using(
        (Arena arena) => _magickWandBindings.DrawSetTextEncoding(
          _wandPtr,
          encoding.toNativeUtf8(allocator: arena).cast(),
        ),
      );

  /// DrawSetTextKerning() sets the spacing between characters in text.
  /// - [kerning] : text kerning
  void drawSetTextKerning(double kerning) =>
      _magickWandBindings.DrawSetTextKerning(_wandPtr, kerning);

  /// - [interlineSpacing] : text line spacing
  void drawSetTextInterlineSpacing(double interlineSpacing) =>
      _magickWandBindings.DrawSetTextInterlineSpacing(
        _wandPtr,
        interlineSpacing,
      );

  /// DrawSetTextInterwordSpacing() sets the spacing between words in text.
  /// - [interwordSpacing] : text word spacing
  void drawSetTextInterwordSpacing(double interwordSpacing) =>
      _magickWandBindings.DrawSetTextInterwordSpacing(
        _wandPtr,
        interwordSpacing,
      );

  /// DrawSetTextUnderColor() specifies the color of a background rectangle to
  /// place under text annotations.
  /// - [underWand] : text under wand
  void drawSetTextUnderColor(PixelWand underWand) =>
      _magickWandBindings.DrawSetTextUnderColor(
        _wandPtr,
        underWand._wandPtr,
      );

  /// DrawSetVectorGraphics() sets the vector graphics associated with the
  /// specified wand. Use this method with DrawGetVectorGraphics() as a method
  /// to persist the vector graphics state.
  ///
  /// {@macro drawing_wand.runs_in_different_isolate}
  /// - [xml] : the drawing wand XML.
  Future<void> drawSetVectorGraphics(String xml) async => await _magickCompute(
        _drawSetVectorGraphics,
        _DrawSetVectorGraphicsParams(
          _wandPtr.address,
          xml,
        ),
      );

  /// DrawSkewX() skews the current coordinate system in the horizontal
  /// direction.
  /// - [degrees] : number of degrees to skew the coordinates
  void drawSkewX(double degrees) =>
      _magickWandBindings.DrawSkewX(_wandPtr, degrees);

  /// DrawSkewY() skews the current coordinate system in the vertical direction.
  /// - [degrees] : number of degrees to skew the coordinates
  void drawSkewY(double degrees) =>
      _magickWandBindings.DrawSkewY(_wandPtr, degrees);

  /// DrawTranslate() applies a translation to the current coordinate system
  /// which moves the coordinate system origin to the specified coordinate.
  /// - [x] : new x ordinate for coordinate system origin
  /// - [y] : new y ordinate for coordinate system origin
  void drawTranslate(double x, double y) =>
      _magickWandBindings.DrawTranslate(_wandPtr, x, y);

  /// DrawSetViewbox() sets the overall canvas size to be recorded with the
  /// drawing vector data. Usually this will be specified using the same size as
  /// the canvas image. When the vector data is saved to SVG or MVG formats, the
  /// viewbox is use to specify the size of the canvas image that a viewer will
  /// render the vector data on.
  /// - [x1] : left x ordinate
  /// - [y1] : top y ordinate
  /// - [x2] : right x ordinate
  /// - [y2] : bottom y ordinate
  void drawSetViewbox(double x1, double y1, double x2, double y2) =>
      _magickWandBindings.DrawSetViewbox(_wandPtr, x1, y1, x2, y2);

  /// IsDrawingWand() returns true if the wand is verified as a drawing wand.
  bool isDrawingWand() => _magickWandBindings.IsDrawingWand(_wandPtr).toBool();

  /// NewDrawingWand() returns a drawing wand required for all other methods in
  /// the API.
  factory DrawingWand.newDrawingWand() =>
      DrawingWand._(_magickWandBindings.NewDrawingWand());

  /// PopDrawingWand() destroys the current drawing wand and returns to the
  /// previously pushed drawing wand. Multiple drawing wands may exist. It is an
  /// error to attempt to pop more drawing wands than have been pushed, and it is
  /// proper form to pop all drawing wands which have been pushed.
  bool popDrawingWand() =>
      _magickWandBindings.PopDrawingWand(_wandPtr).toBool();

  /// PushDrawingWand() clones the current drawing wand to create a new drawing
  /// wand. The original drawing wand(s) may be returned to by invoking
  /// PopDrawingWand(). The drawing wands are stored on a drawing wand stack. For
  /// every Pop there must have already been an equivalent Push.
  bool pushDrawingWand() =>
      _magickWandBindings.PushDrawingWand(_wandPtr).toBool();
}
