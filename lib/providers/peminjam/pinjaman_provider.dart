import 'package:cloud_firestore/cloud_firestore.dart';

class PinjamanProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'peminjaman',
  );

  Stream<QuerySnapshot<Object?>> getData(String id) {
    return _reference.where('idPeminjam', isEqualTo: id).snapshots();
  }

  Future<void> cancelPinjaman(String id) async {
    await _reference.doc(id).update({'status': 'di_batalkan'});
  }

  Future<void> returProduct(String id) async {
    await _reference.doc(id).update({'status': 'di_kembalikan'});
  }
}
