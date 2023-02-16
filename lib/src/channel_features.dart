part of 'image_magick_q8.dart';

/// Represents features of a channel in an image.
class ChannelFeatures {
  final Float64List? angularSecondMoment;
  final Float64List? contrast;
  final Float64List? correlation;
  final Float64List? varianceSumOfSquares;
  final Float64List? inverseDifferenceMoment;
  final Float64List? sumAverage;
  final Float64List? sumVariance;
  final Float64List? sumEntropy;
  final Float64List? entropy;
  final Float64List? differenceVariance;
  final Float64List? differenceEntropy;
  final Float64List? measureOfCorrelation1;
  final Float64List? measureOfCorrelation2;
  final Float64List? maximumCorrelationCoefficient;

  ChannelFeatures({
    required this.angularSecondMoment,
    required this.contrast,
    required this.correlation,
    required this.varianceSumOfSquares,
    required this.inverseDifferenceMoment,
    required this.sumAverage,
    required this.sumVariance,
    required this.sumEntropy,
    required this.entropy,
    required this.differenceVariance,
    required this.differenceEntropy,
    required this.measureOfCorrelation1,
    required this.measureOfCorrelation2,
    required this.maximumCorrelationCoefficient,
  });

  static ChannelFeatures? _fromChannelFeaturesStructPointer(
          Pointer<mwbg.ChannelFeatures> ptr) =>
      ptr == nullptr
          ? null
          : ChannelFeatures(
              angularSecondMoment:
                  ptr.ref.angular_second_moment.toFloat64List(4),
              contrast: ptr.ref.contrast.toFloat64List(4),
              correlation: ptr.ref.correlation.toFloat64List(4),
              varianceSumOfSquares:
                  ptr.ref.variance_sum_of_squares.toFloat64List(4),
              inverseDifferenceMoment:
                  ptr.ref.inverse_difference_moment.toFloat64List(4),
              sumAverage: ptr.ref.sum_average.toFloat64List(4),
              sumVariance: ptr.ref.sum_variance.toFloat64List(4),
              sumEntropy: ptr.ref.sum_entropy.toFloat64List(4),
              entropy: ptr.ref.entropy.toFloat64List(4),
              differenceVariance: ptr.ref.difference_variance.toFloat64List(4),
              differenceEntropy: ptr.ref.difference_entropy.toFloat64List(4),
              measureOfCorrelation1:
                  ptr.ref.measure_of_correlation_1.toFloat64List(4),
              measureOfCorrelation2:
                  ptr.ref.measure_of_correlation_2.toFloat64List(4),
              maximumCorrelationCoefficient:
                  ptr.ref.maximum_correlation_coefficient.toFloat64List(4),
            );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelFeatures &&
          runtimeType == other.runtimeType &&
          angularSecondMoment == other.angularSecondMoment &&
          contrast == other.contrast &&
          correlation == other.correlation &&
          varianceSumOfSquares == other.varianceSumOfSquares &&
          inverseDifferenceMoment == other.inverseDifferenceMoment &&
          sumAverage == other.sumAverage &&
          sumVariance == other.sumVariance &&
          sumEntropy == other.sumEntropy &&
          entropy == other.entropy &&
          differenceVariance == other.differenceVariance &&
          differenceEntropy == other.differenceEntropy &&
          measureOfCorrelation1 == other.measureOfCorrelation1 &&
          measureOfCorrelation2 == other.measureOfCorrelation2 &&
          maximumCorrelationCoefficient == other.maximumCorrelationCoefficient;

  @override
  int get hashCode =>
      angularSecondMoment.hashCode ^
      contrast.hashCode ^
      correlation.hashCode ^
      varianceSumOfSquares.hashCode ^
      inverseDifferenceMoment.hashCode ^
      sumAverage.hashCode ^
      sumVariance.hashCode ^
      sumEntropy.hashCode ^
      entropy.hashCode ^
      differenceVariance.hashCode ^
      differenceEntropy.hashCode ^
      measureOfCorrelation1.hashCode ^
      measureOfCorrelation2.hashCode ^
      maximumCorrelationCoefficient.hashCode;

  @override
  String toString() =>
      'ChannelFeatures{angularSecondMoment: $angularSecondMoment, contrast: $contrast, correlation: $correlation, varianceSumOfSquares: $varianceSumOfSquares, inverseDifferenceMoment: $inverseDifferenceMoment, sumAverage: $sumAverage, sumVariance: $sumVariance, sumEntropy: $sumEntropy, entropy: $entropy, differenceVariance: $differenceVariance, differenceEntropy: $differenceEntropy, measureOfCorrelation1: $measureOfCorrelation1, measureOfCorrelation2: $measureOfCorrelation2, maximumCorrelationCoefficient: $maximumCorrelationCoefficient}';
}
