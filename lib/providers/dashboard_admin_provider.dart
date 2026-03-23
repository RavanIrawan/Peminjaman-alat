import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardAdminProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('users');
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('alat');

  Future<int> getUserLength() async {
    final data = await _reference.count().get();

    return data.count ?? 0;
  }

  Future<int> getAlatLength() async {
    final data = await _collectionReference.count().get();

    return data.count ?? 0;
  }
}