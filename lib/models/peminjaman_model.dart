import 'package:peminjaman_alat/models/detail_peminjaman.dart';

class PeminjamanModel {
  final String? id;
  int denda;
  List<DetailPeminjaman> detailPinjaman;
  int durasi;
  String idPeminjam;
  String status;
  final DateTime? tanggalKembali;
  DateTime tanggalPinjam;
  DateTime tenggatWaktu;
  final String? alasanPenolakan;
  final DateTime? tanggalDitolak;

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
    this.alasanPenolakan,
    this.tanggalDitolak,
  });
}
