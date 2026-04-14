import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';

class EditPinjamanProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection(
    'peminjaman',
  );

  Future<void> updateDataPeminjaman(
    String id,
    String status,
    Timestamp tanggalPinjam,
    Timestamp tenggatWaktu,
    String catatanAdmin,
    PeminjamanModel datalama,
    String idAdmin,
    String namaAdmin,
  ) async {
    final batch = FirebaseFirestore.instance.batch();

    final documentTransfer = _reference.doc(id);

    Map<String, dynamic> data = {
      'status': status,
      'tanggalPinjam': tanggalPinjam,
      'tenggatWaktu': tenggatWaktu,
      'catatanAdmin': catatanAdmin,
    };

    if (status == 'selesai' && datalama.status != 'selesai') {
      data['tanggalKembali'] = FieldValue.serverTimestamp();
    }

    batch.update(documentTransfer, data);

    if (status == 'selesai' && datalama.status != 'selesai') {
      for (var dataDetail in datalama.detailPinjaman) {
        final docTrans = FirebaseFirestore.instance
            .collection('alat')
            .doc(dataDetail.productId);

        batch.update(docTrans, {'stok': FieldValue.increment(dataDetail.qty)});
      }
    }

    final docLog = FirebaseFirestore.instance.collection('logs').doc();
    final dataLog = {
      'idUser': idAdmin,
      'idTransaksi': documentTransfer.id,
      'namaAdmin': namaAdmin,
      'type': 'update_transaksi',
      'aksi': '$namaAdmin melakukan edit data peminjaman ${datalama.namaPeminjam}.', 
      'createdAt': FieldValue.serverTimestamp(),
    };
    batch.set(docLog, dataLog);

    try {
      await batch.commit();
    } catch (error) {
      throw Exception('Gagal mengubah data barang terjadi kesalahan');
    }
  }
}
