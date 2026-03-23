import 'package:get/get.dart';
import 'package:peminjaman_alat/models/kategori_model.dart';
import 'package:peminjaman_alat/providers/alat_provider.dart';
import 'package:peminjaman_alat/providers/kategori_product_provider.dart';
import 'package:peminjaman_alat/utils/random_text.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class KategoriController extends GetxController {
  final dataKategori = <KategoriModel>[].obs;
  final dataKategoriEdit = <KategoriModel>[].obs;
  final dataAlatId = <String>[].obs;
  final isLoading = false.obs;
  final kategoriNameText = TextEditingController();
  final kategoriNameTextEdit = TextEditingController();
  final keyword = ''.obs;
  final _provider = Get.find<KategoriProductProvider>();
  final newIsEdit = ''.obs;
  final _alatProvider = AlatProvider();

  int? get dataKategoriLength => dataKategori.length;

  @override
  void onInit() async {
    await getAllkategori();
    await getAllAlatId();

    debounce(keyword, (callback) {
      searchDataKategory(keyword.value);
    }, time: Duration(milliseconds: 800));
    super.onInit();
  }

  @override
  void onClose() {
    kategoriNameText.dispose();
    super.onClose();
  }

  int checkAlatIdWithKategoriId(String id) {
    final idData = dataAlatId.where((i) => i == id,).length;

    return idData;
  }

  Future<void> getAllAlatId() async {
    isLoading.value = true;
    try {
      final response = await _alatProvider.getAlat();

      if (response.docs.isNotEmpty) {
        for (var alat in response.docs) {
          final data = alat.data() as Map<String, dynamic>;
          dataAlatId.add(data['idKategori']);
        }
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error $error',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }finally{
      isLoading.value = false;
    }
  }

  void toggleEditForm(String id) {
    if (newIsEdit.value == id) {
      newIsEdit.value = '';
    } else {
      newIsEdit.value = id;
    }
  }

  void searchDataKategory(String keyword) {
    if (keyword.isEmpty) {
      dataKategoriEdit.clear();
      newIsEdit.value = '';
      return;
    }

    final key = dataKategori
        .where((k) => k.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();

    if (key.isEmpty) {
      dataKategoriEdit.clear();
    } else {
      dataKategoriEdit.assignAll(key);
    }
  }

  Future<void> updateKategoriName(String id) async {
    final indexkategori = dataKategori.indexWhere(
      (element) => element.id == id,
    );
    final indexkategoriEdit = dataKategoriEdit.indexWhere(
      (element) => element.id == id,
    );

    if (indexkategori != -1) {
      dataKategori[indexkategori] = KategoriModel(
        id: id,
        name: kategoriNameTextEdit.text,
      );
      dataKategoriEdit[indexkategoriEdit] = KategoriModel(
        id: id,
        name: kategoriNameTextEdit.text,
      );

      try {
        await _provider.updateKategori(id, kategoriNameTextEdit.text);
        newIsEdit.value = '';

        Get.snackbar(
          'Berhasil',
          'Berhasil Mengedit kategori',
          backgroundColor: AppColors.primary,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.check_circle),
          colorText: AppColors.background,
        );
      } catch (error) {
        Get.snackbar(
          'Error',
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
      Get.snackbar(
        'Gagal',
        'Gagal data kategori tidak ditemukan',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }
  }

  Future<void> getAllkategori() async {
    try {
      isLoading.value = true;
      dataKategori.clear();

      final response = await _provider.getKategori();

      for (var dataIn in response.docs) {
        final data = dataIn.data() as Map<String, dynamic>;
        final extractedData = KategoriModel(name: data['nama'], id: dataIn.id);

        dataKategori.add(extractedData);
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error $error',
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

  Future<void> addNewKategori() async {
    isLoading.value = true;
    try {
      final randomId = RandomText().generateRandomString(28);

      await _provider.addKategori(randomId, kategoriNameText.text.trim());
      kategoriNameText.clear();

      await getAllkategori();

      Get.snackbar(
        'Berhasil',
        'Berhasil membuat kategori baru',
        backgroundColor: AppColors.primary,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.check_circle),
        colorText: AppColors.background,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Error $error',
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

  Future<void> deleteKategoriProduct(String id) async {
    isLoading.value = true;
    final indexKategori = dataKategori.indexWhere(
      (element) => element.id == id,
    );
    if (indexKategori != -1) {
      final dataBackup = dataKategori[indexKategori];
      try {
        dataKategori.removeAt(indexKategori);

        await _provider.deleteKategori(id);
        Get.snackbar(
          'Berhasil',
          'Berhasil menghapus kategori product',
          backgroundColor: AppColors.primary,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.check_circle),
          colorText: AppColors.background,
        );
      } catch (error) {
        dataKategori.insert(indexKategori, dataBackup);
        Get.snackbar(
          'Error',
          'Error $error',
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
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Gagal',
        'Gagal data kategori tidak di temukan',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }
  }

  void showDeleteDialog(String id) async {
    Get.defaultDialog(
      backgroundColor: AppColors.surface,
      titlePadding: EdgeInsets.zero,
      title: '',
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lotties/deleteIconAnimation.json',
            height: 90,
            fit: BoxFit.cover,
            repeat: false,
          ),
          SizedBox(height: 10),
          Text(
            'Hapus Data?',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Apakah Anda yakin ingin menghapus data ini? Tindakan ini dapat dibatalkan',
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
          Get.back();
          deleteKategoriProduct(id);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text('Hapus'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text('Batal'),
      ),
    );
  }
}
