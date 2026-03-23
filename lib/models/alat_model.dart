import 'package:cloud_firestore/cloud_firestore.dart';

class AlatModel {
  String? id;
  String? namaAlat;
  String? idKategori;
  int? stok;
  String? gambar;
  String? deskripsi;

  AlatModel({this.id, this.namaAlat, this.idKategori, this.stok, this.gambar, this.deskripsi});

  Map<String, dynamic> toMap(){
    return {
      'nama': namaAlat,
      'idKategori': idKategori,
      'stok': stok,
      'gambar': gambar,
      'deskripsi': deskripsi ?? '-',
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}