import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/models/user_model.dart';
import 'package:peminjaman_alat/providers/users_provider.dart';
import 'package:peminjaman_alat/utils/url_default_profile.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UsersController extends GetxController {
  final users = <UserModel>[].obs;
  final displayUser = <UserModel>[].obs;
  final _auth = Get.find<AuthController>();
  final isLoading = false.obs;
  final isSearch = false.obs;
  final keyword = ''.obs;
  final _provider = Get.find<UsersProvider>();

  String? get uid => _auth.auth.currentUser?.uid;

  @override
  void onInit() {
    getAllUsers();

    debounce(keyword, (callback) {
      searchUser(keyword.value);
    }, time: Duration(milliseconds: 500));

    super.onInit();
  }

  void searchUser(String keyword) {
    if (keyword.isEmpty) {
      displayUser.assignAll(users);
      return;
    }

    final keywordUser = users.where((item) {
      return item.nama!.toLowerCase().contains(keyword.toLowerCase());
    }).toList();

    if (keywordUser.isEmpty) {
      displayUser.clear();
    } else {
      displayUser.assignAll(keywordUser);
    }
  }

  Future<void> getAllUsers() async {
    isLoading.value = true;
    try {
      final response = await _provider.getUsers();

      users.clear();

      for (var data in response.docs) {
        final dataUser = data.data() as Map<String, dynamic>;

        final extractedDataUser = UserModel(
          id: data.id,
          nama: dataUser['nama'] ?? 'Guest',
          email: dataUser['email'] ?? 'Guest@gmail.com',
          profile: dataUser['profile'] ?? UrlDefaultProfile.url,
          role: dataUser['role'] ?? 'Peminjam',
          phone: dataUser['phone'] ?? 0,
        );
        users.add(extractedDataUser);
        displayUser.add(extractedDataUser);
      }
    } catch (error) {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan $error',
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

  Future<void> deleteUser(String id) async {
    isLoading.value = true;
    final indexUser = users.indexWhere((element) => element.id == id);
    if (indexUser != -1) {
      final userItem = users[indexUser];
      users.removeAt(indexUser);
      try {
        await _provider.deleteUser(id);

        await getAllUsers();
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
        users.insert(indexUser, userItem);
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
      } finally {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      Get.snackbar(
        'Gagal',
        'Error User tidak di temukan',
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
          deleteUser(id);
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
