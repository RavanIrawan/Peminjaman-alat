import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/peminjam/detail_alat_view_controller.dart';

class DetailAlatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailAlatViewController());
  }
}
