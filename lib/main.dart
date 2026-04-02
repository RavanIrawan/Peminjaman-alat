import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/bindings/general_binding.dart';
import 'package:peminjaman_alat/routes/route_page.dart';
import 'package:peminjaman_alat/services/app_service.dart';
import 'package:peminjaman_alat/views/general_view/login.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => AppService().init(),);
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      initialBinding: GeneralBinding(),
      getPages: RoutePage.route,
    );
  }
}