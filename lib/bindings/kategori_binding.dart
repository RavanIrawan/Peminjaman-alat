import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/kategori_controller.dart';
import 'package:peminjaman_alat/controllers/kategori_home_controller.dart';
import 'package:peminjaman_alat/providers/kategori_product_provider.dart';

class KategoriBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KategoriProductProvider());
    Get.lazyPut(() => KategoriHomeController());
    Get.lazyPut(() => KategoriController());
  }
}