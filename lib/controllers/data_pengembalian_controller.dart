import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/models/detail_peminjaman.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';
import 'package:peminjaman_alat/providers/pengembalian_providerd.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/utils/url_default_profile.dart';

class DataPengembalianController extends GetxController {
  final dataPengembalianAll = <PeminjamanModel>[].obs;
  final _provider = Get.find<DataPengembalianProvider>();
  final isLoading = false.obs;
  final keyword = ''.obs;
  double radius = 50.0;
  final tab = [Tab(text: 'Dikembalikan'), Tab(text: 'Selesai')];
  final showChoice = false.obs;

  List<PeminjamanModel> get dataWithStatusDikembalikan {
    return dataPengembalianAll.where((value) {
      final isStatusMatch = value.status == 'di_kembalikan';
      final isKeywordMatch =
          value.namaPeminjam.toLowerCase().contains(
            keyword.value.toLowerCase(),
          ) ||
          value.id!.toLowerCase().contains(keyword.value.toLowerCase());

      return isStatusMatch && isKeywordMatch;
    }).toList();
  }

  List<PeminjamanModel> get dataWithStatusSelesai {
    return dataPengembalianAll.where((value) {
      final isStatusMatch = value.status == 'selesai';
      final isKeywordMatch =
          value.namaPeminjam.toLowerCase().contains(
            keyword.value.toLowerCase(),
          ) ||
          value.id!.toLowerCase().contains(keyword.value.toLowerCase());

      return isStatusMatch && isKeywordMatch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    getAllDataPengembalian();
  }

  void searchDataWithkeyword(String value) {
    keyword.value = value;
  }

  Future<void> getAllDataPengembalian() async {
    isLoading.value = true;
    try {
      final response = await _provider.getAllData();

      if (response.docs.isNotEmpty) {
        dataPengembalianAll.clear();

        for (var data in response.docs) {
          final dataPengembalian = data.data() as Map<String, dynamic>;

          List<DetailPeminjaman> dataDetail = [];
          for (var detail in dataPengembalian['detailPinjaman']) {
            final detailPinjaman = DetailPeminjaman(
              productId: detail['productId'] ?? '',
              nama: detail['nama'] ?? 'guest',
              gambar: detail['gambar'],
              qty: detail['qty'] ?? 0,
            );

            dataDetail.add(detailPinjaman);
          }

          final pengembalianData = PeminjamanModel(
            id: data.id,
            denda: dataPengembalian['denda'] ?? 0,
            detailPinjaman: dataDetail,
            durasi: dataPengembalian['durasiHari'],
            idPeminjam: dataPengembalian['idPeminjam'] ?? '',
            status: dataPengembalian['status'] ?? 'unkownn',
            tanggalPengajuan:
                (dataPengembalian['tanggalPengajuan'] as Timestamp).toDate(),
            profilePeminjam:
                dataPengembalian['profilePeminjam'] ?? UrlDefaultProfile.url,
            namaPeminjam: dataPengembalian['namaPeminjam'] ?? 'guest',
            alasanPenolakan: dataPengembalian['alasanPenolakan'] ?? '',
            catatanAdmin: dataPengembalian['catatanAdmin'] ?? '',
            tanggalDitolak: dataPengembalian['tanggalDitolak'] != null
                ? (dataPengembalian['tanggalDitolak'] as Timestamp).toDate()
                : null,
            tanggalKembali: dataPengembalian['tanggalKembali'] != null
                ? (dataPengembalian['tanggalKembali'] as Timestamp).toDate()
                : null,
            tanggalPinjam: dataPengembalian['tanggalPinjam'] != null
                ? (dataPengembalian['tanggalPinjam'] as Timestamp).toDate()
                : null,
            tenggatWaktu: dataPengembalian['tenggatWaktu'] != null
                ? (dataPengembalian['tenggatWaktu'] as Timestamp).toDate()
                : null,
          );

          dataPengembalianAll.add(pengembalianData);
        }
      }
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
}
