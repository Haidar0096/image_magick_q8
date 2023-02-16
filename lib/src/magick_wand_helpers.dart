part of 'image_magick_q8.dart';

/// Represents an exception that occurred while using the ImageMagick API.
class MagickGetExceptionResult {
  /// The type of the exception.
  final ExceptionType severity;

  /// The description of the exception.
  final String description;

  const MagickGetExceptionResult(this.severity, this.description);

  @override
  String toString() =>
      'MagickException{severity: $severity, description: $description}';
}

/// Represents a result to a call to `magickGetPage()`.
class MagickGetPageResult {
  final int width;
  final int height;
  final int x;
  final int y;

  const MagickGetPageResult(this.width, this.height, this.x, this.y);

  @override
  String toString() =>
      'MagickGetPageResult{width: $width, height: $height, x: $x, y: $y}';
}

/// Represents a result to a call to `magickGetResolution()`.
class MagickGetResolutionResult {
  final double x;
  final double y;

  const MagickGetResolutionResult(this.x, this.y);

  @override
  String toString() => 'MagickGetResolutionResult{x: $x, y: $y}';
}

/// Represents a result to a call to `magickGetSize()`.
class MagickGetSizeResult {
  final int width;
  final int height;

  const MagickGetSizeResult(this.width, this.height);

  @override
  String toString() => 'MagickGetSizeResult{width: $width, height: $height}';
}

class _MagickAdaptiveBlurImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickAdaptiveBlurImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickAdaptiveBlurImage(
        _MagickAdaptiveBlurImageParams params) async =>
    _magickWandBindings.MagickAdaptiveBlurImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
    ).toBool();

class _MagickAdaptiveResizeImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;

  _MagickAdaptiveResizeImageParams(
      this.wandPtrAddress, this.columns, this.rows);
}

Future<bool> _magickAdaptiveResizeImage(
        _MagickAdaptiveResizeImageParams params) async =>
    _magickWandBindings.MagickAdaptiveResizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.columns,
      params.rows,
    ).toBool();

class _MagickAdaptiveSharpenImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickAdaptiveSharpenImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
  );
}

Future<bool> _magickAdaptiveSharpenImage(
        _MagickAdaptiveSharpenImageParams params) async =>
    _magickWandBindings.MagickAdaptiveSharpenImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
    ).toBool();

class _MagickAdaptiveThresholdImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final double bias;

  _MagickAdaptiveThresholdImageParams(
      this.wandPtrAddress, this.width, this.height, this.bias);
}

Future<bool> _magickAdaptiveThresholdImage(
        _MagickAdaptiveThresholdImageParams params) async =>
    _magickWandBindings.MagickAdaptiveThresholdImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.width,
      params.height,
      params.bias,
    ).toBool();

class _MagickAddImageParams {
  final int wandPtrAddress;
  final int otherWandPtrAddress;

  _MagickAddImageParams(this.wandPtrAddress, this.otherWandPtrAddress);
}

Future<bool> _magickAddImage(_MagickAddImageParams params) async =>
    _magickWandBindings.MagickAddImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(params.otherWandPtrAddress),
    ).toBool();

class _MagickAddNoiseImageParams {
  final int wandPtrAddress;
  final int noiseTypeIndex;
  final double attenuate;

  _MagickAddNoiseImageParams(
      this.wandPtrAddress, this.noiseTypeIndex, this.attenuate);
}

Future<bool> _magickAddNoiseImage(_MagickAddNoiseImageParams params) async =>
    _magickWandBindings.MagickAddNoiseImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.noiseTypeIndex,
      params.attenuate,
    ).toBool();

class _MagickAffineTransformImageParams {
  final int wandPtrAddress;
  final int drawingWandPtrAddress;

  _MagickAffineTransformImageParams(
    this.wandPtrAddress,
    this.drawingWandPtrAddress,
  );
}

Future<bool> _magickAffineTransformImage(
        _MagickAffineTransformImageParams params) async =>
    _magickWandBindings.MagickAffineTransformImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.DrawingWand>.fromAddress(params.drawingWandPtrAddress),
    ).toBool();

class _MagickAnnotateImageParams {
  final int wandPtrAddress;
  final int drawingWandPtrAddress;
  final double x;
  final double y;
  final double angle;
  final String text;

  _MagickAnnotateImageParams(this.wandPtrAddress, this.drawingWandPtrAddress,
      this.x, this.y, this.angle, this.text);
}

Future<bool> _magickAnnotateImage(_MagickAnnotateImageParams params) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickAnnotateImage(
        Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
        Pointer<mwbg.DrawingWand>.fromAddress(params.drawingWandPtrAddress),
        params.x,
        params.y,
        params.angle,
        params.text.toNativeUtf8(allocator: arena).cast(),
      ),
    ).toBool();

class _MagickAppendImagesParams {
  final int wandPtrAddress;
  final bool stack;

  _MagickAppendImagesParams(this.wandPtrAddress, this.stack);
}

Future<int> _magickAppendImages(_MagickAppendImagesParams params) async =>
    _magickWandBindings.MagickAppendImages(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.stack.toInt(),
    ).address;

Future<bool> _magickAutoGammaImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickAutoGammaImage(
            Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress))
        .toBool();

Future<bool> _magickAutoLevelImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickAutoLevelImage(
            Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress))
        .toBool();

Future<bool> _magickAutoOrientImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickAutoOrientImage(
            Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress))
        .toBool();

class _MagickAutoThresholdImageParams {
  final int wandPtrAddress;
  final int thresholdMethodIndex;

  _MagickAutoThresholdImageParams(
      this.wandPtrAddress, this.thresholdMethodIndex);
}

Future<bool> _magickAutoThresholdImage(
        _MagickAutoThresholdImageParams params) async =>
    _magickWandBindings.MagickAutoThresholdImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.thresholdMethodIndex,
    ).toBool();

class _MagickBilateralBlurImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;
  final double intensitySigma;
  final double spatialSigma;

  _MagickBilateralBlurImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
    this.intensitySigma,
    this.spatialSigma,
  );
}

Future<bool> _magickBilateralBlurImage(
        _MagickBilateralBlurImageParams params) async =>
    _magickWandBindings.MagickBilateralBlurImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
      params.intensitySigma,
      params.spatialSigma,
    ).toBool();

class _MagickBlackThresholdImageParams {
  final int wandPtrAddress;
  final int thresholdWandPtrAddress;

  _MagickBlackThresholdImageParams(
      this.wandPtrAddress, this.thresholdWandPtrAddress);
}

Future<bool> _magickBlackThresholdImage(
        _MagickBlackThresholdImageParams params) async =>
    _magickWandBindings.MagickBlackThresholdImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(params.thresholdWandPtrAddress),
    ).toBool();

class _MagickBlueShiftImageParams {
  final int wandPtrAddress;
  final double factor;

  _MagickBlueShiftImageParams(this.wandPtrAddress, this.factor);
}

Future<bool> _magickBlueShiftImage(_MagickBlueShiftImageParams params) async =>
    _magickWandBindings.MagickBlueShiftImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.factor,
    ).toBool();

class _MagickBlurImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickBlurImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickBlurImage(_MagickBlurImageParams params) async =>
    _magickWandBindings.MagickBlurImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
    ).toBool();

class _MagickBorderImageParams {
  final int wandPtrAddress;
  final int borderWandPtrAddress;
  final int width;
  final int height;
  final int composeIndex;

  _MagickBorderImageParams(
    this.wandPtrAddress,
    this.borderWandPtrAddress,
    this.width,
    this.height,
    this.composeIndex,
  );
}

Future<bool> _magickBorderImage(_MagickBorderImageParams params) async =>
    _magickWandBindings.MagickBorderImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(params.borderWandPtrAddress),
      params.width,
      params.height,
      params.composeIndex,
    ).toBool();

class _MagickBrightnessContrastImageParams {
  final int wandPtrAddress;
  final double brightness;
  final double contrast;

  _MagickBrightnessContrastImageParams(
    this.wandPtrAddress,
    this.brightness,
    this.contrast,
  );
}

Future<bool> _magickBrightnessContrastImage(
        _MagickBrightnessContrastImageParams params) async =>
    _magickWandBindings.MagickBrightnessContrastImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.brightness,
      params.contrast,
    ).toBool();

class _MagickCannyEdgeImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;
  final double lowerPercent;
  final double upperPercent;

  _MagickCannyEdgeImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
    this.lowerPercent,
    this.upperPercent,
  );
}

Future<bool> _magickCannyEdgeImage(_MagickCannyEdgeImageParams params) async =>
    _magickWandBindings.MagickCannyEdgeImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
      params.lowerPercent,
      params.upperPercent,
    ).toBool();

class _MagickChannelFxImageParams {
  final int wandPtrAddress;
  final String expression;

  _MagickChannelFxImageParams(this.wandPtrAddress, this.expression);
}

Future<int> _magickChannelFxImage(_MagickChannelFxImageParams params) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickChannelFxImage(
        Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
        params.expression.toNativeUtf8(allocator: arena).cast(),
      ).address,
    );

class _MagickCharcoalImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickCharcoalImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickCharcoalImage(_MagickCharcoalImageParams params) async =>
    _magickWandBindings.MagickCharcoalImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.radius,
      params.sigma,
    ).toBool();

class _MagickChopImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final int x;
  final int y;

  _MagickChopImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.x,
    this.y,
  );
}

Future<bool> _magickChopImage(_MagickChopImageParams params) async =>
    _magickWandBindings.MagickChopImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.width,
      params.height,
      params.x,
      params.y,
    ).toBool();

class _MagickCLAHEImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final double numberBins;
  final double clipLimit;

  _MagickCLAHEImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.numberBins,
    this.clipLimit,
  );
}

Future<bool> _magickCLAHEImage(_MagickCLAHEImageParams params) async =>
    _magickWandBindings.MagickCLAHEImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.width,
      params.height,
      params.numberBins,
      params.clipLimit,
    ).toBool();

Future<bool> _magickClampImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickClampImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

Future<bool> _magickClipImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickClipImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickClipImagePathParams {
  final int wandPtrAddress;
  final String pathname;
  final bool inside;

  _MagickClipImagePathParams(this.wandPtrAddress, this.pathname, this.inside);
}

Future<bool> _magickClipImagePath(_MagickClipImagePathParams params) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickClipImagePath(
        Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
        params.pathname.toNativeUtf8(allocator: arena).cast(),
        params.inside.toInt(),
      ),
    ).toBool();

class _MagickClutImageParams {
  final int wandPtrAddress;
  final int clutWandPtrAddress;
  final int interpolateMethod;

  _MagickClutImageParams(
    this.wandPtrAddress,
    this.clutWandPtrAddress,
    this.interpolateMethod,
  );
}

Future<bool> _magickClutImage(_MagickClutImageParams params) async =>
    _magickWandBindings.MagickClutImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(params.clutWandPtrAddress),
      params.interpolateMethod,
    ).toBool();

