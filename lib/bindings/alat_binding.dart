import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/alat_controller.dart';
import 'package:peminjaman_alat/providers/alat_provider.dart';

class AlatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AlatProvider());
    Get.lazyPut(() => AlatController());
  }
}