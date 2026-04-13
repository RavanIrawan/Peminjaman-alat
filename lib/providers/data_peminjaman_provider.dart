import 'package:cloud_firestore/cloud_firestore.dart';

class DataPeminjamanProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('peminjaman');

  Future<QuerySnapshot<Object?>> getAllDataPeminjam() async {
    return await _reference.get();
  }
}