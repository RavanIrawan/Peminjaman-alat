import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/peminjam/rejected_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:peminjaman_alat/utils/empaty_state.dart';

class RejectedView extends GetView<RejectedController> {
  const RejectedView({super.key});
  static const routeName = '/rejected_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(
          'Riwayat Ditolak',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (controller.pinjamanC.dataPeminjamanDitolak.isEmpty) {
          return Center(
            child: Empetystate(
              title: 'Belum ada riwayat',
              subTitle: 'Belum ada data yang di tolak petugas/admin',
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemBuilder: (context, index) {
              final dataRejected =
                  controller.pinjamanC.dataPeminjamanDitolak[index];
              final tanggalditolak =
                  dataRejected.tanggalDitolakAdmin ?? DateTime.now();
              final tglDiTolak = DateFormat(
                'dd MMM yyyy',
              ).format(dataRejected.tanggalDitolak ?? tanggalditolak);
              final barangUtama = dataRejected.detailPinjaman[0];
              final listNamaBarang = dataRejected.detailPinjaman
                  .map((e) => e.nama)
                  .toString()
                  .replaceAll('(', '')
                  .replaceAll(')', '');

              return Container(
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: dataRejected.status == 'di_tolak'
                                ? AppColors.error.withValues(alpha: 0.1)
                                : AppColors.textSecondary.withValues(
                                    alpha: 0.1,
                                  ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.remove_done,
                                color: AppColors.error,
                                size: 18,
                              ),
                              SizedBox(width: 5),
                              Text(
                                dataRejected.status == 'di_tolak'
                                    ? 'ditolak'.toUpperCase()
                                    : 'unkown'.toUpperCase(),
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
                        Text(
                          tglDiTolak,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'Inter',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            barangUtama.gambar,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                barangUtama.nama,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Total ${dataRejected.detailPinjaman.length} Alat • $listNamaBarang',
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
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        dataRejected.alasanPenolakan == ''
                            ? 'Alasan penolakan: ${dataRejected.catatanAdmin}.'
                            : 'Alasan: ${dataRejected.alasanPenolakan}.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            controller.deleteProduct(dataRejected.id ?? '');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            elevation: 0,
                            foregroundColor: AppColors.textSecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.delete_rounded),
                              SizedBox(width: 5),
                              Text('Hapus Riwayat'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            itemCount: controller.pinjamanC.dataPeminjamanDitolak.length,
          ),
        );
      }),
    );
  }
}
