import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:peminjaman_alat/providers/petugas/report_pdf_provider.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:peminjaman_alat/utils/convert_to_rupiah.dart';

class ReportPdfController extends GetxController {
  final _provder = Get.find<ReportPdfProvider>();
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final textRentangWaktu = 'Pilih Rentang Tanggal'.obs;
  final isLoading = false.obs;

  Future<void> rentangTanggal(BuildContext context) async {
    final pickedRangeDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      helpText: 'Pilih Rentang tanggal',
    );

    if (pickedRangeDate != null) {
      startDate.value = pickedRangeDate.start;
      endDate.value = DateTime(
        pickedRangeDate.end.year,
        pickedRangeDate.end.month,
        pickedRangeDate.end.day,
        23,
        59,
        59,
      );

      String formatStart = DateFormat('dd MMM yyyy').format(startDate.value!);
      String formatEnd = DateFormat('dd MMM yyyy').format(endDate.value!);
      textRentangWaktu.value = '$formatStart - $formatEnd';
    }
  }

  Future<void> getAndPrintPDF() async {
    if (startDate.value == null || endDate.value == null) {
      isLoading.value = false;
      Get.snackbar(
        'Peringatan',
        'Pilih tanggal laporan terlebih dahulu!',
        backgroundColor: AppColors.warning,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _provder.getData(
        Timestamp.fromDate(startDate.value!),
        Timestamp.fromDate(endDate.value!),
      );

      final dataLaporan = response.docs;

      if (dataLaporan.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          'Info',
          'Tidak ada transaksi pada tanggal tersebut!',
          backgroundColor: AppColors.warning,
          snackPosition: SnackPosition.TOP,
          animationDuration: Duration(milliseconds: 800),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.warning),
          colorText: AppColors.background,
        );
        return;
      }

      final doc = pw.Document();

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          header: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'LAPORAN PEMINJAMAN SIPINJAM',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Periode: ${DateFormat('dd MMM yyyy').format(startDate.value!)} - ${DateFormat('dd MMM yyyy').format(endDate.value!)}',
                ),
                pw.SizedBox(height: 20),
              ],
            );
          },
          footer: (context) {
            return pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Halaman ${context.pageNumber} dari ${context.pagesCount}',
              ),
            );
          },
          build: (context) => [
            pw.TableHelper.fromTextArray(
              context: context,
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey200),
              cellAlignment: pw.Alignment.centerLeft,
              headers: [
                'No',
                'Nama',
                'Daftar Alat',
                'Tgl Pinjam',
                'Tgl Kembali',
                'Denda',
                'Status',
              ],
              data: dataLaporan.asMap().entries.map((value) {
                final index = value.key + 1;
                final data = value.value.data() as Map<String, dynamic>;

                final nama = data['namaPeminjam'] ?? '-';
                List daftarAlat = data['detailPinjaman'] ?? [];
                final detailAlat = daftarAlat
                    .map((alat) => '- ${alat['nama']} (${alat['qty']}x)')
                    .join('\n');

                final tglPinjam = data['tanggalPinjam'] != null
                    ? DateFormat(
                        'dd/MM/yy',
                      ).format((data['tanggalPinjam'] as Timestamp).toDate())
                    : '-';
                final tglkembali = data['tanggalBarangKembali'] != null
                    ? DateFormat('dd/MM/yy').format(
                        (data['tanggalBarangKembali'] as Timestamp).toDate(),
                      )
                    : '-';

                final denda = data['denda'] == 0
                    ? '-'
                    : ConvertToRupiah.convertToRupiah(data['denda']);
                final status = data['status'] ?? '-';
                return [
                  index.toString(),
                  nama,
                  detailAlat,
                  tglPinjam,
                  tglkembali,
                  denda,
                  status,
                ];
              }).toList(),
            ),
          ],
        ),
      );

      final fileSave = await doc.save();

      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/Laporan_SIPINJAM_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );

      await file.writeAsBytes(fileSave);

      await OpenFile.open(file.path);

      startDate.value = null;
      endDate.value = null;
      textRentangWaktu.value = 'Pilih Rentang Tanggal';
    } catch (error) {
      Get.snackbar(
        'Erro',
        'Tidak dapat membuat laporan (gagal)',
        backgroundColor: AppColors.error,
        snackPosition: SnackPosition.TOP,
        animationDuration: Duration(milliseconds: 800),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.warning),
        colorText: AppColors.background,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
