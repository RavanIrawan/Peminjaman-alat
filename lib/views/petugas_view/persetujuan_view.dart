import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/petugas/persetujuan_controller.dart';
import 'package:peminjaman_alat/controllers/petugas/petugas_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class PersetujuanView extends StatefulWidget {
  const PersetujuanView({super.key});

  @override
  State<PersetujuanView> createState() => _PersetujuanViewState();
}

class _PersetujuanViewState extends State<PersetujuanView>
    with AutomaticKeepAliveClientMixin {
  final persetujuanC = Get.find<PersetujuanController>();
  final petugasC = Get.find<PetugasController>();
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(
          'Pengajuan Masuk',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menunggu Persetujuan',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Obx(() {
                    if (petugasC.allDataPersetujuan.isNotEmpty) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Request Baru',
                          style: TextStyle(
                            color: AppColors.surface,
                            fontFamily: 'Inter',
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),
                ],
              ),
              SizedBox(height: 15,),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final dataPersetujuan = petugasC.allDataPersetujuan[index];
                  final barangUtama = dataPersetujuan.detailPinjaman[0];

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textSecondary.withValues(alpha: 0.1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: petugasC.allDataPersetujuan.length,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
