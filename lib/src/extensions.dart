import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

extension UnsignedCharPointerExtension on Pointer<UnsignedChar> {
  /// Creates a `Uint8List` from this pointer by copying the pointer's data.
  ///
  /// `length` is the length of the array.
  ///
  /// null is returned if the pointer is equal to `nullptr`.
  Uint8List? toUint8List(int length) {
    if (this == nullptr) {
      return null;
    }
    final Uint8List list = Uint8List(length);
    for (int i = 0; i < length; i++) {
      list[i] = this[i];
    }
    return list;
  }
}

extension Uint16PointerExtension on Pointer<Uint16> {
  /// Creates a `Uint16List` from this pointer by copying the pointer's data.
  ///
  /// `length` is the length of the array.
  ///
  /// null is returned if the pointer is equal to `nullptr`.
  Uint16List? toUint16List(int length) {
    if (this == nullptr) {
      return null;
    }
    final Uint16List list = Uint16List(length);
    for (int i = 0; i < length; i++) {
      list[i] = this[i];
    }
    return list;
  }
}

extension Uint32PointerExtension on Pointer<Uint32> {
  /// Creates a `Uint32List` from this pointer by copying the pointer's data.
  ///
  /// `length` is the length of the array.
  ///
  /// null is returned if the pointer is equal to `nullptr`.
  Uint32List? toUint32List(int length) {
    if (this == nullptr) {
      return null;
    }
    final Uint32List list = Uint32List(length);
    for (int i = 0; i < length; i++) {
      list[i] = this[i];
    }
    return list;
  }
}

extension Uint64PointerExtension on Pointer<Uint64> {
  /// Creates a `Uint64List` from this pointer by copying the pointer's data.
  ///
  /// `length` is the length of the array.
  ///
  /// null is returned if the pointer is equal to `nullptr`.
  Uint64List? toUint64List(int length) {
    if (this == nullptr) {
      return null;
    }
    final Uint64List list = Uint64List(length);
    for (int i = 0; i < length; i++) {
      list[i] = this[i];
    }
    return list;
  }
}

extension FloatPointerExtension on Pointer<Float> {
  /// Creates a `Float32List` from this pointer by copying the pointer's data.
  ///
  /// `length` is the length of the array.
  ///
  /// null is returned if the pointer is equal to `nullptr`.
  Float32List? toFloat32List(int length) {
    if (this == nullptr) {
      return null;
    }
    final Float32List list = Float32List(length);
    for (int i = 0; i < length; i++) {
      list[i] = this[i];
    }
    return list;
  }
}

extension DoublePointerExtension on Pointer<Double> {
  /// Creates a `Float64List` from this pointer by copying the pointer's data.
  ///
  /// `length` is the length of the array.
  ///
  /// null is returned if the pointer is equal to `nullptr`.
  Float64List? toFloat64List(int length) {
    if (this == nullptr) {
      return null;
    }
    final Float64List list = Float64List(length);
    for (int i = 0; i < length; i++) {
      list[i] = this[i];
    }
    return list;
  }
}

extension CharPointerPointerExtension on Pointer<Pointer<Char>> {
  /// Creates a `List<String>` from this pointer by copying the pointer's data.
  ///
  /// `length` is the length of the array.
  ///
  /// null is returned if the pointer is equal to `nullptr`.
  List<String>? toStringList(int length) {
    if (this == nullptr) {
      return null;
    }
    final List<String> list = [];
    for (int i = 0; i < length; i++) {
      list.add(this[i].toNullableString()!);
    }
    return list;
  }
}

extension DoubleArrayExtension on Array<Double> {
  /// Creates a `Float64List` from this array by copying the array's data.
  ///
  /// `length` is the length of the array.
  ///
  /// null is returned if the array is empty.
  Float64List? toFloat64List(int length) {
    if (length == 0) {
      return null;
    }
    final Float64List list = Float64List(length);
    for (int i = 0; i < length; i++) {
      list[i] = this[i];
    }
    return list;
  }
}

extension Uint8ListExtension on Uint8List {
  /// Creates an `unsigned char` array from this list by copying the
  /// list's data, and returns a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<UnsignedChar> toUnsignedCharArrayPointer(
      {required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<UnsignedChar> ptr =
        allocator(sizeOf<UnsignedChar>() * length);
    for (int i = 0; i < length; i++) {
      ptr[i] = this[i];
    }
    return ptr;
  }
}

extension Uint16ListExtension on Uint16List {
  /// Creates an `unsigned short` array from this list by copying the
  /// list's data, and returns a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<Uint16> toUint16ArrayPointer({required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<Uint16> ptr = allocator(sizeOf<Uint16>() * length);
    for (int i = 0; i < length; i++) {
      ptr[i] = this[i];
    }
    return ptr;
  }
}

extension Uint32ListExtension on Uint32List {
  /// Creates an `unsigned int` array from this list by copying the
  /// list's data, and returns a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<Uint32> toUint32ArrayPointer({required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<Uint32> ptr = allocator(sizeOf<Uint32>() * length);
    for (int i = 0; i < length; i++) {
      ptr[i] = this[i];
    }
    return ptr;
  }
}

extension Uint64ListExtension on Uint64List {
  /// Creates an `unsigned long long` array from this list by copying
  /// the list's  data, and returns a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<Uint64> toUint64ArrayPointer({required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<Uint64> ptr = allocator(sizeOf<Uint64>() * length);
    for (int i = 0; i < length; i++) {
      ptr[i] = this[i];
    }
    return ptr;
  }
}

extension Float32ListExtension on Float32List {
  /// Creates a `float` array from this list by copying the list's data,
  /// and returns a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<Float> toFloatArrayPointer({required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<Float> ptr = allocator(sizeOf<Float>() * length);
    for (int i = 0; i < length; i++) {
      ptr[i] = this[i];
    }
    return ptr;
  }
}

extension Float64ListExtension on Float64List {
  /// Creates a `double` array from this list by copying the list's
  /// data, and returns a pointer to it.
  ///
  /// `nullptr` is returned if the list is empty.
  Pointer<Double> toDoubleArrayPointer({required Allocator allocator}) {
    if (isEmpty) {
      return nullptr;
    }
    final Pointer<Double> ptr = allocator(sizeOf<Double>() * length);
    for (int i = 0; i < length; i++) {
      ptr[i] = this[i];
    }
    return ptr;
  }
}

extension IntExtension on int {
  /// Creates a bool from this int.
  ///
  /// The value of this int should be either 0 or 1, otherwise an
  /// exception is thrown.
  bool toBool() => this == 1
      ? true
      : this == 0
          ? false
          : throw Exception('Invalid value passed to toBool: $this');
}

extension BoolExtension on bool {
  /// Creates an int from this bool.
  int toInt() => this ? 1 : 0;
}

extension CharPointerExtension on Pointer<Char> {
  /// Creates a nullable `String` from this pointer. If this pointer is equal
  /// to `nullptr`, null is returned. Otherwise, the pointer is cast to `Utf8`
  /// and converted to a Dart string.
  String? toNullableString() =>
      this == nullptr ? null : cast<Utf8>().toDartString();
}
