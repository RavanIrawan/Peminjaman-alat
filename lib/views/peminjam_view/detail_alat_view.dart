import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/peminjam/detail_alat_view_controller.dart';
import 'package:peminjaman_alat/controllers/peminjam/keranjang_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DetailAlatView extends GetView<DetailAlatViewController> {
  const DetailAlatView({super.key});
  static const routeName = '/detail-alat';

  @override
  Widget build(BuildContext context) {
    final keranjangC = Get.find<KeranjangController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(
          'Detail Alat',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: NetworkImage(
                      controller.detailProd.value?.gambar ?? '',
                    ),
                    fit: BoxFit.cover,
                  ),
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
              SizedBox(height: 12),
              Container(
                width: 110,
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                decoration: BoxDecoration(
                  color: controller.detailProd.value?.stok != 0
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Icon(
                      controller.detailProd.value?.stok != 0
                          ? Icons.check_circle
                          : Icons.error,
                      color: controller.detailProd.value?.stok != 0
                          ? AppColors.primary
                          : AppColors.error,
                      size: 15,
                    ),
                    SizedBox(width: 4),
                    Text(
                      controller.detailProd.value?.stok != 0
                          ? 'tersedia'.toUpperCase()
                          : 'kosong'.toUpperCase(),
                      style: TextStyle(
                        color: controller.detailProd.value?.stok != 0
                            ? AppColors.primary
                            : AppColors.error,
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textSecondary.withValues(alpha: 0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${controller.detailProd.value?.namaAlat}',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'deskripsi'.toUpperCase(),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${controller.detailProd.value?.deskripsi}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textSecondary.withValues(alpha: 0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jumlah Pinjam (Qty)',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sisa Stok: ${controller.detailProd.value?.stok} Alat',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.kurangQty();
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.remove,
                                color: AppColors.textPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Obx(
                            () => Text(
                              '${controller.qty.value}',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              controller.addQty();
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.add,
                                color: AppColors.surface,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Rincian Peminjaman',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsGeometry.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withValues(alpha: 0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'durasi pinjam (hari)'.toUpperCase(),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 0.9,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Obx(
                          () => DropdownButton2(
                            value: controller.selectedDuration.value,
                            underline: SizedBox(),
                            items: controller.durasi.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text('$e Hari'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedDuration.value = value;
                              }
                            },
                            buttonStyleData: ButtonStyleData(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            iconStyleData: IconStyleData(
                              icon: Icon(Icons.date_range),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              maxHeight: 150,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Harap di baca'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Poppins',
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.error,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (keranjangC.isLoadingDetail.value) {
          return Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.surface),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(color: AppColors.primary)],
              ),
            ),
          );
        }
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(color: AppColors.surface),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  tileMode: TileMode.clamp,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.qty.value != 0) {
                    keranjangC.userTransactionInDetail(
                      controller.productId,
                      controller.detailProd.value?.namaAlat ?? '',
                      controller.qty.value,
                      controller.selectedDuration.value!,
                      controller.detailProd.value?.gambar ?? '',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ajukan Pinjaman',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(Icons.arrow_forward_sharp, size: 19),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
