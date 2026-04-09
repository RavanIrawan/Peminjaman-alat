import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';

class PersetujuanProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'peminjaman',
  );

  Future<void> acceptPeminjaman(
    String id,
    Timestamp tglPinjam,
    Timestamp tenggatWaktu,
    PeminjamanModel data,
  ) async {
    final batch = FirebaseFirestore.instance.batch();
    final docTransRef = _reference.doc(id);
    batch.update(docTransRef, {
      'status': 'diPinjam',
      'tanggalPinjam': tglPinjam,
      'tenggatWaktu': tenggatWaktu,
    });

    for (var dataBarang in data.detailPinjaman) {
      final barangRef = FirebaseFirestore.instance
          .collection('alat')
          .doc(dataBarang.productId);

      batch.update(barangRef, {'stok': FieldValue.increment(-dataBarang.qty)});
    }

    try {
      await batch.commit();
    } catch (error) {
      throw Exception('Gagar memproses persetujuan: $error');
    }
  }

  Future<void> rejectPeminjaman(
    String id,
    Timestamp tanggalDitolak,
    String alasan,
  ) async {
    await _reference.doc(id).update({
      'tanggalDitolak': tanggalDitolak,
      'status': 'di_tolak',
      'alasanPenolakan': alasan,
    });
  }
}
