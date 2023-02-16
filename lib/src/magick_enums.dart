// ignore_for_file: constant_identifier_names

part of 'image_magick_q8.dart';

/// Represents the type of an exception that occurred when using the ImageMagick
/// API.
enum ExceptionType {
  UndefinedException(0),
  WarningException(300),
  TypeWarning(305),
  OptionWarning(310),
  DelegateWarning(315),
  MissingDelegateWarning(320),
  CorruptImageWarning(325),
  FileOpenWarning(330),
  BlobWarning(335),
  StreamWarning(340),
  CacheWarning(345),
  CoderWarning(350),
  FilterWarning(352),
  ModuleWarning(355),
  DrawWarning(360),
  ImageWarning(365),
  WandWarning(370),
  RandomWarning(375),
  XServerWarning(380),
  MonitorWarning(385),
  RegistryWarning(390),
  ConfigureWarning(395),
  PolicyWarning(399),
  ErrorException(400),
  TypeError(405),
  OptionError(410),
  DelegateError(415),
  MissingDelegateError(420),
  CorruptImageError(425),
  FileOpenError(430),
  BlobError(435),
  StreamError(440),
  CacheError(445),
  CoderError(450),
  FilterError(452),
  ModuleError(455),
  DrawError(460),
  ImageError(465),
  WandError(470),
  RandomError(475),
  XServerError(480),
  MonitorError(485),
  RegistryError(490),
  ConfigureError(495),
  PolicyError(499),
  FatalErrorException(700),
  TypeFatalError(705),
  OptionFatalError(710),
  DelegateFatalError(715),
  MissingDelegateFatalError(720),
  CorruptImageFatalError(725),
  FileOpenFatalError(730),
  BlobFatalError(735),
  StreamFatalError(740),
  CacheFatalError(745),
  CoderFatalError(750),
  FilterFatalError(752),
  ModuleFatalError(755),
  DrawFatalError(760),
  ImageFatalError(765),
  WandFatalError(770),
  RandomFatalError(775),
  XServerFatalError(780),
  MonitorFatalError(785),
  RegistryFatalError(790),
  ConfigureFatalError(795),
  PolicyFatalError(799);

  static const ResourceLimitWarning = WarningException;

  static const ResourceLimitError = ErrorException;

  static const ResourceLimitFatalError = FatalErrorException;

  final int value;

  const ExceptionType(this.value);

  static ExceptionType fromValue(int value) =>
      ExceptionType.values.firstWhere((e) => e.value == value);
}

/// Represents a colorspace type.
enum ColorspaceType {
  UndefinedColorspace,
  CMYColorspace,
  CMYKColorspace,
  GRAYColorspace,
  HCLColorspace,
  HCLpColorspace,
  HSBColorspace,
  HSIColorspace,
  HSLColorspace,
  HSVColorspace,
  HWBColorspace,
  LabColorspace,
  LCHColorspace,
  LCHabColorspace,
  LCHuvColorspace,
  LogColorspace,
  LMSColorspace,
  LuvColorspace,
  OHTAColorspace,
  Rec601YCbCrColorspace,
  Rec709YCbCrColorspace,
  RGBColorspace,
  scRGBColorspace,
  sRGBColorspace,
  TransparentColorspace,
  xyYColorspace,
  XYZColorspace,
  YCbCrColorspace,
  YCCColorspace,
  YDbDrColorspace,
  YIQColorspace,
  YPbPrColorspace,
  YUVColorspace,
  LinearGRAYColorspace,
  JzazbzColorspace,
  DisplayP3Colorspace,
  Adobe98Colorspace,
  ProPhotoColorspace
}

/// Represents an image compression type.
enum CompressionType {
  UndefinedCompression,
  B44ACompression,
  B44Compression,
  BZipCompression,
  DXT1Compression,
  DXT3Compression,
  DXT5Compression,
  FaxCompression,
  Group4Compression,
  JBIG1Compression,
  JBIG2Compression,
  JPEG2000Compression,
  JPEGCompression,
  LosslessJPEGCompression,
  LZMACompression,
  LZWCompression,
  NoCompression,
  PizCompression,
  Pxr24Compression,
  RLECompression,
  ZipCompression,
  ZipSCompression,
  ZstdCompression,
  WebPCompression,
  DWAACompression,
  DWABCompression,
  BC7Compression
}

