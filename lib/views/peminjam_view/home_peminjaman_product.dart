import 'package:flutter/material.dart';
import 'package:peminjaman_alat/controllers/peminjam/home_peminjaman_product_controller.dart';
import 'package:peminjaman_alat/controllers/peminjam/keranjang_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/views/peminjam_view/detail_alat_view.dart';

class HomePeminjamanProduct extends StatefulWidget {
  const HomePeminjamanProduct({super.key});

  @override
  State<HomePeminjamanProduct> createState() => _HomePeminjamanProductState();
}

class _HomePeminjamanProductState extends State<HomePeminjamanProduct>
    with AutomaticKeepAliveClientMixin {
  final _homeController = Get.find<HomePeminjamanProductController>();
  final _keranjangC = Get.find<KeranjangController>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColors.background,

      body: RefreshIndicator.adaptive(
        onRefresh: () => _homeController.getAllAlatProduct(),
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: AppColors.surface,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Browse Tools',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Find the right equipment for your job',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Get.bottomSheet(
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadiusGeometry.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Urutkan Dari',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Inter',
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Obx(
                                () => ChoiceChip(
                                  label: const Text('Stok Terbanyak'),
                                  selected:
                                      _homeController.sortBy.value ==
                                      'stok_terbanyak',
                                  checkmarkColor:
                                      _homeController.sortBy.value ==
                                          'stok_terbanyak'
                                      ? AppColors.primary
                                      : null,
                                  onSelected: (bool selected) {
                                    _homeController.onSortBy('stok_terbanyak');
                                  },
                                ),
                              ),
                              Obx(
                                () => ChoiceChip(
                                  label: const Text('Nama (A-Z)'),
                                  selected:
                                      _homeController.sortBy.value == 'nama_az',
                                  checkmarkColor:
                                      _homeController.sortBy.value == 'nama_az'
                                      ? AppColors.primary
                                      : null,
                                  onSelected: (bool selected) {
                                    _homeController.onSortBy('nama_az');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.filter_list, color: AppColors.primary),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 100),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          _homeController.keyword.value = value;
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
                          hintText: 'Search for tools, equipments',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontFamily: 'Inter',
                            fontSize: 15,
                          ),
                          prefixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15.0,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: _homeController.kategori.map((element) {
                              final isSelected =
                                  _homeController.selectedLabel.value ==
                                  element.id;
        
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _homeController.selecLabel(element.id!);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 2.5,
                                  ),
                                  child: Container(
                                    padding: EdgeInsetsGeometry.symmetric(
                                      horizontal: 8,
                                      vertical: 3.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withValues(
                                              alpha: 0.1,
                                            )
                                          : Colors.grey.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(50),
                                      border: BoxBorder.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.grey.shade400,
                                        width: 0.2,
                                      ),
                                    ),
                                    child: Text(
                                      element.name,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.primary
                                            : Colors.grey,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Obx(() {
              if (_homeController.isLoading.value) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }
        
              if (_homeController.alat.isEmpty ||
                  _homeController.alatDisplay.isEmpty) {
                return SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.construction_outlined,
                        size: 70,
                        color: Colors.grey.withValues(alpha: 0.3),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Belum ada peralatan.',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Saat ini belum ada alat yang bisa dipinjam. Silakan cek kembali nanti atau hubungi Admin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Inter',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }
        
              return SliverPadding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    final data = _homeController.alatDisplay[index];
        
                    return Card(
                      color: AppColors.surface,
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(
                            DetailAlatView.routeName,
                            arguments: data.id,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              child:
                                  data.gambar != null && data.gambar!.isNotEmpty
                                  ? Image.network(
                                      data.gambar ?? '',
                                      height: 130,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 130,
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 5,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.namaAlat ?? '',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    padding: EdgeInsetsGeometry.symmetric(
                                      horizontal: 5,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: data.stok! > 20
                                          ? AppColors.primary.withValues(
                                              alpha: 0.1,
                                            )
                                          : (data.stok! > 10
                                                ? AppColors.warning.withValues(
                                                    alpha: 0.1,
                                                  )
                                                : AppColors.error.withValues(
                                                    alpha: 0.1,
                                                  )),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Stok Tersedia: ${data.stok}',
                                      style: TextStyle(
                                        color: data.stok! > 20
                                            ? AppColors.primary
                                            : (data.stok! > 10
                                                  ? AppColors.warning
                                                  : AppColors.error),
                                        fontSize: 11,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Obx(() {
                                    final qty = _keranjangC.getProdQty(
                                      _homeController.alat[index].id!,
                                    );
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _keranjangC.addCartItem(data);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius: BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: AppColors.surface,
                                            ),
                                          ),
                                        ),
                                        if (qty != 0)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 15,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.withValues(
                                                alpha: 0.1,
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                50,
                                              ),
                                            ),
                                            child: Text(
                                              '$qty In Cart',
                                              style: TextStyle(
                                                color: Color(0xff538165),
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: _homeController.alatDisplay.length,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
