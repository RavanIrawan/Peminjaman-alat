import 'package:cloud_firestore/cloud_firestore.dart';

class AlatProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('alat');

  Future<QuerySnapshot<Object?>> getAlat() async {
    return await _reference.orderBy('createdAt', descending: false).get();
  }
  Future<void> deleteAlat(String id) async{
    await _reference.doc(id).delete();
  }
}