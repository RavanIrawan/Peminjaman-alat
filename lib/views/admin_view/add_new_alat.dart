import 'package:flutter/material.dart';
import 'package:peminjaman_alat/controllers/add_alat_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/utils/url_default_profile.dart';

class AddNewAlat extends GetView<AddAlatController> {
  const AddNewAlat({super.key});
  static const routeName = '/AddAlat';

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(
          'Tambah Alat Baru',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  AnimatedCrossFade(
                    firstChild: GestureDetector(
                      onTap: () => controller.pickImageFormgallery(),
                      child: Container(
                        width: double.infinity,
                        height: 240,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          border: BoxBorder.all(
                            color: AppColors.primary,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.surface,
                              radius: 25,
                              child: Icon(
                                Icons.camera_alt,
                                color: AppColors.primary,
                                size: 25,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Upload Foto Barang',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Tap to take a picture or select',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    secondChild: GestureDetector(
                      onTap: () => controller.pickImageFormgallery(),
                      child: Container(
                        width: double.infinity,
                        height: 240,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                          image:
                              controller.imageFile.value != null ||
                                  controller.oldImageUrl.value != null
                              ? DecorationImage(
                                  image:
                                      (() {
                                            if (controller.imageFile.value !=
                                                null) {
                                              return FileImage(
                                                controller.imageFile.value!,
                                              );
                                            }
                                            if (controller.oldImageUrl.value !=
                                                null) {
                                              return NetworkImage(
                                                controller.oldImageUrl.value!,
                                              );
                                            }
                                            return NetworkImage(
                                              UrlDefaultProfile.url,
                                            );
                                          })()
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ),
                    crossFadeState:
                        controller.imageFile.value != null ||
                            controller.oldImageUrl.value != null
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 500),
                  ),

                  SizedBox(height: 15),

                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Nama Alat',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              fontSize: 15,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: controller.nameText,
                          validator: (value) {
                            if (value!.length < 8 || value.isEmpty) {
                              return 'nama terlalu pendek';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.error,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.error,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(
                              Icons.handyman_outlined,
                              color: Colors.grey,
                            ),
                            hintText: 'Ex: Hammer Drill',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Kategori',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              fontSize: 15,
                            ),
                          ),
                        ),
                        DropdownButtonFormField(
                          items: controller.kategori.map((element) {
                            return DropdownMenuItem(
                              value: element.id,
                              child: Text(element.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.kategoriSelect.value = value;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.category,
                              color: Colors.grey,
                            ),
                            hintText: 'Select category',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.error,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.error,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Stok Awal',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              fontSize: 15,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: controller.stokText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Stok jangan kosong';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.error,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.error,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: Icon(
                              Icons.inventory,
                              color: Colors.grey,
                            ),
                            hintText: '0',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Deskripsi',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                              fontSize: 15,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: controller.deskText,
                          maxLines: 10,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'deskripsi jangan sampai kosong';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.error,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.error,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 0.1,
                                color: AppColors.textSecondary,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Add specific details or condition...',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (controller.isEditMode.value) {
                controller.updateAlatData();
              } else {
                if (formKey.currentState!.validate()) {
                  controller.addNewAlat();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save, size: 20),
                SizedBox(width: 5),
                Text(
                  'Simpan Data',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
