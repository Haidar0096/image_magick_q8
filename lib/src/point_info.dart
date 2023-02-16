part of 'image_magick_q8.dart';

/// Represents a point in a 2D space.
class PointInfo {
  final double x;
  final double y;

  const PointInfo({required this.x, required this.y});

  Pointer<mwbg.PointInfo> _toPointInfoStructPointer({
    required Allocator allocator,
  }) =>
      allocator()
        ..ref.x = x
        ..ref.y = y;

  PointInfo._fromPointInfoStruct(mwbg.PointInfo pointInfoStruct)
      : x = pointInfoStruct.x,
        y = pointInfoStruct.y;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PointInfo &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => 'PointInfo(x: $x, y: $y)';
}
