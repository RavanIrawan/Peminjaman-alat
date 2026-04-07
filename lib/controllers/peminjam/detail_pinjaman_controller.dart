import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/peminjam/pinjaman_controller.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class DetailPinjamanController extends GetxController {
  Rx<PeminjamanModel?> data = Rx<PeminjamanModel?>(null);
  DateTime currentDay = DateTime.now();

  DateTime? tengatBersih;
  final iconAndTextView = [].obs;

  @override
  void onInit() {
    final dataProduct = Get.arguments as PeminjamanModel;

    final peminjamC = Get.find<PinjamanController>();

    data.value = peminjamC.data.firstWhereOrNull(
      (element) => element.id == dataProduct.id,
    );

    tengatBersih = DateTime(
      data.value?.tenggatWaktu?.year ?? DateTime.now().year,
      data.value?.tenggatWaktu?.month ?? DateTime.now().month,
      data.value?.tenggatWaktu?.day ?? DateTime.now().day,
    );
    DateTime now = DateTime(currentDay.year, currentDay.month, currentDay.day);
    iconAndTextView.assignAll([
      {
        'icon': Icons.schedule_send,
        'text': 'Tanggal Pengajuan',
        'colorText': AppColors.primary,
        'textContent': data.value?.tanggalPengajuan,
      },
      {
        'icon': Icons.calendar_today,
        'text': 'Tanggal Pinjam (Di Setujui Petugas)',
        'colorText': AppColors.textPrimary,
        'textContent': data.value?.tanggalPinjam,
      },
      {
        'icon': Icons.access_alarm,
        'text': 'Jatuh Tempo',
        'colorText': data.value?.tenggatWaktu != null
            ? (now.isAfter(tengatBersih!) ? AppColors.error : AppColors.primary)
            : AppColors.textPrimary,
        'textContent': data.value?.tenggatWaktu,
      },
    ]);
    super.onInit();
  }
}