Future<int> _magickCoalesceImages(int wandPtrAddress) async =>
    _magickWandBindings.MagickCoalesceImages(
            Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress))
        .address;

class _MagickColorDecisionListImageParams {
  final int wandPtrAddress;
  final String colorCorrectionCollection;

  _MagickColorDecisionListImageParams(
    this.wandPtrAddress,
    this.colorCorrectionCollection,
  );
}

Future<bool> _magickColorDecisionListImage(
        _MagickColorDecisionListImageParams params) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickColorDecisionListImage(
        Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
        params.colorCorrectionCollection.toNativeUtf8(allocator: arena).cast(),
      ),
    ).toBool();

class _MagickColorizeImageParams {
  final int wandPtrAddress;
  final int colorizePixelWandPtrAddress;
  final int blendPixelWandPtrAddress;

  _MagickColorizeImageParams(
    this.wandPtrAddress,
    this.colorizePixelWandPtrAddress,
    this.blendPixelWandPtrAddress,
  );
}

Future<bool> _magickColorizeImage(_MagickColorizeImageParams params) async =>
    _magickWandBindings.MagickColorizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(params.colorizePixelWandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(params.blendPixelWandPtrAddress),
    ).toBool();

class _MagickColorMatrixImageParams {
  final int wandPtrAddress;
  final KernelInfo colorMatrix;

  _MagickColorMatrixImageParams(this.wandPtrAddress, this.colorMatrix);
}

Future<bool> _magickColorMatrixImage(
        _MagickColorMatrixImageParams params) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickColorMatrixImage(
        Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
        params.colorMatrix._toKernelInfoStructPointer(allocator: arena),
      ),
    ).toBool();

class _MagickColorThresholdImageParams {
  final int wandPtrAddress;
  final int startColorPixelWandPtrAddress;
  final int endColorPixelWandPtrAddress;

  _MagickColorThresholdImageParams(
    this.wandPtrAddress,
    this.startColorPixelWandPtrAddress,
    this.endColorPixelWandPtrAddress,
  );
}

Future<bool> _magickColorThresholdImage(
        _MagickColorThresholdImageParams params) async =>
    _magickWandBindings.MagickColorThresholdImage(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(params.startColorPixelWandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(params.endColorPixelWandPtrAddress),
    ).toBool();

class _MagickCombineImagesParams {
  final int wandPtrAddress;
  final int colorSpaceType;

  _MagickCombineImagesParams(this.wandPtrAddress, this.colorSpaceType);
}

Future<int> _magickCombineImages(_MagickCombineImagesParams params) async =>
    _magickWandBindings.MagickCombineImages(
      Pointer<mwbg.MagickWand>.fromAddress(params.wandPtrAddress),
      params.colorSpaceType,
    ).address;

class _MagickCommentImageParams {
  final int wandPtrAddress;
  final String comment;

  _MagickCommentImageParams(this.wandPtrAddress, this.comment);
}

Future<bool> _magickCommentImage(_MagickCommentImageParams args) async => using(
      (Arena arena) => _magickWandBindings.MagickCommentImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.comment.toNativeUtf8(allocator: arena).cast(),
      ),
    ).toBool();

class _MagickCompareImagesLayersParams {
  final int wandPtrAddress;
  final int compareLayerMethod;

  _MagickCompareImagesLayersParams(
      this.wandPtrAddress, this.compareLayerMethod);
}

Future<int> _magickCompareImagesLayers(
        _MagickCompareImagesLayersParams args) async =>
    _magickWandBindings.MagickCompareImagesLayers(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.compareLayerMethod,
    ).address;

class _MagickCompareImagesParams {
  final int wandPtrAddress;
  final int referenceWandPtrAddress;
  final int metricType;
  final Float64List distortion;

  _MagickCompareImagesParams(
    this.wandPtrAddress,
    this.referenceWandPtrAddress,
    this.metricType,
    this.distortion,
  );
}

Future<int> _magickCompareImages(_MagickCompareImagesParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickCompareImages(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        Pointer<mwbg.MagickWand>.fromAddress(args.referenceWandPtrAddress),
        args.metricType,
        args.distortion.toDoubleArrayPointer(allocator: arena),
      ).address,
    );

class _MagickComplexImagesParams {
  final int wandPtrAddress;
  final int complexOperator;

  _MagickComplexImagesParams(this.wandPtrAddress, this.complexOperator);
}

Future<int> _magickComplexImages(_MagickComplexImagesParams args) async =>
    _magickWandBindings.MagickComplexImages(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.complexOperator,
    ).address;

class _MagickCompositeImageParams {
  final int wandPtrAddress;
  final int sourceWandPtrAddress;
  final int compositeOperator;
  final bool clipToSelf;
  final int x;
  final int y;

  _MagickCompositeImageParams(
    this.wandPtrAddress,
    this.sourceWandPtrAddress,
    this.compositeOperator,
    this.clipToSelf,
    this.x,
    this.y,
  );
}

Future<bool> _magickCompositeImage(_MagickCompositeImageParams args) async =>
    _magickWandBindings.MagickCompositeImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(args.sourceWandPtrAddress),
      args.compositeOperator,
      args.clipToSelf.toInt(),
      args.x,
      args.y,
    ).toBool();

class _MagickCompositeImageGravityParams {
  final int wandPtrAddress;
  final int sourceWandPtrAddress;
  final int compositeOperator;
  final int gravityType;

  _MagickCompositeImageGravityParams(
    this.wandPtrAddress,
    this.sourceWandPtrAddress,
    this.compositeOperator,
    this.gravityType,
  );
}

Future<bool> _magickCompositeImageGravity(
        _MagickCompositeImageGravityParams args) async =>
    _magickWandBindings.MagickCompositeImageGravity(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(args.sourceWandPtrAddress),
      args.compositeOperator,
      args.gravityType,
    ).toBool();

class _MagickCompositeLayersParams {
  final int wandPtrAddress;
  final int sourceWandPtrAddress;
  final int compositeOperator;
  final int x;
  final int y;

  _MagickCompositeLayersParams(
    this.wandPtrAddress,
    this.sourceWandPtrAddress,
    this.compositeOperator,
    this.x,
    this.y,
  );
}

Future<bool> _magickCompositeLayers(_MagickCompositeLayersParams args) async =>
    _magickWandBindings.MagickCompositeLayers(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(args.sourceWandPtrAddress),
      args.compositeOperator,
      args.x,
      args.y,
    ).toBool();

class _MagickContrastImageParams {
  final int wandPtrAddress;
  final bool sharpen;

  _MagickContrastImageParams(this.wandPtrAddress, this.sharpen);
}

Future<bool> _magickContrastImage(_MagickContrastImageParams args) async =>
    _magickWandBindings.MagickContrastImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.sharpen.toInt(),
    ).toBool();

class _MagickContrastStretchImageParams {
  final int wandPtrAddress;
  final double whitePoint;
  final double blackPoint;

  _MagickContrastStretchImageParams(
    this.wandPtrAddress,
    this.whitePoint,
    this.blackPoint,
  );
}

Future<bool> _magickContrastStretchImage(
        _MagickContrastStretchImageParams args) async =>
    _magickWandBindings.MagickContrastStretchImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.blackPoint,
      args.whitePoint,
    ).toBool();

class _MagickConvolveImageParams {
  final int wandPtrAddress;
  final KernelInfo kernel;

  _MagickConvolveImageParams(this.wandPtrAddress, this.kernel);
}

Future<bool> _magickConvolveImage(_MagickConvolveImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickConvolveImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.kernel._toKernelInfoStructPointer(allocator: arena),
      ),
    ).toBool();

class _MagickCropImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final int x;
  final int y;

  _MagickCropImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.x,
    this.y,
  );
}

Future<bool> _magickCropImage(_MagickCropImageParams args) async => using(
      (Arena arena) => _magickWandBindings.MagickCropImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.width,
        args.height,
        args.x,
        args.y,
      ),
    ).toBool();

class _MagickCycleColormapImageParams {
  final int wandPtrAddress;
  final int displace;

  _MagickCycleColormapImageParams(this.wandPtrAddress, this.displace);
}

Future<bool> _magickCycleColormapImage(
        _MagickCycleColormapImageParams args) async =>
    _magickWandBindings.MagickCycleColormapImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.displace,
    ).toBool();

class _MagickConstituteImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;
  final String map;
  final _StorageType storageType;
  final TypedData pixels;

  _MagickConstituteImageParams(
    this.wandPtrAddress,
    this.columns,
    this.rows,
    this.map,
    this.storageType,
    this.pixels,
  );
}

Future<bool> _magickConstituteImage(_MagickConstituteImageParams args) async =>
    using(
      (Arena arena) {
        if (args.pixels.lengthInBytes == 0) {
          return false;
        }
        final Pointer<Void> pixelsPtr;
        switch (args.storageType) {
          case _StorageType.UndefinedPixel:
            return false;
          case _StorageType.CharPixel:
            pixelsPtr = (args.pixels as Uint8List)
                .toUnsignedCharArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.DoublePixel:
            pixelsPtr = (args.pixels as Float64List)
                .toDoubleArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.FloatPixel:
            pixelsPtr = (args.pixels as Float32List)
                .toFloatArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.LongPixel:
            pixelsPtr = (args.pixels as Uint32List)
                .toUint32ArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.LongLongPixel:
            pixelsPtr = (args.pixels as Uint64List)
                .toUint64ArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.QuantumPixel:
            // TODO: support this when it becomes clear how to map the `Quantum`
            // C type to dart
            return false;
          case _StorageType.ShortPixel:
            pixelsPtr = (args.pixels as Uint16List)
                .toUint16ArrayPointer(allocator: arena)
                .cast();
            break;
        }
        return _magickWandBindings.MagickConstituteImage(
          Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
          args.columns,
          args.rows,
          args.map.toNativeUtf8(allocator: arena).cast(),
          args.storageType.index,
          pixelsPtr,
        ).toBool();
      },
    );

class _MagickDecipherImageParams {
  final int wandPtrAddress;
  final String passphrase;

  _MagickDecipherImageParams(this.wandPtrAddress, this.passphrase);
}

Future<bool> _magickDecipherImage(_MagickDecipherImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickDecipherImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.passphrase.toNativeUtf8(allocator: arena).cast(),
      ),
    ).toBool();

Future<int> _magickDeconstructImages(int wandPtrAddress) async =>
    _magickWandBindings.MagickDeconstructImages(
            Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress))
        .address;

class _MagickDeskewImageParams {
  final int wandPtrAddress;
  final double threshold;

  _MagickDeskewImageParams(this.wandPtrAddress, this.threshold);
}

Future<bool> _magickDeskewImage(_MagickDeskewImageParams args) async =>
    _magickWandBindings.MagickDeskewImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.threshold,
    ).toBool();

Future<bool> _magickDespeckleImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickDespeckleImage(
            Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress))
        .toBool();

