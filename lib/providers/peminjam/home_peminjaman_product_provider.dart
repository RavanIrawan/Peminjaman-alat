import 'package:cloud_firestore/cloud_firestore.dart';

class HomePeminjamanProductProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('kategori');
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('alat');

  Future<QuerySnapshot<Object?>> getAllKategori() async {
    return await _reference.get();
  }

  Future<QuerySnapshot<Object?>> getAllAlat() async {
    return await _collectionReference.get();
  }
}