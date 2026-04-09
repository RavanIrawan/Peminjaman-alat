import 'package:get/get.dart';
import 'package:peminjaman_alat/bindings/profile_binding.dart';
import 'package:peminjaman_alat/controllers/petugas/dashboard_petugas_controller.dart';
import 'package:peminjaman_alat/controllers/petugas/pengembalian_controller.dart';
import 'package:peminjaman_alat/controllers/petugas/persetujuan_controller.dart';
import 'package:peminjaman_alat/controllers/petugas/petugas_controller.dart';
import 'package:peminjaman_alat/providers/petugas/pengembalian_provider.dart';
import 'package:peminjaman_alat/providers/petugas/persetujuan_provider.dart';
import 'package:peminjaman_alat/providers/petugas/petugas_provider.dart';

class DashboardPetugasBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PetugasProvider());
    Get.lazyPut(() => PersetujuanProvider());
    Get.lazyPut(() => PengembalianProvider());

    Get.lazyPut(() => PengembalianController());
    Get.lazyPut(() => PersetujuanController());
    Get.lazyPut(() => PetugasController());
    Get.lazyPut(() => DashboardPetugasController());

    ProfileBinding().dependencies();
  }
}
