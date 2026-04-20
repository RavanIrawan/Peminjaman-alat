import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/petugas/report_pdf_controller.dart';
import 'package:peminjaman_alat/providers/petugas/report_pdf_provider.dart';

class ReportPdfAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportPdfProvider(),);
    Get.lazyPut(() => ReportPdfController(),);
  }
}