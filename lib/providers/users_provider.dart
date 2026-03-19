import 'package:cloud_firestore/cloud_firestore.dart';

class UsersProvider {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('users');
}