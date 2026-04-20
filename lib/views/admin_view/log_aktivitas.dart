import 'package:flutter/material.dart';
import 'package:peminjaman_alat/controllers/log_aktivitas_controller.dart';
import 'package:peminjaman_alat/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class LogAktivitas extends StatefulWidget {
  const LogAktivitas({super.key});

  @override
  State<LogAktivitas> createState() => _LogAktivitasState();
}

class _LogAktivitasState extends State<LogAktivitas>
    with AutomaticKeepAliveClientMixin {
  final logC = Get.find<LogAktivitasController>();
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Log Aktivitas',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logC.fetchLogs();
            },
            icon: Icon(Icons.refresh, color: AppColors.primary),
          ),
        ],
      ),
      body: Obx(() {
        if (logC.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TimelineLog(
                      color: AppColors.primary,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                      title: 'approved',
                      titleColor: AppColors.primary,
                      text: logC.logApproved.value?.aksi ?? '',
                      time: timeago.format(
                        logC.logApproved.value?.createdAt ?? DateTime.now(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TimelineLog(
                      color: Colors.blue.shade800,
                      backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
                      title: 'update',
                      titleColor: Colors.blue.shade800,
                      text: logC.logUpdate.value?.aksi ?? '',
                      time: timeago.format(
                        logC.logUpdate.value?.createdAt ?? DateTime.now(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TimelineLog(
                      color: AppColors.warning,
                      backgroundColor: AppColors.warning.withValues(alpha: 0.2),
                      title: 'new item',
                      titleColor: AppColors.warning,
                      text: logC.logNewItem.value?.aksi ?? '',
                      time: timeago.format(
                        logC.logNewItem.value?.createdAt ?? DateTime.now(),
                      ),
                    ),
                    SizedBox(height: 15),
                    TimelineLog(
                      color: Colors.purple,
                      backgroundColor: Colors.purple.withValues(alpha: 0.2),
                      title: 'request',
                      titleColor: Colors.purple,
                      text: logC.logRequest.value?.aksi ?? '',
                      time: timeago.format(
                        logC.logRequest.value?.createdAt ?? DateTime.now(),
                        locale: 'id',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class TimelineLog extends StatelessWidget {
  final Color color;
  final Color backgroundColor;
  final String title;
  final Color titleColor;
  final String text;
  final String time;
  const TimelineLog({
    super.key,
    required this.color,
    required this.backgroundColor,
    required this.title,
    required this.titleColor,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Container(
                  width: 14,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 15),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textSecondary.withValues(alpha: 0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          color: titleColor,
                          fontFamily: 'Inter',
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Inter',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
