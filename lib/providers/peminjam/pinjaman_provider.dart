import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peminjaman_alat/models/detail_peminjaman.dart';

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

  Future<void> returProduct(String id, List<DetailPeminjaman> dataDetail) async {
    final batch = FirebaseFirestore.instance.batch();

    final docTrans = _reference.doc(id);

    final data = {
      'status': 'di_kembalikan',
      'tanggalKembali': FieldValue.serverTimestamp(),
      };

      batch.update(docTrans, data);

      try{  
        await batch.commit();
      }catch(error){
        throw Exception('Gagal mengembalikan barang');
      }
  }
}
