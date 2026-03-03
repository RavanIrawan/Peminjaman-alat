import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class Login extends GetView<AuthController> {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        
        return Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsGeometry.all(8.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsetsGeometry.all(9.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.handshake,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 20),

                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) {
                        return LinearGradient(colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end:  Alignment.bottomRight
                        ).createShader(bounds);
                      },
                      child: Text(
                        'SIPINJAM',
                        style: TextStyle(
                          color: AppColors.surface,
                          fontFamily: 'Inter',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),

                    SizedBox(height: 50),

                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email Address',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),

                            SizedBox(height: 8.0),

                            TextFormField(
                              controller: controller.emailC,
                              validator: (value) {
                                if(!GetUtils.isEmail(value!)){
                                  return 'Format email salah';
                                } else{
                                  return null;
                                }
                              },
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
                                hintText: 'Enter your email',
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
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),

                            SizedBox(height: 8.0),

                            TextFormField(
                              controller: controller.passC,
                              obscureText: controller.isObsecureText.value ? false : true,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
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
                                hintText: 'Enter your password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.isObsecureText.toggle();
                                  },
                                  icon: controller.isObsecureText.value ? Icon(Icons.visibility_off, color: Colors.grey,) : Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.grey,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),

                            SizedBox(height: 6),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if(formKey.currentState!.validate()){
                                    controller.login(controller.emailC.text, controller.passC.text);
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
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      SizedBox(width: 5.0),
                                      Icon(Icons.arrow_forward, size: 20,),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 15,),

                            Align(alignment: Alignment.center,
                            child: Text('Or continue with', style: TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: 'Inter',
                            ),),),

                            SizedBox(height: 10,),

                            Container(
                              width: double.infinity,
                              padding: EdgeInsetsGeometry.all(1.0),
                              child: OutlinedButton(onPressed: (){
                                controller.googleSignIn();
                              }, 
                              style: OutlinedButton.styleFrom(
                                overlayColor: AppColors.primaryLight,
                                side: BorderSide(
                                  width: 0.2,
                                  color: Colors.grey
                                ),
                                padding: EdgeInsetsGeometry.symmetric
                                (vertical: 5.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                )
                              ),
                              child: CircleAvatar(
                                backgroundImage: AssetImage('assets/icons/GoogleLogo.png'),
                                backgroundColor: AppColors.background,
                              )),
                            ),

                            SizedBox(height: 18,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account?"),
                                TextButton(onPressed: (){
                                  Get.toNamed('/register');
                                }, 
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  foregroundColor: AppColors.primary
                                ),
                                child: Text('Sign up'))
                              ],
                            )
                          ],
                        ),
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
