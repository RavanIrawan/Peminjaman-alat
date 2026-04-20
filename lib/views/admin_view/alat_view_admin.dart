import 'package:flutter/material.dart';
import 'package:peminjaman_alat/controllers/alat_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/views/admin_view/add_new_alat.dart';

class AlatViewAdmin extends GetView<AlatController> {
  const AlatViewAdmin({super.key});
  static const routeName = '/alat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return RefreshIndicator(
          backgroundColor: AppColors.surface,
          color: AppColors.primary,
          onRefresh: () => controller.getAllAlat(),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.surface,
                title: Text(
                  'Kelola Data Alat',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                bottom: PreferredSize(
                  preferredSize: Size(double.infinity, 50),
                  child: Padding(
                    padding: EdgeInsets.all(9.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: TextField(
                        onChanged: (value) {
                          controller.keyword.value = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
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
                          hintText: 'Cari nama alat atau kategori',
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
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final data = controller.displayAlat[index];
                    final kategoriName = controller.getKategoriName(
                      data.idKategori ?? '',
                    );

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsetsGeometry.all(8.0),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                data.gambar ?? '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.namaAlat ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                        Text(
                                          'Kategori: $kategoriName',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 2.5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: data.stok! > 20
                                                ? AppColors.primary.withValues(
                                                    alpha: 0.1,
                                                  )
                                                : (data.stok! > 10
                                                      ? AppColors.warning
                                                            .withValues(
                                                              alpha: 0.1,
                                                            )
                                                      : AppColors.error
                                                            .withValues(
                                                              alpha: 0.1,
                                                            )),
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: Text(
                                            'Stok: ${data.stok}',
                                            style: TextStyle(
                                              color: data.stok! > 20
                                                  ? AppColors.primary
                                                  : (data.stok! > 10
                                                        ? AppColors.warning
                                                        : AppColors.error),
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            AddNewAlat.routeName,
                                            arguments: data.id,
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 8),

                                      GestureDetector(
                                        onTap: () {
                                          controller.showDeleteDialog(
                                            data.id ?? '',
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: controller.displayAlat.length),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AddNewAlat.routeName);
        },
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(Icons.add, color: AppColors.surface),
      ),
    );
  }
}
