part of 'image_magick_q8.dart';

class _DrawCompositeParams {
  final int drawingWantPtrAddress;
  final CompositeOperator operator;
  final double x;
  final double y;
  final double width;
  final double height;
  final int magickWandPtrAddress;

  const _DrawCompositeParams(
    this.drawingWantPtrAddress,
    this.operator,
    this.x,
    this.y,
    this.width,
    this.height,
    this.magickWandPtrAddress,
  );
}

void _drawComposite(_DrawCompositeParams params) =>
    _magickWandBindings.DrawComposite(
      Pointer<mwbg.DrawingWand>.fromAddress(params.drawingWantPtrAddress),
      params.operator.index,
      params.x,
      params.y,
      params.width,
      params.height,
      Pointer<mwbg.MagickWand>.fromAddress(params.magickWandPtrAddress),
    );

/// Represents a result to a call to [DrawingWand.drawGetException].
class DrawGetExceptionResult {
  final ExceptionType severity;
  final String description;

  const DrawGetExceptionResult(this.severity, this.description);

  @override
  String toString() =>
      'DrawGetExceptionResult{severity: $severity, description: $description}';
}

/// Represents a result to a call to [DrawingWand.drawGetFontResolution].
class DrawGetFontResolutionResult {
  final double x;
  final double y;

  const DrawGetFontResolutionResult(this.x, this.y);

  @override
  String toString() => 'DrawGetFontResolutionResult{x: $x, y: $y}';
}

class _DrawGetTypeMetricsParams {
  final int drawingWantPtrAddress;
  final String text;
  final bool ignoreNewlines;

  const _DrawGetTypeMetricsParams(
    this.drawingWantPtrAddress,
    this.text,
    this.ignoreNewlines,
  );
}

Future<TypeMetric?> _drawGetTypeMetrics(
        _DrawGetTypeMetricsParams params) async =>
    using(
      (Arena arena) {
        Pointer<mwbg.TypeMetric> typeMetricPtr = arena();
        final bool result = _magickWandBindings.DrawGetTypeMetrics(
          Pointer<mwbg.DrawingWand>.fromAddress(params.drawingWantPtrAddress),
          params.text.toNativeUtf8(allocator: arena).cast(),
          params.ignoreNewlines.toInt(),
          typeMetricPtr,
        ).toBool();
        return result
            ? TypeMetric._fromTypeMetricStructPointer(typeMetricPtr)
            : null;
      },
    );

Future<String?> _drawGetVectorGraphics(int drawingWantPtrAddress) async {
  final Pointer<Char> vectorGraphicsPtr =
      _magickWandBindings.DrawGetVectorGraphics(
    Pointer<mwbg.DrawingWand>.fromAddress(drawingWantPtrAddress),
  );
  final String? vectorGraphics = vectorGraphicsPtr.toNullableString();
  _magickRelinquishMemory(vectorGraphicsPtr.cast());
  return vectorGraphics;
}

class _DrawSetVectorGraphicsParams {
  final int drawingWantPtrAddress;
  final String xml;

  const _DrawSetVectorGraphicsParams(
    this.drawingWantPtrAddress,
    this.xml,
  );
}

void _drawSetVectorGraphics(_DrawSetVectorGraphicsParams params) => using(
      (Arena arena) => _magickWandBindings.DrawSetVectorGraphics(
        Pointer<mwbg.DrawingWand>.fromAddress(params.drawingWantPtrAddress),
        params.xml.toNativeUtf8(allocator: arena).cast(),
      ),
    );
