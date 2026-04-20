import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/data_pengembalian_controller.dart';
import 'package:peminjaman_alat/providers/pengembalian_providerd.dart';

class PengembalianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DataPengembalianProvider(),);

    Get.lazyPut(() => DataPengembalianController(),);
  }
}