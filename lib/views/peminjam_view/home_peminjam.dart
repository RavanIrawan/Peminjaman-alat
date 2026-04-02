import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/peminjam/home_peminjaman_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/views/general_view/profile.dart';
import 'package:peminjaman_alat/views/peminjam_view/home_peminjaman_product.dart';
import 'package:peminjaman_alat/views/peminjam_view/keranjang_view.dart';

class HomePeminjam extends GetView<HomePeminjamanController> {
  const HomePeminjam({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.pages.length,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: TabBarView(
          controller: controller.tab,
          children: [HomePeminjamanProduct(), KeranjangView(), Profile()],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: AppColors.surface),
            child: TabBar(
              controller: controller.tab,
              indicatorWeight: 5,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              tabs: controller.pages,
            ),
          ),
        ),
      ),
    );
  }
}
