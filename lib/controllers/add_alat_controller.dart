import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peminjaman_alat/controllers/alat_controller.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/models/alat_model.dart';
import 'package:peminjaman_alat/models/kategori_model.dart';
import 'package:peminjaman_alat/providers/add_alat_provider.dart';
import 'dart:io';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/saved_data_dialog.dart';

class AddAlatController extends GetxController {
  final _provider = Get.find<AddAlatProvider>();
  final _authC = Get.find<AuthController>();
  final isLoading = false.obs;
  final isUploading = false.obs;
  final _imagePicker = ImagePicker();
  final _getConnect = GetConnect();
  Rx<File?> imageFile = Rx<File?>(null);
  final oldImageUrl = Rx<String?>(null);
  final kategori = <KategoriModel>[].obs;
  Rx<String?> kategoriSelect = Rx<String?>(null);
  TextEditingController nameText = TextEditingController();
  TextEditingController stokText = TextEditingController();
  TextEditingController deskText = TextEditingController();
  final isEditMode = false.obs;
  String? idAlat = Get.arguments as String?;
  AlatModel? dataAlat;

  get selectedKategori => kategori.first;

  @override
  void onInit() {
    getAllKategori();
    checkEditMode();
    super.onInit();
  }

  @override
  void onClose() {
    imageFile.value = null;
    nameText.dispose();
    stokText.dispose();
    deskText.dispose();
    super.onClose();
  }

  void checkEditMode() {
    if (idAlat != null) {
      isEditMode.value = true;

      final alatC = Get.find<AlatController>();

      dataAlat = alatC.allAlat.firstWhere((element) => element.id == idAlat);

      nameText.text = dataAlat!.namaAlat!;
      stokText.text = dataAlat!.stok!.toString();
      deskText.text = dataAlat!.deskripsi!;
      kategoriSelect.value = dataAlat!.idKategori;
      oldImageUrl.value = dataAlat!.gambar;
    } else {
      isEditMode.value = false;
      oldImageUrl.value = null;
      nameText.clear();
      stokText.clear();
      deskText.clear();
      kategoriSelect.value = null;
    }
  }

  Future<void> updateAlatData() async {
    if (isEditMode.value) {
      isLoading.value = true;
      final alatC = Get.find<AlatController>();
      try {
        final indexAlat = alatC.allAlat.indexWhere(
          (element) => element.id == idAlat,
        );
        final indexAlatDisplay = alatC.displayAlat.indexWhere(
          (element) => element.id == idAlat,
        );
        if (indexAlat != -1) {
          String? finalUrlImage;

          if (imageFile.value != null) {
            final urlImage = await uploadIMageToCloudinary();

            if (urlImage == null) {
              isLoading.value = false;
              return;
            }
            finalUrlImage = urlImage;
          } else {
            finalUrlImage = oldImageUrl.value ?? '';
          }

          alatC.allAlat[indexAlat] = AlatModel(
            id: idAlat,
            namaAlat: nameText.text,
            idKategori: kategoriSelect.value,
            stok: int.parse(stokText.text),
            gambar: finalUrlImage,
            deskripsi: deskText.text,
          );
          if (indexAlatDisplay != -1) {
            alatC.displayAlat[indexAlatDisplay] = AlatModel(
              id: idAlat,
              namaAlat: nameText.text,
              idKategori: kategoriSelect.value,
              stok: int.parse(stokText.text),
              gambar: finalUrlImage,
              deskripsi: deskText.text,
            );
          }

          await _provider.updateAlat(
            idAlat!,
            nameText.text,
            kategoriSelect.value ?? '',
            int.parse(stokText.text),
            finalUrlImage,
            deskText.text,
            _authC.userWithModel.value?.id ?? '',
            _authC.userWithModel.value?.nama ?? '',
            dataAlat!,
          );
          SavedDataDialog().showSavedDataDialog(
            'Berhasil',
            'Data Barang barhasil di update',
            false,
          );
        } else {
          Get.snackbar(
            'Error',
            'Error data barang tidak ditemukan',
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
  }

  Future<void> getAllKategori() async {
    isLoading.value = true;
    try {
      final respose = await _provider.getKategori();

      if (respose.docs.isNotEmpty) {
        for (var kategoriAll in respose.docs) {
          final data = kategoriAll.data() as Map<String, dynamic>;

          final extractedData = KategoriModel(
            name: data['nama'],
            id: data['idKategori'],
          );
          kategori.add(extractedData);
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImageFormgallery() async {
    imageFile.value = null;

    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      imageFile.value = File(pickedImage.path);
      oldImageUrl.value = null;
    }
  }

  Future<String?> uploadIMageToCloudinary() async {
    if (imageFile.value == null) return null;

    isUploading.value = true;
    try {
      final cloudinaryName = 'CLOUDINARY_NAME';
      final storage = 'PRESET_NAME';

      final url =
          'https://api.cloudinary.com/v1_1/$cloudinaryName/image/upload';

      final formData = FormData({
        'file': MultipartFile(
          imageFile.value!.path,
          filename: imageFile.value!.path.split('/').last,
        ),
        'upload_preset': storage,
      });

      final response = await _getConnect.post(url, formData);

      if (response.hasError) {
        Get.snackbar(
          'gagal',
          'Terjadi kesalahan saat meng-upload gambar',
          backgroundColor: AppColors.error,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.warning),
          colorText: AppColors.background,
        );

        return null;
      } else {
        final imagePicked = response.body['secure_url'];
        return imagePicked;
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Sistem bermasalah $error',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );

      return null;
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> addNewAlat() async {
    isLoading.value = true;
    try {
      final imageUrl = await uploadIMageToCloudinary();

      await _provider.addAlat(
        nameText.text,
        kategoriSelect.value!,
        int.parse(stokText.text),
        imageUrl!,
        deskText.text,
        _authC.userWithModel.value?.id ?? '',
        _authC.userWithModel.value?.nama ?? '',
      );

      SavedDataDialog().showSavedDataDialog(
        'Berhasil',
        'Data Barang telah berhasil disimpan',
        false,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        'Sistem bermasalah $error',
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
