import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/data_peminjaman_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/views/admin_view/edit_pinjaman_view.dart';
import 'package:timeago/timeago.dart' as timeago;

class DataPeminjamanView extends GetView<DataPeminjamanController> {
  const DataPeminjamanView({super.key});
  static const routeName = '/peminjaman';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))
        ),
        backgroundColor: AppColors.surface,
        centerTitle: true,
        title: Text(
          'Riwayat peminjaman',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size(
            double.infinity,
            100,
          ),
          child: Obx(() {
            return Column(
              children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      onChanged: (value) => controller.searchData(value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.background.withValues(alpha: 0.1),
                        hintText: 'search by name...',
                        border: InputBorder.none,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.textSecondary,
                            width: 0.2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.textSecondary,
                            width: 0.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.textSecondary,
                            width: 0.2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.textSecondary,
                            width: 0.2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.textSecondary,
                            width: 0.2,
                          ),
                        ),
                        prefixIcon: Icon(Icons.manage_search),
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10)
                      ),
                      cursorColor: AppColors.primary,
                    ),
                  ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: controller.listStatus.map((e) {
                    final statusTrue = controller.selectedStatus.value == e;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 8,
                      ),
                      child: GestureDetector(
                        onTap: () => controller.selectStatus(e),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: statusTrue
                                ? AppColors.primary
                                : AppColors.textSecondary.withValues(
                                    alpha: 0.2,
                                  ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            e == 'selesai'
                                ? 'Selesai'
                                : (e == 'diPinjam'
                                      ? 'Dipinjam'
                                      : (e == 'di_kembalikan'
                                            ? 'Dikembalikan'
                                            : 'Unkown')),
                            style: TextStyle(
                              color: statusTrue
                                  ? AppColors.surface
                                  : AppColors.textSecondary,
                              fontFamily: 'Inter',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            await controller.getAllData();
            controller.getDataWithStatusDiPinjam();
          },
          color: AppColors.primary,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.dataPeminjaman.length,
                itemBuilder: (context, index) {
                  final data = controller.dataPeminjaman[index];
                  final tglPinjam = timeago.format(
                    data.tanggalPinjam ?? DateTime.now(),
                    locale: 'id',
                  );
          
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textSecondary.withValues(alpha: 0.1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tglPinjam,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(
                                  Icons.inventory,
                                  color: AppColors.primary,
                                  size: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            data.namaPeminjam,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: data.detailPinjaman.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e.nama,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          'Qty: ${e.qty}',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 8),
                          Divider(color: AppColors.textSecondary, thickness: 0.2),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: data.status == 'diPinjam'
                                      ? AppColors.warning.withValues(alpha: 0.1)
                                      : AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 12,
                                      color: data.status == 'diPinjam'
                                          ? AppColors.warning
                                          : AppColors.primary,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      data.status == 'diPinjam'
                                          ? 'Dipinjam'
                                          : (data.status == 'di_kembalikan'
                                                ? 'Dikembalikan'
                                                : (data.status == 'selesai'
                                                      ? 'selesai'
                                                      : 'unkown')),
                                      style: TextStyle(
                                        color: data.status == 'diPinjam'
                                            ? AppColors.warning
                                            : AppColors.primary,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(
                                    EditPinjamanView.routeName,
                                    arguments: data,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  overlayColor: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Edit Data',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