class _MagickDistortImageParams {
  final int wandPtrAddress;
  final DistortMethod method;
  final Float64List arguments;
  final bool bestFit;

  _MagickDistortImageParams(
      this.wandPtrAddress, this.method, this.arguments, this.bestFit);
}

Future<bool> _magickDistortImage(_MagickDistortImageParams args) async => using(
      (Arena arena) => _magickWandBindings.MagickDistortImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.method.index,
        args.arguments.length,
        args.arguments.toDoubleArrayPointer(allocator: arena),
        args.bestFit.toInt(),
      ),
    ).toBool();

class _MagickDrawImageParams {
  final int wandPtrAddress;
  final int drawWandPtrAddress;

  _MagickDrawImageParams(this.wandPtrAddress, this.drawWandPtrAddress);
}

Future<bool> _magickDrawImage(_MagickDrawImageParams args) async =>
    _magickWandBindings.MagickDrawImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.DrawingWand>.fromAddress(args.drawWandPtrAddress),
    ).toBool();

class _MagickEdgeImageParams {
  final int wandPtrAddress;
  final double radius;

  _MagickEdgeImageParams(this.wandPtrAddress, this.radius);
}

Future<bool> _magickEdgeImage(_MagickEdgeImageParams args) async =>
    _magickWandBindings.MagickEdgeImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
    ).toBool();

class _MagickEmbossImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickEmbossImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickEmbossImage(_MagickEmbossImageParams args) async =>
    _magickWandBindings.MagickEmbossImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
    ).toBool();

class _MagickEncipherImageParams {
  final int wandPtrAddress;
  final String passphrase;

  _MagickEncipherImageParams(this.wandPtrAddress, this.passphrase);
}

Future<bool> _magickEncipherImage(_MagickEncipherImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickEncipherImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.passphrase.toNativeUtf8(allocator: arena).cast(),
      ),
    ).toBool();

Future<bool> _magickEnhanceImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickEnhanceImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

Future<bool> _magickEqualizeImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickEqualizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickEvaluateImageParams {
  final int wandPtrAddress;
  final MagickEvaluateOperator operator;
  final double value;

  _MagickEvaluateImageParams(this.wandPtrAddress, this.operator, this.value);
}

Future<bool> _magickEvaluateImage(_MagickEvaluateImageParams args) async =>
    _magickWandBindings.MagickEvaluateImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.operator.index,
      args.value,
    ).toBool();

class _MagickExportImagePixelsParams {
  final int wandPtrAddress;
  final int x;
  final int y;
  final int columns;
  final int rows;
  final String map;

  _MagickExportImagePixelsParams(
    this.wandPtrAddress,
    this.x,
    this.y,
    this.columns,
    this.rows,
    this.map,
  );
}

Future<Uint8List?> _magickExportImageCharPixels(
        _MagickExportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        int pixelsArraySize =
            args.columns * args.rows * args.map.length * sizeOf<UnsignedChar>();
        final Pointer<UnsignedChar> pixelsPtr = arena(pixelsArraySize);
        bool result = _magickWandBindings.MagickExportImagePixels(
          Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
          args.x,
          args.y,
          args.columns,
          args.rows,
          args.map.toNativeUtf8(allocator: arena).cast(),
          _StorageType.CharPixel.index,
          pixelsPtr.cast(),
        ).toBool();
        if (result) {
          return pixelsPtr.toUint8List(pixelsArraySize);
        }
        return null;
      },
    );

Future<Float64List?> _magickExportImageDoublePixels(
        _MagickExportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        int pixelsArraySize =
            args.columns * args.rows * args.map.length * sizeOf<Double>();
        final Pointer<Double> pixelsPtr = arena(pixelsArraySize);
        bool result = _magickWandBindings.MagickExportImagePixels(
          Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
          args.x,
          args.y,
          args.columns,
          args.rows,
          args.map.toNativeUtf8(allocator: arena).cast(),
          _StorageType.DoublePixel.index,
          pixelsPtr.cast(),
        ).toBool();
        if (result) {
          // TODO: see if we can return the list using `asTypedData` instead
          // of copying, while still freeing the pointer automatically when the
          // list is garbage collected.
          return pixelsPtr.toFloat64List(pixelsArraySize);
        }
        return null;
      },
    );

Future<Float32List?> _magickExportImageFloatPixels(
        _MagickExportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        int pixelsArraySize =
            args.columns * args.rows * args.map.length * sizeOf<Float>();
        final Pointer<Float> pixelsPtr = arena(pixelsArraySize);
        bool result = _magickWandBindings.MagickExportImagePixels(
          Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
          args.x,
          args.y,
          args.columns,
          args.rows,
          args.map.toNativeUtf8(allocator: arena).cast(),
          _StorageType.FloatPixel.index,
          pixelsPtr.cast(),
        ).toBool();
        if (result) {
          // TODO: see if we can return the list using `asTypedData` instead
          // of copying, while still freeing the pointer automatically when the
          // list is garbage collected.
          return pixelsPtr.toFloat32List(pixelsArraySize);
        }
        return null;
      },
    );

Future<Uint32List?> _magickExportImageLongPixels(
        _MagickExportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        int pixelsArraySize =
            args.columns * args.rows * args.map.length * sizeOf<Uint32>();
        final Pointer<Uint32> pixelsPtr = arena(pixelsArraySize);
        bool result = _magickWandBindings.MagickExportImagePixels(
          Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
          args.x,
          args.y,
          args.columns,
          args.rows,
          args.map.toNativeUtf8(allocator: arena).cast(),
          _StorageType.LongPixel.index,
          pixelsPtr.cast(),
        ).toBool();
        if (result) {
          // TODO: see if we can return the list using `asTypedData` instead
          // of copying, while still freeing the pointer automatically when the
          // list is garbage collected.
          return pixelsPtr.toUint32List(pixelsArraySize);
        }
        return null;
      },
    );

Future<Uint64List?> _magickExportImageLongLongPixels(
        _MagickExportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        int pixelsArraySize =
            args.columns * args.rows * args.map.length * sizeOf<Uint64>();
        final Pointer<Uint64> pixelsPtr = arena(pixelsArraySize);
        bool result = _magickWandBindings.MagickExportImagePixels(
          Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
          args.x,
          args.y,
          args.columns,
          args.rows,
          args.map.toNativeUtf8(allocator: arena).cast(),
          _StorageType.LongLongPixel.index,
          pixelsPtr.cast(),
        ).toBool();
        if (result) {
          // TODO: see if we can return the list using `asTypedData` instead
          // of copying, while still freeing the pointer automatically when the
          // list is garbage collected.
          return pixelsPtr.toUint64List(pixelsArraySize);
        }
        return null;
      },
    );

// TODO: support _magickExportImageQuantumPixels when it becomes clear how to
// map the `Quantum` type to Dart.

Future<Uint16List?> _magickExportImageShortPixels(
        _MagickExportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        int pixelsArraySize =
            args.columns * args.rows * args.map.length * sizeOf<Uint16>();
        final Pointer<Uint16> pixelsPtr = arena(pixelsArraySize);
        bool result = _magickWandBindings.MagickExportImagePixels(
          Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
          args.x,
          args.y,
          args.columns,
          args.rows,
          args.map.toNativeUtf8(allocator: arena).cast(),
          _StorageType.ShortPixel.index,
          pixelsPtr.cast(),
        ).toBool();
        if (result) {
          // TODO: see if we can return the list using `asTypedData` instead
          // of copying, while still freeing the pointer automatically when the
          // list is garbage collected.
          return pixelsPtr.toUint16List(pixelsArraySize);
        }
        return null;
      },
    );

class _MagickExtentImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final int x;
  final int y;

  _MagickExtentImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.x,
    this.y,
  );
}

Future<bool> _magickExtentImage(_MagickExtentImageParams args) async =>
    _magickWandBindings.MagickExtentImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.width,
      args.height,
      args.x,
      args.y,
    ).toBool();

Future<bool> _magickFlipImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickFlipImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickFloodfillPaintImageParams {
  final int wandPtrAddress;
  final int fillPixelWandAddress;
  final double fuzz;
  final int bordercolorPixelWandAddress;
  final int x;
  final int y;
  final bool invert;

  _MagickFloodfillPaintImageParams(
    this.wandPtrAddress,
    this.fillPixelWandAddress,
    this.fuzz,
    this.bordercolorPixelWandAddress,
    this.x,
    this.y,
    this.invert,
  );
}

Future<bool> _magickFloodfillPaintImage(
        _MagickFloodfillPaintImageParams args) async =>
    _magickWandBindings.MagickFloodfillPaintImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.fillPixelWandAddress),
      args.fuzz,
      Pointer<mwbg.PixelWand>.fromAddress(args.bordercolorPixelWandAddress),
      args.x,
      args.y,
      args.invert.toInt(),
    ).toBool();

Future<bool> _magickFlopImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickFlopImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickFrameImageParams {
  final int wandPtrAddress;
  final int matteColorPixelWandAddress;
  final int width;
  final int height;
  final int innerBevel;
  final int outerBevel;
  final CompositeOperator compose;

  _MagickFrameImageParams(
    this.wandPtrAddress,
    this.matteColorPixelWandAddress,
    this.width,
    this.height,
    this.innerBevel,
    this.outerBevel,
    this.compose,
  );
}

Future<bool> _magickFrameImage(_MagickFrameImageParams args) async =>
    _magickWandBindings.MagickFrameImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.matteColorPixelWandAddress),
      args.width,
      args.height,
      args.innerBevel,
      args.outerBevel,
      args.compose.index,
    ).toBool();

class _MagickFunctionImageParams {
  final int wandPtrAddress;
  final MagickFunctionType function;
  final Float64List arguments;

  _MagickFunctionImageParams(
    this.wandPtrAddress,
    this.function,
    this.arguments,
  );
}

Future<bool> _magickFunctionImage(_MagickFunctionImageParams args) async =>
    using(
      (Arena arena) {
        final Pointer<Double> argumentsPtr =
            args.arguments.toDoubleArrayPointer(allocator: arena);
        return _magickWandBindings.MagickFunctionImage(
          Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
          args.function.index,
          args.arguments.length,
          argumentsPtr,
        );
      },
    ).toBool();

class _MagickFxImageParams {
  final int wandPtrAddress;
  final String expression;

  _MagickFxImageParams(
    this.wandPtrAddress,
    this.expression,
  );
}

Future<int> _magickFxImage(_MagickFxImageParams args) async => using(
      (Arena arena) => _magickWandBindings.MagickFxImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.expression.toNativeUtf8(allocator: arena).cast(),
      ).address,
    );

class _MagickGammaImageParams {
  final int wandPtrAddress;
  final double gamma;

  _MagickGammaImageParams(this.wandPtrAddress, this.gamma);
}

Future<bool> _magickGammaImage(_MagickGammaImageParams args) async =>
    _magickWandBindings.MagickGammaImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.gamma,
    ).toBool();

