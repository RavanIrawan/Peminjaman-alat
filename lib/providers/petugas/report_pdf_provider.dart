import 'package:cloud_firestore/cloud_firestore.dart';

class ReportPdfProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'peminjaman',
  );

  Future<QuerySnapshot<Object?>> getData(
    Timestamp startDate,
    Timestamp endDate,
  ) async {
    return _reference
        .where('tanggalPinjam', isGreaterThanOrEqualTo: startDate)
        .where('tanggalPinjam', isLessThanOrEqualTo: endDate)
        .get();
  }
}
