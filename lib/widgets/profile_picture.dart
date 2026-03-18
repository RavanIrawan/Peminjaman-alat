import 'package:flutter/material.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';

class ProfilePicture extends StatelessWidget {
  final Widget child;
  const ProfilePicture({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: (){},
            child: Container(
              padding: EdgeInsetsGeometry.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(50),
                border: BoxBorder.all(width: 1.5, color: AppColors.background),
              ),
              child: Icon(Icons.camera_alt, color: AppColors.background, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}
