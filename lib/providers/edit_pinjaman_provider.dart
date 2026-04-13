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
  ) async {
    final batch = FirebaseFirestore.instance.batch();

    final documentTransfer = _reference.doc(id);

    final data = {
      'status': status,
      'tanggalPinjam': tanggalPinjam,
      'tenggatWaktu': tenggatWaktu,
      'catatanAdmin': catatanAdmin,
    };

    if(status == 'selesai' && datalama.status != 'selesai'){
      data['tanggalKembali'] = FieldValue.serverTimestamp();
    }

    
  }
}
