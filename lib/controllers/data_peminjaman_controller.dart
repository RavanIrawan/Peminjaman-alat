import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/models/detail_peminjaman.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';
import 'package:peminjaman_alat/providers/data_peminjaman_provider.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/utils/url_default_profile.dart';

class DataPeminjamanController extends GetxController {
  final _provider = Get.find<DataPeminjamanProvider>();
  final dataPeminjaman = <PeminjamanModel>[].obs;
  final dataPeminjamanSementara = <PeminjamanModel>[].obs;
  final dataAll = <PeminjamanModel>[].obs;
  final isLoading = false.obs;
  final listStatus = ['selesai', 'diPinjam', 'di_kembalikan'];
  Rx<String?> selectedStatus = Rx<String?>(null);
  final keyword = ''.obs;
  final isSearch = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await getAllData();
    getDataWithStatusDiPinjam();
  }

  void searchData(String value) {
    keyword.value = value;
    applyFilter();
  }

  void selectStatus(String value) {
    if (selectedStatus.value == value) {
      selectedStatus.value = null;
    } else {
      selectedStatus.value = value;
    }
    applyFilter();
  }

  void applyFilter() {
    var filetredData = dataPeminjamanSementara.toList();

    if (selectedStatus.value != null) {
      filetredData = filetredData
          .where((element) => element.status == selectedStatus.value)
          .toList();
    }

    if (keyword.isNotEmpty) {
      filetredData = filetredData
          .where(
            (element) => element.namaPeminjam.toLowerCase().contains(
              keyword.toLowerCase(),
            ),
          )
          .toList();
    }

    if (filetredData.isEmpty) {
      dataPeminjaman.clear();
    } else {
      dataPeminjaman.assignAll(filetredData);
    }
  }

  void getDataWithStatusDiPinjam() {
    final dataWithStatusDiPinjam = dataAll
        .where(
          (element) =>
              element.status == 'diPinjam' ||
              element.status == 'di_kembalikan' ||
              element.status == 'selesai',
        )
        .toList();

    dataPeminjaman.addAll(dataWithStatusDiPinjam);
    dataPeminjamanSementara.addAll(dataWithStatusDiPinjam);
  }

  Future<void> getAllData() async {
    isLoading.value = true;
    try {
      final response = await _provider.getAllDataPeminjam();

      dataAll.clear();
      dataPeminjaman.clear();
      for (var peminjaman in response.docs) {
        final data = peminjaman.data() as Map<String, dynamic>;
        List<DetailPeminjaman> detailPinjaman = [];
        for (var detail in data['detailPinjaman']) {
          final dataDetail = DetailPeminjaman(
            productId: detail['productId'] ?? '',
            gambar: detail['gambar'] ?? UrlDefaultProfile.url,
            nama: detail['nama'] ?? '',
            qty: detail['qty'] ?? 0,
          );

          detailPinjaman.add(dataDetail);
        }

        final peminjamanModel = PeminjamanModel(
          id: peminjaman.id,
          denda: data['denda'] ?? 0,
          detailPinjaman: detailPinjaman,
          durasi: data['durasiHari'],
          idPeminjam: data['idPeminjam'] ?? '',
          status: data['status'] ?? '',
          tanggalPengajuan: (data['tanggalPengajuan'] as Timestamp).toDate(),
          profilePeminjam: data['profilePeminjam'] ?? '',
          namaPeminjam: data['namaPeminjam'] ?? '',
          alasanPenolakan: data['alasanPenolakan'] ?? '',
          tanggalDitolak: data['tanggalDitolak'] != null
              ? (data['tanggalDitolak'] as Timestamp).toDate()
              : null,
          tanggalKembali: data['tanggalKembali'] != null
              ? (data['tanggalKembali'] as Timestamp).toDate()
              : null,
          tanggalPinjam: data['tanggalPinjam'] != null
              ? (data['tanggalPinjam'] as Timestamp).toDate()
              : null,
          tenggatWaktu: data['tenggatWaktu'] != null
              ? (data['tenggatWaktu'] as Timestamp).toDate()
              : null,
        );
        dataAll.add(peminjamanModel);
      }
    } catch (error) {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat mengambil data',
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
