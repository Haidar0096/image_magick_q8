part of 'image_magick_q8.dart';

/// Represents an image kernel matrix.
class KernelInfo {
  KernelInfoType? type;
  int? width;
  int? height;
  int? x;
  int? y;
  Float64List? values;
  double? minimum;
  double? maximum;
  double? negativeRange;
  double? positiveRange;
  double? angle;
  KernelInfo? next;
  int? signature;

  KernelInfo({
    this.type,
    this.width,
    this.height,
    this.x,
    this.y,
    this.values,
    this.minimum,
    this.maximum,
    this.negativeRange,
    this.positiveRange,
    this.angle,
    this.next,
    this.signature,
  });

  Pointer<mwbg.KernelInfo> _toKernelInfoStructPointer(
      {required Allocator allocator}) {
    final Pointer<mwbg.KernelInfo> kernelInfoStruct = allocator();
    kernelInfoStruct.ref.type = type?.index ?? 0;
    kernelInfoStruct.ref.width = width ?? 0;
    kernelInfoStruct.ref.height = height ?? 0;
    kernelInfoStruct.ref.x = x ?? 0;
    kernelInfoStruct.ref.y = y ?? 0;
    kernelInfoStruct.ref.values =
        values?.toDoubleArrayPointer(allocator: allocator) ?? nullptr;
    kernelInfoStruct.ref.minimum = minimum ?? 0.0;
    kernelInfoStruct.ref.maximum = maximum ?? 0.0;
    kernelInfoStruct.ref.negative_range = negativeRange ?? 0.0;
    kernelInfoStruct.ref.positive_range = positiveRange ?? 0.0;
    kernelInfoStruct.ref.angle = angle ?? 0.0;
    kernelInfoStruct.ref.next =
        next?._toKernelInfoStructPointer(allocator: allocator) ?? nullptr;
    kernelInfoStruct.ref.signature = signature ?? 0;
    return kernelInfoStruct;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KernelInfo &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          width == other.width &&
          height == other.height &&
          x == other.x &&
          y == other.y &&
          values == other.values &&
          minimum == other.minimum &&
          maximum == other.maximum &&
          negativeRange == other.negativeRange &&
          positiveRange == other.positiveRange &&
          angle == other.angle &&
          next == other.next &&
          signature == other.signature;

  @override
  int get hashCode =>
      type.hashCode ^
      width.hashCode ^
      height.hashCode ^
      x.hashCode ^
      y.hashCode ^
      values.hashCode ^
      minimum.hashCode ^
      maximum.hashCode ^
      negativeRange.hashCode ^
      positiveRange.hashCode ^
      angle.hashCode ^
      next.hashCode ^
      signature.hashCode;

  @override
  String toString() =>
      'KernelInfo{type: $type, width: $width, height: $height, x: $x, y: $y, values: $values, minimum: $minimum, maximum: $maximum, negativeRange: $negativeRange, positiveRange: $positiveRange, angle: $angle, next: $next, signature: $signature}';
}
