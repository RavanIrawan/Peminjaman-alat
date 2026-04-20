import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/controllers/peminjam/home_peminjaman_product_controller.dart';
import 'package:peminjaman_alat/models/alat_model.dart';
import 'package:peminjaman_alat/models/keranjang_model.dart';
import 'package:peminjaman_alat/providers/peminjam/keranjang_provider.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/utils/saved_data_dialog.dart';
import 'package:flutter/material.dart';

class KeranjangController extends GetxController {
  final cartItems = <KeranjangModel>[].obs;
  final _provider = Get.find<KeranjangProvider>();
  final _prodC = Get.find<HomePeminjamanProductController>();
  final _authC = Get.find<AuthController>();
  final isLoading = false.obs;
  final isLoadingDetail = false.obs;
  final durasi = [1, 2, 3, 4, 5, 6, 7];
  Rx<int?> selectedDuration = Rx<int?>(3);

  int get itemLength => cartItems.length;

  int? getProdQty(String id) {
    final item = cartItems.firstWhereOrNull(
      (element) => element.products.id == id,
    );

    return item?.qty ?? 0;
  }

  void addCartItem(AlatModel item) {
    final indexProductItem = cartItems.indexWhere(
      (element) => element.products.id == item.id,
    );

    if (indexProductItem != -1) {
      cartItems[indexProductItem].qty++;
      cartItems.refresh();
    } else {
      cartItems.add(KeranjangModel(products: item, qty: 1));
    }
  }

  void addQty(String id) {
    final indexItem = cartItems.indexWhere(
      (element) => element.products.id == id,
    );
    final indexAlat = _prodC.alat.indexWhere((element) => element.id == id);

    if (indexItem != -1 && indexAlat != -1) {
      if (cartItems[indexItem].qty >= _prodC.alat[indexAlat].stok!) {
        Get.snackbar(
          'Stok Terbatas',
          'Kamu sudah mencapai batas maksimal stok yang tersedia',
          backgroundColor: AppColors.warning,
          snackPosition: SnackPosition.TOP,
          animationDuration: const Duration(milliseconds: 800),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.warning_amber_rounded),
          colorText: AppColors.background,
        );
      } else {
        cartItems[indexItem].qty++;
        cartItems.refresh();
      }
    }
  }

  void minCartItem(String id) {
    final indexProductItem = cartItems.indexWhere(
      (element) => element.products.id == id,
    );

    if (indexProductItem != -1) {
      if (cartItems[indexProductItem].qty > 1) {
        cartItems[indexProductItem].qty--;
        cartItems.refresh();
      } else {
        cartItems.removeAt(indexProductItem);
      }
    }
  }

  void removeProd(String id) {
    final index = cartItems.indexWhere((element) => element.products.id == id);

    if (index != -1) {
      cartItems.removeAt(index);
    } else {
      Get.snackbar(
        'Gagal',
        'Product tidak ada',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    }
  }

  Future<void> userTransactionInDetail(
    String id,
    String nama,
    int qty,
    int duration,
    String gambar,
  ) async {
    if (qty == 0) return;
    isLoadingDetail.value = true;
    try {
      final data = [
        {'productId': id, 'nama': nama, 'qty': qty, 'gambar': gambar},
      ];

      await _provider.transaction(
        _authC.user.value!.uid,
        duration,
        'menunggu_persetujuan',
        0,
        data,
        '',
        '${_authC.userWithModel.value?.profile}',
        '${_authC.userWithModel.value?.nama}',
        '',
        '${_authC.userWithModel.value?.phone}',
      );
      SavedDataDialog().showSavedDataDialog(
        'Pengajuan Berhasil!',
        'Permintaan peminjaman mu sudah terkirim, silahkan tunggu persetujuan dari petugas.',
        true,
      );
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
      isLoadingDetail.value = false;
    }
  }

  Future<void> userTransactionInCart() async {
    if (cartItems.isEmpty) return;
    isLoading.value = true;
    try {
      final data = cartItems.map((element) => element.toMap()).toList();

      await _provider.transaction(
        _authC.user.value!.uid,
        selectedDuration.value!,
        'menunggu_persetujuan',
        0,
        data,
        '',
        '${_authC.userWithModel.value?.profile}',
        '${_authC.userWithModel.value?.nama}',
        '',
        '${_authC.userWithModel.value?.phone}',
      );
      cartItems.clear();

      SavedDataDialog().showSavedDataDialog(
        'Pengajuan Berhasil!',
        'Permintaan peminjaman mu sudah terkirim, silahkan tunggu persetujuan dari petugas.',
        true,
      );
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

  void tampilkanDialogLengkapiProfil() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), 
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1), 
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.contact_phone_outlined, 
                  color: AppColors.primary, 
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Lengkapi Profil Anda',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Inter', 
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              Text(
                'Sistem mendeteksi Anda belum mendaftarkan nomor telepon. Silakan perbarui profil Anda terlebih dahulu agar dapat meminjam alat.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5, 
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(), 
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'Nanti Saja',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0, 
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50), 
                        ),
                      ),
                      child: const Text(
                        'Update Profil',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
