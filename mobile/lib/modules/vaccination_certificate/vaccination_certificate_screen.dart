// lib/modules/vaccination_certificate/vaccination_certificate_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/response/booking_history_response.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/modules/vaccination_certificate/vaccination_certificate_controller.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VaccinationCertificateScreen
    extends GetView<VaccinationCertificateController> {
  const VaccinationCertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Chứng nhận tiêm chủng',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: ColorConstants.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white, size: 20.w),
        actions: [
          IconButton(
            icon: Icon(Icons.verified_user, size: 20.w),
            onPressed: controller.verifyCertificate,
            tooltip: 'Xác thực chứng nhận',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.certificate.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.w,
                  color: Colors.grey,
                ),
                SizedBox(height: 16.h),
                Text(
                  controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : 'Không tìm thấy thông tin chứng nhận',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: controller.goBack,
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                  child: Text(
                    'Quay lại',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          );
        }

        final certificate = controller.certificate.value!;
        final bookingHistory = controller.bookingHistoryData;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Certificate Header
              _buildCertificateHeader(certificate, bookingHistory),

              SizedBox(height: 24.h),

              // Certificate Status
              _buildCertificateStatus(bookingHistory),

              SizedBox(height: 16.h),

              // Patient Information
              if (bookingHistory != null)
                _buildPatientInformation(bookingHistory),

              SizedBox(height: 16.h),

              // Vaccine Information
              _buildVaccineInformation(certificate, bookingHistory),

              SizedBox(height: 16.h),

              // Vaccination Details
              _buildVaccinationDetails(certificate, bookingHistory),

              SizedBox(height: 16.h),

              // Certificate Information
              _buildCertificateInformation(bookingHistory),

              SizedBox(height: 24.h),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCertificateHeader(VaccineBooking certificate,
      [BookingHistoryData? bookingHistory]) {
    final displayName = bookingHistory != null
        ? (bookingHistory.familyMemberName ?? bookingHistory.patientName)
        : 'Bệnh nhân';

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ColorConstants.primaryGreen, ColorConstants.secondaryGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorConstants.primaryGreen.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.verified,
            size: 48.w,
            color: Colors.white,
          ),
          SizedBox(height: 12.h),
          Text(
            'CHỨNG NHẬN TIÊM CHỦNG',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            displayName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Mã đặt lịch: ${bookingHistory?.bookingId ?? certificate.confirmationCode}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateStatus([BookingHistoryData? bookingHistory]) {
    final isCompleted = bookingHistory?.bookingStatus == 'COMPLETED';
    final statusText = isCompleted ? 'Hoàn thành' : 'Đang tiến hành';
    final statusColor = isCompleted ? Colors.green : Colors.orange;
    final statusIcon = isCompleted ? Icons.check_circle : Icons.schedule;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trạng thái chứng nhận',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor),
              ),
              child: Row(
                children: [
                  Icon(
                    statusIcon,
                    color: statusColor,
                    size: 24.w,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Ngày tạo: ${bookingHistory != null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(bookingHistory.createdAt)) : 'N/A'}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
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
  }

  Widget _buildPatientInformation(BookingHistoryData bookingHistory) {
    final displayName =
        bookingHistory.familyMemberName ?? bookingHistory.patientName;
    final formattedAmount = NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
        .format(bookingHistory.totalAmount);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin bệnh nhân',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              icon: Icons.person,
              title: 'Tên bệnh nhân',
              value: displayName,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.confirmation_number,
              title: 'Mã đặt lịch',
              value: bookingHistory.bookingId.toString(),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.attach_money,
              title: 'Tổng tiền',
              value: formattedAmount,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.vaccines,
              title: 'Tổng mũi tiêm',
              value: bookingHistory.totalDoses.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccineInformation(VaccineBooking certificate,
      [BookingHistoryData? bookingHistory]) {
    final vaccineName = bookingHistory?.vaccineName ??
        certificate.vaccines.firstOrNull?.name ??
        'N/A';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin vaccine',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.vaccines,
                    color: ColorConstants.primaryGreen,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vaccineName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vaccine phòng ngừa bệnh',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
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
  }

  Widget _buildVaccinationDetails(VaccineBooking certificate,
      [BookingHistoryData? bookingHistory]) {
    final appointments = bookingHistory?.appointments ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chi tiết tiêm chủng',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            if (appointments.isNotEmpty)
              ...appointments.map((appointment) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: appointment.appointmentStatus == 'COMPLETED'
                          ? Colors.green[50]
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: appointment.appointmentStatus == 'COMPLETED'
                            ? Colors.green[200]!
                            : Colors.grey[200]!,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Mũi ${appointment.doseNumber}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:
                                    appointment.appointmentStatus == 'COMPLETED'
                                        ? Colors.green
                                        : ColorConstants.secondaryGreen,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    appointment.appointmentStatus == 'COMPLETED'
                                        ? Colors.green
                                        : ColorConstants.secondaryGreen,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                appointment.appointmentStatus == 'COMPLETED'
                                    ? 'Đã hoàn thành'
                                    : 'Chưa hoàn thành',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          icon: Icons.calendar_today,
                          title: 'Ngày tiêm',
                          value: DateFormat('dd/MM/yyyy').format(
                              DateTime.parse(appointment.scheduledDate)),
                        ),
                        const SizedBox(height: 4),
                        _buildDetailRow(
                          icon: Icons.access_time,
                          title: 'Giờ tiêm',
                          value: appointment.scheduledTime,
                        ),
                        const SizedBox(height: 4),
                        _buildDetailRow(
                          icon: Icons.location_on,
                          title: 'Địa điểm',
                          value: appointment.centerName,
                        ),
                        if (appointment.doctorName != null) ...[
                          const SizedBox(height: 4),
                          _buildDetailRow(
                            icon: Icons.person,
                            title: 'Bác sĩ',
                            value: appointment.doctorName!,
                          ),
                        ],
                        if (appointment.appointmentStatus == 'COMPLETED') ...[
                          const SizedBox(height: 4),
                          _buildDetailRow(
                            icon: Icons.check_circle,
                            title: 'Trạng thái',
                            value: 'Đã hoàn thành',
                          ),
                        ],
                      ],
                    ),
                  ))
            else
              ...certificate.doseBookings.values.map((dose) => InkWell(
                    onTap: () => Get.toNamed(
                        Routes.vaccineManagementAppointmentDetail,
                        arguments: certificate),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: dose.isCompleted
                            ? Colors.green[50]
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: dose.isCompleted
                              ? Colors.green[200]!
                              : Colors.grey[200]!,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Mũi ${dose.vaccineDoseNumber}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: dose.isCompleted
                                      ? Colors.green
                                      : ColorConstants.secondaryGreen,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: dose.isCompleted
                                      ? Colors.green
                                      : ColorConstants.secondaryGreen,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  dose.isCompleted
                                      ? 'Đã hoàn thành'
                                      : 'Chưa hoàn thành',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            icon: Icons.calendar_today,
                            title: 'Ngày tiêm',
                            value:
                                DateFormat('dd/MM/yyyy').format(dose.dateTime),
                          ),
                          const SizedBox(height: 4),
                          _buildDetailRow(
                            icon: Icons.access_time,
                            title: 'Giờ tiêm',
                            value: DateFormat('HH:mm').format(dose.dateTime),
                          ),
                          const SizedBox(height: 4),
                          _buildDetailRow(
                            icon: Icons.location_on,
                            title: 'Địa điểm',
                            value: dose.facility.name,
                          ),
                          if (dose.isCompleted && dose.completedAt != null) ...[
                            const SizedBox(height: 4),
                            _buildDetailRow(
                              icon: Icons.check_circle,
                              title: 'Hoàn thành',
                              value: DateFormat('dd/MM/yyyy HH:mm')
                                  .format(dose.completedAt!),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateInformation([BookingHistoryData? bookingHistory]) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin chứng nhận',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            if (bookingHistory != null) ...[
              _buildDetailRow(
                icon: Icons.calendar_today,
                title: 'Ngày tạo',
                value: DateFormat('dd/MM/yyyy HH:mm')
                    .format(DateTime.parse(bookingHistory.createdAt)),
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                icon: Icons.confirmation_number,
                title: 'Mã đặt lịch',
                value: bookingHistory.bookingId.toString(),
              ),
              const SizedBox(height: 12),
            ],
            _buildDetailRow(
              icon: Icons.qr_code,
              title: 'Mã QR',
              value: 'Quét mã để xác thực',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.security,
              title: 'Bảo mật',
              value: 'Chứng nhận điện tử có xác thực số',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.business,
              title: 'Cơ quan cấp',
              value: 'Trung tâm Y tế Quốc gia',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (controller.isCertificateCompleted())
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.isDownloading.value
                  ? null
                  : controller.downloadCertificate,
              icon: controller.isDownloading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.download),
              label: Text(controller.isDownloading.value
                  ? 'Đang tải...'
                  : 'Tải chứng nhận PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed:
                controller.isSharing.value ? null : controller.shareCertificate,
            icon: controller.isSharing.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          ColorConstants.primaryGreen),
                    ),
                  )
                : const Icon(Icons.share),
            label: Text(controller.isSharing.value
                ? 'Đang chia sẻ...'
                : 'Chia sẻ chứng nhận'),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorConstants.primaryGreen,
              side: const BorderSide(color: ColorConstants.primaryGreen),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: controller.goBack,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Quay lại'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[400]!),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
