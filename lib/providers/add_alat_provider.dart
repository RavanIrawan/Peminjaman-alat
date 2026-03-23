import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peminjaman_alat/models/alat_model.dart';

class AddAlatProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'alat',
  );
  final CollectionReference _kategori = FirebaseFirestore.instance.collection(
    'kategori',
  );

  Future<QuerySnapshot<Object?>> getKategori() async {
    return await _kategori.get();
  }

  Future<void> addAlat(
    String nama,
    String idKategori,
    int stok,
    String gambar,
    String deskripsi,
  ) async {
    final data = AlatModel(
      namaAlat: nama,
      idKategori: idKategori,
      stok: stok,
      gambar: gambar,
      deskripsi: deskripsi,
    );

    await _reference.doc().set(data.toMap());
  }

  Future<void> updateAlat(
    String id,
    String nama,
    String idKategori,
    int stok,
    String gambar,
    String deskripsi,
  ) async {
    final data = AlatModel(
      namaAlat: nama,
      idKategori: idKategori,
      stok: stok,
      deskripsi: deskripsi,
      gambar: gambar,
    );

    await _reference.doc(id).update(data.toMap());
  }

  
}
