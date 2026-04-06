import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/controllers/main_admin_view_controller.dart';
import 'package:peminjaman_alat/controllers/profile_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/views/general_view/edit_profile.dart';
import 'package:peminjaman_alat/views/general_view/reset_password.dart';
import 'package:peminjaman_alat/widgets/profile_picture.dart';

class Profile extends GetView<ProfileController> {
  const Profile({super.key});
  static const routename = '/profile';

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final homeC = Get.find<MainAdminViewController>();
    final nameProf = homeC.getTwoLetters(
      authC.userWithModel.value?.nama ?? 'Guest',
    );
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile Saya',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ProfilePicture(
                  child: authC.userWithModel.value?.profile != null
                      ? Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                authC.userWithModel.value?.profile ?? '',
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(95),
                          ),
                        )
                      : CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.primary,
                          child: Text(nameProf),
                        ),
                ),

                SizedBox(height: 18),

                Text(
                  authC.userWithModel.value?.nama ?? 'Guest',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  authC.userWithModel.value?.email ?? 'Guest@gmail.com',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),

                SizedBox(height: 8),

                Container(
                  padding: EdgeInsetsGeometry.symmetric(
                    vertical: 4,
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    authC.userWithModel.value?.role ?? 'Peminjam',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 35),

                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsetsGeometry.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.edit, color: AppColors.primary),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      IconButton(
                        onPressed: () {
                          Get.toNamed(EditProfile.routeName);
                        },
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.textSecondary,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsetsGeometry.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.lock, color: AppColors.primary),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Ubah Password',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      IconButton(
                        onPressed: () {
                          Get.toNamed(ResetPassword.routeName);
                        },
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.textSecondary,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: EdgeInsetsGeometry.all(10),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            authC.logout();
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsetsGeometry.all(15),
            backgroundColor: AppColors.background,
            side: BorderSide(color: AppColors.error),
            foregroundColor: AppColors.error,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout),
              SizedBox(width: 5),
              Text('Keluar Akun'),
            ],
          ),
        ),
      ),
    );
  }
}
