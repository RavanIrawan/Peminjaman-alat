import 'package:cloud_firestore/cloud_firestore.dart';

class PetugasProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('peminjaman');

  Stream<QuerySnapshot<Object?>> getAllPeminjaman() {
    return _reference.snapshots();
  }
}