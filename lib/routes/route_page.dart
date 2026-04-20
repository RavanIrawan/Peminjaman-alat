import 'package:get/get.dart';
import 'package:peminjaman_alat/bindings/add_alat_binding.dart';
import 'package:peminjaman_alat/bindings/add_user_binding.dart';
import 'package:peminjaman_alat/bindings/alat_binding.dart';
import 'package:peminjaman_alat/bindings/arsip_dibatalkan_binding.dart';
import 'package:peminjaman_alat/bindings/dashboard_home_admin_binding.dart';
import 'package:peminjaman_alat/bindings/data_peminjaman_binding.dart';
import 'package:peminjaman_alat/bindings/edit_pengembalian_admin_binding.dart';
import 'package:peminjaman_alat/bindings/edit_pinjaman_binding.dart';
import 'package:peminjaman_alat/bindings/edit_profile_binding.dart';
import 'package:peminjaman_alat/bindings/kategori_binding.dart';
import 'package:peminjaman_alat/bindings/peminjam/cancel_peminjaman_binding.dart';
import 'package:peminjaman_alat/bindings/peminjam/detail_alat_binding.dart';
import 'package:peminjaman_alat/bindings/peminjam/detail_pinjaman_binding.dart';
import 'package:peminjaman_alat/bindings/peminjam/rejected_binding.dart';
import 'package:peminjaman_alat/bindings/pengembalian_admin_binding.dart';
import 'package:peminjaman_alat/bindings/pengembalian_binding.dart';
import 'package:peminjaman_alat/bindings/persetujuan_admin_binding.dart';
import 'package:peminjaman_alat/bindings/petugas/dashboard_petugas_bindings.dart';
import 'package:peminjaman_alat/bindings/profile_binding.dart';
import 'package:peminjaman_alat/bindings/report_pdf_admin_binding.dart';
import 'package:peminjaman_alat/bindings/users_binding.dart';
import 'package:peminjaman_alat/views/admin_view/add_new_alat.dart';
import 'package:peminjaman_alat/views/admin_view/add_new_user.dart';
import 'package:peminjaman_alat/views/admin_view/alat_view_admin.dart';
import 'package:peminjaman_alat/views/admin_view/arsip_dibatalkan_view.dart';
import 'package:peminjaman_alat/views/admin_view/data_peminjaman_view.dart';
import 'package:peminjaman_alat/views/admin_view/data_pengembalian_view.dart';
import 'package:peminjaman_alat/views/admin_view/edit_data_pengembalian.dart';
import 'package:peminjaman_alat/views/admin_view/edit_pinjaman_view.dart';
import 'package:peminjaman_alat/views/admin_view/kategory_home.dart';
import 'package:peminjaman_alat/views/admin_view/main_admin_view.dart';
import 'package:peminjaman_alat/views/admin_view/users_page.dart';
import 'package:peminjaman_alat/views/general_view/edit_profile.dart';
import 'package:peminjaman_alat/views/general_view/profile.dart';
import 'package:peminjaman_alat/views/general_view/register.dart';
import 'package:peminjaman_alat/views/general_view/reset_password.dart';
import 'package:peminjaman_alat/views/peminjam_view/cancel_peminjaman_view.dart';
import 'package:peminjaman_alat/views/peminjam_view/detail_alat_view.dart';
import 'package:peminjaman_alat/views/peminjam_view/detail_pinjaman_view.dart';
import 'package:peminjaman_alat/views/peminjam_view/home_peminjam.dart';
import 'package:peminjaman_alat/views/peminjam_view/rejected_view.dart';
import 'package:peminjaman_alat/views/petugas_view/home_petugas.dart';
import 'package:peminjaman_alat/bindings/peminjam/dashboard_peminjaman.dart';
import 'package:peminjaman_alat/views/petugas_view/pengembalian_view.dart';
import 'package:peminjaman_alat/views/petugas_view/persetujuan_view.dart';
import 'package:peminjaman_alat/views/petugas_view/report_pdf_view.dart';

class RoutePage {
  static final route = [
    GetPage(
      name: '/register',
      page: () => Register(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: '/Admin-view',
      page: () => MainAdminView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      bindings: [
        DashboardHomeAdminBinding(),
        DashboardPeminjaman(),
      ],
    ),
    GetPage(
      name: '/Petugas-view',
      page: () => HomePetugas(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: DashboardPetugasBindings(),
    ),
    GetPage(
      name: '/Peminjam-view',
      page: () => HomePeminjam(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: DashboardPeminjaman(),
    ),
    GetPage(
      name: ResetPassword.routeName,
      page: () => ResetPassword(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: Profile.routename,
      page: () => Profile(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: EditProfile.routeName,
      page: () => EditProfile(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: KategoryHome.routeName,
      page: () => KategoryHome(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: KategoriBinding(),
    ),
    GetPage(
      name: UsersPage.routeName,
      page: () => UsersPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: UsersBinding(),
    ),
    GetPage(
      name: AddNewUser.routeName,
      page: () => AddNewUser(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: AddUserBinding(),
    ),
    GetPage(
      name: AlatViewAdmin.routeName,
      page: () => AlatViewAdmin(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: AlatBinding(),
    ),
    GetPage(
      name: AddNewAlat.routeName,
      page: () => AddNewAlat(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: AddAlatBinding(),
    ),
    GetPage(
      name: DetailAlatView.routeName,
      page: () => DetailAlatView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: DetailAlatBinding(),
    ),
    GetPage(
      name: DetailPinjamanView.routeName,
      page: () => DetailPinjamanView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: DetailPinjamanBinding(),
    ),
    GetPage(
      name: CancelPeminjamanView.routeName,
      page: () => CancelPeminjamanView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: CancelPeminjamanBinding(),
    ),
    GetPage(
      name: RejectedView.routeName,
      page: () => RejectedView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: RejectedBinding(),
    ),
    GetPage(
      name: DataPeminjamanView.routeName,
      page: () => DataPeminjamanView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: DataPeminjamanBinding(),
    ),
    GetPage(
      name: EditPinjamanView.routeName,
      page: () => EditPinjamanView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: EditPinjamanBinding(),
    ),
    GetPage(
      name: DataPengembalianView.routeName,
      page: () => DataPengembalianView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PengembalianBinding(),
    ),
    GetPage(
      name: EditDataPengembalian.routeName,
      page: () => EditDataPengembalian(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: EditPengembalianAdminBinding(),
    ),
    GetPage(
      name: ArsipDibatalkanView.routeName,
      page: () => ArsipDibatalkanView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: ArsipDibatalkanBinding(),
    ),
    GetPage(
      name: PersetujuanView.routeName,
      page: () => PersetujuanView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PersetujuanAdminBinding(),
    ),
    GetPage(
      name: PengembalianView.routeName,
      page: () => PengembalianView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: PengembalianAdminBinding(),
    ),
    GetPage(
      name: ReportPdfView.routeName,
      page: () => ReportPdfView(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: ReportPdfAdminBinding(),
    ),
  ];
}
