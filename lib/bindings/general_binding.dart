import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:peminjaman_alat/controllers/main_admin_view_controller.dart';
import 'package:peminjaman_alat/providers/user_provider.dart';

class GeneralBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserProvider(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(MainAdminViewController(), permanent: true);
  }
}