
class DetailPeminjaman {
  final String productId;
  final String nama;
  final int qty;
  final String gambar;

  DetailPeminjaman({required this.productId, required this.nama, required this.qty, required this.gambar});

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'nama': nama,
      'qty': qty,
      'gambar': gambar,
    };
  }
}