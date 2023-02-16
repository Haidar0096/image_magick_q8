part of 'image_magick_q8.dart';

/// Represents a result to a call to [PixelIterator.pixelGetIteratorException].
class PixelGetIteratorExceptionResult {
  /// The severity of the exception.
  final ExceptionType severity;

  /// The description of the exception.
  final String description;

  const PixelGetIteratorExceptionResult(this.severity, this.description);

  @override
  String toString() =>
      'PixelGetIteratorExceptionResult(severity: $severity, description: $description)';
}

Future<List<int>> _pixelGetCurrentIteratorRow(int iteratorPtrAddress) async =>
    using(
      (Arena arena) {
        Pointer<Size> numberWandsPtr = arena();
        Pointer<Pointer<mwbg.PixelWand>> pixelWandsPtr =
            _magickWandBindings.PixelGetCurrentIteratorRow(
          Pointer<mwbg.PixelIterator>.fromAddress(iteratorPtrAddress),
          numberWandsPtr,
        );
        if (pixelWandsPtr == nullptr) {
          return [];
        }
        List<int> pixelWandsAddresses = [];
        for (int i = 0; i < numberWandsPtr.value; i++) {
          pixelWandsAddresses.add(pixelWandsPtr[i].address);
        }
        return pixelWandsAddresses;
      },
    );

Future<List<int>> _pixelGetNextIteratorRow(int iteratorPtrAddress) async =>
    using(
      (Arena arena) {
        Pointer<Size> numberWandsPtr = arena();
        Pointer<Pointer<mwbg.PixelWand>> pixelWandsPtr =
            _magickWandBindings.PixelGetNextIteratorRow(
          Pointer<mwbg.PixelIterator>.fromAddress(iteratorPtrAddress),
          numberWandsPtr,
        );
        if (pixelWandsPtr == nullptr) {
          return [];
        }
        List<int> pixelWandsAddresses = [];
        for (int i = 0; i < numberWandsPtr.value; i++) {
          pixelWandsAddresses.add(pixelWandsPtr[i].address);
        }
        return pixelWandsAddresses;
      },
    );

Future<List<int>> _pixelGetPreviousIteratorRow(int iteratorPtrAddress) async =>
    using(
      (Arena arena) {
        Pointer<Size> numberWandsPtr = arena();
        Pointer<Pointer<mwbg.PixelWand>> pixelWandsPtr =
            _magickWandBindings.PixelGetPreviousIteratorRow(
          Pointer<mwbg.PixelIterator>.fromAddress(iteratorPtrAddress),
          numberWandsPtr,
        );
        if (pixelWandsPtr == nullptr) {
          return [];
        }
        List<int> pixelWandsAddresses = [];
        for (int i = 0; i < numberWandsPtr.value; i++) {
          pixelWandsAddresses.add(pixelWandsPtr[i].address);
        }
        return pixelWandsAddresses;
      },
    );

Future<bool> _pixelSyncIterator(int iteratorPtrAddress) async =>
    _magickWandBindings.PixelSyncIterator(
      Pointer<mwbg.PixelIterator>.fromAddress(iteratorPtrAddress),
    ).toBool();