class _MagickGaussianBlurImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickGaussianBlurImageParams(this.wandPtrAddress, this.radius, this.sigma);
}

Future<bool> _magickGaussianBlurImage(
        _MagickGaussianBlurImageParams args) async =>
    _magickWandBindings.MagickGaussianBlurImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
    ).toBool();

Future<int> _magickGetImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickGetImage(
            Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress))
        .address;

class _MagickGetImageMaskParams {
  final int wandPtrAddress;
  final PixelMask type;

  _MagickGetImageMaskParams(this.wandPtrAddress, this.type);
}

Future<int> _magickGetImageMask(_MagickGetImageMaskParams args) async =>
    _magickWandBindings.MagickGetImageMask(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.type.value,
    ).address;

Future<Uint8List?> _magickGetImageBlob(int wandPtrAddress) async => using(
      (Arena arena) async {
        final Pointer<Size> lengthPtr = arena();
        final Pointer<UnsignedChar> blobPtr =
            _magickWandBindings.MagickGetImageBlob(
          Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
          lengthPtr,
        );
        final Uint8List? result =
            Pointer<UnsignedChar>.fromAddress(blobPtr.address)
                .toUint8List(lengthPtr.value);
        _magickRelinquishMemory(blobPtr.cast());
        return result;
      },
    );

Future<Uint8List?> _magickGetImagesBlob(int wandPtrAddress) async => using(
      (Arena arena) async {
        final Pointer<Size> lengthPtr = arena();
        final Pointer<UnsignedChar> blobPtr =
            _magickWandBindings.MagickGetImagesBlob(
          Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
          lengthPtr,
        );
        final Uint8List? result =
            Pointer<UnsignedChar>.fromAddress(blobPtr.address)
                .toUint8List(lengthPtr.value);
        _magickRelinquishMemory(blobPtr.cast());
        return result;
      },
    );

class MagickGetImageBluePrimaryResult {
  /// The chromaticity blue primary x-point
  final double x;

  /// The chromaticity blue primary y-point
  final double y;

  /// The chromaticity blue primary z-point
  final double z;

  const MagickGetImageBluePrimaryResult(this.x, this.y, this.z);

  @override
  String toString() => 'MagickGetImageBluePrimaryResult{x: $x, y: $y, z: $z}';
}

class _MagickGetImageFeaturesParams {
  final int wandPtrAddress;
  final int distance;

  _MagickGetImageFeaturesParams(this.wandPtrAddress, this.distance);
}

Future<ChannelFeatures?> _magickGetImageFeatures(
    _MagickGetImageFeaturesParams args) async {
  final Pointer<mwbg.ChannelFeatures> featuresPtr =
      _magickWandBindings.MagickGetImageFeatures(
    Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
    args.distance,
  ).cast();
  ChannelFeatures? result =
      ChannelFeatures._fromChannelFeaturesStructPointer(featuresPtr);
  _magickRelinquishMemory(featuresPtr.cast());
  return result;
}

/// Represents the result of a call to [magickGetImageKurtosis].
class MagickGetImageKurtosisResult {
  /// The kurtosis of the corresponding image channel.
  final double kurtosis;

  /// The skewness of the corresponding image channel.
  final double skewness;

  const MagickGetImageKurtosisResult(this.kurtosis, this.skewness);

  @override
  String toString() =>
      'MagickGetImageKurtosisResult{kurtosis: $kurtosis, skewness: $skewness}';
}

Future<MagickGetImageKurtosisResult?> _magickGetImageKurtosis(
        int wandPtrAddress) async =>
    using(
      (Arena arena) {
        final Pointer<Double> kurtosisPtr = arena();
        final Pointer<Double> skewnessPtr = arena();
        bool result = _magickWandBindings.MagickGetImageKurtosis(
          Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
          kurtosisPtr,
          skewnessPtr,
        ).toBool();
        if (!result) {
          return null;
        }
        return MagickGetImageKurtosisResult(
          kurtosisPtr.value,
          skewnessPtr.value,
        );
      },
    );

/// Represents the result of a call to [magickGetImageMean].
class MagickGetImageMeanResult {
  /// The mean of the image.
  final double mean;

  /// The standard deviation of the image.
  final double standardDeviation;

  const MagickGetImageMeanResult(this.mean, this.standardDeviation);

  @override
  String toString() =>
      'MagickGetMeanResult{mean: $mean, standardDeviation: $standardDeviation}';
}

Future<MagickGetImageMeanResult?> _magickGetImageMean(
        int wandPtrAddress) async =>
    using(
      (Arena arena) {
        final Pointer<Double> meanPtr = arena();
        final Pointer<Double> standardDeviationPtr = arena();
        bool result = _magickWandBindings.MagickGetImageMean(
          Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
          meanPtr,
          standardDeviationPtr,
        ).toBool();
        if (!result) {
          return null;
        }
        return MagickGetImageMeanResult(
          meanPtr.value,
          standardDeviationPtr.value,
        );
      },
    );

/// Represents the result of a call to [magickGetImageRange].
class MagickGetImageRangeResult {
  /// The minimum pixel value for the specified channel(s).
  final double minima;

  /// The maximum pixel value for the specified channel(s).
  final double maxima;

  const MagickGetImageRangeResult(this.minima, this.maxima);

  @override
  String toString() =>
      'MagickGetImageRangeResult{minima: $minima, maxima: $maxima}';
}

Future<MagickGetImageRangeResult?> _magickGetImageRange(
        int wandPtrAddress) async =>
    using(
      (Arena arena) {
        final Pointer<Double> minimaPtr = arena();
        final Pointer<Double> maximaPtr = arena();
        bool result = _magickWandBindings.MagickGetImageRange(
          Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
          minimaPtr,
          maximaPtr,
        ).toBool();
        if (!result) {
          return null;
        }
        return MagickGetImageRangeResult(
          minimaPtr.value,
          maximaPtr.value,
        );
      },
    );

Future<ChannelStatistics?> _magickGetImageStatistics(int wandPtrAddress) async {
  final Pointer<mwbg.ChannelStatistics> statisticsPtr =
      _magickWandBindings.MagickGetImageStatistics(
    Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
  ).cast();
  ChannelStatistics? result =
      ChannelStatistics._fromChannelStatisticsStructPointer(statisticsPtr);
  _magickRelinquishMemory(statisticsPtr.cast());
  return result;
}

Future<int> _magickGetImageColors(int wandPtrAddress) async =>
    _magickWandBindings.MagickGetImageColors(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    );

/// Represents the result of a call to [magickGetImageGreenPrimary].
class MagickGetImageGreenPrimaryResult {
  /// The chromaticity green primary x-point.
  final double x;

  /// The chromaticity green primary y-point.
  final double y;

  /// The chromaticity green primary z-point.
  final double z;

  const MagickGetImageGreenPrimaryResult(
    this.x,
    this.y,
    this.z,
  );

  @override
  String toString() => 'MagickGetImageGreenPrimaryResult{x: $x, y: $y, z: $z}';
}

Future<List<int>> _magickGetImageHistogram(int wandPtrAddress) async => using(
      (Arena arena) {
        final Pointer<Size> numberColorsPtr = arena();
        final Pointer<Pointer<mwbg.PixelWand>> pixelWandsPtr =
            _magickWandBindings.MagickGetImageHistogram(
          Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
          numberColorsPtr,
        );
        if (pixelWandsPtr == nullptr) {
          return [];
        }
        final List<int> result = [];
        for (int i = 0; i < numberColorsPtr.value; i++) {
          result.add(pixelWandsPtr[i].address);
        }
        return result;
      },
    );

/// Represents the result of a call to [magickGetImagePage].
class MagickGetImagePageResult {
  final int width;
  final int height;
  final int x;
  final int y;

  const MagickGetImagePageResult(
    this.width,
    this.height,
    this.x,
    this.y,
  );

  @override
  String toString() =>
      'MagickGetImagePageResult{width: $width, height: $height, x: $x, y: $y}';
}

/// Represents the result of a call to [magickGetImageRedPrimary].
class MagickGetImageRedPrimaryResult {
  /// The chromaticity red primary x-point.
  final double x;

  /// The chromaticity red primary y-point.
  final double y;

  /// The chromaticity red primary z-point.
  final double z;

  const MagickGetImageRedPrimaryResult(
    this.x,
    this.y,
    this.z,
  );

  @override
  String toString() => 'MagickGetImageRedPrimaryResult{x: $x, y: $y, z: $z}';
}

class _MagickGetImageRegionParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final int x;
  final int y;

  _MagickGetImageRegionParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.x,
    this.y,
  );
}

Future<int> _magickGetImageRegion(_MagickGetImageRegionParams args) async =>
    _magickWandBindings.MagickGetImageRegion(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.width,
      args.height,
      args.x,
      args.y,
    ).address;

/// Represents the result of a call to [magickGetImageResolution].
class MagickGetImageResolutionResult {
  /// The image x-resolution.
  final double xResolution;

  /// The image y-resolution.
  final double yResolution;

  const MagickGetImageResolutionResult(this.xResolution, this.yResolution);

  @override
  String toString() =>
      'MagickGetImageResolutionResult{xResolution: $xResolution, yResolution: $yResolution}';
}

/// Represents the result of a call to [magickGetImageWhitePoint].
class MagickGetImageWhitePointResult {
  /// The chromaticity white point x-point.
  final double x;

  /// The chromaticity white point y-point.
  final double y;

  /// The chromaticity white point z-point.
  final double z;

  const MagickGetImageWhitePointResult(this.x, this.y, this.z);

  @override
  String toString() => 'MagickGetImageWhitePointResult{x: $x, y: $y, z: $z}';
}

Future<double> _magickGetImageTotalInkDensity(int wandPtrAddress) async =>
    _magickWandBindings.MagickGetImageTotalInkDensity(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    );

class _MagickHaldClutImageParams {
  final int wandPtrAddress;
  final int clutWandPtrAddress;

  _MagickHaldClutImageParams(
    this.wandPtrAddress,
    this.clutWandPtrAddress,
  );
}

Future<bool> _magickHaldClutImage(_MagickHaldClutImageParams args) async =>
    _magickWandBindings.MagickHaldClutImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(args.clutWandPtrAddress),
    ).toBool();

class _MagickHoughLineImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final int threshold;

  _MagickHoughLineImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.threshold,
  );
}

Future<bool> _magickHoughLineImage(_MagickHoughLineImageParams args) async =>
    _magickWandBindings.MagickHoughLineImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.width,
      args.height,
      args.threshold,
    ).toBool();

Future<String?> _magickIdentifyImage(int wandPtrAddress) async {
  final Pointer<Char> resultPtr = _magickWandBindings.MagickIdentifyImage(
    Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
  );
  final String? result = resultPtr.toNullableString();
  _magickRelinquishMemory(resultPtr.cast());
  return result;
}

Future<ImageType> _magickIdentifyImageType(int wandPtrAddress) async =>
    ImageType.values[_magickWandBindings.MagickIdentifyImageType(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    )];

