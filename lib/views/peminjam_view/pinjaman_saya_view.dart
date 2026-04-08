import 'package:flutter/material.dart';
import 'package:peminjaman_alat/controllers/peminjam/pinjaman_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:peminjaman_alat/utils/empaty_state.dart';
import 'package:peminjaman_alat/views/peminjam_view/detail_pinjaman_view.dart';

class PinjamanSayaView extends StatefulWidget {
  const PinjamanSayaView({super.key});

  @override
  State<PinjamanSayaView> createState() => _PinjamanSayaViewState();
}

class _PinjamanSayaViewState extends State<PinjamanSayaView>
    with AutomaticKeepAliveClientMixin {
  final pinjamanC = Get.find<PinjamanController>();
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (pinjamanC.dataPeminjaman.isEmpty) {
          return Empetystate(
            title: 'Belum Ada Riwayat',
            subTitle:
                'Barang yang sedang di pinjam akan muncul di halaman ini.',
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final dataPinjaman = pinjamanC.dataPeminjaman[index];
                final barangUtama = dataPinjaman.detailPinjaman[0];
                final checkTenggatTrue = pinjamanC.checkTenggatWaktu(
                  dataPinjaman.id ?? '',
                );

                return Padding(
                  padding: const EdgeInsets.all(8.0),
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Obx(() {
                                if (pinjamanC.dataPeminjaman[index].status ==
                                    'di_kembalikan') {
                                  return Text(
                                    'dikembalikan'.toUpperCase(),
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                                return Text(
                                  'sedang dipinjam'.toUpperCase(),
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                            ),

                            if (checkTenggatTrue)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  'terlambat'.toUpperCase(),
                                  style: TextStyle(
                                    color: AppColors.error,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textSecondary.withValues(
                                      alpha: 0.1,
                                    ),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  barangUtama.gambar,
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  barangUtama.nama,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  dataPinjaman.detailPinjaman.length > 1
                                      ? '${barangUtama.qty} Units • +${dataPinjaman.detailPinjaman.length}other item'
                                      : '${barangUtama.qty} Units',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontFamily: "Inter",
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Divider(color: Colors.grey, thickness: 0.5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jatuh Tempo:',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd MMM yyyy').format(
                                    dataPinjaman.tenggatWaktu ?? DateTime.now(),
                                  ),
                                  style: TextStyle(
                                    color: checkTenggatTrue
                                        ? AppColors.error
                                        : (DateTime.now().isAtSameMomentAs(
                                                dataPinjaman.tenggatWaktu ?? DateTime.now(),
                                              )
                                              ? AppColors.warning
                                              : AppColors.primary),
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.toNamed(
                                        DetailPinjamanView.routeName,
                                        arguments: dataPinjaman,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 25,
                                      ),
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.surface,
                                    ),
                                    child: Text(
                                      'View Detail',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                      ),
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
              },
              itemCount: pinjamanC.dataPeminjaman.length,
            ),
          ),
        );
      }),
    );
  }
}