/// Represents a gravity type.
enum GravityType {
  UndefinedGravity(0),
  NorthWestGravity(1),
  NorthGravity(2),
  NorthEastGravity(3),
  WestGravity(4),
  CenterGravity(5),
  EastGravity(6),
  SouthWestGravity(7),
  SouthGravity(8),
  SouthEastGravity(9);

  static const ForgetGravity = UndefinedGravity;

  final int value;

  const GravityType(this.value);

  static GravityType fromValue(int value) =>
      GravityType.values.firstWhere((e) => e.value == value);
}

/// Represents an interlace type.
enum InterlaceType {
  UndefinedInterlace,
  NoInterlace,
  LineInterlace,
  PlaneInterlace,
  PartitionInterlace,
  GIFInterlace,
  JPEGInterlace,
  PNGInterlace;
}

/// Represents a pixel interpolation method.
enum PixelInterpolateMethod {
  UndefinedInterpolatePixel,
  /* Average 4 nearest neighbours */
  AverageInterpolatePixel,
  /* Average 9 nearest neighbours */
  Average9InterpolatePixel,
  /* Average 16 nearest neighbours */
  Average16InterpolatePixel,
  /* Just return background color */
  BackgroundInterpolatePixel,
  /* Triangular filter interpolation */
  BilinearInterpolatePixel,
  /* blend of nearest 1, 2 or 4 pixels */
  BlendInterpolatePixel,
  /* Catmull-Rom interpolation */
  CatromInterpolatePixel,
  /* Integer (floor) interpolation */
  IntegerInterpolatePixel,
  /* Triangular Mesh interpolation */
  MeshInterpolatePixel,
  /* Nearest Neighbour Only */
  NearestInterpolatePixel,
  /* Cubic Spline (blurred) interpolation */
  SplineInterpolatePixel
}

/// Represents an orientation type.
enum OrientationType {
  UndefinedOrientation,
  TopLeftOrientation,
  TopRightOrientation,
  BottomRightOrientation,
  BottomLeftOrientation,
  LeftTopOrientation,
  RightTopOrientation,
  RightBottomOrientation,
  LeftBottomOrientation
}

/// Represents a resource type.
enum ResourceType {
  UndefinedResource,
  AreaResource,
  DiskResource,
  FileResource,
  HeightResource,
  MapResource,
  MemoryResource,
  ThreadResource,
  ThrottleResource,
  TimeResource,
  WidthResource,
  ListLengthResource
}

/// Represents an image type.
enum ImageType {
  UndefinedType,
  BilevelType,
  GrayscaleType,
  GrayscaleAlphaType,
  PaletteType,
  PaletteAlphaType,
  TrueColorType,
  TrueColorAlphaType,
  ColorSeparationType,
  ColorSeparationAlphaType,
  OptimizeType,
  PaletteBilevelAlphaType
}

/// Represents a noise type.
enum NoiseType {
  UndefinedNoise,
  UniformNoise,
  GaussianNoise,
  MultiplicativeGaussianNoise,
  ImpulseNoise,
  LaplacianNoise,
  PoissonNoise,
  RandomNoise
}

/// Represents an auto-threshold method.
enum AutoThresholdMethod {
  UndefinedThresholdMethod,
  KapurThresholdMethod,
  OTSUThresholdMethod,
  TriangleThresholdMethod
}

