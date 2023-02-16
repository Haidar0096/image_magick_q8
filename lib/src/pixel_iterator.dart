part of 'image_magick_q8.dart';

/// A pixel iterator that can be used to iterate over the pixels of an image.
///
/// Create a new pixel iterator using [newPixelIterator] or
/// [newPixelRegionIterator].
///
/// When done with a PixelIterator, destroy it with [destroyPixelIterator].
class PixelIterator {
  final Pointer<mwbg.PixelIterator> _iteratorPtr;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PixelIterator &&
          runtimeType == other.runtimeType &&
          _iteratorPtr == other._iteratorPtr;

  @override
  int get hashCode => _iteratorPtr.hashCode;

  const PixelIterator._(this._iteratorPtr);

  /// Clear resources associated with a PixelIterator.
  void clearPixelIterator() =>
      _magickWandBindings.ClearPixelIterator(_iteratorPtr);

  /// Make an exact copy of the specified iterator.
  PixelIterator clonePixelIterator() =>
      PixelIterator._(_magickWandBindings.ClonePixelIterator(_iteratorPtr));

  /// DestroyPixelIterator() deallocates resources associated with a
  /// PixelIterator.
  /// <strong> Never use a pixel iterator after it has been destroyed. </strong>
  void destroyPixelIterator() =>
      _magickWandBindings.DestroyPixelIterator(_iteratorPtr);

  /// Returns true if the iterator is verified as a pixel iterator.
  bool isPixelIterator() =>
      _magickWandBindings.IsPixelIterator(_iteratorPtr).toBool();

  static PixelIterator? _fromAddress(int address) => address == 0
      ? null
      : PixelIterator._(Pointer<mwbg.PixelIterator>.fromAddress(address));

  /// Returns a new pixel iterator.
  ///
  /// {@template pixel_iterator.don't_forget_to_destroy_the_returned_iterator}
  /// Don't forget to destroy the returned iterator using [destroyPixelIterator]
  /// when you are done with it.
  /// {@endtemplate}
  static PixelIterator? newPixelIterator(MagickWand wand) =>
      PixelIterator._fromAddress(
        _magickWandBindings.NewPixelIterator(wand._wandPtr).address,
      );

  /// Clear any exceptions associated with the iterator.
  bool pixelClearIteratorException() =>
      _magickWandBindings.PixelClearIteratorException(_iteratorPtr).toBool();

  /// Returns a new pixel iterator for a region of the image.
  /// {@macro pixel_iterator.don't_forget_to_destroy_the_returned_iterator}
  /// - [x] The x offset of the region.
  /// - [y] The y offset of the region.
  /// - [width] The width of the region.
  /// - [height] The height of the region.
  static PixelIterator? newPixelRegionIterator({
    required MagickWand wand,
    required int x,
    required int y,
    required int width,
    required int height,
  }) =>
      PixelIterator._fromAddress(
        _magickWandBindings.NewPixelRegionIterator(
          wand._wandPtr,
          x,
          y,
          width,
          height,
        ).address,
      );

  /// Returns the current row as an array of pixel wands from the pixel
  /// iterator.
  ///
  /// {@template pixel_iterator.don't_forget_to_destroy_returned_pixel_wands}
  /// Don't forget to destroy each of the returned pixel wands using
  /// [destroyPixelWand] when you are done with them.
  /// {@endtemplate}
  ///
  /// {@template pixel_iterator.runs_in_different_isolate}
  /// This method runs in a different isolate than the main isolate.
  /// {@endtemplate}
  Future<List<PixelWand>> pixelGetCurrentIteratorRow() async {
    List<int> pixelWandsAddresses = await _magickCompute(
      _pixelGetCurrentIteratorRow,
      _iteratorPtr.address,
    );
    List<PixelWand> pixelWands = [];
    for (int i = 0; i < pixelWandsAddresses.length; i++) {
      PixelWand? pixelWand = PixelWand._fromAddress(pixelWandsAddresses[i]);
      pixelWands.add(pixelWand!);
    }
    return pixelWands;
  }

