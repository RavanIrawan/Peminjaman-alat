import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peminjaman_alat/controllers/arsip_dibatalkan_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/utils/empaty_state.dart';

class ArsipDibatalkanView extends GetView<ArsipDibatalkanController> {
  const ArsipDibatalkanView({super.key});
  static const routeName = '/archived';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(
          'Arsip Dibatalkan',
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
            MediaQuery.of(context).size.height * 0.1,
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                hintText: 'Cari Nama Atau ID...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(controller.radius),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(controller.radius),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(controller.radius),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(controller.radius),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(controller.radius),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(controller.radius),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.textSecondary.withValues(alpha: 0.1),
              ),
              cursorColor: AppColors.success,
              autocorrect: true,
              onChanged: (value) => controller.searchDataWithkeyword(value),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.dataWithStatusDibatalkan.isEmpty) {
          return Center(
            child: Empetystate(
              title: 'Tidak ada riwayat...',
              subTitle:
                  'Data dengan status di batalkan admin akan muncul di halaman ini.',
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'log audit pembatalan'.toUpperCase(),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      '${controller.dataWithStatusDibatalkan.length} total'
                          .toUpperCase(),
                      style: TextStyle(
                        color: AppColors.error,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.dataWithStatusDibatalkan.length,
                  itemBuilder: (context, index) {
                    final data = controller.dataWithStatusDibatalkan[index];
                    final date = DateFormat(
                      'dd MMM, HH:mm a',
                    ).format(data.tanggalDitolakAdmin ?? DateTime.now());

                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border(
                          left: BorderSide(
                            color: data.status == 'dibatalkan_admin'
                                ? AppColors.error
                                : AppColors.textSecondary,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '#${data.id}',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: data.status == 'dibatalkan_admin'
                                      ? AppColors.error.withValues(alpha: 0.2)
                                      : AppColors.textSecondary.withValues(
                                          alpha: 0.2,
                                        ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  data.status == 'dibatalkan_admin'
                                      ? 'dibatalkan'.toUpperCase()
                                      : 'unkown'.toUpperCase(),
                                  style: TextStyle(
                                    color: data.status == 'dibatalkan_admin'
                                        ? AppColors.error
                                        : AppColors.textSecondary,
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: AppColors.textSecondary,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    data.namaPeminjam,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.access_time_filled,
                                    color: AppColors.textSecondary,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Dibatalkan: $date',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alasan:',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data.catatanAdmin ?? 'Unkown',
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
