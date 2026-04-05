import 'package:peminjaman_alat/models/alat_model.dart';

class KeranjangModel {
  final AlatModel products;
  int qty;

  KeranjangModel({required this.products, required this.qty});

  Map<String, dynamic> toMap(){
    return {
      'productId': products.id ?? 0,
      'nama': products.namaAlat ?? 'Unknown',
      'qty': qty,
      'gambar': products.gambar ?? '',
    };
  }
}