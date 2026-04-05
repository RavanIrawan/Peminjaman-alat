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
    String status,
    int? denda,
    List<Map<String, dynamic>> items,
    String? alasanPenolakan,
  ) async {
    final batch = _reference.batch();

    final docTransRef = _collectionReference.doc();

    final dataTransfer = {
      'idPeminjam': id,
      'durasiHari': durasi,
      'tanggalPinjam': tglPinjam,
      'tenggatWaktu': tenggat,
      'status': status,
      'denda': denda ?? 0,
      'detailPinjaman': items,
      'alasanPenolakan': alasanPenolakan ?? '',
    };

    batch.set(docTransRef, dataTransfer);

    try{
      await batch.commit();
    }catch(error){
      throw Exception('Gagal, Terjadi kesalahan');
    }
  }
}
