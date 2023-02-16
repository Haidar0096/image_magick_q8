part of 'image_magick_q8.dart';

/// Represents an affine matrix.
class AffineMatrix {
  final double sx;
  final double rx;
  final double ry;
  final double sy;
  final double tx;
  final double ty;

  AffineMatrix({
    required this.sx,
    required this.rx,
    required this.ry,
    required this.sy,
    required this.tx,
    required this.ty,
  });

  Pointer<mwbg.AffineMatrix> _toAffineMatrixStructPointer(
          {required Allocator allocator}) =>
      allocator()
        ..ref.sx = sx
        ..ref.rx = rx
        ..ref.ry = ry
        ..ref.sy = sy
        ..ref.tx = tx
        ..ref.ty = ty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AffineMatrix &&
          runtimeType == other.runtimeType &&
          sx == other.sx &&
          rx == other.rx &&
          ry == other.ry &&
          sy == other.sy &&
          tx == other.tx &&
          ty == other.ty;

  @override
  int get hashCode =>
      sx.hashCode ^
      rx.hashCode ^
      ry.hashCode ^
      sy.hashCode ^
      tx.hashCode ^
      ty.hashCode;

  @override
  String toString() =>
      'AffineMatrix(sx: $sx, rx: $rx, ry: $ry, sy: $sy, tx: $tx, ty: $ty)';
}
