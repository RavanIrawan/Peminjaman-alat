import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peminjaman_alat/controllers/peminjam/pinjaman_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/utils/empaty_state.dart';
import 'package:peminjaman_alat/views/peminjam_view/detail_pinjaman_view.dart';

class PinjamanDiajukanView extends StatefulWidget {
  const PinjamanDiajukanView({super.key});

  @override
  State<PinjamanDiajukanView> createState() => _PinjamanDiajukanViewState();
}

class _PinjamanDiajukanViewState extends State<PinjamanDiajukanView>
    with AutomaticKeepAliveClientMixin {
  final pinjamanC = Get.find<PinjamanController>();
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() {
            if (pinjamanC.dataPeminjamanDiAjukan.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Empetystate(
                  title: 'Belum Ada Riwayat',
                  subTitle:
                      'Barang yang sedang di ajukan/menunggu persetujuan akan muncul di halaman ini.',
                ),
              );
            }
            if (pinjamanC.isLoading.value) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final dataPinjaman = pinjamanC.dataPeminjamanDiAjukan[index];
                final dataDetailPinjaman = dataPinjaman.detailPinjaman;
                final barangUtama = dataDetailPinjaman[0];
                final statusFirst = dataPinjaman.status.replaceAll('_', ' ');

                return Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  color: AppColors.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            child: Image.network(
                              barangUtama.gambar,
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 15,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.textPrimary.withValues(
                                  alpha: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                'TOTAL ITEMS: ${dataDetailPinjaman.length}',
                                style: TextStyle(
                                  color: AppColors.surface,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.warning.withValues(alpha: 0.1),
                                border: BoxBorder.all(
                                  color: AppColors.warning,
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                statusFirst.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              barangUtama.nama,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                dataDetailPinjaman.length > 1
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 4,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.inventory,
                                              size: 15,
                                              color: AppColors.textSecondary,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '${dataDetailPinjaman.length} tools',
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontFamily: 'Inter',
                                                fontSize: 12,
                                              ),
                                            ),

                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      )
                                    : SizedBox.shrink(),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 15,
                                        color: AppColors.textSecondary,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        DateFormat(
                                          'dd MMM yyyy',
                                        ).format(dataPinjaman.tanggalPengajuan),
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
                            SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.1),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: dataDetailPinjaman.map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.surface,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: Text(
                                            '${e.qty} Units',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryDark,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    pinjamanC.cancelPeminjaman(
                                      dataPinjaman.id ?? '',
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Batalkan Pinjaman',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 42,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primaryDark,
                                        AppColors.primary,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.toNamed(
                                        DetailPinjamanView.routeName,
                                        arguments: dataPinjaman,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 0.1,
                                        horizontal: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      foregroundColor: AppColors.surface,
                                    ),
                                    child: Text(
                                      'View Details',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: pinjamanC.dataPeminjamanDiAjukan.length,
            );
          }),
        ),
      ),
    );
  }
}