class _MagickImplodeImageParams {
  final int wandPtrAddress;
  final double amount;
  final PixelInterpolateMethod method;

  _MagickImplodeImageParams(
    this.wandPtrAddress,
    this.amount,
    this.method,
  );
}

Future<bool> _magickImplodeImage(_MagickImplodeImageParams args) async =>
    _magickWandBindings.MagickImplodeImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.amount,
      args.method.index,
    ).toBool();

class _MagickImportImagePixelsParams {
  final int wandPtrAddress;
  final int x;
  final int y;
  final int columns;
  final int rows;
  final String map;
  final _StorageType storageType;
  final TypedData pixels;

  _MagickImportImagePixelsParams(
    this.wandPtrAddress,
    this.x,
    this.y,
    this.columns,
    this.rows,
    this.map,
    this.storageType,
    this.pixels,
  );
}

Future<bool> _magickImportImagePixels(
        _MagickImportImagePixelsParams args) async =>
    using(
      (Arena arena) {
        if (args.pixels.lengthInBytes == 0) {
          return false;
        }
        final Pointer<Void> pixelsPtr;
        switch (args.storageType) {
          case _StorageType.UndefinedPixel:
            return false;
          case _StorageType.CharPixel:
            pixelsPtr = (args.pixels as Uint8List)
                .toUnsignedCharArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.DoublePixel:
            pixelsPtr = (args.pixels as Float64List)
                .toDoubleArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.FloatPixel:
            pixelsPtr = (args.pixels as Float32List)
                .toFloatArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.LongPixel:
            pixelsPtr = (args.pixels as Uint32List)
                .toUint32ArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.LongLongPixel:
            pixelsPtr = (args.pixels as Uint64List)
                .toUint64ArrayPointer(allocator: arena)
                .cast();
            break;
          case _StorageType.QuantumPixel:
            // TODO: support this when it becomes clear how to map the `Quantum`
            // C type to dart
            return false;
          case _StorageType.ShortPixel:
            pixelsPtr = (args.pixels as Uint16List)
                .toUint16ArrayPointer(allocator: arena)
                .cast();
            break;
        }
        return _magickWandBindings.MagickImportImagePixels(
          Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
          args.x,
          args.y,
          args.columns,
          args.rows,
          args.map.toNativeUtf8(allocator: arena).cast(),
          args.storageType.index,
          pixelsPtr,
        ).toBool();
      },
    );

class _MagickInterpolativeResizeImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;
  final PixelInterpolateMethod method;

  _MagickInterpolativeResizeImageParams(
    this.wandPtrAddress,
    this.columns,
    this.rows,
    this.method,
  );
}

Future<bool> _magickInterpolativeResizeImage(
        _MagickInterpolativeResizeImageParams args) async =>
    _magickWandBindings.MagickInterpolativeResizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.columns,
      args.rows,
      args.method.index,
    ).toBool();

class _MagickKmeansImageParams {
  final int wandPtrAddress;
  final int numberColors;
  final int maxIterations;
  final double tolerance;

  _MagickKmeansImageParams(
    this.wandPtrAddress,
    this.numberColors,
    this.maxIterations,
    this.tolerance,
  );
}

Future<bool> _magickKmeansImage(_MagickKmeansImageParams args) async =>
    _magickWandBindings.MagickKmeansImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.numberColors,
      args.maxIterations,
      args.tolerance,
    ).toBool();

class _MagickKuwaharaImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickKuwaharaImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
  );
}

Future<bool> _magickKuwaharaImage(_MagickKuwaharaImageParams args) async =>
    _magickWandBindings.MagickKuwaharaImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
    ).toBool();

class _MagickLabelImageParams {
  final int wandPtrAddress;
  final String label;

  _MagickLabelImageParams(this.wandPtrAddress, this.label);
}

Future<bool> _magickLabelImage(_MagickLabelImageParams args) async => using(
      (Arena arena) => _magickWandBindings.MagickLabelImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.label.toNativeUtf8(allocator: arena).cast(),
      ),
    ).toBool();

class _MagickLevelImageParams {
  final int wandPtrAddress;
  final double blackPoint;
  final double gamma;
  final double whitePoint;

  _MagickLevelImageParams(
    this.wandPtrAddress,
    this.blackPoint,
    this.gamma,
    this.whitePoint,
  );
}

Future<bool> _magickLevelImage(_MagickLevelImageParams args) async =>
    _magickWandBindings.MagickLevelImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.blackPoint,
      args.gamma,
      args.whitePoint,
    ).toBool();

class _MagickLevelImageColorsParams {
  final int wandPtrAddress;
  final int blackColorPixelWandAddress;
  final int whiteColorPixelWandAddress;
  final bool invert;

  _MagickLevelImageColorsParams(
    this.wandPtrAddress,
    this.blackColorPixelWandAddress,
    this.whiteColorPixelWandAddress,
    this.invert,
  );
}

Future<bool> _magickLevelImageColors(
        _MagickLevelImageColorsParams args) async =>
    _magickWandBindings.MagickLevelImageColors(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.blackColorPixelWandAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.whiteColorPixelWandAddress),
      args.invert.toInt(),
    ).toBool();

class _MagickLevelizeImageParams {
  final int wandPtrAddress;
  final double blackPoint;
  final double whitePoint;
  final double gamma;

  _MagickLevelizeImageParams(
    this.wandPtrAddress,
    this.blackPoint,
    this.whitePoint,
    this.gamma,
  );
}

Future<bool> _magickLevelizeImage(_MagickLevelizeImageParams args) async =>
    _magickWandBindings.MagickLevelizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.blackPoint,
      args.whitePoint,
      args.gamma,
    ).toBool();

class _MagickLinearStretchImageParams {
  final int wandPtrAddress;
  final double blackPoint;
  final double whitePoint;

  _MagickLinearStretchImageParams(
    this.wandPtrAddress,
    this.blackPoint,
    this.whitePoint,
  );
}

Future<bool> _magickLinearStretchImage(
        _MagickLinearStretchImageParams args) async =>
    _magickWandBindings.MagickLinearStretchImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.blackPoint,
      args.whitePoint,
    ).toBool();

class _MagickLiquidRescaleImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;
  final double deltaX;
  final double rigidity;

  _MagickLiquidRescaleImageParams(
    this.wandPtrAddress,
    this.columns,
    this.rows,
    this.deltaX,
    this.rigidity,
  );
}

Future<bool> _magickLiquidRescaleImage(
        _MagickLiquidRescaleImageParams args) async =>
    _magickWandBindings.MagickLiquidRescaleImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.columns,
      args.rows,
      args.deltaX,
      args.rigidity,
    ).toBool();

class _MagickLocalContrastImageParams {
  final int wandPtrAddress;
  final double radius;
  final double strength;

  _MagickLocalContrastImageParams(
    this.wandPtrAddress,
    this.radius,
    this.strength,
  );
}

Future<bool> _magickLocalContrastImage(
        _MagickLocalContrastImageParams args) async =>
    _magickWandBindings.MagickLocalContrastImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.strength,
    ).toBool();

Future<bool> _magickMagnifyImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickMagnifyImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickMeanShiftImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final double colorDistance;

  _MagickMeanShiftImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.colorDistance,
  );
}

Future<bool> _magickMeanShiftImage(_MagickMeanShiftImageParams args) async =>
    _magickWandBindings.MagickMeanShiftImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.width,
      args.height,
      args.colorDistance,
    ).toBool();

class _MagickMergeImageLayersParams {
  final int wandPtrAddress;
  final LayerMethod layerMethod;

  _MagickMergeImageLayersParams(
    this.wandPtrAddress,
    this.layerMethod,
  );
}

Future<int> _magickMergeImageLayers(_MagickMergeImageLayersParams args) async =>
    _magickWandBindings.MagickMergeImageLayers(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.layerMethod.index,
    ).address;

Future<bool> _magickMinifyImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickMinifyImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickModulateImageParams {
  final int wandPtrAddress;
  final double brightness;
  final double saturation;
  final double hue;

  _MagickModulateImageParams(
    this.wandPtrAddress,
    this.brightness,
    this.saturation,
    this.hue,
  );
}

Future<bool> _magickModulateImage(_MagickModulateImageParams args) async =>
    _magickWandBindings.MagickModulateImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.brightness,
      args.saturation,
      args.hue,
    ).toBool();

class _MagickMontageImageParams {
  final int wandPtrAddress;
  final int drawingWandPtrAddress;
  final String tileGeometry;
  final String thumbnailGeometry;
  final MontageMode montageMode;
  final String frame;

  _MagickMontageImageParams(
    this.wandPtrAddress,
    this.drawingWandPtrAddress,
    this.tileGeometry,
    this.thumbnailGeometry,
    this.montageMode,
    this.frame,
  );
}

Future<int> _magickMontageImage(_MagickMontageImageParams args) async => using(
      (Arena arena) => _magickWandBindings.MagickMontageImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        Pointer<mwbg.DrawingWand>.fromAddress(args.drawingWandPtrAddress),
        args.tileGeometry.toNativeUtf8(allocator: arena).cast(),
        args.thumbnailGeometry.toNativeUtf8(allocator: arena).cast(),
        args.montageMode.index,
        args.frame.toNativeUtf8(allocator: arena).cast(),
      ),
    ).address;

class _MagickMorphImagesParams {
  final int wandPtrAddress;
  final int numberFrames;

  _MagickMorphImagesParams(
    this.wandPtrAddress,
    this.numberFrames,
  );
}

Future<int> _magickMorphImages(_MagickMorphImagesParams args) async =>
    _magickWandBindings.MagickMorphImages(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.numberFrames,
    ).address;

class _MagickMorphologyImageParams {
  final int wandPtrAddress;
  final MorphologyMethod morphologyMethod;
  final int iterations;
  final KernelInfo kernelInfo;

  _MagickMorphologyImageParams(
    this.wandPtrAddress,
    this.morphologyMethod,
    this.iterations,
    this.kernelInfo,
  );
}

Future<bool> _magickMorphologyImage(_MagickMorphologyImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickMorphologyImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.morphologyMethod.index,
        args.iterations,
        args.kernelInfo._toKernelInfoStructPointer(allocator: arena),
      ),
    ).toBool();

class _MagickMotionBlurImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;
  final double angle;

  _MagickMotionBlurImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
    this.angle,
  );
}

Future<bool> _magickMotionBlurImage(_MagickMotionBlurImageParams args) async =>
    _magickWandBindings.MagickMotionBlurImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
      args.angle,
    ).toBool();

class _MagickNegateImageParams {
  final int wandPtrAddress;
  final bool gray;

  _MagickNegateImageParams(
    this.wandPtrAddress,
    this.gray,
  );
}

Future<bool> _magickNegateImage(_MagickNegateImageParams args) async =>
    _magickWandBindings.MagickNegateImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.gray.toInt(),
    ).toBool();

class _MagickNewImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final int pixelWandPtrAddress;

  _MagickNewImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.pixelWandPtrAddress,
  );
}