  /// Returns the severity, reason, and description of any error that occurs
  /// when using other methods in this API.
  PixelGetIteratorExceptionResult pixelGetIteratorException() => using(
        (Arena arena) {
          Pointer<Int32> severityPtr = arena();
          Pointer<Char> descriptionPtr =
              _magickWandBindings.PixelGetIteratorException(
                  _iteratorPtr, severityPtr);
          final PixelGetIteratorExceptionResult result =
              PixelGetIteratorExceptionResult(
            ExceptionType.fromValue(severityPtr.value),
            descriptionPtr.toNullableString()!,
          );
          _magickRelinquishMemory(descriptionPtr.cast());
          return result;
        },
      );

  /// Returns the exception type associated with the iterator.
  ExceptionType pixelGetIteratorExceptionType() => ExceptionType.fromValue(
        _magickWandBindings.PixelGetIteratorExceptionType(_iteratorPtr),
      );

  /// Returns the current pixel iterator row.
  int pixelGetIteratorRow() =>
      _magickWandBindings.PixelGetIteratorRow(_iteratorPtr);

  /// Returns the next row as an array of pixel wands from the pixel iterator.
  ///
  /// {@macro pixel_iterator.don't_forget_to_destroy_returned_pixel_wands}
  ///
  /// {@macro pixel_iterator.runs_in_different_isolate}
  Future<List<PixelWand>> pixelGetNextIteratorRow() async {
    List<int> pixelWandsAddresses = await _magickCompute(
      _pixelGetNextIteratorRow,
      _iteratorPtr.address,
    );
    List<PixelWand> pixelWands = [];
    for (int i = 0; i < pixelWandsAddresses.length; i++) {
      PixelWand? pixelWand = PixelWand._fromAddress(pixelWandsAddresses[i]);
      pixelWands.add(pixelWand!);
    }
    return pixelWands;
  }

  /// Returns the previous row as an array of pixel wands from the pixel
  /// iterator.
  ///
  /// {@macro pixel_iterator.don't_forget_to_destroy_returned_pixel_wands}
  ///
  /// {@macro pixel_iterator.runs_in_different_isolate}
  Future<List<PixelWand>> pixelGetPreviousIteratorRow() async {
    List<int> pixelWandsAddresses = await _magickCompute(
      _pixelGetPreviousIteratorRow,
      _iteratorPtr.address,
    );
    List<PixelWand> pixelWands = [];
    for (int i = 0; i < pixelWandsAddresses.length; i++) {
      PixelWand? pixelWand = PixelWand._fromAddress(pixelWandsAddresses[i]);
      pixelWands.add(pixelWand!);
    }
    return pixelWands;
  }

  /// Resets the pixel iterator. Use it in conjunction with
  /// [pixelGetNextIteratorRow] to iterate over all the pixels in a pixel
  /// container.
  void pixelResetIterator() =>
      _magickWandBindings.PixelResetIterator(_iteratorPtr);

  /// Sets the pixel iterator to the first pixel row.
  void pixelSetFirstIteratorRow() =>
      _magickWandBindings.PixelSetFirstIteratorRow(_iteratorPtr);

  /// Set the pixel iterator row.
  /// - [row] the row.
  bool pixelSetIteratorRow(int row) =>
      _magickWandBindings.PixelSetIteratorRow(_iteratorPtr, row).toBool();

  /// Sets the pixel iterator to the last pixel row.
  void pixelSetLastIteratorRow() =>
      _magickWandBindings.PixelSetLastIteratorRow(_iteratorPtr);

  /// Syncs the pixel iterator.
  ///
  /// {@template pixel_iterator.runs_in_different_isolate}
  Future<bool> pixelSyncIterator() async =>
      await _magickCompute(_pixelSyncIterator, _iteratorPtr.address);
}
