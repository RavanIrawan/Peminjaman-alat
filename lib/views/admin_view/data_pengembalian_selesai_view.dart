import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class DataPengembalianSelesaiView extends StatefulWidget {
  const DataPengembalianSelesaiView({super.key});

  @override
  State<DataPengembalianSelesaiView> createState() => _DataPengembalianSelesaiViewState();
}

class _DataPengembalianSelesaiViewState extends State<DataPengembalianSelesaiView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
    );
  }
}