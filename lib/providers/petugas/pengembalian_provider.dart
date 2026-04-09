import 'package:cloud_firestore/cloud_firestore.dart';

class PengembalianProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('peminjaman');

  Future<void> productReturn(String id, int denda) async {
    await _reference.doc(id).update({
      'status': 'selesai',
      'denda': denda,
    });
  }
}