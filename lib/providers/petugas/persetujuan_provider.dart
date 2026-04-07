import 'package:cloud_firestore/cloud_firestore.dart';

class PersetujuanProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'peminjaman',
  );

  Future<void> acceptPeminjaman(String id, Timestamp tglPinjam, Timestamp tenggatWaktu) async {
    await _reference.doc(id).update({
      'status': 'diPinjam',
      'tanggalPinjam': tglPinjam,
      'tenggatWaktu': tenggatWaktu,
      });
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
