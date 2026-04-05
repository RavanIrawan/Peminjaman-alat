import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/peminjam/rejected_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class RejectedView extends GetView<RejectedController> {
  const RejectedView({super.key});
  static const routeName = '/rejected_view';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
    );
  }
}