import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/add_user_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class AddNewUser extends GetView<AddUserController> {
  const AddNewUser({super.key});
  static const routeName = '/addNewUser';

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          controller.isEditMode.value ? 'Edit User' : 'Tambah User Baru',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return SingleChildScrollView(
          child: Center(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nama Lengkap',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 8),

                    TextFormField(
                      controller: controller.namaText,
                      validator: (value) {
                        if (value!.length <= 5) {
                          return 'Nama terlalu pendek';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
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
                        hintText: 'Masukan nama lengkap',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),

                    SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: controller.isEditMode.value
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(height: 8),

                    TextFormField(
                      controller: controller.emailText,
                      enabled: controller.isEditMode.value ? false : null,
                      validator: (value) {
                        if (!GetUtils.isEmail(value!)) {
                          return 'Format email tidak valid';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
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
                        hintText: 'name@example.com',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Phone',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: controller.isEditMode.value
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(height: 8),

                    TextFormField(
                      controller: controller.phoneText,
                      enabled: controller.isEditMode.value ? false : null,
                      validator: (value) {
                        if (!GetUtils.isNumericOnly(value!) &&
                            value.length > 15) {
                          return 'input nomor tidak valid';
                        } else if (value.isEmpty) {
                          return 'Field tidak boleh kosong';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
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
                        hintText: '08937264859',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),

                    SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: controller.isEditMode.value
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(height: 8),

                    TextFormField(
                      controller: controller.passText,
                      enabled: controller.isEditMode.value ? false : null,
                      validator: (value) {
                        if (value!.length <= 8) {
                          return 'Password terlalu pendek';
                        } else {
                          return null;
                        }
                      },
                      obscureText: controller.isObsecureText.value
                          ? false
                          : true,
                      keyboardType: TextInputType.text,
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
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.isObsecureText.toggle();
                          },
                          icon: controller.isObsecureText.value
                              ? Icon(Icons.visibility_off, color: Colors.grey)
                              : Icon(Icons.visibility, color: Colors.grey),
                        ),
                        hintText: '••••••',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),

                    SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Role (Hak akses)',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 8),
                    DropdownButtonFormField(
                      value: controller.selectedRole.value,
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
                      ),
                      items: controller.listRole.map((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: 'Inter',
                              fontSize: 15,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if (value != null) {
                          controller.selectedRole.value = value;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value) {
          return SizedBox.shrink();
        }
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.isEditMode.value) {
                    controller.updateUser();
                  } else {
                    if (formKey.currentState!.validate()) {
                      controller.addUser(
                        controller.emailText.text,
                        controller.passText.text,
                        controller.namaText.text,
                        controller.phoneText.text,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  controller.isEditMode.value ? 'Edit User' : 'Simpan User',
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
