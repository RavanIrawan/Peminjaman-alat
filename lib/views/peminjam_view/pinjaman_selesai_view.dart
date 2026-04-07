import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:peminjaman_alat/controllers/peminjam/pinjaman_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/utils/empaty_state.dart';
import 'package:peminjaman_alat/views/peminjam_view/detail_pinjaman_view.dart';

class PinjamanSelesaiView extends StatefulWidget {
  const PinjamanSelesaiView({super.key});

  @override
  State<PinjamanSelesaiView> createState() => _PinjamanSelesaiViewState();
}

class _PinjamanSelesaiViewState extends State<PinjamanSelesaiView>
    with AutomaticKeepAliveClientMixin {
  final pinjamanC = Get.find<PinjamanController>();
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Obx(() {
          if (pinjamanC.dataPeminjamanSelesai.isEmpty) {
            return Empetystate(
              title: 'Belum Ada Riwayat',
              subTitle:
                  'Barang yang sudah selesai kamu pinjam akan tampil di halaman ini.',
            );
          }
          return SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final dataPinjaman = pinjamanC.dataPeminjamanSelesai[index];
                final barangUtama = dataPinjaman.detailPinjaman[0];
                final dataNamaBarang = dataPinjaman.detailPinjaman
                    .map((e) => e.nama)
                    .toString()
                    .replaceAll('(', '')
                    .replaceAll(')', '');
                final checkTenggat = pinjamanC.checkTenggatWaktu(
                  dataPinjaman.id ?? '',
                );

                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(15),
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
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  dataPinjaman.status == 'selesai'
                                      ? 'Peminjaman Selesai'
                                      : 'Unkown',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(
                                dataPinjaman.tanggalKembali ?? DateTime.now(),
                              ),
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontFamily: 'Inter',
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                barangUtama.gambar,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Detail Peminjaman Alat',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Jumlah Alat: ${dataPinjaman.detailPinjaman.length} Unit Total.',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '$dataNamaBarang.',
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
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(thickness: 0.5, color: AppColors.textSecondary),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jatuh Tempo: ${DateFormat('d MMM yyyy').format(dataPinjaman.tenggatWaktu ?? DateTime.now())}',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Tanggal Kembali: ${DateFormat('d MMM yyyy').format(dataPinjaman.tanggalKembali ?? DateTime.now())}',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: checkTenggat
                                        ? AppColors.error.withValues(alpha: 0.2)
                                        : AppColors.primary.withValues(
                                            alpha: 0.2,
                                          ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    checkTenggat
                                        ? 'terlambat'.toUpperCase()
                                        : 'tepat waktu'.toUpperCase(),
                                    style: TextStyle(
                                      color: checkTenggat
                                          ? AppColors.error
                                          : AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            OutlinedButton(
                              onPressed: () {
                                Get.toNamed(
                                  DetailPinjamanView.routeName,
                                  arguments: dataPinjaman,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(color: AppColors.primary),
                              ),
                              child: Text(
                                'View Detail',
                                style: TextStyle(fontFamily: 'Inter'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: pinjamanC.dataPeminjamanSelesai.length,
            ),
          );
        }),
      ),
    );
  }
}
