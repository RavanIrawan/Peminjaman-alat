import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peminjaman_alat/models/detail_peminjaman.dart';

class PengembalianProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'peminjaman',
  );

  Future<void> productReturn(
    String id,
    int denda,
    List<DetailPeminjaman> dataDetail,
    String idPetugas,
    String namaPetugas,
    String namaPeminjam,
  ) async {
    final batch = FirebaseFirestore.instance.batch();

    final docTransRef = _reference.doc(id);

    final data = {
      'status': 'selesai',
      'denda': denda,
      'tanggalBarangKembali': FieldValue.serverTimestamp(),
    };

    batch.update(docTransRef, data);

    for (var detail in dataDetail) {
      final docTransEdit = FirebaseFirestore.instance
          .collection('alat')
          .doc(detail.productId);

      batch.update(docTransEdit, {'stok': FieldValue.increment(detail.qty)});
    }

    final docLog = FirebaseFirestore.instance.collection('logs').doc();
    final barangUtama = dataDetail[0].nama;
    final sisaBarang = dataDetail.length - 1;

    final dataLog = {
      'idUser': idPetugas,
      'idTransaksi': id,
      'namaPetugas': namaPetugas,
      'type': 'pengembalian',
      'aksi': dataDetail.length > 1
          ? '$namaPetugas telah menerima pengembalian $barangUtama dan $sisaBarang alat lainnya dari $namaPeminjam.'
          : '$namaPetugas telah menerima pengembalian $barangUtama dari $namaPeminjam.',
      'createdAt': FieldValue.serverTimestamp(),
    };
    batch.set(docLog, dataLog);

    try {
      await batch.commit();
    } catch (error) {
      throw Exception('Gagal menyelesaikan peminjaman');
    }
  }
}
