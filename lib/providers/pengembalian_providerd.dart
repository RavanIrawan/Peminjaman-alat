import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';

class DataPengembalianProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'peminjaman',
  );

  Future<void> rejectPengembalian(String id) async {
    await _reference.doc(id).update({'status': 'diPinjam'});
  }

  Future<void> softDelete(
    String id,
    String idAdmin,
    String namaAdmin,
    String namaPeminjam,
    PeminjamanModel dataPeminjaman,
    String catatan,
  ) async {
    final batch = FirebaseFirestore.instance.batch();

    final doctransRef = _reference.doc(id);
    final dataTrans = {
      'status': 'dibatalkan_admin',
      'catatanAdmin': catatan,
      'tanggalDiTolakAdmin': FieldValue.serverTimestamp(),
    };

    batch.update(doctransRef, dataTrans);

    if (dataPeminjaman.status == 'diPinjam' ||
        dataPeminjaman.status == 'di_kembalikan') {
      for (var dataLama in dataPeminjaman.detailPinjaman) {
        final docAlat = FirebaseFirestore.instance
            .collection('alat')
            .doc(dataLama.productId);
        batch.update(docAlat, {'stok': FieldValue.increment(dataLama.qty)});
      }
    }

    final docLog = FirebaseFirestore.instance.collection('logs').doc();
    final dataLog = {
      'idUser': idAdmin,
      'idTransaksi': id,
      'namaPetugas': namaAdmin,
      'type': 'rejectByAdmin',
      'aksi':
          'Admin $namaAdmin membatalkan peminjaman milik $namaPeminjam dengan id: $id',
      'createdAt': FieldValue.serverTimestamp(),
    };
    batch.set(docLog, dataLog);
    try {
      await batch.commit();
    } catch (error) {
      throw Exception('Gagal membatalkan peminjaman user $namaPeminjam');
    }
  }

  Future<QuerySnapshot<Object?>> getAllData() async {
    return await _reference
        .where(
          'status',
          whereIn: ['di_kembalikan', 'selesai', 'dibatalkan_admin'],
        )
        .get();
  }

  Future<void> selesaikanPeminjaman(
    String id,
    int denda,
    PeminjamanModel dataPinjaman,
    String idAdmin,
    String namaAdmin,
  ) async {
    final batch = FirebaseFirestore.instance.batch();

    final doctransRef = _reference.doc(id);

    final data = {
      'status': 'selesai',
      'denda': denda,
      'tanggalBarangKembali': FieldValue.serverTimestamp(),
    };

    batch.update(doctransRef, data);

    for (var detail in dataPinjaman.detailPinjaman) {
      final docTrans = FirebaseFirestore.instance
          .collection('alat')
          .doc(detail.productId);
      batch.update(docTrans, {'stok': FieldValue.increment(detail.qty)});
    }

    final docLog = FirebaseFirestore.instance.collection('logs').doc();
    final barangUtama = dataPinjaman.detailPinjaman[0].nama;
    final sisaBarang = dataPinjaman.detailPinjaman.length - 1;

    final dataLog = {
      'idUser': idAdmin,
      'idTransaksi': id,
      'namaPetugas': namaAdmin,
      'type': 'pengembalian',
      'aksi': dataPinjaman.detailPinjaman.length > 1
          ? '$namaAdmin telah menerima pengembalian $barangUtama dan $sisaBarang alat lainnya dari ${dataPinjaman.namaPeminjam}.'
          : '$namaAdmin telah menerima pengembalian $barangUtama dari ${dataPinjaman.namaPeminjam}.',
      'createdAt': FieldValue.serverTimestamp(),
    };
    batch.set(docLog, dataLog);

    try {
      await batch.commit();
    } catch (error) {
      throw Exception('Gagal menyelesaikan pinjaman');
    }
  }
}
