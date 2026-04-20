import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:peminjaman_alat/controllers/petugas/dashboard_petugas_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/views/general_view/profile.dart';
import 'package:peminjaman_alat/views/petugas_view/pengembalian_view.dart';
import 'package:peminjaman_alat/views/petugas_view/persetujuan_view.dart';
import 'package:peminjaman_alat/views/petugas_view/report_pdf_view.dart';

class HomePetugas extends GetView<DashboardPetugasController> {
  const HomePetugas({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.tab.length,
      child: Scaffold(
        body: TabBarView(
          children: [
            PersetujuanView(),
            PengembalianView(),
            ReportPdfView(),
            Profile(),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: AppColors.surface),
            child: TabBar(
              unselectedLabelColor: AppColors.textSecondary,
              indicatorWeight: 5,
              labelColor: AppColors.primary,
              indicatorColor: AppColors.primary,
              labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 10),
              tabs: controller.tab,
            ),
          ),
        ),
      ),
    );
  }
}
