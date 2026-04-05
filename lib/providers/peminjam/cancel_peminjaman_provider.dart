import 'package:cloud_firestore/cloud_firestore.dart';

class CancelPeminjamanProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('peminjaman');

  Future<void> deletePeminjaman(String id) async {
    await _reference.doc(id).delete();
  }
}