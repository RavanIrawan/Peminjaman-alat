import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peminjaman_alat/controllers/data_pengembalian_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/utils/convert_to_rupiah.dart';
import 'package:peminjaman_alat/utils/empaty_state.dart';
import 'package:peminjaman_alat/views/admin_view/edit_data_pengembalian.dart';

class DataPengembalianSelesaiView extends StatefulWidget {
  const DataPengembalianSelesaiView({super.key});

  @override
  State<DataPengembalianSelesaiView> createState() =>
      _DataPengembalianSelesaiViewState();
}

class _DataPengembalianSelesaiViewState
    extends State<DataPengembalianSelesaiView>
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
        if (pengembalianC.isLoadingSecond.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Riwayat selesai'.toUpperCase(),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        '${pengembalianC.dataWithStatusSelesai.length} item'
                            .toUpperCase(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pengembalianC.dataWithStatusSelesai.length,
                  itemBuilder: (context, index) {
                    final data = pengembalianC.dataWithStatusSelesai[index];
                    final tglBarangKembali = DateFormat(
                      'dd MMM yyyy',
                    ).format(data.tanggalBarangKembali ?? DateTime.now());
                    final tenggat = DateTime(
                      data.tenggatWaktu?.year ?? DateTime.now().year,
                      data.tenggatWaktu?.month ?? DateTime.now().month,
                      data.tenggatWaktu?.day ?? DateTime.now().day,
                    );
                    final tglbarang = DateTime(
                      data.tanggalBarangKembali?.year ?? DateTime.now().year,
                      data.tanggalBarangKembali?.month ?? DateTime.now().month,
                      data.tanggalBarangKembali?.day ?? DateTime.now().day,
                    );
                    final checkDelay = tglbarang.isAfter(tenggat);
                    final toRupiah = ConvertToRupiah.convertToRupiah(
                      data.denda,
                    );

                    return Obx(() {
                      if (pengembalianC.dataWithStatusSelesai.isEmpty) {
                        return Center(
                          child: Empetystate(
                            title: 'Belum ada riwayat',
                            subTitle: 'Data dengan status belum ada',
                          ),
                        );
                      }

                      return Card(
                        color: AppColors.surface,
                        margin: EdgeInsetsGeometry.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.inventory_rounded,
                                      color: AppColors.primary,
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '#${data.id}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                    onSelected: (value) {
                                      if (value == 'detail') {
                                        pengembalianC.showBottomSheetsForDetail(
                                          context,
                                          data,
                                        );
                                      } else if (value == 'edit') {
                                        Get.toNamed(
                                          EditDataPengembalian.routeName,
                                          arguments: data,
                                        );
                                      } else if (value == 'delete') {
                                        pengembalianC.showBottomSheetsForReject(
                                          data.id ?? '',
                                          data,
                                        );
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          value: 'detail',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.details,
                                                color: AppColors.primary,
                                                size: 18,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Detail',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                size: 18,
                                                color: AppColors.warning,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Edit',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.warning,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                size: 18,
                                                color: AppColors.error,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.error,
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
                              SizedBox(height: 10),
                              Divider(
                                color: AppColors.textSecondary,
                                thickness: 0.2,
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                runSpacing: 8,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: AppColors.textSecondary,
                                        size: 15,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Dikambelikan: $tglBarangKembali',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: checkDelay
                                          ? AppColors.error.withValues(
                                              alpha: 0.1,
                                            )
                                          : AppColors.primary.withValues(
                                              alpha: 0.1,
                                            ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          checkDelay
                                              ? Icons.warning
                                              : Icons.check_circle,
                                          size: 15,
                                          color: checkDelay
                                              ? AppColors.error
                                              : AppColors.primary,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          checkDelay
                                              ? 'terlambat - denda $toRupiah'
                                                    .toUpperCase()
                                              : 'tepat waktu'.toUpperCase(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: checkDelay
                                                ? AppColors.error
                                                : AppColors.primary,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
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
                      );
                    });
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
