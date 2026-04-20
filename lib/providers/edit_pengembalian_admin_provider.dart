import 'package:cloud_firestore/cloud_firestore.dart';

class EditPengembalianAdminProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'peminjaman',
  );

  Future<void> editpengembalian(
    String id,
    Timestamp? tanggalBarangkembaliRaw,
    int denda,
    String catatanAdmin,
    String idAdmin,
    String namaAdmin,
    String namaPeminjam,
  ) async {
    final batch = FirebaseFirestore.instance.batch();

    final docTransRef = _reference.doc(id);

    Map<String, dynamic> data = {'denda': denda, 'catatanAdmin': catatanAdmin};

    if (tanggalBarangkembaliRaw != null) {
      data['tanggalBarangKembali'] = tanggalBarangkembaliRaw;
    } else {
      data['tanggalBarangKembali'] = FieldValue.serverTimestamp();
    }

    batch.update(docTransRef, data);

    final docLog = FirebaseFirestore.instance.collection('logs').doc();
    final dataLog = {
      'idUser': idAdmin,
      'idTransaksi': id,
      'namaPetugas': namaAdmin,
      'type': 'update',
      'aksi':
          'Admin $namaAdmin telah mengubah data pengembalian milik $namaPeminjam dengan id: #$id',
      'createdAt': FieldValue.serverTimestamp(),
    };
    batch.set(docLog, dataLog);

    try {
      await batch.commit();
    } catch (error) {
      throw Exception('Gagal mengubah data peminjaman');
    }
  }
}
