import 'package:cloud_firestore/cloud_firestore.dart';

class RejectedProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('peminjaman');

  Future<void> deleteProductRejected(String id) async {
    await _reference.doc(id).delete();
  }
}