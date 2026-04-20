import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/petugas/persetujuan_controller.dart';
import 'package:peminjaman_alat/controllers/petugas/petugas_controller.dart';
import 'package:peminjaman_alat/providers/petugas/persetujuan_provider.dart';
import 'package:peminjaman_alat/providers/petugas/petugas_provider.dart';

class PersetujuanAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PetugasProvider(),);
    Get.lazyPut(() => PersetujuanProvider(),);

    Get.lazyPut(() => PersetujuanController(),);
    Get.lazyPut(() => PetugasController(),);
  }
}