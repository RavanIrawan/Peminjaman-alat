import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/add_alat_controller.dart';
import 'package:peminjaman_alat/providers/add_alat_provider.dart';

class AddAlatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddAlatProvider());
    Get.lazyPut(() => AddAlatController());
  }
}