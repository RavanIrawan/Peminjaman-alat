import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/edit_pinjaman_controller.dart';
import 'package:peminjaman_alat/providers/edit_pinjaman_provider.dart';

class EditPinjamanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditPinjamanProvider(),);

    Get.lazyPut(() => EditPinjamanController(),);
  }
}