Future<bool> _magickNewImage(_MagickNewImageParams args) async =>
    _magickWandBindings.MagickNewImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.width,
      args.height,
      Pointer<mwbg.PixelWand>.fromAddress(args.pixelWandPtrAddress),
    ).toBool();

Future<bool> _magickNormalizeImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickNormalizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickOilPaintImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickOilPaintImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
  );
}

Future<bool> _magickOilPaintImage(_MagickOilPaintImageParams args) async =>
    _magickWandBindings.MagickOilPaintImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
    ).toBool();

class _MagickOpaquePaintImageParams {
  final int wandPtrAddress;
  final int targetPixelWandPtrAddress;
  final int fillPixelWandPtrAddress;
  final double fuzz;
  final bool invert;

  _MagickOpaquePaintImageParams(
    this.wandPtrAddress,
    this.targetPixelWandPtrAddress,
    this.fillPixelWandPtrAddress,
    this.fuzz,
    this.invert,
  );
}

Future<bool> _magickOpaquePaintImage(
        _MagickOpaquePaintImageParams args) async =>
    _magickWandBindings.MagickOpaquePaintImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.targetPixelWandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.fillPixelWandPtrAddress),
      args.fuzz,
      args.invert.toInt(),
    ).toBool();

Future<int> _magickOptimizeImageLayers(int wandPtrAddress) async =>
    _magickWandBindings.MagickOptimizeImageLayers(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).address;

Future<bool> _magickOptimizeImageTransparency(int wandPtrAddress) async =>
    _magickWandBindings.MagickOptimizeImageTransparency(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickOrderedDitherImageParams {
  final int wandPtrAddress;
  final String thresholdMap;

  _MagickOrderedDitherImageParams(
    this.wandPtrAddress,
    this.thresholdMap,
  );
}

Future<bool> _magickOrderedDitherImage(
        _MagickOrderedDitherImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickOrderedDitherImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.thresholdMap.toNativeUtf8(allocator: arena).cast(),
      ),
    ).toBool();

class _MagickPingImageParams {
  final int wandPtrAddress;
  final String fileName;

  _MagickPingImageParams(
    this.wandPtrAddress,
    this.fileName,
  );
}

Future<bool> _magickPingImage(_MagickPingImageParams args) async => using(
      (Arena arena) => _magickWandBindings.MagickPingImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.fileName.toNativeUtf8(allocator: arena).cast(),
      ),
    ).toBool();

class _MagickPolaroidImageParams {
  final int wandPtrAddress;
  final int drawingWandPtrAddress;
  final String caption;
  final double angle;
  final PixelInterpolateMethod method;

  _MagickPolaroidImageParams(
    this.wandPtrAddress,
    this.drawingWandPtrAddress,
    this.caption,
    this.angle,
    this.method,
  );
}

Future<bool> _magickPolaroidImage(_MagickPolaroidImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickPolaroidImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        Pointer<mwbg.DrawingWand>.fromAddress(args.drawingWandPtrAddress),
        args.caption.toNativeUtf8(allocator: arena).cast(),
        args.angle,
        args.method.index,
      ),
    ).toBool();

class _MagickPosterizeImageParams {
  final int wandPtrAddress;
  final int levels;
  final DitherMethod method;

  _MagickPosterizeImageParams(
    this.wandPtrAddress,
    this.levels,
    this.method,
  );
}

Future<bool> _magickPosterizeImage(_MagickPosterizeImageParams args) async =>
    _magickWandBindings.MagickPosterizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.levels,
      args.method.index,
    ).toBool();

class _MagickPreviewImagesParams {
  final int wandPtrAddress;
  final PreviewType preview;

  _MagickPreviewImagesParams(
    this.wandPtrAddress,
    this.preview,
  );
}

Future<int> _magickPreviewImages(_MagickPreviewImagesParams args) async =>
    _magickWandBindings.MagickPreviewImages(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.preview.index,
    ).address;

class _MagickQuantizeImageParams {
  final int wandPtrAddress;
  final int numberColors;
  final ColorspaceType colorspace;
  final int treeDepth;
  final DitherMethod ditherMethod;
  final bool measureError;

  _MagickQuantizeImageParams(
    this.wandPtrAddress,
    this.numberColors,
    this.colorspace,
    this.treeDepth,
    this.ditherMethod,
    this.measureError,
  );
}

Future<bool> _magickQuantizeImage(_MagickQuantizeImageParams args) async =>
    _magickWandBindings.MagickQuantizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.numberColors,
      args.colorspace.index,
      args.treeDepth,
      args.ditherMethod.index,
      args.measureError.toInt(),
    ).toBool();

class _MagickRangeThresholdImageParams {
  final int wandPtrAddress;
  final double lowBlack;
  final double lowWhite;
  final double highWhite;
  final double highBlack;

  _MagickRangeThresholdImageParams(
    this.wandPtrAddress,
    this.lowBlack,
    this.lowWhite,
    this.highWhite,
    this.highBlack,
  );
}

Future<bool> _magickRangeThresholdImage(
        _MagickRangeThresholdImageParams args) async =>
    _magickWandBindings.MagickRangeThresholdImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.lowBlack,
      args.lowWhite,
      args.highWhite,
      args.highBlack,
    ).toBool();

class _MagickRotationalBlurImageParams {
  final int wandPtrAddress;
  final double angle;

  _MagickRotationalBlurImageParams(
    this.wandPtrAddress,
    this.angle,
  );
}

Future<bool> _magickRotationalBlurImage(
        _MagickRotationalBlurImageParams args) async =>
    _magickWandBindings.MagickRotationalBlurImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.angle,
    ).toBool();

class _MagickRaiseImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final int x;
  final int y;
  final bool raise;

  _MagickRaiseImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.x,
    this.y,
    this.raise,
  );
}

Future<bool> _magickRaiseImage(_MagickRaiseImageParams args) async =>
    _magickWandBindings.MagickRaiseImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.width,
      args.height,
      args.x,
      args.y,
      args.raise.toInt(),
    ).toBool();

class _MagickRandomThresholdImageParams {
  final int wandPtrAddress;
  final double low;
  final double high;

  _MagickRandomThresholdImageParams(
    this.wandPtrAddress,
    this.low,
    this.high,
  );
}

Future<bool> _magickRandomThresholdImage(
        _MagickRandomThresholdImageParams args) async =>
    _magickWandBindings.MagickRandomThresholdImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.low,
      args.high,
    ).toBool();

class _MagickReadImageParams {
  final int wandPtrAddress;
  final String imageFilePath;

  _MagickReadImageParams(this.wandPtrAddress, this.imageFilePath);
}

Future<bool> _magickReadImage(_MagickReadImageParams args) async => using(
      (Arena arena) => _magickWandBindings.MagickReadImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.imageFilePath.toNativeUtf8(allocator: arena).cast(),
      ),
    ).toBool();

class _MagickReadImageBlobParams {
  final int wandPtrAddress;
  final Uint8List blob;

  _MagickReadImageBlobParams(
    this.wandPtrAddress,
    this.blob,
  );
}

Future<bool> _magickReadImageBlob(_MagickReadImageBlobParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickReadImageBlob(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.blob.toUnsignedCharArrayPointer(allocator: arena).cast(),
        args.blob.length,
      ),
    ).toBool();

class _MagickRemapImageParams {
  final int wandPtrAddress;
  final int remapWandPtrAddress;
  final DitherMethod ditherMethod;

  _MagickRemapImageParams(
    this.wandPtrAddress,
    this.remapWandPtrAddress,
    this.ditherMethod,
  );
}

Future<bool> _magickRemapImage(_MagickRemapImageParams args) async =>
    _magickWandBindings.MagickRemapImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(args.remapWandPtrAddress),
      args.ditherMethod.index,
    ).toBool();

Future<bool> _magickRemoveImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickRemoveImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickResampleImageParams {
  final int wandPtrAddress;
  final double xResolution;
  final double yResolution;
  final FilterType filter;

  _MagickResampleImageParams(
    this.wandPtrAddress,
    this.xResolution,
    this.yResolution,
    this.filter,
  );
}

Future<bool> _magickResampleImage(_MagickResampleImageParams args) async =>
    _magickWandBindings.MagickResampleImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.xResolution,
      args.yResolution,
      args.filter.index,
    ).toBool();

class _MagickResetImagePageParams {
  final int wandPtrAddress;
  final String page;

  _MagickResetImagePageParams(
    this.wandPtrAddress,
    this.page,
  );
}

Future<bool> _magickResetImagePage(_MagickResetImagePageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickResetImagePage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.page.toNativeUtf8(allocator: arena).cast(),
      ),
    ).toBool();

class _MagickResizeImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;
  final FilterType filter;

  _MagickResizeImageParams(
    this.wandPtrAddress,
    this.columns,
    this.rows,
    this.filter,
  );
}

Future<bool> _magickResizeImage(_MagickResizeImageParams args) async =>
    _magickWandBindings.MagickResizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.columns,
      args.rows,
      args.filter.index,
    ).toBool();

class _MagickRollImageParams {
  final int wandPtrAddress;
  final int x;
  final int y;

  _MagickRollImageParams(
    this.wandPtrAddress,
    this.x,
    this.y,
  );
}

Future<bool> _magickRollImage(_MagickRollImageParams args) async =>
    _magickWandBindings.MagickRollImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.x,
      args.y,
    ).toBool();

class _MagickRotateImageParams {
  final int wandPtrAddress;
  final int backgroundPixelWandPtrAddress;
  final double degrees;

  _MagickRotateImageParams(
    this.wandPtrAddress,
    this.backgroundPixelWandPtrAddress,
    this.degrees,
  );
}

Future<bool> _magickRotateImage(_MagickRotateImageParams args) async =>
    _magickWandBindings.MagickRotateImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.backgroundPixelWandPtrAddress),
      args.degrees,
    ).toBool();

class _MagickSampleImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;

  _MagickSampleImageParams(
    this.wandPtrAddress,
    this.columns,
    this.rows,
  );
}

Future<bool> _magickSampleImage(_MagickSampleImageParams args) async =>
    _magickWandBindings.MagickSampleImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.columns,
      args.rows,
    ).toBool();

class _MagickScaleImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;

  _MagickScaleImageParams(
    this.wandPtrAddress,
    this.columns,
    this.rows,
  );
}

Future<bool> _magickScaleImage(_MagickScaleImageParams args) async =>
    _magickWandBindings.MagickScaleImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.columns,
      args.rows,
    ).toBool();

class _MagickSegmentImageParams {
  final int wandPtrAddress;
  final ColorspaceType colorspace;
  final bool verbose;
  final double clusterThreshold;
  final double smoothThreshold;

  _MagickSegmentImageParams(
    this.wandPtrAddress,
    this.colorspace,
    this.verbose,
    this.clusterThreshold,
    this.smoothThreshold,
  );
}

