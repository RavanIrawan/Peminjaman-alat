import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/edit_pengembalian_admin_controller.dart';
import 'package:peminjaman_alat/providers/edit_pengembalian_admin_provider.dart';

class EditPengembalianAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditPengembalianAdminProvider(),);
    
    Get.lazyPut(() => EditPengembalianAdminController(),);
  }
}