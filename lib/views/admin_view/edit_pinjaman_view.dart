import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:peminjaman_alat/controllers/edit_pinjaman_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class EditPinjamanView extends GetView<EditPinjamanController> {
  const EditPinjamanView({super.key});
  static const routeName = '/edit-pinjaman';

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Edit Peminjaman',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: BoxBorder.all(color: AppColors.error, width: 0.2),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.warning, color: AppColors.error, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Admin Override: Ubah data hanya jika terjadi kesalahan sistem',
                            style: TextStyle(
                              color: AppColors.error,
                              fontFamily: 'Inter',
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Status',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButton2(
                        value: controller.selectedStatus.value,
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedStatus.value = value;
                          }
                        },
                        items: controller.listStatus.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e == 'selesai'
                                  ? 'Selesai'
                                  : (e == 'di_kembalikan'
                                        ? 'Dikembalikan'
                                        : (e == 'diPinjam'
                                              ? 'Dipinjam'
                                              : 'Pilih status')),
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontFamily: 'Inter',
                              ),
                            ),
                          );
                        }).toList(),
                        underline: Container(),
                        buttonStyleData: ButtonStyleData(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: BoxBorder.all(
                              color: AppColors.textSecondary,
                              width: 0.2,
                            ),
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 150,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal Pinjam',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: controller.tglPinjamC,
                        readOnly: true,
                        onTap: () async {
                          final pickedDate = await controller.choseInCalender(
                            context,
                            controller.dataPeminjaman.value?.tanggalPinjam ??
                                DateTime.now(),
                          );

                          if (pickedDate != null) {
                            final dateFormated = DateFormat(
                              'MM/dd/yyyy',
                            ).format(pickedDate);

                            controller.tanggalPinjam.value = pickedDate;
                            controller.tglPinjamC?.text = dateFormated;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                            ), // Garis berubah warna saat diklik
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tenggat Waktu',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: controller.tenggatWaktuC,
                        readOnly: true,
                        onTap: () async {
                          final pickedDate = await controller.choseInCalender(
                            context,
                            controller.dataPeminjaman.value?.tenggatWaktu ??
                                DateTime.now(),
                          );

                          if (pickedDate != null) {
                            final dateFormated = DateFormat(
                              'MM/dd/yyyy',
                            ).format(pickedDate);

                            controller.tenggatWaktu.value = pickedDate;
                            controller.tenggatWaktuC?.text = dateFormated;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.edit_calendar_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                            ), // Garis berubah warna saat diklik
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catatan Admin (Opsional)',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: controller.catatanAdmin,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null && value!.trim().isEmpty) {
                            return null;
                          }
                          if (value.isNotEmpty && value.trim().length < 3) {
                            return 'Catatan terlalu pendek';
                          }
                          return null;
                        },
                        autocorrect: true,
                        maxLines: 4,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.error.withValues(alpha: 0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                            ), // Garis berubah warna saat diklik
                          ),
                          hintText: 'Alasan perubahan data...',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'Inter',
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value) {
          return SizedBox.shrink();
        }
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15, right: 10, left: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.updatePeminjaman(
                      controller.tanggalPinjam.value ??
                          controller.dataPeminjaman.value!.tanggalPinjam!,
                      controller.tenggatWaktu.value ??
                          controller.dataPeminjaman.value!.tenggatWaktu!,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 8),
                    Text('Update Data Transaksi'),
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
