import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peminjaman_alat/controllers/data_pengembalian_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';

class DataPengembalianDiKembalikanView extends StatefulWidget {
  const DataPengembalianDiKembalikanView({super.key});

  @override
  State<DataPengembalianDiKembalikanView> createState() =>
      _DataPengembalianDiKembalikanViewState();
}

class _DataPengembalianDiKembalikanViewState
    extends State<DataPengembalianDiKembalikanView>
    with AutomaticKeepAliveClientMixin {
  final pengembalianC = Get.find<DataPengembalianController>();

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (pengembalianC.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'peminjaman aktif'.toUpperCase(),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      '${pengembalianC.dataWithStatusDikembalikan.length} item'
                          .toUpperCase(),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: pengembalianC.dataWithStatusDikembalikan.length,
                  itemBuilder: (context, index) {
                    final data =
                        pengembalianC.dataWithStatusDikembalikan[index];
                    final dateNow = DateTime.now();
                    final now = DateTime(
                      dateNow.year,
                      dateNow.month,
                      dateNow.day,
                    );
                    final tenggat = DateTime(
                      data.tenggatWaktu?.year ?? DateTime.now().year,
                      data.tenggatWaktu?.month ?? DateTime.now().month,
                      data.tenggatWaktu?.day ?? DateTime.now().day,
                    );
                    final checkTenggat = now.isAfter(tenggat);
                    final tanggalkembali = DateFormat(
                      'dd MMM, HH:mm a',
                    ).format(data.tanggalKembali ?? DateTime.now());

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        color: AppColors.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '#${data.id}',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        data.namaPeminjam,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(
                                      Icons.inventory_outlined,
                                      color: AppColors.primary,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: checkTenggat
                                          ? AppColors.error.withValues(
                                              alpha: 0.1,
                                            )
                                          : AppColors.primary.withValues(
                                              alpha: 0.1,
                                            ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      checkTenggat
                                          ? 'terlambat'.toUpperCase()
                                          : 'tepat waktu'.toUpperCase(),
                                      style: TextStyle(
                                        color: checkTenggat
                                            ? AppColors.error
                                            : AppColors.primary,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: AppColors.textSecondary,
                                          size: 15,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Dikembalikan: $tanggalkembali',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primaryDark,
                                            AppColors.primary,
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          overlayColor: AppColors.background,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                        ),
                                        child: Text(
                                          'Selesaikan Peminjaman',
                                          style: TextStyle(
                                            color: AppColors.surface,
                                            fontFamily: 'Inter',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  PopupMenuButton(
                                    color: AppColors.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    position: PopupMenuPosition.under,
                                    popUpAnimationStyle: AnimationStyle(
                                      curve: Curves.easeInOut,
                                      duration: Duration(milliseconds: 500),
                                    ),
                                    onSelected: (value) {},
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 12,
                                          ),
                                          height: 20,
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: AppColors.primary,
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Edit',
                                                style: TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 12,
                                          ),
                                          height: 20,
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: AppColors.primary,
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ];
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
