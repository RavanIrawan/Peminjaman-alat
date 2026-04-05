import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePeminjamanController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tab;

  final pages = [
    Tab(icon: Icon(Icons.home_filled), text: 'Beranda'),
    Tab(icon: Icon(Icons.shopping_cart), text: 'Keranjang'),
    Tab(icon: Icon(Icons.assignment), text: 'Pinjaman saya'),
    Tab(text: 'Profile', icon: Icon(Icons.person)),
  ];

  @override
  void onInit() {
    tab = TabController(length: pages.length, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
   tab.dispose();
    super.onClose();
  }

  void changeTabIndex(int index){
    tab.animateTo(index);
  }
}
