import 'package:flutter/material.dart';
import 'package:peminjaman_alat/controllers/petugas/pengembalian_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PengembalianView extends StatefulWidget {
  const PengembalianView({super.key});

  @override
  State<PengembalianView> createState() => _PengembalianViewState();
}

class _PengembalianViewState extends State<PengembalianView>
    with AutomaticKeepAliveClientMixin {
  final pengembalianC = Get.find<PengembalianController>();
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.surface,
        title: Text(
          'Pantau Pengembalian',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (pengembalianC.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: BoxBorder.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'total dipinjam'.toUpperCase(),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${pengembalianC.totalDipinjam}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: BoxBorder.all(
                            color: AppColors.error.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'terlambat'.toUpperCase(),
                              style: TextStyle(
                                color: AppColors.error,
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${pengembalianC.totalterlambat ?? 0}',
                              style: TextStyle(
                                color: AppColors.error,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: pengembalianC.petugasC.allDataDiPinjam.length,
                  itemBuilder: (context, index) {
                    final data = pengembalianC.petugasC.allDataDiPinjam[index];
                    final tenggat = DateFormat(
                      'dd MMM yyy',
                    ).format(data.tenggatWaktu ?? DateTime.now());
                    final countTheDaysLate = pengembalianC.countTheDaysLate(
                      data.tenggatWaktu ?? DateTime.now(),
                    );
                    final now = DateTime(
                      pengembalianC.now.year,
                      pengembalianC.now.month,
                      pengembalianC.now.day,
                    );
                    final tenggatColor = DateTime(
                      data.tenggatWaktu!.year,
                      data.tenggatWaktu!.month,
                      data.tenggatWaktu!.day,
                    );

                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsetsGeometry.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          left: BorderSide(
                            color: now.isAfter(tenggatColor)
                                ? AppColors.error
                                : AppColors.primary,
                            width: 4,
                          ),
                        ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'peminjam'.toUpperCase(),
                                      style: TextStyle(
                                        color: AppColors.textSecondary
                                            .withValues(alpha: 0.6),
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Text(
                                      data.namaPeminjam,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              now.isAfter(tenggatColor)
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        'Terlambat $countTheDaysLate Hari',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.error,
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Daftar Alat (Total ${data.detailPinjaman.length} Unit)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            children: data.detailPinjaman.map((detailPinjaman) {
                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        detailPinjaman.gambar,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          detailPinjaman.nama,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.textSecondary
                                              .withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        child: Text(
                                          'Qty: ${detailPinjaman.qty}',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 15,
                                color: now.isAfter(tenggatColor)
                                    ? AppColors.error
                                    : AppColors.textSecondary,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Tenggat: $tenggat',
                                style: TextStyle(
                                  color: now.isAfter(tenggatColor)
                                      ? AppColors.error
                                      : AppColors.textSecondary,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () {
                                if (data.status == 'di_kembalikan') {
                                  pengembalianC
                                      .returnProductWithStatusCompleted(
                                        data.id!,
                                        data.tanggalKembali!,
                                        data.tenggatWaktu!,
                                      );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                foregroundColor: AppColors.primary,
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                side: BorderSide(color: AppColors.primary),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data.status == 'diPinjam'
                                        ? 'Sedang Di Pinjam'
                                        : 'Proses Pengembalian',
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    data.status == 'diPinjam'
                                        ? Icons.access_time_filled
                                        : Icons.arrow_forward,
                                  ),
                                ],
                              ),
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
