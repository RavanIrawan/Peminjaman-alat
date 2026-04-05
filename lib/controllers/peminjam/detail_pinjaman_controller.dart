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
      data.value!.tenggatWaktu.year,
      data.value!.tenggatWaktu.month,
      data.value!.tenggatWaktu.day,
    );
    DateTime now = DateTime(currentDay.year, currentDay.month, currentDay.day);
    iconAndTextView.assignAll([
      {
        'icon': Icons.calendar_today,
        'text': 'Tanggal Pinjam',
        'colorText': AppColors.textPrimary,
        'textContent': data.value?.tanggalPinjam,
      },
      {
        'icon': Icons.access_alarm,
        'text': 'Jatuh Tempo',
        'colorText': now.isAfter(tengatBersih!)
            ? AppColors.error
            : AppColors.primary,
        'textContent': data.value?.tenggatWaktu,
      },
    ]);
    super.onInit();
  }
}
