import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/users_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/utils/url_default_profile.dart';
import 'package:peminjaman_alat/views/admin_view/add_new_user.dart';

class UsersPage extends GetView<UsersController> {
  const UsersPage({super.key});
  static const routeName = '/users';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(
          'Data User',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                controller.isSearch.toggle();
              },
              icon: Icon(
                controller.isSearch.value
                    ? Icons.cancel_outlined
                    : Icons.search,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AnimatedCrossFade(
                  reverseDuration: Duration(milliseconds: 500),
                  firstCurve: Curves.easeInOut,
                  secondCurve: Curves.easeOut,
                  alignment: AlignmentGeometry.directional(15, 3),
                  firstChild: SizedBox.shrink(),
                  secondChild: Container(
                    padding: EdgeInsets.all(8.0),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              controller.keyword.value = value;
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

                        SizedBox(width: 8),

                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.searchUser(controller.keyword.value);
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
                            child: Text(
                              'Search',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.surface,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  crossFadeState: controller.isSearch.value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: Duration(milliseconds: 500),
                ),
              ),

              SliverToBoxAdapter(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final dataUser = controller.displayUser[index];

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: EdgeInsets.all(9.0),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(50),
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
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    dataUser.profile ?? UrlDefaultProfile.url,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
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
                                          dataUser.nama ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          dataUser.email ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Container(
                                          padding: EdgeInsetsGeometry.symmetric(
                                            vertical: 2,
                                            horizontal: 7,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            color: dataUser.role == 'Admin'
                                                ? AppColors.primary.withValues(
                                                    alpha: 0.1,
                                                  )
                                                : (dataUser.role == 'Petugas'
                                                      ? Colors.blue.withValues(
                                                          alpha: 0.1,
                                                        )
                                                      : Colors
                                                            .deepOrangeAccent
                                                            .shade400
                                                            .withValues(
                                                              alpha: 0.1,
                                                            )),
                                          ),
                                          child: Text(
                                            '${dataUser.role}'.toUpperCase(),
                                            style: TextStyle(
                                              color: dataUser.role == 'Admin'
                                                  ? AppColors.primary
                                                  : (dataUser.role == 'Petugas'
                                                        ? Colors.blue
                                                        : Colors
                                                              .deepOrangeAccent
                                                              .shade400),
                                              fontFamily: 'Poppins',
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                 
                                    if (dataUser.id == controller.uid)
                                      SizedBox.shrink()
                                      else
                                      Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: AppColors.textSecondary,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.toNamed(AddNewUser.routeName, arguments: dataUser.id);
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              size: 22,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          InkWell(
                                            onTap: () {
                                              controller.showDeleteDialog(dataUser.id ?? '');
                                            },
                                            child: Icon(
                                              Icons.delete_outline_rounded,
                                              size: 22,
                                              color: AppColors.textSecondary,
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
                  itemCount: controller.displayUser.length,
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Obx(
        () => controller.isLoading.value
            ? SizedBox.shrink()
            : FloatingActionButton(

                onPressed: () {
                  Get.toNamed(AddNewUser.routeName);
                },
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.add),
              ),
      ),
    );
  }
}
