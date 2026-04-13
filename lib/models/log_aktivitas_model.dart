class LogAktivitasModel {
  final String aksi;
  final String idUser;
  final String idTransaksi;
  final DateTime createdAt;
  final String type;
  final String nama;

  LogAktivitasModel({
    required this.aksi,
    required this.createdAt,
    required this.idTransaksi,
    required this.idUser,
    required this.type,
    required this.nama,
  });
}
