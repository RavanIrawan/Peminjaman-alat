import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        authC.nameReg.clear();
        authC.emailReg.clear();
        authC.passReg.clear();
        authC.phoneReg.clear();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Obx(() {
          if (authC.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return Center(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsetsGeometry.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.group_add_rounded,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),

                      SizedBox(height: 18),

                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        'Join our community today',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Inter',
                        ),
                      ),

                      SizedBox(height: 30),

                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Full Name',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            SizedBox(height: 8.0),

                            TextFormField(
                              controller: authC.nameReg,
                              validator: (value) {
                                if (value!.length <= 5) {
                                  return 'Nama terlalu pendek';
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.text,
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
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                hintText: 'John Doe',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email Address',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            SizedBox(height: 8),

                            TextFormField(
                              controller: authC.emailReg,
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
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                                hintText: 'name@example.com',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
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
                                ),
                              ),
                            ),

                            SizedBox(height: 8),

                            TextFormField(
                              controller: authC.phoneReg,
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
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.grey,
                                ),
                                hintText: '089349182377',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
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
                                ),
                              ),
                            ),

                            SizedBox(height: 8),

                            TextFormField(
                              controller: authC.passReg,
                              validator: (value) {
                                if (value!.length <= 8) {
                                  return 'Password terlalu pendek';
                                } else {
                                  return null;
                                }
                              },
                              obscureText: authC.isObsecureTextPassReg.value
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
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    authC.isObsecureTextPassReg.toggle();
                                  },
                                  icon: authC.isObsecureTextPassReg.value
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: Colors.grey,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                ),
                                hintText: '••••••',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Confirm Password',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            SizedBox(height: 8),

                            TextFormField(
                              validator: (value) {
                                if (value! != authC.passReg.text) {
                                  return 'Password tidak sesuai';
                                } else {
                                  return null;
                                }
                              },
                              obscureText:
                                  authC.isObsecureTextRegConfirmPass.value
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
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    authC.isObsecureTextRegConfirmPass.toggle();
                                  },
                                  icon: authC.isObsecureTextRegConfirmPass.value
                                      ? Icon(
                                          Icons.visibility_off,
                                          color: Colors.grey,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                ),
                                hintText: '••••••',
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),

                            SizedBox(height: 28),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    authC.signin(
                                      authC.nameReg.text,
                                      authC.emailReg.text,
                                      authC.passReg.text,
                                      authC.phoneReg.text,
                                    );

                                    authC.nameReg.clear();
                                    authC.emailReg.clear();
                                    authC.passReg.clear();
                                    authC.phoneReg.clear();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsetsGeometry.symmetric(
                                    vertical: 15,
                                  ),
                                ),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 30),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account?'),
                                TextButton(
                                  onPressed: () {
                                    authC.nameReg.clear();
                                    authC.emailReg.clear();
                                    authC.passReg.clear();
                                    Get.back();
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    foregroundColor: AppColors.primary,
                                  ),
                                  child: Text(
                                    'Log In',
                                    style: TextStyle(wordSpacing: 0.1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
