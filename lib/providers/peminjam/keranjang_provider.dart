import 'package:cloud_firestore/cloud_firestore.dart';

class KeranjangProvider {
  final _reference = FirebaseFirestore.instance;
  final CollectionReference _collectionReference = FirebaseFirestore.instance
      .collection('peminjaman');

  Future<void> transaction(
    String id,
    int durasi,
    String status,
    int? denda,
    List<Map<String, dynamic>> items,
    String? alasanPenolakan,
    String profilePeminjam,
    String namaPeminjam
  ) async {
    final batch = _reference.batch();

    final docTransRef = _collectionReference.doc();

    final dataTransfer = {
      'idPeminjam': id,
      'durasiHari': durasi,
      'status': status,
      'denda': denda ?? 0,
      'detailPinjaman': items,
      'alasanPenolakan': alasanPenolakan ?? '',
      'tanggalPengajuan': FieldValue.serverTimestamp(),
      'profilePeminjam': profilePeminjam,
      'namaPeminjam': namaPeminjam,
    };

    batch.set(docTransRef, dataTransfer);

    try{
      await batch.commit();
    }catch(error){
      throw Exception('Gagal, Terjadi kesalahan');
    }
  }
}
