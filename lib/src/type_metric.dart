part of 'image_magick_q8.dart';

/// A class that represents a type metric.
class TypeMetric {
  final PointInfo pixelsPerEm;
  final double ascent;
  final double descent;
  final double width;
  final double height;
  final double maxAdvance;
  final double underlinePosition;
  final double underlineThickness;
  final SegmentInfo bounds;
  final PointInfo origin;

  const TypeMetric({
    required this.pixelsPerEm,
    required this.ascent,
    required this.descent,
    required this.width,
    required this.height,
    required this.maxAdvance,
    required this.underlinePosition,
    required this.underlineThickness,
    required this.bounds,
    required this.origin,
  });

  static TypeMetric? _fromTypeMetricStructPointer(
    Pointer<mwbg.TypeMetric> ptr,
  ) =>
      ptr == nullptr
          ? null
          : TypeMetric(
              pixelsPerEm:
                  PointInfo._fromPointInfoStruct(ptr.ref.pixels_per_em),
              ascent: ptr.ref.ascent,
              descent: ptr.ref.descent,
              width: ptr.ref.width,
              height: ptr.ref.height,
              maxAdvance: ptr.ref.max_advance,
              underlinePosition: ptr.ref.underline_position,
              underlineThickness: ptr.ref.underline_thickness,
              bounds: SegmentInfo._fromSegmentInfoStruct(ptr.ref.bounds),
              origin: PointInfo._fromPointInfoStruct(ptr.ref.origin),
            );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeMetric &&
          runtimeType == other.runtimeType &&
          pixelsPerEm == other.pixelsPerEm &&
          ascent == other.ascent &&
          descent == other.descent &&
          width == other.width &&
          height == other.height &&
          maxAdvance == other.maxAdvance &&
          underlinePosition == other.underlinePosition &&
          underlineThickness == other.underlineThickness &&
          bounds == other.bounds &&
          origin == other.origin;

  @override
  int get hashCode =>
      pixelsPerEm.hashCode ^
      ascent.hashCode ^
      descent.hashCode ^
      width.hashCode ^
      height.hashCode ^
      maxAdvance.hashCode ^
      underlinePosition.hashCode ^
      underlineThickness.hashCode ^
      bounds.hashCode ^
      origin.hashCode;

  @override
  String toString() =>
      'TypeMetric{pixelsPerEm: $pixelsPerEm, ascent: $ascent, descent: $descent, width: $width, height: $height, maxAdvance: $maxAdvance, underlinePosition: $underlinePosition, underlineThickness: $underlineThickness, bounds: $bounds, origin: $origin}';
}
