import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KategoriHomeController extends GetxController {
  final List<Tab> tabs = [
    Tab(icon: Icon(Icons.category), text: 'kategori',),
    Tab(icon: Icon(Icons.edit), text: 'Edit',),
  ];
}