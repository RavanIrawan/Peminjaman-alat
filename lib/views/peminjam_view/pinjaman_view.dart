import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/peminjam/pinjaman_view_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/views/peminjam_view/cancel_peminjaman_view.dart';
import 'package:peminjaman_alat/views/peminjam_view/pinjaman_diajukan_view.dart';
import 'package:peminjaman_alat/views/peminjam_view/pinjaman_saya_view.dart';
import 'package:peminjaman_alat/views/peminjam_view/pinjaman_selesai_view.dart';
import 'package:peminjaman_alat/views/peminjam_view/rejected_view.dart';

class PinjamanView extends GetView<PinjamanViewController> {
  const PinjamanView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.tab.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          title: Text(
            'Barang saya',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12),
            overlayColor: WidgetStateColor.transparent,
            tabs: controller.tab,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(CancelPeminjamanView.routeName);
              },
              icon: Icon(Icons.delete_sweep, color: AppColors.primary),
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(RejectedView.routeName);
              },
              icon: Icon(Icons.remove_done, color: AppColors.primary),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            PinjamanDiajukanView(),
            PinjamanSayaView(),
            PinjamanSelesaiView(),
          ],
        ),
      ),
    );
  }
}