/// Represents a composite operator.
enum CompositeOperator {
  UndefinedCompositeOp,
  AlphaCompositeOp,
  AtopCompositeOp,
  BlendCompositeOp,
  BlurCompositeOp,
  BumpmapCompositeOp,
  ChangeMaskCompositeOp,
  ClearCompositeOp,
  ColorBurnCompositeOp,
  ColorDodgeCompositeOp,
  ColorizeCompositeOp,
  CopyBlackCompositeOp,
  CopyBlueCompositeOp,
  CopyCompositeOp,
  CopyCyanCompositeOp,
  CopyGreenCompositeOp,
  CopyMagentaCompositeOp,
  CopyAlphaCompositeOp,
  CopyRedCompositeOp,
  CopyYellowCompositeOp,
  DarkenCompositeOp,
  DarkenIntensityCompositeOp,
  DifferenceCompositeOp,
  DisplaceCompositeOp,
  DissolveCompositeOp,
  DistortCompositeOp,
  DivideDstCompositeOp,
  DivideSrcCompositeOp,
  DstAtopCompositeOp,
  DstCompositeOp,
  DstInCompositeOp,
  DstOutCompositeOp,
  DstOverCompositeOp,
  ExclusionCompositeOp,
  HardLightCompositeOp,
  HardMixCompositeOp,
  HueCompositeOp,
  InCompositeOp,
  IntensityCompositeOp,
  LightenCompositeOp,
  LightenIntensityCompositeOp,
  LinearBurnCompositeOp,
  LinearDodgeCompositeOp,
  LinearLightCompositeOp,
  LuminizeCompositeOp,
  MathematicsCompositeOp,
  MinusDstCompositeOp,
  MinusSrcCompositeOp,
  ModulateCompositeOp,
  ModulusAddCompositeOp,
  ModulusSubtractCompositeOp,
  MultiplyCompositeOp,
  NoCompositeOp,
  OutCompositeOp,
  OverCompositeOp,
  OverlayCompositeOp,
  PegtopLightCompositeOp,
  PinLightCompositeOp,
  PlusCompositeOp,
  ReplaceCompositeOp,
  SaturateCompositeOp,
  ScreenCompositeOp,
  SoftLightCompositeOp,
  SrcAtopCompositeOp,
  SrcCompositeOp,
  SrcInCompositeOp,
  SrcOutCompositeOp,
  SrcOverCompositeOp,
  ThresholdCompositeOp,
  VividLightCompositeOp,
  XorCompositeOp,
  StereoCompositeOp,
  FreezeCompositeOp,
  InterpolateCompositeOp,
  NegateCompositeOp,
  ReflectCompositeOp,
  SoftBurnCompositeOp,
  SoftDodgeCompositeOp,
  StampCompositeOp,
  RMSECompositeOp,
  SaliencyBlendCompositeOp,
  SeamlessBlendCompositeOp
}

/// Represents a layer method.
enum LayerMethod {
  UndefinedLayer,
  CoalesceLayer,
  CompareAnyLayer,
  CompareClearLayer,
  CompareOverlayLayer,
  DisposeLayer,
  OptimizeLayer,
  OptimizeImageLayer,
  OptimizePlusLayer,
  OptimizeTransLayer,
  RemoveDupsLayer,
  RemoveZeroLayer,
  CompositeLayer,
  MergeLayer,
  FlattenLayer,
  MosaicLayer,
  TrimBoundsLayer
}

/// Represents a metric type.
enum MetricType {
  UndefinedErrorMetric,
  AbsoluteErrorMetric,
  FuzzErrorMetric,
  MeanAbsoluteErrorMetric,
  MeanErrorPerPixelErrorMetric,
  MeanSquaredErrorMetric,
  NormalizedCrossCorrelationErrorMetric,
  PeakAbsoluteErrorMetric,
  PeakSignalToNoiseRatioErrorMetric,
  PerceptualHashErrorMetric,
  RootMeanSquaredErrorMetric,
  StructuralSimilarityErrorMetric,
  StructuralDissimilarityErrorMetric
}

/// Represents a complex operator.
enum ComplexOperator {
  UndefinedComplexOperator,
  AddComplexOperator,
  ConjugateComplexOperator,
  DivideComplexOperator,
  MagnitudePhaseComplexOperator,
  MultiplyComplexOperator,
  RealImaginaryComplexOperator,
  SubtractComplexOperator
}

/// Represents a kernel type.
enum KernelInfoType {
  /* equivalent to UnityKernel */
  UndefinedKernel,
  /* The no-op or 'original image' kernel */
  UnityKernel,
  /* Convolution Kernels, Gaussian Based */
  GaussianKernel,
  DoGKernel,
  LoGKernel,
  BlurKernel,
  CometKernel,
  BinomialKernel,
  /* Convolution Kernels, by Name */
  LaplacianKernel,
  SobelKernel,
  FreiChenKernel,
  RobertsKernel,
  PrewittKernel,
  CompassKernel,
  KirschKernel,
  /* Shape Kernels */
  DiamondKernel,
  SquareKernel,
  RectangleKernel,
  OctagonKernel,
  DiskKernel,
  PlusKernel,
  CrossKernel,
  RingKernel,
  /* Hit And Miss Kernels */
  PeaksKernel,
  EdgesKernel,
  CornersKernel,
  DiagonalsKernel,
  LineEndsKernel,
  LineJunctionsKernel,
  RidgesKernel,
  ConvexHullKernel,
  ThinSEKernel,
  SkeletonKernel,
  /* Distance Measuring Kernels */
  ChebyshevKernel,
  ManhattanKernel,
  OctagonalKernel,
  EuclideanKernel,
  /* User Specified Kernel Array */
  UserDefinedKernel
}

