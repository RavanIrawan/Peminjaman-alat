import 'package:get/get.dart';
import 'package:peminjaman_alat/models/alat_model.dart';
import 'package:peminjaman_alat/models/kategori_model.dart';
import 'package:peminjaman_alat/providers/peminjam/home_peminjaman_product_provider.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomePeminjamanProductController extends GetxController {
  final kategori = <KategoriModel>[].obs;
  final alat = <AlatModel>[].obs;
  final alatDisplay = <AlatModel>[].obs;
  final _provider = Get.find<HomePeminjamanProductProvider>();
  final isLoading = false.obs;
  final keyword = ''.obs;
  Rx<String?> selectedLabel = Rx<String?>(null);
  final sortBy = ''.obs;

  @override
  void onInit() {
    getAllKategori();
    getAllAlatProduct();

    debounce(keyword, (callback) {
      searchProduct(keyword.value);
    }, time: Duration(milliseconds: 500));
    super.onInit();
  }

  void onSortBy(String value) {
    if (sortBy.value == value) {
      sortBy.value = '';
    } else {
      sortBy.value = value;
    }
    applyFilter();
  }

  void searchProduct(String key) {
    keyword.value = key;
    applyFilter();
  }

  void selecLabel(String id) {
    if (selectedLabel.value == id) {
      selectedLabel.value = null;
    } else {
      selectedLabel.value = id;
    }
    applyFilter();
  }

  void applyFilter() {
    var filterdList = alat.toList();

    if (selectedLabel.value != null) {
      filterdList = filterdList
          .where((element) => element.idKategori == selectedLabel.value)
          .toList();
    }

    if (keyword.value.isNotEmpty) {
      filterdList = filterdList
          .where(
            (element) => element.namaAlat!.toLowerCase().contains(
              keyword.value.toLowerCase(),
            ),
          )
          .toList();
    }

    if (sortBy.value == 'stok_terbanyak') {
      filterdList.sort((a, b) => b.stok!.compareTo(a.stok!));
    }

    if (sortBy.value == 'nama_az') {
      filterdList.sort((a, b) => a.namaAlat!.compareTo(b.namaAlat!));
    }

    if (filterdList.isEmpty) {
      alatDisplay.clear();
    } else {
      alatDisplay.assignAll(filterdList);
    }
  }

  String getKategoriName(String id) {
    final name = kategori.where((kategori) => kategori.id == id).firstOrNull;

    return name?.name ?? 'Unkown';
  }

  Future<void> getAllKategori() async {
    isLoading.value = true;
    try {
      final response = await _provider.getAllKategori();
      if (response.docs.isNotEmpty) {
        kategori.clear();
        for (var dataKate in response.docs) {
          final data = dataKate.data() as Map<String, dynamic>;

          final kategoriModel = KategoriModel(
            name: data['nama'],
            id: dataKate.id,
          );

          kategori.add(kategoriModel);
        }
      }
    } catch (error) {
      Get.snackbar(
        'Gagal',
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

  Future<void> getAllAlatProduct() async {
    isLoading.value = true;
    try {
      final response = await _provider.getAllAlat();
      if (response.docs.isNotEmpty) {
        alat.clear();
        alatDisplay.clear();
        for (var dataAlat in response.docs) {
          final data = dataAlat.data() as Map<String, dynamic>;

          final extractedData = AlatModel(
            id: dataAlat.id,
            namaAlat: data['nama'] ?? 'Unknown',
            idKategori: data['idKategori'] ?? 'Unkown',
            stok: data['stok'] ?? 0,
            gambar: data['gambar'],
            deskripsi: data['deskripsi'],
          );

          alat.add(extractedData);
          alatDisplay.add(extractedData);
        }
      }
    } catch (error) {
      Get.snackbar(
        'Gagal',
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
