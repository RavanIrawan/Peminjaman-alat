import 'package:get/get.dart';
import 'package:peminjaman_alat/models/alat_model.dart';
import 'package:peminjaman_alat/models/kategori_model.dart';
import 'package:peminjaman_alat/providers/alat_provider.dart';
import 'package:peminjaman_alat/providers/kategori_product_provider.dart';
import 'package:peminjaman_alat/utils/url_default_profile.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AlatController extends GetxController {
  final _provider = Get.find<AlatProvider>();
  final allAlat = <AlatModel>[].obs;
  final displayAlat = <AlatModel>[].obs;
  final kategori = <KategoriModel>[].obs;
  final isLoading = false.obs;
  final _kategoriProvider = KategoriProductProvider();
  final keyword = ''.obs;

  @override
  void onInit() async {
    await getKategori();
    await getAllAlat();

    debounce(keyword, (callback) {
      getAlatWithSearch(keyword.value);
    });
    super.onInit();
  }

  String getKategoriName(String id) {
    final searchResult = kategori.where((element) => element.id == id).firstOrNull;

    return searchResult?.name ?? 'Tidak diketahui';
  }

  void getAlatWithSearch(String key) {
    if (key.isEmpty) {
      displayAlat.assignAll(allAlat);
      return;
    }

    final searchKategoriName = kategori.where((kate) {
      return kate.name.toLowerCase().contains(key.toLowerCase());
    }).toList();

    final matchedNameKategory = searchKategoriName.map((e) => e.id).toList();

    final searchResult = allAlat.where((alat) {
      final alatName = alat.namaAlat!.toLowerCase().contains(key.toLowerCase());
      final kategoryName = matchedNameKategory.contains(alat.idKategori);

      return alatName || kategoryName;
    }).toList();

    if (searchResult.isEmpty) {
      displayAlat.clear();
    } else {
      displayAlat.assignAll(searchResult);
    }
  }

  Future<void> deleteProduct(String id) async {
    isLoading.value = true;
    final indexAlat = allAlat.indexWhere((element) => element.id == id);
    final indexAlatDisplay = displayAlat.indexWhere(
      (element) => element.id == id,
    );

    if (indexAlat != -1) {
      final alatByIndex = allAlat[indexAlat];

      allAlat.removeAt(indexAlat);

      AlatModel? displayAlatByIndex;
      if (indexAlatDisplay != -1) {
        displayAlatByIndex = displayAlat[indexAlatDisplay];
        displayAlat.removeAt(indexAlatDisplay);
      }

      try {
        await _provider.deleteAlat(id);
        Get.snackbar(
          'Berhasil',
          'Berhasil menghapus product',
          backgroundColor: AppColors.primary,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.check_circle),
          colorText: AppColors.background,
        );
      } catch (error) {
        allAlat.insert(indexAlat, alatByIndex);
        if (indexAlatDisplay != -1 && displayAlatByIndex != null) {
          displayAlat.insert(indexAlatDisplay, displayAlatByIndex);
        }
        Get.snackbar(
          'Error',
          'Error: $Error',
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
        'Error',
        'Data tidak di temukan',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }
  }

  Future<void> getKategori() async {
    isLoading.value = true;
    try {
      final response = await _kategoriProvider.getKategori();

      if (response.docs.isNotEmpty) {
        for (var kategoriProvider in response.docs) {
          final kategoriData = kategoriProvider.data() as Map<String, dynamic>;

          final data = KategoriModel(
            name: kategoriData['nama'],
            id: kategoriData['idKategori'],
          );

          kategori.add(data);
        }
      } else {
        Get.snackbar(
          'Error',
          'Data pada Document/Collection kosong',
          backgroundColor: AppColors.error,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.warning),
          colorText: AppColors.background,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        ' Error: $error',
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

  Future<void> getAllAlat() async {
    isLoading.value = true;
    try {
      displayAlat.clear();
      final response = await _provider.getAlat();

      if (response.docs.isNotEmpty) {
        for (var dataProvider in response.docs) {
          final data = dataProvider.data() as Map<String, dynamic>;

          final dataAlat = AlatModel(
            id: dataProvider.id,
            namaAlat: data['nama'] ?? 'Unkown',
            idKategori: data['idKategori'] ?? 'Unkown',
            stok: data['stok'] ?? 0,
            gambar: data['gambar'] ?? UrlDefaultProfile.url,
            deskripsi: data['deskripsi'] ?? '-',
          );

          allAlat.add(dataAlat);
          displayAlat.add(dataAlat);
        }
      } else {
        Get.snackbar(
          'Info',
          'Data pada Document/Collection kosong',
          backgroundColor: AppColors.warning,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.warning),
          colorText: AppColors.background,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        ' Error: $error',
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

  void showDeleteDialog(String id) async {
    Get.defaultDialog(
      barrierDismissible: false,
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
          deleteProduct(id);
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
