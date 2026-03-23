import 'package:flutter/material.dart';
import 'package:peminjaman_alat/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/controllers/home_admin_controller.dart';
import 'package:peminjaman_alat/controllers/main_admin_view_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:peminjaman_alat/views/admin_view/add_new_user.dart';
import 'package:peminjaman_alat/views/general_view/profile.dart';

class HomeAdmin extends GetView<HomeAdminController> {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final homeC = Get.find<MainAdminViewController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        scrolledUnderElevation: 3.0,
        surfaceTintColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Get.toNamed(Profile.routename);
                  },
                  child: authC.user.value?.photoURL != null
                      ? CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            authC.user.value!.photoURL!,
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, size: 25),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.background,
        child: ListView(
          padding: EdgeInsetsGeometry.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              accountName: Text(
                authC.user.value?.displayName ?? 'Guest@gmail.com',
                style: TextStyle(fontFamily: 'Inter'),
              ),
              accountEmail: Text(
                authC.user.value?.email ?? 'Guest',
                style: TextStyle(fontFamily: 'Inter'),
              ),
              currentAccountPicture: authC.user.value?.photoURL != null
                  ? CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        authC.user.value!.photoURL!,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: AppColors.textSecondary,
                      child: Icon(Icons.person, size: 45),
                    ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return RefreshIndicator.adaptive(
          color: AppColors.primary,
          displacement: 1.5,
          onRefresh: () {
            controller.getDataCountAlat();
            return controller.getDataCountUser();
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.textSecondary,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Dashboard Overview',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 10)),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.textPrimary.withValues(
                                        alpha: 0.1,
                                      ),
                                      spreadRadius: 2,
                                      blurRadius: 15,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsetsGeometry.all(5),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.group,
                                          color: AppColors.primary,
                                          size: 25,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Total Users',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '${controller.userCountData}',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontFamily: 'Poppins',
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.textPrimary.withValues(
                                      alpha: 0.1,
                                    ),
                                    spreadRadius: 2,
                                    blurRadius: 15,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsetsGeometry.all(5),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Icon(
                                        Icons.inventory,
                                        color: AppColors.primary,
                                        size: 25,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Total Items',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${controller.alatCountData}',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontFamily: 'Poppins',
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 18)),
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Management Menu',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'View All',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.all(20.0),
                    sliver: SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        final dataList = homeC.menuCard.values.toList();
                        final dataItem = dataList[index];
                        return ManagementMenuCard(
                          icon: dataItem['icon'] as IconData,
                          text: dataItem['text'] as String,
                          route: dataItem['route'] as String,
                        );
                      },
                      itemCount: homeC.menuCard.length,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Actions',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(AddNewUser.routeName);
                              },
                              child: Container(
                                width: 200,
                                padding: EdgeInsetsGeometry.all(8.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      const Color.fromARGB(255, 8, 212, 123),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'New User',
                                        style: TextStyle(
                                          color: AppColors.background
                                              .withValues(alpha: 0.8),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      Text(
                                        'Add Member',
                                        style: TextStyle(
                                          color: AppColors.surface,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: EdgeInsetsGeometry.all(5),
                                          decoration: BoxDecoration(
                                            color: AppColors.background
                                                .withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: AppColors.background,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
          ),
        );
      }),
    );
  }
}

class ManagementMenuCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? route;
  const ManagementMenuCard({
    super.key,
    required this.icon,
    required this.text,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(route!);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.1),
              spreadRadius: 1.2,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsetsGeometry.all(6.0),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(icon, size: 30, color: AppColors.primary),
            ),
            SizedBox(height: 15),
            Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