Future<bool> _magickSegmentImage(_MagickSegmentImageParams args) async =>
    _magickWandBindings.MagickSegmentImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.colorspace.index,
      args.verbose.toInt(),
      args.clusterThreshold,
      args.smoothThreshold,
    ).toBool();

class _MagickSelectiveBlurImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;
  final double threshold;

  _MagickSelectiveBlurImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
    this.threshold,
  );
}

Future<bool> _magickSelectiveBlurImage(
        _MagickSelectiveBlurImageParams args) async =>
    _magickWandBindings.MagickSelectiveBlurImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
      args.threshold,
    ).toBool();

class _MagickSeparateImageParams {
  final int wandPtrAddress;
  final ChannelType channel;

  _MagickSeparateImageParams(
    this.wandPtrAddress,
    this.channel,
  );
}

Future<bool> _magickSeparateImage(_MagickSeparateImageParams args) async =>
    _magickWandBindings.MagickSeparateImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.channel.value,
    ).toBool();

class _MagickSepiaToneImageParams {
  final int wandPtrAddress;
  final double threshold;

  _MagickSepiaToneImageParams(
    this.wandPtrAddress,
    this.threshold,
  );
}

Future<bool> _magickSepiaToneImage(_MagickSepiaToneImageParams args) async =>
    _magickWandBindings.MagickSepiaToneImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.threshold,
    ).toBool();

class _MagickSetImageParams {
  final int wandPtrAddress;
  final int setWandPtrAddress;

  _MagickSetImageParams(
    this.wandPtrAddress,
    this.setWandPtrAddress,
  );
}

Future<bool> _magickSetImage(_MagickSetImageParams args) async =>
    _magickWandBindings.MagickSetImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(args.setWandPtrAddress),
    ).toBool();

class _MagickSetImageAlphaChannelParams {
  final int wandPtrAddress;
  final AlphaChannelOption alphaType;

  _MagickSetImageAlphaChannelParams(
    this.wandPtrAddress,
    this.alphaType,
  );
}

Future<bool> _magickSetImageAlphaChannel(
        _MagickSetImageAlphaChannelParams args) async =>
    _magickWandBindings.MagickSetImageAlphaChannel(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.alphaType.index,
    ).toBool();

class _MagickSetImageChannelMaskParams {
  final int wandPtrAddress;
  final ChannelType channel;

  _MagickSetImageChannelMaskParams(
    this.wandPtrAddress,
    this.channel,
  );
}

Future<bool> _magickSetImageChannelMask(
        _MagickSetImageChannelMaskParams args) async =>
    _magickWandBindings.MagickSetImageChannelMask(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.channel.value,
    ).toBool();

class _MagickSetImageMaskParams {
  final int wandPtrAddress;
  final PixelMask type;
  final int clipMaskWandPtrAddress;

  _MagickSetImageMaskParams(
    this.wandPtrAddress,
    this.type,
    this.clipMaskWandPtrAddress,
  );
}

Future<bool> _magickSetImageMask(_MagickSetImageMaskParams args) async =>
    _magickWandBindings.MagickSetImageMask(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.type.value,
      Pointer<mwbg.MagickWand>.fromAddress(args.clipMaskWandPtrAddress),
    ).toBool();

class _MagickSetImageColorParams {
  final int wandPtrAddress;
  final int backgroundColorWandPtrAddress;

  _MagickSetImageColorParams(
    this.wandPtrAddress,
    this.backgroundColorWandPtrAddress,
  );
}

Future<bool> _magickSetImageColor(_MagickSetImageColorParams args) async =>
    _magickWandBindings.MagickSetImageColor(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.backgroundColorWandPtrAddress),
    ).toBool();

class _MagickSetImageColormapColorParams {
  final int wandPtrAddress;
  final int index;
  final int colorWandPtrAddress;

  _MagickSetImageColormapColorParams(
    this.wandPtrAddress,
    this.index,
    this.colorWandPtrAddress,
  );
}

Future<bool> _magickSetImageColormapColor(
        _MagickSetImageColormapColorParams args) async =>
    _magickWandBindings.MagickSetImageColormapColor(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.index,
      Pointer<mwbg.PixelWand>.fromAddress(args.colorWandPtrAddress),
    ).toBool();

class _MagickSetImageColorspaceParams {
  final int wandPtrAddress;
  final ColorspaceType colorspace;

  _MagickSetImageColorspaceParams(
    this.wandPtrAddress,
    this.colorspace,
  );
}

Future<bool> _magickSetImageColorspace(
        _MagickSetImageColorspaceParams args) async =>
    _magickWandBindings.MagickSetImageColorspace(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.colorspace.index,
    ).toBool();

class _MagickSetImageDepthParams {
  final int wandPtrAddress;
  final int depth;

  _MagickSetImageDepthParams(
    this.wandPtrAddress,
    this.depth,
  );
}

Future<bool> _magickSetImageDepth(_MagickSetImageDepthParams args) async =>
    _magickWandBindings.MagickSetImageDepth(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.depth,
    ).toBool();

class _MagickSetImageExtentParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;

  _MagickSetImageExtentParams(
    this.wandPtrAddress,
    this.columns,
    this.rows,
  );
}

Future<bool> _magickSetImageExtent(_MagickSetImageExtentParams args) async =>
    _magickWandBindings.MagickSetImageExtent(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.columns,
      args.rows,
    ).toBool();

class _MagickSetImageMatteParams {
  final int wandPtrAddress;
  final bool matte;

  _MagickSetImageMatteParams(
    this.wandPtrAddress,
    this.matte,
  );
}

Future<bool> _magickSetImageMatte(_MagickSetImageMatteParams args) async =>
    _magickWandBindings.MagickSetImageMatte(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.matte.toInt(),
    ).toBool();

class _MagickSetImageAlphaParams {
  final int wandPtrAddress;
  final double alpha;

  _MagickSetImageAlphaParams(
    this.wandPtrAddress,
    this.alpha,
  );
}

Future<bool> _magickSetImageAlpha(_MagickSetImageAlphaParams args) async =>
    _magickWandBindings.MagickSetImageAlpha(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.alpha,
    ).toBool();

class _MagickSetImagePixelColorParams {
  final int wandPtrAddress;
  final int x;
  final int y;
  final int colorWandPtrAddress;

  _MagickSetImagePixelColorParams(
    this.wandPtrAddress,
    this.x,
    this.y,
    this.colorWandPtrAddress,
  );
}

Future<bool> _magickSetImagePixelColor(
        _MagickSetImagePixelColorParams args) async =>
    _magickWandBindings.MagickSetImagePixelColor(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.x,
      args.y,
      Pointer<mwbg.PixelWand>.fromAddress(args.colorWandPtrAddress),
    ).toBool();

class _MagickSetImageTypeParams {
  final int wandPtrAddress;
  final ImageType type;

  _MagickSetImageTypeParams(
    this.wandPtrAddress,
    this.type,
  );
}

Future<bool> _magickSetImageType(_MagickSetImageTypeParams args) async =>
    _magickWandBindings.MagickSetImageType(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.type.index,
    ).toBool();

class _MagickSetImageVirtualPixelMethodParams {
  final int wandPtrAddress;
  final VirtualPixelMethod method;

  _MagickSetImageVirtualPixelMethodParams(
    this.wandPtrAddress,
    this.method,
  );
}

Future<bool> _magickSetImageVirtualPixelMethod(
        _MagickSetImageVirtualPixelMethodParams args) async =>
    _magickWandBindings.MagickSetImageVirtualPixelMethod(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.method.index,
    ).toBool();

class _MagickShadeImageParams {
  final int wandPtrAddress;
  final bool gray;
  final double azimuth;
  final double elevation;

  _MagickShadeImageParams(
    this.wandPtrAddress,
    this.gray,
    this.azimuth,
    this.elevation,
  );
}

Future<bool> _magickShadeImage(_MagickShadeImageParams args) async =>
    _magickWandBindings.MagickShadeImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.gray.toInt(),
      args.azimuth,
      args.elevation,
    ).toBool();

class _MagickShadowImageParams {
  final int wandPtrAddress;
  final double alpha;
  final double sigma;
  final int x;
  final int y;

  _MagickShadowImageParams(
    this.wandPtrAddress,
    this.alpha,
    this.sigma,
    this.x,
    this.y,
  );
}

Future<bool> _magickShadowImage(_MagickShadowImageParams args) async =>
    _magickWandBindings.MagickShadowImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.alpha,
      args.sigma,
      args.x,
      args.y,
    ).toBool();

class _MagickSharpenImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;

  _MagickSharpenImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
  );
}

Future<bool> _magickSharpenImage(_MagickSharpenImageParams args) async =>
    _magickWandBindings.MagickSharpenImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
    ).toBool();

class _MagickShaveImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;

  _MagickShaveImageParams(
    this.wandPtrAddress,
    this.columns,
    this.rows,
  );
}

Future<bool> _magickShaveImage(_MagickShaveImageParams args) async =>
    _magickWandBindings.MagickShaveImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.columns,
      args.rows,
    ).toBool();

class _MagickShearImageParams {
  final int wandPtrAddress;
  final int backgroundPixelWandPtrAddress;
  final double xShear;
  final double yShear;

  _MagickShearImageParams(
    this.wandPtrAddress,
    this.backgroundPixelWandPtrAddress,
    this.xShear,
    this.yShear,
  );
}

Future<bool> _magickShearImage(_MagickShearImageParams args) async =>
    _magickWandBindings.MagickShearImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.backgroundPixelWandPtrAddress),
      args.xShear,
      args.yShear,
    ).toBool();

class _MagickSigmoidalContrastImageParams {
  final int wandPtrAddress;
  final bool sharpen;
  final double alpha;
  final double beta;

  _MagickSigmoidalContrastImageParams(
    this.wandPtrAddress,
    this.sharpen,
    this.alpha,
    this.beta,
  );
}

Future<bool> _magickSigmoidalContrastImage(
        _MagickSigmoidalContrastImageParams args) async =>
    _magickWandBindings.MagickSigmoidalContrastImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.sharpen.toInt(),
      args.alpha,
      args.beta,
    ).toBool();

class _MagickSketchImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;
  final double angle;

  _MagickSketchImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
    this.angle,
  );
}

Future<bool> _magickSketchImage(_MagickSketchImageParams args) async =>
    _magickWandBindings.MagickSketchImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
      args.angle,
    ).toBool();

class _MagickSmushImagesParams {
  final int wandPtrAddress;
  final bool stack;
  final int offset;

  _MagickSmushImagesParams(
    this.wandPtrAddress,
    this.stack,
    this.offset,
  );
}

Future<int> _magickSmushImages(_MagickSmushImagesParams args) async =>
    _magickWandBindings.MagickSmushImages(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.stack.toInt(),
      args.offset,
    ).address;

class _MagickSolarizeImageParams {
  final int wandPtrAddress;
  final double threshold;

  _MagickSolarizeImageParams(
    this.wandPtrAddress,
    this.threshold,
  );
}

