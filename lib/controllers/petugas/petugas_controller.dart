import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/models/detail_peminjaman.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';
import 'package:peminjaman_alat/providers/petugas/petugas_provider.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/utils/url_default_profile.dart';

class PetugasController extends GetxController {
  final allData = <PeminjamanModel>[].obs;
  final allDataPersetujuan = <PeminjamanModel>[].obs;
  final allDataDiPinjam = <PeminjamanModel>[].obs;
  StreamSubscription? _streamSubscription;
  final _provider = Get.find<PetugasProvider>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllData();
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }

  void clearData() {
    _streamSubscription?.cancel();
    allData.clear();
    allDataPersetujuan.clear();
  }

  void getAllData() {
    isLoading.value = true;

    try {
      _streamSubscription?.cancel();

      _streamSubscription = _provider.getAllPeminjaman().listen((event) {
        allData.clear();
        allDataPersetujuan.clear();
        allDataDiPinjam.clear();
        for (var data in event.docs) {
          final dataRes = data.data() as Map<String, dynamic>;
          final detailData = <DetailPeminjaman>[];
          for (var detail in data['detailPinjaman']) {
            final currentDetail = DetailPeminjaman(
              productId: detail['productId'] ?? '',
              nama: detail['nama'] ?? '',
              qty: detail['qty'] ?? 0,
              gambar: detail['gambar'] ?? UrlDefaultProfile.url,
            );

            detailData.add(currentDetail);
          }

          final dataPinjaman = PeminjamanModel(
            id: data.id,
            denda: dataRes['denda'] ?? 0,
            detailPinjaman: detailData,
            durasi: dataRes['durasiHari'] ?? 0,
            idPeminjam: dataRes['idPeminjam'] ?? '',
            status: dataRes['status'] ?? 'menunggu_persetujuan',
            tanggalPengajuan: dataRes['tanggalpengajuan'] != null
                ? (dataRes['tanggalPengajuan'] as Timestamp).toDate()
                : DateTime.now(),
            tanggalPinjam: dataRes['tanggalPinjam'] != null
                ? (dataRes['tanggalPinjam'] as Timestamp).toDate()
                : null,
            tenggatWaktu: dataRes['tenggatWaktu'] != null
                ? (dataRes['tenggatWaktu'] as Timestamp).toDate()
                : null,
            alasanPenolakan: dataRes['alasanPenolakan'] ?? '',
            tanggalDitolak: dataRes['tanggalDitolak'] != null
                ? (dataRes['tanggalDitolak'] as Timestamp).toDate()
                : null,
            tanggalKembali: dataRes['tanggalKembali'] != null
                ? (dataRes['tanggalKembali'] as Timestamp).toDate()
                : null,
            profilePeminjam: dataRes['profilePeminjam'],
            namaPeminjam: dataRes['namaPeminjam'] ?? 'Guest',
            catatanAdmin: dataRes['catatanAdmin'] ?? '',
            tanggalBarangKembali: dataRes['tanggalBarangKembali'] != null
                ? (dataRes['tanggalBarangKembali'] as Timestamp).toDate()
                : null,
            tanggalDitolakAdmin: dataRes['tanggalDiTolakAdmin'] != null
                ? (dataRes['tanggalDiTolakAdmin'] as Timestamp).toDate()
                : null,
          );

          allData.add(dataPinjaman);

          if (dataPinjaman.status == 'menunggu_persetujuan') {
            allDataPersetujuan.add(dataPinjaman);
          } else if (dataPinjaman.status == 'diPinjam' ||
              dataPinjaman.status == 'di_kembalikan') {
            allDataDiPinjam.add(dataPinjaman);
          }
        }
      });
    } on FirebaseException catch (error) {
      Get.snackbar(
        'Gagal',
        error.message ?? 'Gagal data kategori tidak di temukan',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    } catch (error) {
      Get.snackbar(
        'Gagal',
        '$error',
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
}
