import 'package:peminjaman_alat/models/detail_peminjaman.dart';

class PeminjamanModel {
  final String? id;
  int denda;
  List<DetailPeminjaman> detailPinjaman;
  int durasi;
  String idPeminjam;
  String status;
  DateTime tanggalPengajuan;
  final DateTime? tanggalKembali;
  final DateTime? tanggalPinjam;
  final DateTime? tenggatWaktu;
  final String? alasanPenolakan;
  final DateTime? tanggalDitolak;
  String profilePeminjam;
  String namaPeminjam;

  PeminjamanModel({
    this.id,
    required this.denda,
    required this.detailPinjaman,
    required this.durasi,
    required this.idPeminjam,
    required this.status,
    required this.tanggalPengajuan,
    this.tanggalKembali,
    this.tanggalPinjam,
    this.tenggatWaktu,
    this.alasanPenolakan,
    this.tanggalDitolak,
    required this.profilePeminjam,
    required this.namaPeminjam,
  });
}
