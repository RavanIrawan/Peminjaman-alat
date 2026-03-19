import 'package:flutter/material.dart';
import 'package:peminjaman_alat/controllers/kategori_home_controller.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/views/admin_view/kategori_edit.dart';
import 'package:peminjaman_alat/views/admin_view/kategori_product.dart';

class KategoryHome extends GetView<KategoriHomeController> {
  const KategoryHome({super.key});
  static const routeName = '/kategori';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.tabs.length,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: TabBarView(children: [KategoriProduct(), KategoriEdit()]),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: AppColors.surface),
            child: TabBar(
              indicatorWeight: 5,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              tabs: controller.tabs,
            ),
          ),
        ),
      ),
    );
  }
}
