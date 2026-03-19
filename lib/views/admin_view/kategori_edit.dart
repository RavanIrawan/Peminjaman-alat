import 'package:flutter/material.dart';
import 'package:peminjaman_alat/controllers/kategori_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';

class KategoriEdit extends StatelessWidget {
  const KategoriEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final kateC = Get.find<KategoriController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(
          'Edit Kategori',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Cari Kategori',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  kateC.keyword.value = value;
                                },
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
                                  hintText: 'Contoh: Elektronik',
                                  hintStyle: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 15.0,
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              child: ElevatedButton(
                                onPressed: () {
                                  kateC.searchDataKategory(kateC.keyword.value);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsetsGeometry.symmetric(
                                    vertical: 14.0,
                                    horizontal: 20.0,
                                  ),
                                ),
                                child: Text('Search'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Obx(() {
                if (kateC.dataKategoriEdit.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: Column(
                        children: [
                          Icon(Icons.search, color: AppColors.textSecondary),
                          SizedBox(height: 5),
                          Text(
                            'Cari Kategori untuk Edit',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontFamily: 'Inter',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: kateC.dataKategoriEdit.length,
                  itemBuilder: (context, index) {
                    final data = kateC.dataKategoriEdit[index];

                    return Obx(() {
                      final isTrue = kateC.newIsEdit.value == data.id;
                      return Padding(
                        padding: EdgeInsetsGeometry.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.1,
                                ),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data.name,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      kateC.toggleEditForm(data.id ?? '');
                                      kateC.kategoriNameTextEdit.text =
                                          data.name;
                                    },
                                    icon: isTrue
                                        ? Icon(Icons.keyboard_arrow_up)
                                        : Icon(Icons.edit),
                                  ),
                                ],
                              ),
                              AnimatedCrossFade(
                                firstChild: SizedBox.shrink(),
                                secondChild: Column(
                                  children: [
                                    Divider(),
                                    TextField(
                                      controller: kateC.kategoriNameTextEdit,
                                      decoration: InputDecoration(
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 0.1,
                                            color: AppColors.error,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 0.1,
                                            color: AppColors.error,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 0.1,
                                            color: AppColors.textSecondary,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 0.1,
                                            color: AppColors.textSecondary,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 15.0,
                                        ),
                                        isDense: true,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          kateC.updateKategoriName(data.id ?? '');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: AppColors.surface,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text('Simpan Perubahan'),
                                      ),
                                    ),
                                  ],
                                ),
                                crossFadeState: isTrue
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: Duration(milliseconds: 300),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
