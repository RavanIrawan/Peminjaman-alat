import 'package:cloud_firestore/cloud_firestore.dart';
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
  final now = DateTime.now().obs;

  get tenggatWaktu => now.value.add(Duration(days: selectedDuration.value!));

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
    DateTime now,
    int duration,
    DateTime tenggat,
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
        Timestamp.fromDate(now),
        duration,
        Timestamp.fromDate(tenggat),
        'menunggu_persetujuan',
        0,
        data,
        '',
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
        Timestamp.fromDate(now.value),
        selectedDuration.value!,
        Timestamp.fromDate(tenggatWaktu),
        'menunggu_persetujuan',
        0,
        data,
        '',
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
}