/// Represents a storage type.
enum _StorageType {
  UndefinedPixel,
  CharPixel,
  DoublePixel,
  FloatPixel,
  LongPixel,
  LongLongPixel,
  QuantumPixel,
  ShortPixel
}

/// Represent an image distortion method.
enum DistortMethod {
  UndefinedDistortion,
  AffineDistortion,
  AffineProjectionDistortion,
  ScaleRotateTranslateDistortion,
  PerspectiveDistortion,
  PerspectiveProjectionDistortion,
  BilinearForwardDistortion,
  BilinearReverseDistortion,
  PolynomialDistortion,
  ArcDistortion,
  PolarDistortion,
  DePolarDistortion,
  Cylinder2PlaneDistortion,
  Plane2CylinderDistortion,
  BarrelDistortion,
  BarrelInverseDistortion,
  ShepardsDistortion,
  ResizeDistortion,
  SentinelDistortion,
  RigidAffineDistortion;

  static const DistortMethod BilinearDistortion = BilinearForwardDistortion;
}

/// Represents an evaluation operator.
enum MagickEvaluateOperator {
  UndefinedEvaluateOperator,
  AbsEvaluateOperator,
  AddEvaluateOperator,
  AddModulusEvaluateOperator,
  AndEvaluateOperator,
  CosineEvaluateOperator,
  DivideEvaluateOperator,
  ExponentialEvaluateOperator,
  GaussianNoiseEvaluateOperator,
  ImpulseNoiseEvaluateOperator,
  LaplacianNoiseEvaluateOperator,
  LeftShiftEvaluateOperator,
  LogEvaluateOperator,
  MaxEvaluateOperator,
  MeanEvaluateOperator,
  MedianEvaluateOperator,
  MinEvaluateOperator,
  MultiplicativeNoiseEvaluateOperator,
  MultiplyEvaluateOperator,
  OrEvaluateOperator,
  PoissonNoiseEvaluateOperator,
  PowEvaluateOperator,
  RightShiftEvaluateOperator,
  RootMeanSquareEvaluateOperator,
  SetEvaluateOperator,
  SineEvaluateOperator,
  SubtractEvaluateOperator,
  SumEvaluateOperator,
  ThresholdBlackEvaluateOperator,
  ThresholdEvaluateOperator,
  ThresholdWhiteEvaluateOperator,
  UniformNoiseEvaluateOperator,
  XorEvaluateOperator,
  InverseLogEvaluateOperator
}

/// Represents a magick function
enum MagickFunctionType {
  UndefinedFunction,
  ArcsinFunction,
  ArctanFunction,
  PolynomialFunction,
  SinusoidFunction
}

/// Represents a pixel mask.
enum PixelMask {
  UndefinedPixelMask(0x000000),
  ReadPixelMask(0x000001),
  WritePixelMask(0x000002),
  CompositePixelMask(0x000004);

  final int value;

  const PixelMask(this.value);

  static PixelMask fromValue(int value) =>
      PixelMask.values.firstWhere((e) => e.value == value);
}

/// Represents an image dispose type
enum DisposeType {
  UndefinedDispose(0),
  NoneDispose(1),
  BackgroundDispose(2),
  PreviousDispose(3);

  static const DisposeType UnrecognizedDispose = UndefinedDispose;

  final int value;

  static DisposeType fromValue(int value) =>
      DisposeType.values.firstWhere((e) => e.value == value);

  const DisposeType(this.value);
}

/// Represents an endiannness type.
enum EndianType {
  UndefinedEndian,
  LSBEndian,
  MSBEndian,
}

/// Represents a rendering intent.
enum RenderingIntent {
  UndefinedIntent,
  SaturationIntent,
  PerceptualIntent,
  AbsoluteIntent,
  RelativeIntent,
}

/// Represents a resolution type.
enum ResolutionType {
  UndefinedResolution,
  PixelsPerInchResolution,
  PixelsPerCentimeterResolution,
}

