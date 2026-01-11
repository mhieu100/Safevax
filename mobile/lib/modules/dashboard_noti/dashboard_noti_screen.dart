// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/dashboard_noti/dashboard_noti_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardNotiScreen extends GetView<DashboardNotiController> {
  const DashboardNotiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    const Color primaryColor = Color(0xFF199A8E);
    const Color alertColor = Color(0xFFF44336);
    const Color warningColor = Color(0xFFFF9800);
    const Color infoColor = Color(0xFF2196F3);

    return Scaffold(
      backgroundColor: ColorConstants.lightBackGround,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 80.0,
              floating: false,
              pinned: true,
              elevation: 0,
              shadowColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/images/safe_vax_logo.png',
                      height: 32.h,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'SafeVaxx',
                      style: TextStyle(
                        color: ColorConstants.primaryGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 20.w, bottom: 18.h),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorConstants.secondaryGreen.withOpacity(0.15),
                        ColorConstants.secondaryGreen.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorConstants.secondaryGreen.withOpacity(0.2),
                        width: 2.w,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 18.w,
                      backgroundImage: NetworkImage(
                        StorageService.userData?['avatar'] ??
                            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=200&q=80',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.all(20.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  /// HEADER
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                          "Xin chào, ${controller.userName.value.isNotEmpty ? controller.userName.value : 'Người dùng'} 👋",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87))),
                      SizedBox(height: 4.h),
                      Text("Giữ sức khỏe & luôn cập nhật",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey)),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  /// UPCOMING APPOINTMENT CARD
                  Obx(() {
                    if (controller.hasUpcomingAppointment.value) {
                      return _AppointmentCard(
                        date: controller.upcomingAppointment.value,
                        time: controller.upcomingTime.value,
                        vaccine: controller.upcomingVaccine.value,
                        doctor: controller.upcomingDoctor.value,
                        location: controller.upcomingLocation.value,
                        controller: controller,
                      );
                    } else {
                      return _NoAppointmentCard(controller: controller);
                    }
                  }),

                  SizedBox(height: 24.h),

                  /// HEALTH STATS GRID
                  Obx(() => GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 8.w,
                        childAspectRatio: 1.2,
                        children: [
                          _StatCard(
                            title: "Số mũi đã tiêm",
                            icon: Icons.vaccines,
                            value: controller.dosesTaken.value,
                            color: primaryColor,
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withOpacity(0.6),
                                primaryColor.withOpacity(0.9),
                              ],
                            ),
                            onTap: () {
                              controller.toVaccineManagementScreen();
                            },
                          ),
                          _StatCard(
                            title: "Vắc xin còn thiếu",
                            icon: Icons.warning_amber_rounded,
                            value: controller.vaccinesMissing.value,
                            color: warningColor,
                            gradient: LinearGradient(
                              colors: [
                                warningColor.withOpacity(0.6),
                                warningColor.withOpacity(0.9),
                              ],
                            ),
                            onTap: () {
                              controller.toVaccineMissingScreen();
                            },
                          ),
                          _StatCard(
                            title: "Lịch hẹn",
                            icon: Icons.event_available,
                            value: controller.appointmentCount.value,
                            color: infoColor,
                            gradient: LinearGradient(
                              colors: [
                                infoColor.withOpacity(0.6),
                                infoColor.withOpacity(0.9),
                              ],
                            ),
                            onTap: () {
                              controller.toAppointmentListScreen();
                            },
                          ),
                          _StatCard(
                            title: "Cảnh báo sức khỏe",
                            icon: Icons.notifications_active,
                            value: controller.healthAlertsCount.value,
                            color: alertColor,
                            gradient: LinearGradient(
                              colors: [
                                alertColor.withOpacity(0.6),
                                alertColor.withOpacity(0.9),
                              ],
                            ),
                            onTap: () {
                              controller.toMedicalAlertsScreen();
                            },
                          ),
                        ],
                      )),

                  SizedBox(height: 24.h),

                  /// NOTIFICATIONS SECTION
                  Row(
                    children: [
                      Text(
                        "Thông báo",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          controller.toMedicalAlertsScreen();
                        },
                        child: const Text("Xem tất cả"),
                      ),
                    ],
                  ),
                ]),
              ),
            ),

            /// NOTIFICATIONS LIST
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: Obx(() => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final notif = controller.notifications[index];
                        return _NotificationCard(
                          icon: notif['icon'] as IconData,
                          title: notif['title'] as String,
                          message: notif['message'] as String,
                          time: notif['time'] as String,
                          type: notif['type'] as String,
                          onTap: () {
                            controller.toMedicalAlertsDetailScreen();
                          },
                        );
                      },
                      childCount: controller.notifications.length,
                    ),
                  )),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String date;
  final String time;
  final String vaccine;
  final String doctor;
  final String location;
  final DashboardNotiController controller;

  const _AppointmentCard({
    required this.date,
    required this.time,
    required this.vaccine,
    required this.doctor,
    required this.location,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.toAppointmentListScreen(),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF199A8E), Color(0xFF2AB7C6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.calendar_today,
                      color: Colors.white, size: 20.w),
                ),
                SizedBox(width: 12.w),
                Text(
                  "Lịch hẹn sắp tới",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              date,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 4.h),
            Text(
              "lúc $time",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
            ),
            SizedBox(height: 16.h),
            _DetailRow(
              icon: Icons.medical_services,
              text: vaccine,
            ),
            SizedBox(height: 8.h),
            _DetailRow(
              icon: Icons.person,
              text: doctor,
            ),
            SizedBox(height: 8.h),
            _DetailRow(
              icon: Icons.location_on,
              text: location,
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  controller.toAppointmentRescheduleScreen();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: const Text("Xem chi tiết"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoAppointmentCard extends StatelessWidget {
  final DashboardNotiController controller;

  const _NoAppointmentCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: ColorConstants.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available,
              color: ColorConstants.primaryGreen,
              size: 24.w,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Không có lịch hẹn sắp tới",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Bạn chưa có lịch tiêm chủng nào sắp tới. Hãy đặt lịch để bảo vệ sức khỏe!",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () {
              controller.toVaccineListScreen();
            },
            icon: const Icon(Icons.add),
            label: const Text("Đặt lịch tiêm"),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.primaryGreen,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.w, color: Colors.white.withOpacity(0.6)),
        SizedBox(width: 12.w),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final Color color;
  final Gradient gradient;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.icon,
    required this.value,
    required this.color,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 20.w),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final String type;
  final VoidCallback onTap; // add this

  const _NotificationCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.onTap,
  });

  Color _getCardColor() {
    switch (type) {
      case 'alert':
        return const Color(0xFFFEEBEE);
      case 'warning':
        return const Color(0xFFFFF8E1);
      case 'info':
        return const Color(0xFFE3F2FD);
      default:
        return const Color(0xFFE8F5E9);
    }
  }

  Color _getIconColor() {
    switch (type) {
      case 'alert':
        return const Color(0xFFF44336);
      case 'warning':
        return const Color(0xFFFF9800);
      case 'info':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: _getIconColor().withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _getIconColor()),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black, // Changed to black
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style:
                  const TextStyle(color: Colors.black87), // Changed to black87
            ),
            SizedBox(height: 4.h),
            Text(
              time,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black54, // Changed to black54
                  ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.black54, // Changed to black54
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        onTap: onTap,
      ),
    );
  }
}
