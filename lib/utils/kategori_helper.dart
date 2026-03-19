
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:flutter/material.dart';

class KategoriHelper {
  static KategoriVisual getVisual(String name) {
    final nameLower = name.toLowerCase().trim();
    final warnaUtama = AppColors.primary;

    switch (nameLower) {
      case 'elektronik':
        return KategoriVisual(Icons.devices, warnaUtama);
      case 'perkakas tangan':
        return KategoriVisual(Icons.handyman, warnaUtama);
      case 'alat ukur':
        return KategoriVisual(Icons.square_foot, warnaUtama);
      case 'multimedia':
      case 'fotografi':
        return KategoriVisual(Icons.photo_camera, warnaUtama);
      case 'komputer':
      case 'jaringan':
        return KategoriVisual(Icons.router, warnaUtama);
      case 'keselamatan kerja':
      case 'apd':
        return KategoriVisual(Icons.health_and_safety, warnaUtama);
      case 'alat kebersihan':
        return KategoriVisual(Icons.cleaning_services, warnaUtama);
      case 'kendaraan':
      case 'transportasi':
        return KategoriVisual(Icons.local_shipping, warnaUtama);
      case 'alat kantor':
        return KategoriVisual(Icons.print, warnaUtama);
      case 'penyimpanan':
        return KategoriVisual(Icons.inventory_2, warnaUtama);
      case 'olahraga':
        return KategoriVisual(Icons.sports_basketball, warnaUtama);
        
      default:
        return KategoriVisual(Icons.category, warnaUtama); 
    }
  } 
}

class KategoriVisual {
  final IconData icon;
  final Color color;

  KategoriVisual(this.icon,this.color);
}