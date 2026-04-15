import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/models/detail_peminjaman.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';
import 'package:peminjaman_alat/providers/pengembalian_providerd.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/utils/convert_to_rupiah.dart';
import 'package:peminjaman_alat/utils/url_default_profile.dart';

class DataPengembalianController extends GetxController {
  final dataPengembalianAll = <PeminjamanModel>[].obs;
  final _provider = Get.find<DataPengembalianProvider>();
  final _authC = Get.find<AuthController>();
  final isLoading = false.obs;
  final isLoadingSecond = false.obs;
  final keyword = ''.obs;
  double radius = 50.0;
  final tab = [Tab(text: 'Dikembalikan'), Tab(text: 'Selesai')];
  final showChoice = false.obs;
  final catatan = ''.obs;

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

  List<PeminjamanModel> get dataWithStatusDibatalkanAdmin {
    return dataPengembalianAll.where((value) {
      final isStatusMatch = value.status == 'dibatalkan_admin';

      return isStatusMatch;
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
            tanggalBarangKembali:
                dataPengembalian['tanggalBarangKembali'] != null
                ? (dataPengembalian['tanggalBarangKembali'] as Timestamp)
                      .toDate()
                : null,
            tanggalDitolakAdmin: dataPengembalian['tanggalDitolakAdmin'] != null
                ? (dataPengembalian['tanggalDitolakAdmin'] as Timestamp)
                      .toDate()
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

  int countFineMonetary(DateTime tenggat) {
    final dayNow = DateTime.now();
    final now = DateTime(dayNow.year, dayNow.month, dayNow.day);
    final tenggatWaktu = DateTime(tenggat.year, tenggat.month, tenggat.day);

    final countMonetary = now.difference(tenggatWaktu).inDays;

    if (countMonetary > 0) {
      final dendaperhari = 10000;
      return countMonetary * dendaperhari;
    }
    return 0;
  }

  Future<void> selesaikanPeminjamanUser(
    String? id,
    PeminjamanModel data,
  ) async {
    isLoading.value = true;

    final fine = countFineMonetary(data.tenggatWaktu ?? DateTime.now());
    final indexData = dataPengembalianAll.indexWhere(
      (element) => element.id == id,
    );

    if (indexData == -1) {
      Get.snackbar(
        'Gagal',
        'Data barang Tidak ada di dalam document',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
      return;
    }

    if (id != null && id != '') {
      dataPengembalianAll.removeAt(indexData);
      dataPengembalianAll.refresh();

      try {
        await _provider.selesaikanPeminjaman(
          id,
          fine,
          data,
          _authC.userWithModel.value?.id ?? '',
          _authC.userWithModel.value?.nama ?? '',
        );
        isLoading.value = false;
        Get.snackbar(
          'Berhasil',
          'Berhasil menyelesaikan peminjaman ${data.namaPeminjam}',
          backgroundColor: AppColors.primary,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.check_circle),
          colorText: AppColors.background,
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
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Gagal',
        'Data barang Tidak Ditemukan',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }
  }

  Future<void> rejectPengembalian(String id) async {
    isLoading.value = true;

    final index = dataPengembalianAll.indexWhere((element) => element.id == id);
    if (index == -1) {
      isLoading.value = false;
      Get.snackbar(
        'Gagal',
        'Data tidak ada',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
      return;
    }

    dataPengembalianAll.removeAt(index);
    try {
      await _provider.rejectPengembalian(id);
      isLoading.value = false;
      Get.snackbar(
        'Berhasil',
        'Data pengembalian berhasil ditolak',
        backgroundColor: AppColors.primary,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.check_circle),
        colorText: AppColors.background,
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

  Future<void> deleteDataByAdmin(String id, PeminjamanModel data) async {
    isLoading.value = true;
    final indexDataPeminjaman = dataPengembalianAll.indexWhere(
      (element) => element.id == id,
    );

    if (indexDataPeminjaman == -1) {
      isLoading.value = false;
      Get.snackbar(
        'Gagal',
        'Data tidak ada',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
      return;
    }

    dataPengembalianAll.removeAt(indexDataPeminjaman);
    try {
      await _provider.softDelete(
        id,
        _authC.userWithModel.value?.id ?? '',
        _authC.userWithModel.value?.nama ?? '',
        data.namaPeminjam,
        data,
        catatan.value,
      );
      isLoading.value = false;
      Get.snackbar(
        'Berhasil',
        'Data pengembalian berhasil hapus',
        backgroundColor: AppColors.primary,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.check_circle),
        colorText: AppColors.background,
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

  void showBottomSheetsForReject(String id, PeminjamanModel data) {
    Get.bottomSheet(
      isScrollControlled: true,
      enterBottomSheetDuration: Duration(milliseconds: 400),
      exitBottomSheetDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          height: 500,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alasan Data Dihapus',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Beri tahu peminjam mengapa peminjaman akan dihapus. Pesan ini akan dikirimkan secara otomatis",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Detail Alasan'.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        maxLines: 4,
                        onChanged: (value) {
                          catatan.value = value;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.textSecondary.withValues(
                            alpha: 0.1,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'Inter',
                            fontSize: 14,
                          ),
                          hintText:
                              'Contoh: Data diri peminjam tidak lengkap...',
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                deleteDataByAdmin(id, data);
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                'Hapus data',
                                style: TextStyle(
                                  color: AppColors.surface,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showBottomSheetsForDetail(BuildContext context, PeminjamanModel data) {
    Get.bottomSheet(
      isScrollControlled: true,
      enterBottomSheetDuration: Duration(milliseconds: 400),
      exitBottomSheetDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Peminjaman',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '#${data.id}',
                        style: TextStyle(
                          color: AppColors.success,
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: data.status == 'selesai'
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : AppColors.textSecondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: AppColors.textPrimary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          data.status == 'selesai'
                              ? 'selesai'.toUpperCase()
                              : 'unkown'.toUpperCase(),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.textSecondary,
                    backgroundImage: NetworkImage(data.profilePeminjam),
                    radius: 35,
                    onBackgroundImageError: (exception, stackTrace) =>
                        Icon(Icons.image_not_supported_sharp),
                  ),
                  SizedBox(width: 10),
                  Text(
                    data.namaPeminjam,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(color: AppColors.textSecondary, thickness: 0.2),
              SizedBox(height: 10),
              Text(
                'barang dipinjam'.toUpperCase(),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.detailPinjaman.map((e) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              e.gambar,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    e.nama,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'qty: ${e.qty}'.toUpperCase(),
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Dipinjam',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontFamily: 'Inter',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(data.tanggalPinjam ?? DateTime.now()),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.access_alarm,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'TenggatWaktu',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontFamily: 'Inter',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(data.tenggatWaktu ?? DateTime.now()),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.redo_outlined,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Dikembalikan',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontFamily: 'Inter',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(data.tanggalBarangKembali ?? DateTime.now()),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status Pengembalian',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text(
                    'Terlambat - ${ConvertToRupiah.convertToRupiah(data.denda)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.error,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: BoxBorder.all(color: AppColors.warning),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.notes_sharp,
                      size: 18,
                      color: Colors.deepOrangeAccent,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Catatan Admin: ${data.catatanAdmin}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.warning,
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )
                      ),
                      child: Text('Tutup', style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                      ),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
