import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/views/admin_view/alat_view_admin.dart';
import 'package:peminjaman_alat/views/admin_view/kategory_home.dart';
import 'package:peminjaman_alat/views/admin_view/users_page.dart';

class MainAdminViewController extends GetxController {
  final List<Tab> tabs = [
    Tab(text: 'Dashboard', icon: Icon(Icons.dashboard),),
  ];

  final Map<String, Map<String, dynamic>> menuCard = {
    'users':{
      'icon':Icons.person_search,
      'text':'Data Users',
      'route': UsersPage.routeName,
    },

    'kategori': {
      'icon': Icons.category,
      'text':'Data Kategori',
      'route': KategoryHome.routeName,
    },

    'alat': {
      'icon': Icons.construction,
      'text': 'Data Alat',
      'route': AlatViewAdmin.routeName,
    },

    'peminjaman': {
      'icon': Icons.handshake,
      'text': 'Data Peminjaman',
      'route': '/peminjaman',
    },

    'pengembalian': {
      'icon': Icons.move_to_inbox,
      'text': 'Data Pengembalian',
      'route': '/pengembalian',
    },

    'aktivitas': {
      'icon': Icons.access_time,
      'text': 'Log Aktivitas',
      'route': '/aktivitas',
    }
  };

  String getTwoLetters(String name) {
    if(name.trim().isEmpty) return '?';

    final result = name.length > 2 ? name.substring(0, 2) : name;

    return result.toUpperCase();
  }
}