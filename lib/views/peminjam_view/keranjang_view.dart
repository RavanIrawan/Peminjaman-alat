import 'package:flutter/material.dart';
import 'package:peminjaman_alat/controllers/peminjam/home_peminjaman_product_controller.dart';
import 'package:peminjaman_alat/controllers/peminjam/keranjang_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class KeranjangView extends StatefulWidget {
  const KeranjangView({super.key});

  @override
  State<KeranjangView> createState() => _KeranjangViewState();
}

class _KeranjangViewState extends State<KeranjangView>
    with AutomaticKeepAliveClientMixin {
  final _keranjangC = Get.find<KeranjangController>();
  final _homeProdC = Get.find<HomePeminjamanProductController>();

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            onPressed: () {
              if (_keranjangC.cartItems.isNotEmpty) {
                _keranjangC.cartItems.clear();
              }
            },
            icon: Icon(Icons.delete, color: AppColors.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'your selection'.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Poppins',
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Keranjang Pinjaman',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(
                        () => Text(
                          '${_keranjangC.itemLength}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontFamily: 'Poppins',
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'items'.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Obx(() {
                if (_keranjangC.cartItems.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Center(
                      child: Text(
                        'Keranjang masih kosong',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  );
                }
                if (_keranjangC.isLoading.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _keranjangC.cartItems.length,
                  itemBuilder: (context, index) {
                    final data = _keranjangC.cartItems[index];
                    final qtyCart = data.qty;
                    final kategoriName = _homeProdC.getKategoriName(
                      data.products.idKategori ?? 'Unkown',
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        padding: EdgeInsetsGeometry.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.1,
                              ),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                data.products.gambar ?? '',
                                width: 90,
                                height: 90,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.products.namaAlat ?? '',
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Inter',
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            kategoriName,
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _keranjangC.removeProd(
                                            data.products.id ?? '',
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete_outline_rounded,
                                          color: AppColors.textSecondary,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 110,
                                    padding: EdgeInsetsGeometry.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () => _keranjangC.minCartItem(
                                            data.products.id ?? '',
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.surface,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              size: 30,
                                              color: Color(0xff538165),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          '$qtyCart',
                                          style: TextStyle(
                                            color: Color(0xff538165),
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () => _keranjangC.addQty(
                                            data.products.id ?? '',
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.surface,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 30,
                                              color: Color(0xff538165),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
              SizedBox(height: 10),
              Obx(() {
                if (_keranjangC.cartItems.isEmpty) {
                  return SizedBox.shrink();
                }
                if (_keranjangC.isLoading.value) {
                  return SizedBox.shrink();
                }

                return Column(
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
                              value: _keranjangC.selectedDuration.value,
                              underline: SizedBox(),
                              items: _keranjangC.durasi.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text('$e Hari'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  _keranjangC.selectedDuration.value = value;
                                }
                              },
                              buttonStyleData: ButtonStyleData(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
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
                          SizedBox(height: 10),
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
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
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
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (_keranjangC.cartItems.isEmpty) {
          return SizedBox.shrink();
        }
        if (_keranjangC.isLoading.value) {
          return SizedBox.shrink();
        }
        return Container(
          padding: EdgeInsets.all(12),
          height: 150,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'total barang'.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${_keranjangC.itemLength} Alat',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    tileMode: TileMode.clamp,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _keranjangC.userTransactionInCart();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                    foregroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
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
            ],
          ),
        );
      }),
    );
  }
}
