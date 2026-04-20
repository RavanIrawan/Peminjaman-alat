import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/petugas/pengembalian_controller.dart';
import 'package:peminjaman_alat/controllers/petugas/petugas_controller.dart';
import 'package:peminjaman_alat/providers/petugas/pengembalian_provider.dart';
import 'package:peminjaman_alat/providers/petugas/petugas_provider.dart';

class PengembalianAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PetugasProvider(),);
    Get.lazyPut(() => PengembalianProvider(),);

    Get.lazyPut(() => PengembalianController(),);
    Get.lazyPut(() => PetugasController(),);
  }
}