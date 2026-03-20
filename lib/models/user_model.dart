import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peminjaman_alat/utils/url_default_profile.dart';

class UserModel {
  String? id;
  final String? nama;
  final String? email;
  final String? role;
  String? profile;
  final int? phone;
  final dynamic createdAt;

  UserModel({
    this.id,
    this.nama,
    this.email,
    this.role,
    this.profile,
    this.phone,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'email': email,
      'role': role,
      'profile': profile ?? UrlDefaultProfile.url,
      'phone': phone ?? 0,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
