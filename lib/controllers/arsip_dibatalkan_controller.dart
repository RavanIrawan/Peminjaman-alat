import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/data_pengembalian_controller.dart';
import 'package:peminjaman_alat/models/peminjaman_model.dart';

class ArsipDibatalkanController extends GetxController {
  double radius = 20;
  final pengembalianC = Get.find<DataPengembalianController>();
  final keyword = ''.obs;

  List<PeminjamanModel> get dataWithStatusDibatalkan {
    return pengembalianC.dataPengembalianAll.where((element) {
      final isStatusmatch = element.status == 'dibatalkan_admin';
      final isKeywordMatch = element.namaPeminjam.toLowerCase().contains(
        keyword.value.toLowerCase(),
      )  || element.id!.toLowerCase().contains(keyword.value.toLowerCase());

      return isStatusmatch && isKeywordMatch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    debounce(keyword, (callback) {
      searchDataWithkeyword(callback);
    }, time: Duration(milliseconds: 500));
  }

  void searchDataWithkeyword(String value) {
    keyword.value = value;
  }
}
