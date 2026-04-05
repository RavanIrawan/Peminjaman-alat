import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/peminjam/rejected_controller.dart';
import 'package:peminjaman_alat/providers/peminjam/rejected_provider.dart';

class RejectedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RejectedProvider(),);
    Get.lazyPut(() => RejectedController(),);
  }
}