import 'package:cloud_firestore/cloud_firestore.dart';

class KeranjangProvider {
  final _reference = FirebaseFirestore.instance;
  final CollectionReference _collectionReference = FirebaseFirestore.instance
      .collection('peminjaman');

  Future<void> transaction(
    String id,
    Timestamp tglPinjam,
    int durasi,
    Timestamp tenggat,
    Timestamp? tanggalKembali,
    String status,
    int? denda,
    List<Map<String, dynamic>> items,
  ) async {
    final batch = _reference.batch();

    final docTransRef = _collectionReference.doc();

    final dataTransfer = {
      'idPeminjam': id,
      'durasiHari': durasi,
      'tanggalPinjam': tglPinjam,
      'tenggatWaktu': tenggat,
      'tanggalKembali': tanggalKembali ?? 'null',
      'status': status,
      'denda': denda ?? 0,
      'detailPinjaman': items,
    };

    batch.set(docTransRef, dataTransfer);

    for (var item in items) {
      final docProduct = FirebaseFirestore.instance
          .collection('alat')
          .doc(item['productId']);
      batch.update(docProduct, {'stok': FieldValue.increment(-item['qty'])});
    }

    try{
      await batch.commit();
    }catch(error){
      throw Exception('Gagal, Terjadi kesalahan');
    }
  }
}
