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
    String idUser,
    String namaAdmin,
  ) async {
    final batch = FirebaseFirestore.instance.batch();

    final docTransfer = _reference.doc();

    final data = AlatModel(
      namaAlat: nama,
      idKategori: idKategori,
      stok: stok,
      gambar: gambar,
      deskripsi: deskripsi,
    );

    batch.set(docTransfer, data.toMap());

    final docLog = FirebaseFirestore.instance.collection('logs').doc();

    final dataLog = {
      'idUser': idUser,
      'idTransaksi': docTransfer.id,
      'nama': namaAdmin,
      'type': 'add-new-item',
      'aksi': 'admin $namaAdmin menambahkan item baru: $nama',
      'createdAt': FieldValue.serverTimestamp(),
    };

    batch.set(docLog, dataLog);

    try{
      await batch.commit();
    }catch(error){
      throw Exception('Gagal menambahkan Item baru');
    }
  }

  Future<void> updateAlat(
    String id,
    String nama,
    String idKategori,
    int stok,
    String gambar,
    String deskripsi,
    String idUser,
    String namaAdmin,
    AlatModel dataLama,
  ) async {
    List<String> fieldBaru = [];

    if (dataLama.namaAlat != nama) fieldBaru.add('nama alat');
    if (dataLama.idKategori != id) fieldBaru.add('kategori');
    if (dataLama.stok != stok) fieldBaru.add('stok');
    if (dataLama.deskripsi != deskripsi) fieldBaru.add('deskripsi');
    if (dataLama.gambar != gambar) fieldBaru.add('gambar');

    if (fieldBaru.isEmpty) {
      return;
    }

    final fieldBerubah = fieldBaru.join(', ');
    final namaBarang = dataLama.namaAlat ?? '';

    final batch = FirebaseFirestore.instance.batch();

    final docTransRef = _reference.doc(id);

    final data = AlatModel(
      namaAlat: nama,
      idKategori: idKategori,
      stok: stok,
      deskripsi: deskripsi,
      gambar: gambar,
    );

    batch.update(docTransRef, data.toMap());

    final docLog = FirebaseFirestore.instance.collection('logs').doc();

    final dataLog = {
      'idUser': idUser,
      'idTransaksi': docTransRef.id,
      'nama': namaAdmin,
      'type': 'update',
      'aksi': '$namaAdmin memperbarui $fieldBerubah pada alat $namaBarang',
      'createdAt': FieldValue.serverTimestamp(),
    };

    batch.set(docLog, dataLog);
    try {
      await batch.commit();
    } catch (error) {
      throw Exception('Gagal memperbarui data barang');
    }
  }
}
