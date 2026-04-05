import 'package:flutter/material.dart';
import 'package:peminjaman_alat/controllers/peminjam/cancel_peminjaman_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/utils/empaty_state.dart';
import 'package:peminjaman_alat/views/peminjam_view/detail_pinjaman_view.dart';

class CancelPeminjamanView extends GetView<CancelPeminjamanController> {
  const CancelPeminjamanView({super.key});
  static const routeName = '/cancel_peminjaman';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Inventory Management',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.dataCancel.isEmpty) {
          return Empetystate(
            title: 'Belum Ada Riwayat',
            subTitle: 'Peminjaman yang anda cancel akan muncul di halaman ini.',
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'History Peminjaman',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Review your previous and cancelled equipment logs',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'Inter',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final data = controller.dataCancel[index];
                    final barangUtama = data.detailPinjaman[0];
                    final namaBarang = data.detailPinjaman
                        .map((e) => e.nama)
                        .toString()
                        .replaceAll('(', '')
                        .replaceAll(')', '');

                    return InkWell(
                      onTap: () => Get.toNamed(
                        DetailPinjamanView.routeName,
                        arguments: data,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.1,
                                ),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 110,
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: data.status == 'di_batalkan'
                                      ? AppColors.error.withValues(alpha: 0.1)
                                      : AppColors.warning.withValues(
                                          alpha: 0.1,
                                        ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cancel,
                                      size: 15,
                                      color: AppColors.error,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      data.status == 'di_batalkan'
                                          ? 'dibatalkan'.toUpperCase()
                                          : 'Unkown'.toUpperCase(),
                                      style: TextStyle(
                                        color: AppColors.error,
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                        AppColors.textSecondary,
                                        BlendMode.saturation,
                                      ),
                                      child: Image.network(
                                        barangUtama.gambar,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.status == 'di_batalkan'
                                              ? 'Detail Alat (Dibatalkan)'
                                              : 'Detail Alat',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Total ${data.detailPinjaman.length} Alat • $namaBarang',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Divider(
                                color: AppColors.textSecondary,
                                thickness: 0.1,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      controller.deleteProduct(data.id ?? '');
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: BorderSide(
                                        color: AppColors.textSecondary,
                                        width: 0.5,
                                      ),
                                      foregroundColor: AppColors.textSecondary,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_forever),
                                        SizedBox(width: 8),
                                        Text(
                                          'Hapus Permanent',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: controller.dataCancel.length,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
