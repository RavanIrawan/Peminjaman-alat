import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/add_user_controller.dart';
import 'package:peminjaman_alat/providers/add_user_provider.dart';

class AddUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddUserProvider());
    Get.lazyPut(() => AddUserController());

  }
} 