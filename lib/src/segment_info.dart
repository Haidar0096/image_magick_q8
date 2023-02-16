part of 'image_magick_q8.dart';

/// A class that represents a segment info.
class SegmentInfo {
  final double x1;
  final double y1;
  final double x2;
  final double y2;

  const SegmentInfo({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
  });

  SegmentInfo._fromSegmentInfoStruct(mwbg.SegmentInfo segmentInfoStruct)
      : x1 = segmentInfoStruct.x1,
        y1 = segmentInfoStruct.y1,
        x2 = segmentInfoStruct.x2,
        y2 = segmentInfoStruct.y2;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SegmentInfo &&
          runtimeType == other.runtimeType &&
          x1 == other.x1 &&
          y1 == other.y1 &&
          x2 == other.x2 &&
          y2 == other.y2;

  @override
  int get hashCode => x1.hashCode ^ y1.hashCode ^ x2.hashCode ^ y2.hashCode;

  @override
  String toString() => 'SegmentInfo{x1: $x1, y1: $y1, x2: $x2, y2: $y2}';
}
