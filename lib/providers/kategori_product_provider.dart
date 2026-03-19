import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peminjaman_alat/models/kategori_model.dart';

class KategoriProductProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'kategori',
  );

  Future<void> addKategori(String id, String nama) async {
    final data = KategoriModel(name: nama, id: id);

    await _reference.doc(id).set(data.toMap());
  }

  Future<QuerySnapshot<Object?>> getKategori() async {
    return await _reference.get();
  }

  Future<void> deleteKategori(String id) async {
    await _reference.doc(id).delete();
  }

  Future<void> updateKategori(String id, String name) async {
    await _reference.doc(id).update({'nama': name});
  }
}
