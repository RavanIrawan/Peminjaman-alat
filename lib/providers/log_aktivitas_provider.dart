import 'package:cloud_firestore/cloud_firestore.dart';

class LogAktivitasProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('logs');

  Future<QuerySnapshot<Object?>> fetchLog() async {
    return await _reference.get();
  }
}