import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPetugasController extends GetxController {
  final tab = [
    Tab(icon: Icon(Icons.check_circle), text: 'persetujuan'),
    Tab(icon: Icon(Icons.inventory), text: 'pengembalian'),
    Tab(icon: Icon(Icons.receipt_long), text: 'laporan'),
    Tab(text: 'Profile', icon: Icon(Icons.person)),
    ];
}
