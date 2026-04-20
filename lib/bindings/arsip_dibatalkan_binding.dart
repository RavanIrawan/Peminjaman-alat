import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/arsip_dibatalkan_controller.dart';

class ArsipDibatalkanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArsipDibatalkanController(),);
  }
}