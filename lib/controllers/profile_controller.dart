import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ProfileController extends GetxController {
  final isLoading = false.obs;
  final authC = Get.find<AuthController>();
  String get userId => authC.user.value!.uid;
  final isGoogleUser = false.obs;

  @override
  void onInit() {
    userLoginMethod();
    super.onInit();
  }
  void userLoginMethod() {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      for (var provider in currentUser.providerData) {
        if (provider.providerId == 'google.com') {
          isGoogleUser.value = true;
          break;
        }
      }
    }
  }
}
