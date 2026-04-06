import 'package:cloud_firestore/cloud_firestore.dart';

class PersetujuanProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'peminjaman',
  );

  Future<void> acceptPeminjaman(String id) async {
    await _reference.doc(id).update({'status': 'diPinjam'});
  }

  Future<void> rejectPeminjaman(
    String id,
    Timestamp tanggalDitolak,
    String alasan,
  ) async {
    await _reference.doc(id).update({
      'tanggalDitolak': tanggalDitolak,
      'alasanDitolak': alasan,
    });
  }
}
