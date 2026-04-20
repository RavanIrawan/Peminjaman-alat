import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? nama;
  String? email;
  String? role;
  String? profile;
  String? phone;
  dynamic createdAt;

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
      'profile': profile,
      'phone': phone ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
