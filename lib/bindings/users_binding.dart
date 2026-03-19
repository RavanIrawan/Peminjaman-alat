import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/users_controller.dart';
import 'package:peminjaman_alat/providers/users_provider.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UsersProvider());
    Get.lazyPut(() => UsersController());
  }
}