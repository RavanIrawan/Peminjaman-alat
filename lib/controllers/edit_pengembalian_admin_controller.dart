import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/controllers/data_pengembalian_controller.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';
import 'package:peminjaman_alat/providers/edit_pengembalian_admin_provider.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/utils/saved_data_dialog.dart';

class EditPengembalianAdminController extends GetxController {
  final _provider = Get.find<EditPengembalianAdminProvider>();
  final pengembalianC = Get.find<DataPengembalianController>();
  final _authC = Get.find<AuthController>();
  TextEditingController? tanggalBarangKembali;
  TextEditingController? dendaC;
  TextEditingController? catatanAdmin;
  Rx<PeminjamanModel?> dataPengembalian = Rx<PeminjamanModel?>(null);
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    insertdata();

    tanggalBarangKembali = TextEditingController();
    dendaC = TextEditingController();
    catatanAdmin = TextEditingController();

    if (dataPengembalian.value?.tanggalBarangKembali != null) {
      tanggalBarangKembali?.text = DateFormat(
        'MM/dd/yyyy',
      ).format(dataPengembalian.value?.tanggalBarangKembali ?? DateTime.now());
    } else {
      tanggalBarangKembali?.text = DateFormat(
        'MM/dd/yyyy',
      ).format(DateTime.now());
    }
  }

  @override
  void onClose() {
    tanggalBarangKembali?.dispose();
    dendaC?.dispose();
    catatanAdmin?.dispose();
    super.onClose();
  }

  void selecDate(BuildContext context) async {
    final dateSelected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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

    if (dateSelected != null) {
      selectedDate.value = dateSelected;
      tanggalBarangKembali?.text = DateFormat(
        'MM/dd/yyyy',
      ).format(dateSelected);
    }
  }

  Future<void> editDatapengembalian(
    String? id,
    DateTime? tanggalBarangKembaliBaru,
    String catatanAdminBaru,
  ) async {
    isLoading.value = true;
    final indexData = pengembalianC.dataPengembalianAll.indexWhere(
      (element) => element.id == id,
    );

    if (indexData == -1) {
      isLoading.value = false;
      Get.snackbar(
        'Gagal',
        'Data tidak ditemukan',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
      return;
    }

    final totalDenda = dendaC?.text.replaceAll('.', '').trim();
    final denda = int.tryParse(totalDenda ?? '') ?? 0;

    final dataLama = pengembalianC.dataPengembalianAll[indexData];
    final isTanggalSama =
        dataLama.tanggalBarangKembali == tanggalBarangKembaliBaru;
    final isDendaSama = dataLama.denda == denda;
    final isCatatanSama = dataLama.catatanAdmin == catatanAdminBaru;

    if (isTanggalSama && isDendaSama && isCatatanSama) {
      isLoading.value = false;
      Get.snackbar(
        'Info',
        'Tidak ada perubahan data yang dilakukan.',
        backgroundColor: Colors.blue.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    pengembalianC.dataPengembalianAll[indexData].denda = denda;
    pengembalianC.dataPengembalianAll[indexData].tanggalBarangKembali =
        tanggalBarangKembaliBaru;
    pengembalianC.dataPengembalianAll[indexData].catatanAdmin =
        catatanAdminBaru;

    pengembalianC.dataPengembalianAll.refresh();

    try {
      dynamic tanggalPayload;

      if (tanggalBarangKembaliBaru != null) {
        tanggalPayload = Timestamp.fromDate(tanggalBarangKembaliBaru);
      } else {
        tanggalPayload = null;
      }

      await _provider.editpengembalian(
        id ?? dataLama.id!,
        tanggalPayload,
        denda,
        catatanAdminBaru,
        _authC.userWithModel.value?.id ?? '',
        _authC.userWithModel.value?.nama ?? '',
        dataPengembalian.value?.namaPeminjam ?? '',
      );
      isLoading.value = false;
      SavedDataDialog().showSavedDataDialog(
        'Berhasil',
        'Data pengembalian berhasil di ubah',
        false,
      );
    } catch (error) {
      isLoading.value = false;
      Get.snackbar(
        'Gagal',
        'Error $error',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }
  }

  void insertdata() {
    final argument = Get.arguments as PeminjamanModel?;

    if (argument != null) {
      dataPengembalian.value = argument;
    }
  }
}
