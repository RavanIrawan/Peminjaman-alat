import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/data_peminjaman_controller.dart';
import 'package:peminjaman_alat/providers/data_peminjaman_provider.dart';

class DataPeminjamanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DataPeminjamanProvider());

    Get.lazyPut(() => DataPeminjamanController());
  }
}
