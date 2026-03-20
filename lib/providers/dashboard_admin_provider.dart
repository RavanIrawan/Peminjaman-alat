import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardAdminProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('users');

  Future<int> getUserLength() async {
    final data = await _reference.count().get();

    return data.count ?? 0;
  }
}