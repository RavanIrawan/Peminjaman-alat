import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/edit_profile_controller.dart';
import 'package:peminjaman_alat/providers/edit_profile_provider.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileProvider());
    Get.lazyPut(() => EditProfileController(), fenix: true);
  }
}