Future<bool> _magickSolarizeImage(_MagickSolarizeImageParams args) async =>
    _magickWandBindings.MagickSolarizeImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.threshold,
    ).toBool();

class _MagickSparseColorImageParams {
  final int wandPtrAddress;
  final SparseColorMethod method;
  final Float64List arguments;

  _MagickSparseColorImageParams(
    this.wandPtrAddress,
    this.method,
    this.arguments,
  );
}

Future<bool> _magickSparseColorImage(
        _MagickSparseColorImageParams args) async =>
    using(
      (Arena arena) => _magickWandBindings.MagickSparseColorImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.method.value,
        args.arguments.length,
        args.arguments.toDoubleArrayPointer(allocator: arena).cast(),
      ),
    ).toBool();

class _MagickSpliceImageParams {
  final int wandPtrAddress;
  final int width;
  final int height;
  final int x;
  final int y;

  _MagickSpliceImageParams(
    this.wandPtrAddress,
    this.width,
    this.height,
    this.x,
    this.y,
  );
}

Future<bool> _magickSpliceImage(_MagickSpliceImageParams args) async =>
    _magickWandBindings.MagickSpliceImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.width,
      args.height,
      args.x,
      args.y,
    ).toBool();

class _MagickSpreadImageParams {
  final int wandPtrAddress;
  final PixelInterpolateMethod method;
  final double radius;

  _MagickSpreadImageParams(
    this.wandPtrAddress,
    this.method,
    this.radius,
  );
}

Future<bool> _magickSpreadImage(_MagickSpreadImageParams args) async =>
    _magickWandBindings.MagickSpreadImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.method.index,
      args.radius,
    ).toBool();

class _MagickStatisticImageParams {
  final int wandPtrAddress;
  final StatisticType type;
  final int width;
  final int height;

  _MagickStatisticImageParams(
    this.wandPtrAddress,
    this.type,
    this.width,
    this.height,
  );
}

Future<bool> _magickStatisticImage(_MagickStatisticImageParams args) async =>
    _magickWandBindings.MagickStatisticImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.type.index,
      args.width,
      args.height,
    ).toBool();

class _MagickSteganoImageParams {
  final int wandPtrAddress;
  final int watermarkWandPtrAddress;
  final int offset;

  _MagickSteganoImageParams(
    this.wandPtrAddress,
    this.watermarkWandPtrAddress,
    this.offset,
  );
}

Future<int> _magickSteganoImage(_MagickSteganoImageParams args) async =>
    _magickWandBindings.MagickSteganoImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(args.watermarkWandPtrAddress),
      args.offset,
    ).address;

class _MagickStereoImageParams {
  final int wandPtrAddress;
  final int offsetWandPtrAddress;

  _MagickStereoImageParams(
    this.wandPtrAddress,
    this.offsetWandPtrAddress,
  );
}

Future<int> _magickStereoImage(_MagickStereoImageParams args) async =>
    _magickWandBindings.MagickStereoImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(args.offsetWandPtrAddress),
    ).address;

Future<bool> _magickStripImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickStripImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickSwirlImageParams {
  final int wandPtrAddress;
  final double degrees;
  final PixelInterpolateMethod method;

  _MagickSwirlImageParams(
    this.wandPtrAddress,
    this.degrees,
    this.method,
  );
}

Future<bool> _magickSwirlImage(_MagickSwirlImageParams args) async =>
    _magickWandBindings.MagickSwirlImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.degrees,
      args.method.index,
    ).toBool();

class _MagickTextureImageParams {
  final int wandPtrAddress;
  final int textureWandPtrAddress;

  _MagickTextureImageParams(
    this.wandPtrAddress,
    this.textureWandPtrAddress,
  );
}

Future<int> _magickTextureImage(_MagickTextureImageParams args) async =>
    _magickWandBindings.MagickTextureImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.MagickWand>.fromAddress(args.textureWandPtrAddress),
    ).address;

class _MagickThresholdImageParams {
  final int wandPtrAddress;
  final double threshold;

  _MagickThresholdImageParams(
    this.wandPtrAddress,
    this.threshold,
  );
}

Future<bool> _magickThresholdImage(_MagickThresholdImageParams args) async =>
    _magickWandBindings.MagickThresholdImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.threshold,
    ).toBool();

class _MagickThresholdImageChannelParams {
  final int wandPtrAddress;
  final ChannelType channel;
  final double threshold;

  _MagickThresholdImageChannelParams(
    this.wandPtrAddress,
    this.channel,
    this.threshold,
  );
}

Future<bool> _magickThresholdImageChannel(
        _MagickThresholdImageChannelParams args) async =>
    _magickWandBindings.MagickThresholdImageChannel(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.channel.value,
      args.threshold,
    ).toBool();

class _MagickThumbnailImageParams {
  final int wandPtrAddress;
  final int columns;
  final int rows;

  _MagickThumbnailImageParams(
    this.wandPtrAddress,
    this.columns,
    this.rows,
  );
}

Future<bool> _magickThumbnailImage(_MagickThumbnailImageParams args) async =>
    _magickWandBindings.MagickThumbnailImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.columns,
      args.rows,
    ).toBool();

class _MagickTintImageParams {
  final int wandPtrAddress;
  final int tintWandPtrAddress;
  final int blendWandPtrAddress;

  _MagickTintImageParams(
    this.wandPtrAddress,
    this.tintWandPtrAddress,
    this.blendWandPtrAddress,
  );
}

Future<bool> _magickTintImage(_MagickTintImageParams args) async =>
    _magickWandBindings.MagickTintImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.tintWandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.blendWandPtrAddress),
    ).toBool();

class _MagickTransformImageColorspaceParams {
  final int wandPtrAddress;
  final ColorspaceType colorspace;

  _MagickTransformImageColorspaceParams(
    this.wandPtrAddress,
    this.colorspace,
  );
}

Future<bool> _magickTransformImageColorspace(
        _MagickTransformImageColorspaceParams args) async =>
    _magickWandBindings.MagickTransformImageColorspace(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.colorspace.index,
    ).toBool();

class _MagickTransparentPaintImageParams {
  final int wandPtrAddress;
  final int targetWandPtrAddress;
  final double alpha;
  final double fuzz;
  final bool invert;

  _MagickTransparentPaintImageParams(
    this.wandPtrAddress,
    this.targetWandPtrAddress,
    this.alpha,
    this.fuzz,
    this.invert,
  );
}

Future<bool> _magickTransparentPaintImage(
        _MagickTransparentPaintImageParams args) async =>
    _magickWandBindings.MagickTransparentPaintImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.targetWandPtrAddress),
      args.alpha,
      args.fuzz,
      args.invert.toInt(),
    ).toBool();

Future<bool> _magickTransposeImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickTransposeImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

Future<bool> _magickTransverseImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickTransverseImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickTrimImageParams {
  final int wandPtrAddress;
  final double fuzz;

  _MagickTrimImageParams(
    this.wandPtrAddress,
    this.fuzz,
  );
}

Future<bool> _magickTrimImage(_MagickTrimImageParams args) async =>
    _magickWandBindings.MagickTrimImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.fuzz,
    ).toBool();

Future<bool> _magickUniqueImageColors(int wandPtrAddress) async =>
    _magickWandBindings.MagickUniqueImageColors(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickUnsharpMaskImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;
  final double gain;
  final double threshold;

  _MagickUnsharpMaskImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
    this.gain,
    this.threshold,
  );
}

Future<bool> _magickUnsharpMaskImage(
        _MagickUnsharpMaskImageParams args) async =>
    _magickWandBindings.MagickUnsharpMaskImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
      args.gain,
      args.threshold,
    ).toBool();

class _MagickVignetteImageParams {
  final int wandPtrAddress;
  final double radius;
  final double sigma;
  final int x;
  final int y;

  _MagickVignetteImageParams(
    this.wandPtrAddress,
    this.radius,
    this.sigma,
    this.x,
    this.y,
  );
}

Future<bool> _magickVignetteImage(_MagickVignetteImageParams args) async =>
    _magickWandBindings.MagickVignetteImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.radius,
      args.sigma,
      args.x,
      args.y,
    ).toBool();

class _MagickWaveImageParams {
  final int wandPtrAddress;
  final double amplitude;
  final double waveLength;
  final PixelInterpolateMethod method;

  _MagickWaveImageParams(
    this.wandPtrAddress,
    this.amplitude,
    this.waveLength,
    this.method,
  );
}

Future<bool> _magickWaveImage(_MagickWaveImageParams args) async =>
    _magickWandBindings.MagickWaveImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.amplitude,
      args.waveLength,
      args.method.index,
    ).toBool();

class _MagickWaveletDenoiseImageParams {
  final int wandPtrAddress;
  final double threshold;
  final double softness;

  _MagickWaveletDenoiseImageParams(
    this.wandPtrAddress,
    this.threshold,
    this.softness,
  );
}

Future<bool> _magickWaveletDenoiseImage(
        _MagickWaveletDenoiseImageParams args) async =>
    _magickWandBindings.MagickWaveletDenoiseImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      args.threshold,
      args.softness,
    ).toBool();

Future<bool> _magickWhiteBalanceImage(int wandPtrAddress) async =>
    _magickWandBindings.MagickWhiteBalanceImage(
      Pointer<mwbg.MagickWand>.fromAddress(wandPtrAddress),
    ).toBool();

class _MagickWhiteThresholdImageParams {
  final int wandPtrAddress;
  final int thresholdWandPtrAddress;

  _MagickWhiteThresholdImageParams(
    this.wandPtrAddress,
    this.thresholdWandPtrAddress,
  );
}

Future<bool> _magickWhiteThresholdImage(
        _MagickWhiteThresholdImageParams args) async =>
    _magickWandBindings.MagickWhiteThresholdImage(
      Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
      Pointer<mwbg.PixelWand>.fromAddress(args.thresholdWandPtrAddress),
    ).toBool();

class _MagickWriteImageParams {
  final int wandPtrAddress;
  final String imageFilePath;

  _MagickWriteImageParams(this.wandPtrAddress, this.imageFilePath);
}

Future<bool> _magickWriteImage(_MagickWriteImageParams args) async => using(
      (Arena arena) => _magickWandBindings.MagickWriteImage(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.imageFilePath.toNativeUtf8(allocator: arena).cast(),
      ),
    ).toBool();

class _MagickWriteImagesParams {
  final int wandPtrAddress;
  final String imageFilePath;
  final bool adjoin;

  _MagickWriteImagesParams(
      this.wandPtrAddress, this.imageFilePath, this.adjoin);
}

Future<bool> _magickWriteImages(_MagickWriteImagesParams args) async => using(
      (Arena arena) => _magickWandBindings.MagickWriteImages(
        Pointer<mwbg.MagickWand>.fromAddress(args.wandPtrAddress),
        args.imageFilePath.toNativeUtf8(allocator: arena).cast(),
        args.adjoin.toInt(),
      ),
    ).toBool();
