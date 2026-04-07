import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/models/detail_peminjaman.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';
import 'package:peminjaman_alat/providers/peminjam/pinjaman_provider.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:lottie/lottie.dart';

class PinjamanController extends GetxController {
  StreamSubscription? _streamSubscription;
  final data = <PeminjamanModel>[].obs;
  final dataPeminjaman = <PeminjamanModel>[].obs;
  final dataPeminjamanDiAjukan = <PeminjamanModel>[].obs;
  final dataPeminjamanSelesai = <PeminjamanModel>[].obs;
  final dataPeminjamanDitolak = <PeminjamanModel>[].obs;

  final _provider = Get.find<PinjamanProvider>();
  final _authC = Get.find<AuthController>();
  final isLoading = true.obs;
  final isLoadingP = true.obs;
  DateTime currentDay = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    getDataBarang();
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }

  void clearData() {
    _streamSubscription?.cancel();
    data.clear();
    dataPeminjaman.clear();
    dataPeminjamanDiAjukan.clear();
    dataPeminjamanSelesai.clear();
    dataPeminjamanDitolak.clear();
  }

  bool checkTenggatWaktu(String id) {
    final index = data.indexWhere((element) => element.id == id);
    DateTime now = DateTime(currentDay.year, currentDay.month, currentDay.day);
    if (index != -1) {
      final prodId = data[index];
      if (now.isAfter(prodId.tenggatWaktu ?? DateTime.now())) {
        return true;
      }
    }
    return false;
  }

  void getDataBarang() {
    isLoading.value = true;
    try {
      final uid = _authC.user.value?.uid;

      if (uid == null) return;
      _streamSubscription?.cancel();

      _streamSubscription = _provider.getData(uid).listen((event) {
        data.clear();
        dataPeminjaman.clear();
        dataPeminjamanDiAjukan.clear();
        dataPeminjamanSelesai.clear();
        dataPeminjamanDitolak.clear();

        for (var dataRes in event.docs) {
          final res = dataRes.data() as Map<String, dynamic>;
          final detail = <DetailPeminjaman>[];
          for (var detailPinjaman in res['detailPinjaman']) {
            final detailData = DetailPeminjaman(
              productId: detailPinjaman['productId'],
              nama: detailPinjaman['nama'],
              qty: detailPinjaman['qty'],
              gambar: detailPinjaman['gambar'],
            );

            detail.add(detailData);
          }

          final peminjaman = PeminjamanModel(
            id: dataRes.id,
            denda: res['denda'] ?? 0,
            detailPinjaman: detail,
            durasi: res['durasiHari'] ?? 0,
            idPeminjam: res['idPeminjam'] ?? '',
            status: res['status'] ?? '',
            tanggalPengajuan: res['tanggalPengajuan'] != null
                ? (res['tanggalPengajuan'] as Timestamp).toDate()
                : DateTime.now(),
            tanggalKembali: res['tanggalKembali'] != null
                ? (res['tanggalKembali'] as Timestamp).toDate()
                : null,
            tanggalPinjam: res['tanggalPinjam'] != null
                ? (res['tanggalPinjam'] as Timestamp).toDate()
                : null,
            tenggatWaktu: res['tenggatWaktu'] != null
                ? (res['tenggatWaktu'] as Timestamp).toDate()
                : null,
            alasanPenolakan: res['alasanPenolakan'] ?? '',
            tanggalDitolak: res['tanggalDitolak'] == null
                ? null
                : (res['tanggalDitolak'] as Timestamp).toDate(),
            profilePeminjam: res['profilePeminjam'],
            namaPeminjam: res['namaPeminjam'] ?? '',
          );

          data.add(peminjaman);

          if (peminjaman.status == 'menunggu_persetujuan') {
            dataPeminjamanDiAjukan.add(peminjaman);
          } else if (peminjaman.status == 'diPinjam' ||
              peminjaman.status == 'di_kembalikan') {
            dataPeminjaman.add(peminjaman);
          } else if (peminjaman.status == 'selesai') {
            dataPeminjamanSelesai.add(peminjaman);
          } else if (peminjaman.status == 'di_tolak') {
            dataPeminjamanDitolak.add(peminjaman);
          }
        }
      });
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error: $error',
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

  Future<void> cancelPeminjaman(String id) async {
    bool isCanceled = await Get.defaultDialog(
      backgroundColor: AppColors.surface,
      titlePadding: EdgeInsets.zero,
      title: '',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lotties/cancel.json',
            height: 90,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            'Batalkan Pinjaman?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Apakah kamu yakin ingin membatalkan pengajuan ini?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontFamily: 'Inter',
              fontSize: 13,
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(result: true);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text('Batalkan Pinjaman'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back(result: false);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text('Tidak'),
      ),
    );

    if (isCanceled != true) return;
    isLoading.value = true;
    try {
      await _provider.cancelPinjaman(id);
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error: $error',
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

  Future<void> returnProduct(String id) async {
    isLoadingP.value = true;

    final indexData = data.indexWhere((element) => element.id == id);
    final indexproductPinjam = dataPeminjaman.indexWhere(
      (element) => element.id == id,
    );

    if (indexData != -1) {
      data[indexData].status = 'di_kembalikan';

      if (indexproductPinjam != -1) {
        dataPeminjaman[indexproductPinjam].status = 'di_kembalikan';
      }

      try {
        await _provider.returProduct(id);
        Get.defaultDialog(
          barrierDismissible: false,
          backgroundColor: AppColors.surface,
          title: '',
          titlePadding: EdgeInsets.zero,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lotties/successTransactionUser.json',
                height: 100,
                fit: BoxFit.cover,
                repeat: false,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Pengembalian Berhasil',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sistem telah mencatat pengembalianmu. Silakan serahkan fisik alat ke Admin untuk dilakukan pengecekan kondisi barang.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: Text(
                'Kembali',
                style: TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ),
          ],
        );
      } catch (error) {
        Get.snackbar(
          'Error',
          'Error: $error',
          backgroundColor: AppColors.error,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.warning),
          colorText: AppColors.background,
        );
      } finally {
        isLoadingP.value = false;
      }
    } else {
      Get.snackbar(
        'Error',
        'Error: Product Tidak di temukan',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }
  }
}
