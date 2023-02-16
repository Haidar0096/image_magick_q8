part of 'image_magick_q8.dart';

/// Represents a pixel info.
class PixelInfo {
  final ClassType storageClass;

  final ColorspaceType colorspace;

  final PixelTrait alphaTrait;

  final double fuzz;

  final int depth;

  final int count;

  final double red;

  final double green;

  final double blue;

  final double black;

  final double alpha;

  final double index;

  PixelInfo({
    required this.storageClass,
    required this.colorspace,
    required this.alphaTrait,
    required this.fuzz,
    required this.depth,
    required this.count,
    required this.red,
    required this.green,
    required this.blue,
    required this.black,
    required this.alpha,
    required this.index,
  });

  static PixelInfo? _fromPixelInfoStructPointer(Pointer<mwbg.PixelInfo> ptr) =>
      ptr == nullptr
          ? null
          : PixelInfo(
              storageClass: ClassType.values[ptr.ref.storage_class],
              colorspace: ColorspaceType.values[ptr.ref.colorspace],
              alphaTrait: PixelTrait.fromValue(ptr.ref.alpha_trait),
              fuzz: ptr.ref.fuzz,
              depth: ptr.ref.depth,
              count: ptr.ref.count,
              red: ptr.ref.red,
              green: ptr.ref.green,
              blue: ptr.ref.blue,
              black: ptr.ref.black,
              alpha: ptr.ref.alpha,
              index: ptr.ref.index,
            );

  static PixelInfo _fromPixelInfoStruct(mwbg.PixelInfo pixelInfo) => PixelInfo(
        storageClass: ClassType.values[pixelInfo.storage_class],
        colorspace: ColorspaceType.values[pixelInfo.colorspace],
        alphaTrait: PixelTrait.fromValue(pixelInfo.alpha_trait),
        fuzz: pixelInfo.fuzz,
        depth: pixelInfo.depth,
        count: pixelInfo.count,
        red: pixelInfo.red,
        green: pixelInfo.green,
        blue: pixelInfo.blue,
        black: pixelInfo.black,
        alpha: pixelInfo.alpha,
        index: pixelInfo.index,
      );

  Pointer<mwbg.PixelInfo> _toPixelInfoStructPointer(
      {required Allocator allocator}) {
    final Pointer<mwbg.PixelInfo> pixelInfoPtr = allocator();
    pixelInfoPtr.ref.storage_class = storageClass.index;
    pixelInfoPtr.ref.colorspace = colorspace.index;
    pixelInfoPtr.ref.alpha_trait = alphaTrait.value;
    pixelInfoPtr.ref.fuzz = fuzz;
    pixelInfoPtr.ref.depth = depth;
    pixelInfoPtr.ref.count = count;
    pixelInfoPtr.ref.red = red;
    pixelInfoPtr.ref.green = green;
    pixelInfoPtr.ref.blue = blue;
    pixelInfoPtr.ref.black = black;
    pixelInfoPtr.ref.alpha = alpha;
    pixelInfoPtr.ref.index = index;
    return pixelInfoPtr;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PixelInfo &&
          runtimeType == other.runtimeType &&
          storageClass == other.storageClass &&
          colorspace == other.colorspace &&
          alphaTrait == other.alphaTrait &&
          fuzz == other.fuzz &&
          depth == other.depth &&
          count == other.count &&
          red == other.red &&
          green == other.green &&
          blue == other.blue &&
          black == other.black &&
          alpha == other.alpha &&
          index == other.index;

  @override
  int get hashCode =>
      storageClass.hashCode ^
      colorspace.hashCode ^
      alphaTrait.hashCode ^
      fuzz.hashCode ^
      depth.hashCode ^
      count.hashCode ^
      red.hashCode ^
      green.hashCode ^
      blue.hashCode ^
      black.hashCode ^
      alpha.hashCode ^
      index.hashCode;

  @override
  String toString() {
    return 'PixelInfo{storageClass: $storageClass, colorspace: $colorspace, alphaTrait: $alphaTrait, fuzz: $fuzz, depth: $depth, count: $count, red: $red, green: $green, blue: $blue, black: $black, alpha: $alpha, index: $index}';
  }
}
