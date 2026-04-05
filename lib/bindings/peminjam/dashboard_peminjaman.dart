import 'package:get/get.dart';
import 'package:peminjaman_alat/bindings/profile_binding.dart';
import 'package:peminjaman_alat/controllers/peminjam/home_peminjaman_controller.dart';
import 'package:peminjaman_alat/controllers/peminjam/home_peminjaman_product_controller.dart';
import 'package:peminjaman_alat/controllers/peminjam/keranjang_controller.dart';
import 'package:peminjaman_alat/controllers/peminjam/pinjaman_controller.dart';
import 'package:peminjaman_alat/controllers/peminjam/pinjaman_view_controller.dart';
import 'package:peminjaman_alat/providers/peminjam/home_peminjaman_product_provider.dart';
import 'package:peminjaman_alat/providers/peminjam/keranjang_provider.dart';
import 'package:peminjaman_alat/providers/peminjam/pinjaman_provider.dart';

class DashboardPeminjaman extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomePeminjamanController());

    Get.lazyPut(() => HomePeminjamanProductProvider());
    Get.lazyPut(() => KeranjangProvider());
    Get.lazyPut(() => PinjamanProvider());
    Get.lazyPut(() => PinjamanController());
    Get.lazyPut(() => KeranjangController());
    Get.lazyPut(() => HomePeminjamanProductController());
    Get.lazyPut(() => PinjamanViewController());

    ProfileBinding().dependencies();
  }
}