import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/peminjam/detail_pinjaman_controller.dart';
import 'package:peminjaman_alat/controllers/peminjam/pinjaman_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:intl/intl.dart';

class DetailPinjamanView extends GetView<DetailPinjamanController> {
  const DetailPinjamanView({super.key});
  static const routeName = '/detail-pinjam';

  @override
  Widget build(BuildContext context) {
    final pinjamanC = Get.find<PinjamanController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.surface,
        title: const Text(
          'Detail Pinjaman',
          style: TextStyle(
            color: AppColors.primary,
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 25),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: controller.data.value?.status == 'menunggu_persetujuan'
                  ? AppColors.warning.withValues(alpha: 0.1)
                  : (controller.data.value?.status == 'diPinjam'
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : (controller.data.value?.status == 'selesai' ||
                                  controller.data.value?.status ==
                                      'di_kembalikan'
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.data.value?.status == 'menunggu_persetujuan'
                      ? Icons.error
                      : (controller.data.value?.status == 'diPinjam'
                            ? Icons.check_circle
                            : (controller.data.value?.status == 'selesai' ||
                                      controller.data.value?.status ==
                                          'di_kembalikan'
                                  ? Icons.check
                                  : Icons.warning)),
                  color: controller.data.value?.status == 'menunggu_persetujuan'
                      ? Colors.deepOrangeAccent
                      : (controller.data.value?.status == 'diPinjam'
                            ? AppColors.primary
                            : (controller.data.value?.status == 'selesai' ||
                                      controller.data.value?.status ==
                                          'di_kembalikan'
                                  ? AppColors.primary
                                  : AppColors.error)),
                  size: 15,
                ),
                SizedBox(width: 4),
                Text(
                  controller.data.value?.status == 'menunggu_persetujuan'
                      ? 'menunggu persetujuan petugas'.toUpperCase()
                      : (controller.data.value?.status == 'diPinjam'
                            ? 'disetujui petugas'.toUpperCase()
                            : (controller.data.value?.status == 'selesai'
                                  ? 'peminjaman selesai'.toUpperCase()
                                  : (controller.data.value?.status ==
                                            'di_kembalikan'
                                        ? 'sedang dikembalikan'.toUpperCase()
                                        : 'peminjaman dibatalkan'
                                              .toUpperCase()))),
                  style: TextStyle(
                    color:
                        controller.data.value?.status == 'menunggu_persetujuan'
                        ? Colors.deepOrangeAccent
                        : (controller.data.value?.status == 'diPinjam'
                              ? AppColors.primary
                              : (controller.data.value?.status == 'selesai' ||
                                        controller.data.value?.status ==
                                            'di_kembalikan'
                                    ? AppColors.primary
                                    : AppColors.error)),
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
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
                  children: controller.iconAndTextView.map((e) {
                    final dataText = e['text'] as String;
                    final dataIcon = e['icon'] as IconData;
                    final colorText = e['colorText'] as Color;
                    final textContent = e['textContent'] as DateTime;
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              dataIcon,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dataText,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                DateFormat('dd MMM yyyy').format(textContent),
                                style: TextStyle(
                                  color: colorText,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Daftar Alat (${controller.data.value?.detailPinjaman.length} Item)',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: controller.data.value!.detailPinjaman.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
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
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              e.gambar,
                              width: 70,
                              height: 70,
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.nama,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${e.qty} Units',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
              Text(
                'Status Peminjaman',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),

              TimeLineItem(
                iscompleted:
                    controller.data.value?.status == 'menunggu_persetujuan' ||
                        controller.data.value?.status == 'diPinjam' ||
                        controller.data.value?.status == 'selesai' ||
                        controller.data.value?.status == 'di_kembalikan'
                    ? true
                    : false,
                isLast: false,
                title: Text(
                  'Diajukan',
                  style: TextStyle(
                    color:
                        controller.data.value?.status ==
                                'menunggu_persetujuan' ||
                            controller.data.value?.status == 'diPinjam' ||
                            controller.data.value?.status == 'selesai' ||
                            controller.data.value?.status == 'di_kembalikan'
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontFamily: 'Inter',
                    fontWeight:
                        controller.data.value?.status ==
                                'menunggu_persetujuan' ||
                            controller.data.value?.status == 'diPinjam' ||
                            controller.data.value?.status == 'selesai' ||
                            controller.data.value?.status == 'di_kembalikan'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subTitle: Text(
                  DateFormat(
                    'dd MMM yyyy',
                  ).format(controller.data.value!.tanggalPinjam),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                    fontSize: 12,
                  ),
                ),
              ),
              TimeLineItem(
                iscompleted:
                    controller.data.value?.status == 'diPinjam' ||
                        controller.data.value?.status == 'selesai' ||
                        controller.data.value?.status == 'di_kembalikan'
                    ? true
                    : false,
                isLast: false,
                title: Text(
                  'Disetujui',
                  style: TextStyle(
                    color:
                        controller.data.value?.status == 'diPinjam' ||
                            controller.data.value?.status == 'di_kembalikan' ||
                            controller.data.value?.status == 'selesai'
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontFamily: 'Inter',
                    fontWeight:
                        controller.data.value?.status == 'diPinjam' ||
                            controller.data.value?.status == 'di_kembalikan' ||
                            controller.data.value?.status == 'selesai'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subTitle: Text(
                  'Menunggu Konfirmasi Petugas',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                    fontSize: 12,
                  ),
                ),
              ),
              TimeLineItem(
                iscompleted:
                    controller.data.value?.status == 'di_kembalikan' ||
                        controller.data.value?.status == 'selesai'
                    ? true
                    : false,
                isLast: false,
                title: Text(
                  'Dikembalikan',
                  style: TextStyle(
                    color:
                        controller.data.value?.status == 'di_kembalikan' ||
                            controller.data.value?.status == 'selesai'
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontFamily: 'Inter',
                    fontWeight:
                        controller.data.value?.status == 'di_kembalikan' ||
                            controller.data.value?.status == 'selesai'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subTitle: Text(
                  'Kembalikan sebelum tenggat waktu',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                    fontSize: 12,
                  ),
                ),
              ),
              TimeLineItem(
                iscompleted: controller.data.value?.status == 'selesai'
                    ? true
                    : false,
                isLast: true,
                title: Text(
                  'Selesai',
                  style: TextStyle(
                    color: controller.data.value?.status == 'selesai'
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontFamily: 'Inter',
                    fontWeight: controller.data.value?.status == 'selesai'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subTitle: Text(
                  'Peminjaman selesai',
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
      ),
      bottomNavigationBar:
          controller.data.value?.status == 'selesai' ||
              controller.data.value?.status == 'di_kembalikan' ||
              controller.data.value?.status == 'di_batalkan'
          ? SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.data.value?.status == 'diPinjam') {
                      pinjamanC.returnProduct(controller.data.value?.id ?? '');
                    } else {
                      pinjamanC.cancelPeminjaman(
                        controller.data.value?.id ?? '',
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    backgroundColor: controller.data.value?.status == 'diPinjam'
                        ? AppColors.primary
                        : AppColors.error,
                    foregroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        controller.data.value?.status == 'diPinjam'
                            ? Icons.exit_to_app
                            : Icons.cancel_rounded,
                      ),
                      SizedBox(width: 5),
                      Text(
                        controller.data.value?.status == 'diPinjam'
                            ? 'Kembalikan'
                            : 'Batalkan',
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class TimeLineItem extends StatelessWidget {
  final bool iscompleted;
  final bool isLast;
  final Widget title;
  final Widget subTitle;

  const TimeLineItem({
    super.key,
    required this.iscompleted,
    this.isLast = false,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: iscompleted
                    ? AppColors.primary
                    : AppColors.textSecondary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: iscompleted
                  ? Icon(Icons.check, size: 15, color: AppColors.surface)
                  : null,
            ),

            if (!isLast)
              Container(
                width: 2,
                height: 40,
                decoration: BoxDecoration(
                  color: iscompleted
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
          ],
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, subTitle],
          ),
        ),
      ],
    );
  }
}
