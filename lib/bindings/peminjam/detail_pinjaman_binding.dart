import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/peminjam/detail_pinjaman_controller.dart';

class DetailPinjamanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailPinjamanController());
  }
}