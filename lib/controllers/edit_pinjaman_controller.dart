import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';
import 'package:peminjaman_alat/providers/edit_pinjaman_provider.dart';
import 'package:intl/intl.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class EditPinjamanController extends GetxController {
  final _provider = Get.find<EditPinjamanProvider>();
  final _authC = Get.find<AuthController>();
  Rx<PeminjamanModel?> dataPeminjaman = Rx<PeminjamanModel?>(null);
  Rx<DateTime?> tanggalPinjam = Rx<DateTime?>(null);
  Rx<DateTime?> tenggatWaktu = Rx<DateTime?>(null);
  final isLoading = false.obs;
  Rx<String?> selectedStatus = Rx<String?>('diPinjam');
  final listStatus = ['selesai', 'di_kembalikan', 'diPinjam'];
  TextEditingController? tglPinjamC;
  TextEditingController? tenggatWaktuC;
  TextEditingController? catatanAdmin;

  @override
  void onInit() {
    super.onInit();
    getDataInArgument();
    tglPinjamC = TextEditingController();
    tenggatWaktuC = TextEditingController();
    catatanAdmin = TextEditingController();
    tenggatWaktuC?.text = DateFormat(
      'MM/dd/yyyy',
    ).format(dataPeminjaman.value?.tenggatWaktu ?? DateTime.now());
    tglPinjamC?.text = DateFormat(
      'MM/dd/yyyy',
    ).format(dataPeminjaman.value?.tanggalPinjam ?? DateTime.now());
  }

  @override
  void onClose() {
    tglPinjamC?.dispose();
    tenggatWaktuC?.dispose();
    catatanAdmin?.dispose();
    super.onClose();
  }

  void getDataInArgument() {
    final argument = Get.arguments as PeminjamanModel?;

    if (argument != null) {
      dataPeminjaman.value = argument;
    }
  }

  Future<void> updatePeminjaman(
    DateTime tanggalPinjam,
    DateTime tenggatWaktu,
  ) async {
    isLoading.value = true;
    try {
      await _provider.updateDataPeminjaman(
        dataPeminjaman.value?.id ?? '',
        selectedStatus.value ?? '',
        Timestamp.fromDate(tanggalPinjam),
        Timestamp.fromDate(tenggatWaktu),
        catatanAdmin?.text ?? '',
        dataPeminjaman.value!,
        _authC.userWithModel.value?.id ?? '',
        _authC.userWithModel.value?.nama ?? '',
      );
      Get.back();
    } catch (error) {
      Get.snackbar(
        'Error',
        'Sistem bermasalah $error',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<DateTime?> choseInCalender(BuildContext context, DateTime date) async {
    final datePicker = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      selectableDayPredicate: (day) {
        final tanggalPinjam = DateTime(date.year, date.month, date.day);
        if (day.isBefore(tanggalPinjam)) {
          return false;
        }
        return true;
      },
      barrierDismissible: true,
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    return datePicker;
  }
}
