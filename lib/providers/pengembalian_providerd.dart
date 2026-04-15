import 'package:cloud_firestore/cloud_firestore.dart';

class DataPengembalianProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'peminjaman',
  );

  Future<QuerySnapshot<Object?>> getAllData() async {
    return await _reference
        .where('status', whereIn: ['di_kembalikan', 'selesai'])
        .get();
  }
}
