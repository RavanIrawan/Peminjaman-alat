import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/peminjam/cancel_peminjaman_controller.dart';
import 'package:peminjaman_alat/providers/peminjam/cancel_peminjaman_provider.dart';

class CancelPeminjamanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CancelPeminjamanProvider(),);
    Get.lazyPut(() => CancelPeminjamanController());
  }
}