/// Represents a virtual pixel method.
enum VirtualPixelMethod {
  UndefinedVirtualPixelMethod,
  BackgroundVirtualPixelMethod,
  DitherVirtualPixelMethod,
  EdgeVirtualPixelMethod,
  MirrorVirtualPixelMethod,
  RandomVirtualPixelMethod,
  TileVirtualPixelMethod,
  TransparentVirtualPixelMethod,
  MaskVirtualPixelMethod,
  BlackVirtualPixelMethod,
  GrayVirtualPixelMethod,
  WhiteVirtualPixelMethod,
  HorizontalTileVirtualPixelMethod,
  VerticalTileVirtualPixelMethod,
  HorizontalTileEdgeVirtualPixelMethod,
  VerticalTileEdgeVirtualPixelMethod,
  CheckerTileVirtualPixelMethod,
}

/// Represents a montage mode.
enum MontageMode {
  UndefinedMode,
  FrameMode,
  UnframeMode,
  ConcatenateMode,
}

/// Represents a morphology method.
enum MorphologyMethod {
  UndefinedMorphology,
  ConvolveMorphology,
  CorrelateMorphology,
  ErodeMorphology,
  DilateMorphology,
  ErodeIntensityMorphology,
  DilateIntensityMorphology,
  IterativeDistanceMorphology,
  OpenMorphology,
  CloseMorphology,
  OpenIntensityMorphology,
  CloseIntensityMorphology,
  SmoothMorphology,
  EdgeInMorphology,
  EdgeOutMorphology,
  EdgeMorphology,
  TopHatMorphology,
  BottomHatMorphology,
  HitAndMissMorphology,
  ThinningMorphology,
  ThickenMorphology,
  DistanceMorphology,
  VoronoiMorphology,
}

/// Represents a dither method.
enum DitherMethod {
  UndefinedDitherMethod,
  NoDitherMethod,
  RiemersmaDitherMethod,
  FloydSteinbergDitherMethod,
}

/// Represents a preview type.
enum PreviewType {
  UndefinedPreview,
  RotatePreview,
  ShearPreview,
  RollPreview,
  HuePreview,
  SaturationPreview,
  BrightnessPreview,
  GammaPreview,
  SpiffPreview,
  DullPreview,
  GrayscalePreview,
  QuantizePreview,
  DespecklePreview,
  ReduceNoisePreview,
  AddNoisePreview,
  SharpenPreview,
  BlurPreview,
  ThresholdPreview,
  EdgeDetectPreview,
  SpreadPreview,
  SolarizePreview,
  ShadePreview,
  RaisePreview,
  SegmentPreview,
  SwirlPreview,
  ImplodePreview,
  WavePreview,
  OilPaintPreview,
  CharcoalDrawingPreview,
  JPEGPreview,
}

/// Represents a filter type.
enum FilterType {
  UndefinedFilter,
  PointFilter,
  BoxFilter,
  TriangleFilter,
  HermiteFilter,
  HannFilter,
  HammingFilter,
  BlackmanFilter,
  GaussianFilter,
  QuadraticFilter,
  CubicFilter,
  CatromFilter,
  MitchellFilter,
  JincFilter,
  SincFilter,
  SincFastFilter,
  KaiserFilter,
  WelchFilter,
  ParzenFilter,
  BohmanFilter,
  BartlettFilter,
  LagrangeFilter,
  LanczosFilter,
  LanczosSharpFilter,
  Lanczos2Filter,
  Lanczos2SharpFilter,
  RobidouxFilter,
  RobidouxSharpFilter,
  CosineFilter,
  SplineFilter,
  LanczosRadiusFilter,
  CubicSplineFilter,
  SentinelFilter, /* a count of all the filters, not a real filter */
}

/// Represents a channel type.
enum ChannelType {
  UndefinedChannel(0x0000),
  RedChannel(0x0001),
  GrayChannel(0x0001),
  CyanChannel(0x0001),
  LChannel(0x0001),
  GreenChannel(0x0002),
  MagentaChannel(0x0002),
  aChannel(0x0002),
  BlueChannel(0x0004),
  bChannel(0x0002),
  YellowChannel(0x0004),
  BlackChannel(0x0008),
  AlphaChannel(0x0010),
  OpacityChannel(0x0010),
  IndexChannel(0x0020),
  ReadMaskChannel(0x0040),
  WriteMaskChannel(0x0080),
  MetaChannel(0x0100),
  CompositeMaskChannel(0x0200),
  CompositeChannels(0x001F),
  AllChannels(0x7ffffff),
  TrueAlphaChannel(0x0100),
  RGBChannels(0x0200),
  GrayChannels(0x0400),
  SyncChannels(0x20000);

