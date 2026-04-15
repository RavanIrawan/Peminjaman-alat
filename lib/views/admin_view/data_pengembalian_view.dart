import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/data_pengembalian_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/views/admin_view/data_pengembalian_di_kembalikan_view.dart';
import 'package:peminjaman_alat/views/admin_view/data_pengembalian_selesai_view.dart';

class DataPengembalianView extends GetView<DataPengembalianController> {
  const DataPengembalianView({super.key});
  static const routeName = '/pengembalian';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.tab.length,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          title: Text(
            'Riwayat Pengembalian',
            style: TextStyle(
              color: AppColors.primary,
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: AppColors.primary),
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 130),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      onChanged: (value) => controller.searchDataWithkeyword(value),
                      autocorrect: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            controller.radius,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            controller.radius,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            controller.radius,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            controller.radius,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            controller.radius,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            controller.radius,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.textSecondary.withValues(
                          alpha: 0.1,
                        ),
                        isDense: true,
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        hintText: 'Cari berdasarkan nama peminjam...',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textSecondary,
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                        tabs: controller.tab,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            DataPengembalianDiKembalikanView(),
            DataPengembalianSelesaiView(),
          ],
        ),
      ),
    );
  }
}
