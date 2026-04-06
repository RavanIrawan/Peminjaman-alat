import 'package:flutter/material.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/controllers/edit_profile_controller.dart';
import 'package:peminjaman_alat/controllers/main_admin_view_controller.dart';
import 'package:peminjaman_alat/controllers/profile_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/widgets/profile_picture.dart';

class EditProfile extends GetView<EditProfileController> {
  const EditProfile({super.key});
  static const routeName = '/edit-profile';

  @override
  Widget build(BuildContext context) {
    final profileC = Get.find<ProfileController>();
    final authC = Get.find<AuthController>();
    final homeC = Get.find<MainAdminViewController>();
    final nameProf = homeC.getTwoLetters(
      authC.userWithModel.value?.nama ?? 'Guest',
    );
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
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

        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.pickImageFromGallery();
                    },
                    child: ProfilePicture(
                      child: controller.imageFile.value != null
                          ? Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(controller.imageFile.value!),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(95),
                              ),
                            )
                          : (authC.userWithModel.value?.profile != null
                                ? Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          authC.userWithModel.value?.profile ??
                                              '',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(95),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 60,
                                    child: Text(nameProf),
                                  )),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Ketuk untuk ubah foto',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Nama Lengkap',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),

                                SizedBox(height: 8.0),

                                TextFormField(
                                  controller: controller.nameText,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.1,
                                        color: AppColors.error,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.1,
                                        color: AppColors.error,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.1,
                                        color: AppColors.textSecondary,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.1,
                                        color: AppColors.textSecondary,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Alamat Email',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),

                                SizedBox(height: 8.0),

                                TextFormField(
                                  controller: controller.emailText,
                                  onTap: () {
                                    controller.isEditEmail.value = true;
                                  },
                                  onTapOutside: (event) {
                                    controller.isEditEmail.value = false;
                                  },
                                  readOnly: profileC.isGoogleUser.value,
                                  enabled: profileC.isGoogleUser.value
                                      ? !profileC.isGoogleUser.value
                                      : true,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.1,
                                        color: AppColors.error,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.1,
                                        color: AppColors.error,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.1,
                                        color: AppColors.textSecondary,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.1,
                                        color: AppColors.textSecondary,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 15),

                                AnimatedCrossFade(
                                  firstChild: SizedBox.shrink(),
                                  secondChild: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Masukan Password Lama',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 8.0),

                                      TextFormField(
                                        controller: controller.passwordText,
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0.1,
                                              color: AppColors.error,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 0.1,
                                                  color: AppColors.error,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0.1,
                                              color: AppColors.textSecondary,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0.1,
                                              color: AppColors.textSecondary,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 15),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Email Baru',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 8.0),

                                      TextFormField(
                                        controller: controller.newEmailText,
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0.1,
                                              color: AppColors.error,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 0.1,
                                                  color: AppColors.error,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0.1,
                                              color: AppColors.textSecondary,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0.1,
                                              color: AppColors.textSecondary,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  crossFadeState: controller.isEditEmail.value
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  duration: Duration(milliseconds: 500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value) {
          return SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (controller.isEditEmail.value &&
                      controller.passwordText.text.isNotEmpty &&
                      controller.newEmailText.text.isNotEmpty) {
                    controller.changeEmail();
                  }
                  controller.editProfile();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 20),
                    SizedBox(width: 5),
                    Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
