import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_alat/views/admin_view/alat_view_admin.dart';
import 'package:peminjaman_alat/views/admin_view/data_peminjaman_view.dart';
import 'package:peminjaman_alat/views/admin_view/data_pengembalian_view.dart';
import 'package:peminjaman_alat/views/admin_view/kategory_home.dart';
import 'package:peminjaman_alat/views/admin_view/users_page.dart';
import 'package:peminjaman_alat/views/petugas_view/report_pdf_view.dart';

class MainAdminViewController extends GetxController {
  final List<Tab> tabs = [
    Tab(text: 'Dashboard', icon: Icon(Icons.dashboard)),
    Tab(text: 'Aktivitas', icon: Icon(Icons.access_time)),
  ];

  String checkTime() {
    final now = DateTime.now().hour;

    if (now > 00 && now <= 12) {
      return 'morning';
    } else if (now > 12 && now <= 18) {
      return 'afternoon';
    } else if (now >= 18) {
      return 'evening';
    }

    return 'unkown';
  }

  final List<Map<String, dynamic>> menuCard = [
    {
      'icon': Icons.person_search,
      'text': 'Data Users',
      'route': UsersPage.routeName,
    },

    {
      'icon': Icons.category,
      'text': 'Data Kategori',
      'route': KategoryHome.routeName,
    },

    {
      'icon': Icons.construction,
      'text': 'Data Alat',
      'route': AlatViewAdmin.routeName,
    },

    {
      'icon': Icons.handshake,
      'text': 'Data Peminjaman',
      'route': DataPeminjamanView.routeName,
    },

    {
      'icon': Icons.move_to_inbox,
      'text': 'Data Pengembalian',
      'route': DataPengembalianView.routeName,
    },
    {
      'icon': Icons.receipt_long,
      'text': 'Laporan',
      'route': ReportPdfView.routeName,
    },
  ];

  String getTwoLetters(String name) {
    if (name.trim().isEmpty) return '?';

    final result = name.length > 2 ? name.substring(0, 2) : name;

    return result.toUpperCase();
  }
}