  static const DefaultChannels = AllChannels;

  final int value;

  const ChannelType(this.value);

  static ChannelType fromValue(int value) =>
      ChannelType.values.firstWhere((e) => e.value == value);
}

/// Represents an alpha channel type.
enum AlphaChannelOption {
  UndefinedAlphaChannel,
  ActivateAlphaChannel,
  AssociateAlphaChannel,
  BackgroundAlphaChannel,
  CopyAlphaChannel,
  DeactivateAlphaChannel,
  DiscreteAlphaChannel,
  DisassociateAlphaChannel,
  ExtractAlphaChannel,
  OffAlphaChannel,
  OnAlphaChannel,
  OpaqueAlphaChannel,
  RemoveAlphaChannel,
  SetAlphaChannel,
  ShapeAlphaChannel,
  TransparentAlphaChannel,
}

/// Represents a sparse color method.
enum SparseColorMethod {
  UndefinedColorInterpolate(0),
  BarycentricColorInterpolate(1),
  BilinearColorInterpolate(7),
  PolynomialColorInterpolate(8),
  ShepardsColorInterpolate(16),
  VoronoiColorInterpolate(18),
  InverseColorInterpolate(19),
  ManhattanColorInterpolate(20);

  final int value;

  const SparseColorMethod(this.value);

  static SparseColorMethod fromValue(int value) =>
      SparseColorMethod.values.firstWhere((e) => e.value == value);
}

/// Represents a statistic type.
enum StatisticType {
  UndefinedStatistic,
  GradientStatistic,
  MaximumStatistic,
  MeanStatistic,
  MedianStatistic,
  MinimumStatistic,
  ModeStatistic,
  NonpeakStatistic,
  RootMeanSquareStatistic,
  StandardDeviationStatistic,
  ContrastStatistic,
}

/// Represents a class type.
enum ClassType {
  UndefinedClass,
  DirectClass,
  PseudoClass,
}

/// Represents a pixel trait.
enum PixelTrait {
  UndefinedPixelTrait(0),
  CopyPixelTrait(1),
  UpdatePixelTrait(2),
  BlendPixelTrait(0);

  final int value;

  const PixelTrait(this.value);

  static PixelTrait fromValue(int value) =>
      PixelTrait.values.firstWhere((e) => e.value == value);
}

/// Represents a paint method.
enum PaintMethod {
  UndefinedMethod,
  PointMethod,
  ReplaceMethod,
  FloodfillMethod,
  FillToBorderMethod,
  ResetMethod,
}

/// Represents a fill rule.
enum FillRule {
  UndefinedRule,
  EvenOddRule,
  NonZeroRule,
}

/// Represents a clip path unit.
enum ClipPathUnits {
  UndefinedPathUnits,
  UserSpace,
  UserSpaceOnUse,
  ObjectBoundingBox,
}

/// Represents a stretch type.
enum StretchType {
  UndefinedStretch,
  NormalStretch,
  UltraCondensedStretch,
  ExtraCondensedStretch,
  CondensedStretch,
  SemiCondensedStretch,
  SemiExpandedStretch,
  ExpandedStretch,
  ExtraExpandedStretch,
  UltraExpandedStretch,
  AnyStretch,
}

/// Represents a style type.
enum StyleType {
  UndefinedStyle,
  NormalStyle,
  ItalicStyle,
  ObliqueStyle,
  AnyStyle,
  BoldStyle, /* deprecated */
}

/// Represents a line cap.
enum LineCap {
  UndefinedCap,
  ButtCap,
  RoundCap,
  SquareCap,
}

/// Represents a line join.
enum LineJoin {
  UndefinedJoin,
  MiterJoin,
  RoundJoin,
  BevelJoin,
}

/// Represents an align type.
enum AlignType {
  UndefinedAlign,
  LeftAlign,
  CenterAlign,
  RightAlign,
}

/// Represents a text decoration
enum DecorationType {
  UndefinedDecoration,
  NoDecoration,
  UnderlineDecoration,
  OverlineDecoration,
  LineThroughDecoration,
}

/// Represents a text direction.
enum DirectionType {
  UndefinedDirection,
  RightToLeftDirection,
  LeftToRightDirection,
}
