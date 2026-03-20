import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/home_admin_controller.dart';
import 'package:peminjaman_alat/providers/dashboard_admin_provider.dart';

class DashboardHomeAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardAdminProvider());
    Get.lazyPut(() => HomeAdminController());
}
}