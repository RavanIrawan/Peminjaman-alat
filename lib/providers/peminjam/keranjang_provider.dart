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
    String namaPeminjam,
    String catatanAdmin,
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
      'catatanAdmin': catatanAdmin.trim(),
    };

    batch.set(docTransRef, dataTransfer);

    final docLogTrans = FirebaseFirestore.instance.collection('logs').doc();

    final barangUtama = items[0];

    final dataLog = {
      'idUser': id,
      'idTransaksi': docTransRef.id,
      'nama': namaPeminjam,
      'type': 'pengajuan',
      'aksi': items.length > 1
          ? '$namaPeminjam mengajukan pinjaman untuk ${barangUtama['nama']} dan ${items.length - 1} alat lainnya.'
          : '$namaPeminjam mengajukan pinjaman untuk ${barangUtama['nama']}.',
      'createdAt': FieldValue.serverTimestamp(),
    };

    batch.set(docLogTrans, dataLog);

    try {
      await batch.commit();
    } catch (error) {
      throw Exception('Gagal, Terjadi kesalahan');
    }
  }
}
