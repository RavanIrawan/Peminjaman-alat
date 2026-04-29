import 'package:peminjaman_alat/models/detail_peminjaman.dart';

class PeminjamanModel {
  final String? id;
  int denda;
  List<DetailPeminjaman> detailPinjaman;
  int durasi;
  String idPeminjam;
  String status;
  String noPeminjam;
  DateTime tanggalPengajuan;
  DateTime? tanggalBarangKembali;
  DateTime? tanggalKembali;
  DateTime? tanggalPinjam;
  DateTime? tenggatWaktu;
  String? alasanPenolakan;
  DateTime? tanggalDitolak;
  DateTime? tanggalDitolakAdmin;
  String profilePeminjam;
  String namaPeminjam;
  String? catatanAdmin;
  String? kerusakanType;

  PeminjamanModel({
    this.id,
    required this.denda,
    required this.detailPinjaman,
    required this.durasi,
    required this.idPeminjam,
    required this.status,
    required this.tanggalPengajuan,
    this.tanggalBarangKembali,
    this.tanggalKembali,
    this.tanggalPinjam,
    this.tenggatWaktu,
    this.alasanPenolakan,
    this.tanggalDitolak,
    required this.profilePeminjam,
    required this.namaPeminjam,
    this.catatanAdmin,
    this.tanggalDitolakAdmin,
    required this.noPeminjam,
    this.kerusakanType,
  });
}
