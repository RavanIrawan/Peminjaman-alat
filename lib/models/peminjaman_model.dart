import 'package:peminjaman_alat/models/detail_peminjaman.dart';

class PeminjamanModel {
  String? id;
  int denda;
  List<DetailPeminjaman> detailPinjaman;
  int durasi;
  String idPeminjam;
  String status;
  DateTime? tanggalKembali;
  DateTime tanggalPinjam;
  DateTime tenggatWaktu;

  PeminjamanModel({
    this.id,
    required this.denda,
    required this.detailPinjaman,
    required this.durasi,
    required this.idPeminjam,
    required this.status,
    this.tanggalKembali,
    required this.tanggalPinjam,
    required this.tenggatWaktu,
  });
}
