import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/main_admin_view_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/views/admin_view/home_admin.dart';
import 'package:peminjaman_alat/views/admin_view/log_aktivitas.dart';

class MainAdminView extends GetView<MainAdminViewController> {
  final Widget? child;
  const MainAdminView({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.tabs.length,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: TabBarView(children: [HomeAdmin(), LogAktivitas()]),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: AppColors.surface),
            child: TabBar(
              indicatorWeight: 5,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 10),
              tabs: controller.tabs,
            ),
          ),
        ),
      ),
    );
  }
}
