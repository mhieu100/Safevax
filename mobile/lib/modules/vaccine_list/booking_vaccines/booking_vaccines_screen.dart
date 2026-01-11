import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/booking_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_list/booking_vaccines/booking_vaccines_controller.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_list/person_selection/person_selection_controller.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/extension/num_ext.dart';
import 'package:flutter_getx_boilerplate/shared/shared.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class BookingVaccinesScreen extends GetView<BookingVaccinesController> {
  const BookingVaccinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Lịch Tiêm chủng',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: ColorConstants.primaryGreen,
        elevation: 0.5,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.selectedVaccines.isEmpty) {
          return _buildNoVaccinesSelected();
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVaccinesSummary(),
                    const SizedBox(height: 20),
                    _buildFamilyMemberSection(),
                    const SizedBox(height: 20),
                    _buildFacilitySection(),
                    const SizedBox(height: 20),
                    _buildSchedulingForm(),
                  ],
                ),
              ),
            ),
            _buildBottomActionBar(),
          ],
        );
      }),
    );
  }

  Widget _buildFacilitySection() {
    return Obx(() {
      final facility = controller.confirmedFacility.value;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cơ sở tiêm chủng',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => controller.pickFacility(),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FDFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: facility == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE6F7F5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 20,
                              color: ColorConstants.secondaryGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Chọn cơ sở tiêm chủng',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: ColorConstants.secondaryGreen,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.local_hospital,
                              size: 28, color: ColorConstants.secondaryGreen),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  facility.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstants.secondaryGreen,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        facility.address,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.phone,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      facility.phone,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      facility.hours,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 16, color: ColorConstants.secondaryGreen),
                        ],
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFamilyMemberSection() {
    return Obx(() {
      final selectedMember = controller.selectedPerson.value;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Đặt lịch cho',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final selectedPerson =
                    await Get.toNamed(Routes.personSelection);
                if (selectedPerson != null) {
                  controller.selectedPerson.value = selectedPerson;
                  controller.updateSchedulingStatus();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FDFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: selectedMember == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE6F7F5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_add,
                              size: 20,
                              color: ColorConstants.secondaryGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Chọn người đặt lịch',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: ColorConstants.secondaryGreen,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          // Avatar with enhanced styling
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorConstants.secondaryGreen
                                    .withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorConstants.secondaryGreen
                                      .withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundImage: selectedMember
                                          .avatar.isNotEmpty &&
                                      selectedMember.avatar !=
                                          'assets/images/circle_avatar.png'
                                  ? (selectedMember.avatar.startsWith('http')
                                      ? NetworkImage(selectedMember.avatar)
                                          as ImageProvider<Object>
                                      : AssetImage(selectedMember.avatar))
                                  : null,
                              backgroundColor: Colors.white,
                              child: selectedMember.avatar.isEmpty ||
                                      selectedMember.avatar ==
                                          'assets/images/circle_avatar.png'
                                  ? Icon(
                                      Icons.person,
                                      color: const Color(0xFF199A8E),
                                      size: 28,
                                    )
                                  : null,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Person information
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name with badge
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        selectedMember.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1A1F36),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    if (selectedMember.isCurrentUser)
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: ColorConstants.secondaryGreen
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: ColorConstants.secondaryGreen
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        child: const Text(
                                          'Tôi',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                ColorConstants.secondaryGreen,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                // Relation and Gender on the same row
                                Row(
                                  children: [
                                    // Relation with icon
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE3F2FD),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            selectedMember.isCurrentUser
                                                ? Icons.person_outline
                                                : Icons.family_restroom,
                                            size: 12,
                                            color: const Color(0xFF1976D2),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            selectedMember.relation,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF1976D2),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    if (selectedMember.gender != null &&
                                        selectedMember.gender!.isNotEmpty)
                                      const SizedBox(width: 8),

                                    // Gender component
                                    if (selectedMember.gender != null &&
                                        selectedMember.gender!.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFCE4EC),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              selectedMember.gender == 'Nam'
                                                  ? Icons.male
                                                  : Icons.female,
                                              size: 12,
                                              color: const Color(0xFFC2185B),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              selectedMember.gender!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFFC2185B),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Contact info and DOB
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Phone
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 14,
                                          color: const Color(0xFF38a169),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            selectedMember.phone ?? '',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    // Date of birth
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.cake,
                                          size: 14,
                                          color: const Color(0xFFe53e3e),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Sinh ngày: ${selectedMember.dob}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
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
          ],
        ),
      );
    });
  }

  Widget _buildNoVaccinesSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.medical_services_outlined,
              size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Chưa có vaccine nào được chọn',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Quay lại chọn vaccine'),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccinesSummary() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vaccine đã chọn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(height: 12),
          ...controller.selectedVaccines
              .map((vaccine) => _buildVaccineSummaryItem(vaccine)),
        ],
      ),
    );
  }

// Trong _buildVaccineSummaryItem
  Widget _buildVaccineSummaryItem(VaccineModel vaccine) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFEFF6FF),
                ),
                child: vaccine.imageUrl.isNotEmpty
                    ? Image.network(vaccine.imageUrl, fit: BoxFit.cover)
                    : const Icon(Icons.medical_services,
                        size: 24, color: Color(0xFF3B82F6)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vaccine.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${vaccine.price.formatNumber()}₫',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vaccine.description ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Trong _buildVaccineHeader
  Widget _buildVaccineHeader(VaccineModel vaccine) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medical_services,
                  size: 16, color: Color(0xFF3B82F6)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  vaccine.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulingForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thiết lập Lịch Tiêm',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(height: 16),
          ..._buildDoseSchedulingItems(),
        ],
      ),
    );
  }

  List<Widget> _buildDoseSchedulingItems() {
    final widgets = <Widget>[];
    int currentVaccineIndex = 0;

    for (int doseKey = 1;
        doseKey <= controller.doseSchedules.length;
        doseKey++) {
      final scheduling = controller.doseSchedules[doseKey]!;

      // Only show dose 1 for each vaccine
      if (scheduling.vaccineDoseNumber == 1) {
        widgets.add(_buildDoseSchedulingItem(doseKey, scheduling));
        widgets.add(const SizedBox(height: 12));

        currentVaccineIndex++;
        if (currentVaccineIndex < controller.selectedVaccines.length) {
          widgets.add(const Divider(height: 24));
          widgets.add(const SizedBox(height: 8));
        }
      }
    }

    return widgets;
  }

// Trong _buildDoseSchedulingItem, thêm nút chỉnh sửa
  Widget _buildDoseSchedulingItem(int doseKey, DoseScheduling scheduling) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVaccineHeader(scheduling.vaccine),
          const SizedBox(height: 12),

          // Date Picker
          _buildDateTimeField(
            label: 'Ngày tiêm',
            value: controller.selectedDates[doseKey] != null
                ? DateFormat('dd/MM/yyyy')
                    .format(controller.selectedDates[doseKey]!)
                : 'Chưa chọn ngày',
            icon: Icons.calendar_today,
            onTap: () => _selectDate(doseKey),
          ),
          const SizedBox(height: 8),

          // Time Dropdown
          _buildTimeDropdown(doseKey),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final timeLabels = {
      'SLOT_07_00': '07:00 - 09:00',
      'SLOT_09_00': '09:00 - 11:00',
      'SLOT_11_00': '11:00 - 13:00',
      'SLOT_13_00': '13:00 - 15:00',
      'SLOT_15_00': '15:00 - 17:00',
    };
    return timeLabels['SLOT_${time.hour.toString().padLeft(2, '0')}_00'] ??
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate(int doseKey) async {
    final scheduling = controller.doseSchedules[doseKey];
    if (scheduling == null) {
      Get.snackbar(
        'Lỗi',
        'Không tìm thấy thông tin lịch tiêm cho doseKey: $doseKey',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    final now = DateTime.now();
    final firstDate = now.add(const Duration(days: 1));
    final lastDate = now.add(const Duration(days: 365));

    final DateTime? currentlySelectedDate = controller.selectedDates[doseKey];
    DateTime initialDate = firstDate;

    if (currentlySelectedDate != null) {
      // Check if the currently selected date satisfies the selectableDayPredicate
      final occupiedDates = _getOccupiedDates(doseKey);
      final isSelectable = !occupiedDates.any((occupiedDate) =>
          occupiedDate.year == currentlySelectedDate.year &&
          occupiedDate.month == currentlySelectedDate.month &&
          occupiedDate.day == currentlySelectedDate.day);

      if (isSelectable && currentlySelectedDate.isAfter(firstDate)) {
        initialDate = currentlySelectedDate;
      }
    }

    final TimeOfDay? currentlySelectedTime = controller.selectedTimes[doseKey];
    final TimeOfDay initialTime =
        currentlySelectedTime ?? const TimeOfDay(hour: 7, minute: 0);

    final occupiedDates = _getOccupiedDates(doseKey);
    final availableTimeSlots = _generateAvailableTimes([]);

    // Find a safe initial date that satisfies the selectableDayPredicate
    DateTime safeInitialDate = firstDate;
    for (int i = 0; i < 365; i++) {
      final testDate = firstDate.add(Duration(days: i));
      final isSelectable = !occupiedDates.any((occupiedDate) =>
          occupiedDate.year == testDate.year &&
          occupiedDate.month == testDate.month &&
          occupiedDate.day == testDate.day);
      if (isSelectable) {
        safeInitialDate = testDate;
        break;
      }
    }

    _showAdvancedDateTimeDialog(
      doseKey: doseKey,
      scheduling: scheduling,
      initialDate: safeInitialDate,
      initialTime: initialTime,
      firstDate: firstDate,
      lastDate: lastDate,
      occupiedDates: occupiedDates,
      availableTimeSlots: availableTimeSlots,
    );
  }

  List<DateTime> _getOccupiedDates(int currentDoseKey) {
    final occupiedDates = <DateTime>[];

    for (final entry in controller.selectedDates.entries) {
      if (entry.key != currentDoseKey && entry.value != null) {
        // Chỉ xem xét các ngày đã bị chiếm dụng nếu chúng có giờ được chọn
        if (controller.selectedTimes[entry.key] != null) {
          occupiedDates.add(entry.value!);
        }
      }
    }

    return occupiedDates;
  }

  Future<void> _selectTime(int doseKey) async {
    final selectedDate = controller.selectedDates[doseKey];
    if (selectedDate == null) {
      Get.snackbar(
        'Thông báo',
        'Vui lòng chọn ngày trước khi chọn giờ',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
      );
      return;
    }

    final scheduling = controller.doseSchedules[doseKey];
    if (scheduling == null) {
      Get.snackbar(
        'Lỗi',
        'Không tìm thấy thông tin lịch tiêm cho doseKey: $doseKey',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    final now = DateTime.now();
    final firstDate = now.add(const Duration(days: 1));
    final lastDate = now.add(const Duration(days: 365));

    final DateTime initialDate = selectedDate;
    final TimeOfDay? currentlySelectedTime = controller.selectedTimes[doseKey];
    final TimeOfDay initialTime =
        currentlySelectedTime ?? const TimeOfDay(hour: 7, minute: 0);

    final occupiedDates = _getOccupiedDates(doseKey);
    final occupiedTimes = _getOccupiedTimesInSameDate(doseKey, selectedDate);
    final availableTimeSlots = _generateAvailableTimes(occupiedTimes);

    _showAdvancedDateTimeDialog(
      doseKey: doseKey,
      scheduling: scheduling,
      initialDate: initialDate,
      initialTime: initialTime,
      firstDate: firstDate,
      lastDate: lastDate,
      occupiedDates: occupiedDates,
      availableTimeSlots: availableTimeSlots,
    );
  }

  List<TimeOfDay> _getOccupiedTimesInSameDate(
      int currentDoseKey, DateTime selectedDate) {
    final occupiedTimes = <TimeOfDay>[];

    for (final entry in controller.selectedDates.entries) {
      if (entry.key != currentDoseKey &&
          entry.value != null &&
          controller.selectedTimes[entry.key] != null) {
        final otherDate = entry.value!;
        if (otherDate.year == selectedDate.year &&
            otherDate.month == selectedDate.month &&
            otherDate.day == selectedDate.day) {
          occupiedTimes.add(controller.selectedTimes[entry.key]!);
        }
      }
    }

    return occupiedTimes;
  }

  List<TimeOfDay> _generateAvailableTimes(List<TimeOfDay> occupiedTimes) {
    final predefinedTimes = [
      const TimeOfDay(hour: 7, minute: 0),
      const TimeOfDay(hour: 9, minute: 0),
      const TimeOfDay(hour: 11, minute: 0),
      const TimeOfDay(hour: 13, minute: 0),
      const TimeOfDay(hour: 15, minute: 0),
    ];

    return predefinedTimes
        .where((time) => !occupiedTimes.any((occupiedTime) =>
            occupiedTime.hour == time.hour &&
            occupiedTime.minute == time.minute))
        .toList();
  }

  Widget _buildDateTimeField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF6B7280)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: value.contains('Chưa chọn')
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDropdown(int doseKey) {
    final selectedDate = controller.selectedDates[doseKey];
    if (selectedDate == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giờ tiêm',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Vui lòng chọn ngày trước',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final occupiedTimes = _getOccupiedTimesInSameDate(doseKey, selectedDate);
    final availableTimeSlots = _generateAvailableTimes(occupiedTimes);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: const Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Text(
                'Giờ tiêm',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          DropdownButton<TimeOfDay>(
            value:
                availableTimeSlots.contains(controller.selectedTimes[doseKey])
                    ? controller.selectedTimes[doseKey]
                    : null,
            hint: const Text('Chọn giờ'),
            isExpanded: true,
            underline: const SizedBox(),
            items: availableTimeSlots.map((timeSlot) {
              return DropdownMenuItem<TimeOfDay>(
                value: timeSlot,
                child: Text(
                  _formatTime(timeSlot),
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (TimeOfDay? newTime) {
              if (newTime != null) {
                controller.updateTime(doseKey, newTime);
                controller.updateSchedulingStatus();
                controller.update();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                controller.isSchedulingComplete.value ? _confirmBooking : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isSchedulingComplete.value
                  ? ColorConstants.buttontGreen
                  : Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Xác nhận',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      );
    });
  }

  void _confirmBooking() {
    if (!controller.validateScheduling()) {
      Get.snackbar(
        'Thiếu thông tin',
        'Vui lòng chọn đầy đủ ngày và giờ tiêm cho tất cả vaccine',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    final booking = controller.createBooking();
    NavigatorHelper.toBookingSummaryScreen(
      booking: booking,
    );
  }

  void _showAdvancedDateTimeDialog({
    required int doseKey,
    required dynamic scheduling,
    required DateTime initialDate,
    required TimeOfDay initialTime,
    required DateTime firstDate,
    required DateTime lastDate,
    required List<DateTime> occupiedDates,
    required List<TimeOfDay> availableTimeSlots,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: AdvancedDateTimeDialogContent(
          doseKey: doseKey,
          scheduling: scheduling,
          initialDate: initialDate,
          initialTime: initialTime,
          firstDate: firstDate,
          lastDate: lastDate,
          occupiedDates: occupiedDates,
          availableTimeSlots: availableTimeSlots,
          onConfirm: (DateTime selectedDate, TimeOfDay selectedTime) {
            controller.updateDate(doseKey, selectedDate);
            controller.updateTime(doseKey, selectedTime);
            controller.updateSchedulingStatus();
            controller.update();
          },
        ),
      ),
      barrierDismissible: true,
    );
  }
}

class AdvancedDateTimeDialogContent extends StatefulWidget {
  final int doseKey;
  final dynamic scheduling;
  final DateTime initialDate;
  final TimeOfDay initialTime;
  final DateTime firstDate;
  final DateTime lastDate;
  final List<DateTime> occupiedDates;
  final List<TimeOfDay> availableTimeSlots;
  final Function(DateTime, TimeOfDay) onConfirm;

  const AdvancedDateTimeDialogContent({
    super.key,
    required this.doseKey,
    required this.scheduling,
    required this.initialDate,
    required this.initialTime,
    required this.firstDate,
    required this.lastDate,
    required this.occupiedDates,
    required this.availableTimeSlots,
    required this.onConfirm,
  });

  @override
  State<AdvancedDateTimeDialogContent> createState() =>
      _AdvancedDateTimeDialogContentState();
}

class _AdvancedDateTimeDialogContentState
    extends State<AdvancedDateTimeDialogContent> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  bool _isDatePickerOpen = false;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.calendar_today,
                  color: ColorConstants.secondaryGreen),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Chọn ngày và giờ tiêm",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Vaccine info
          Text(
            "Vaccine: ${widget.scheduling.vaccine.name}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 20),

          // Date selection
          const Text(
            "Ngày tiêm:",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const Icon(Icons.calendar_today, size: 20),
              title: Text(
                  DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(selectedDate)),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () async {
                if (_isDatePickerOpen || !mounted) return;

                setState(() {
                  _isDatePickerOpen = true;
                });

                try {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    selectableDayPredicate: (DateTime day) {
                      return !widget.occupiedDates.any((occupiedDate) =>
                          occupiedDate.year == day.year &&
                          occupiedDate.month == day.month &&
                          occupiedDate.day == day.day);
                    },
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: ColorConstants.secondaryGreen,
                            onPrimary: Colors.white,
                            surface: Colors.white,
                            onSurface: Colors.black,
                          ),
                          dialogTheme: const DialogThemeData(
                              backgroundColor: Colors.white),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null &&
                      pickedDate != selectedDate &&
                      mounted) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                } finally {
                  if (mounted) {
                    setState(() {
                      _isDatePickerOpen = false;
                    });
                  }
                }
              },
            ),
          ),

          const SizedBox(height: 20),

          // Time selection
          const Text(
            "Giờ tiêm:",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),

          Text(
            "Chọn khung giờ trống:",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),

          // Dropdown for time slots
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<TimeOfDay>(
              value: selectedTime,
              isExpanded: true,
              underline: const SizedBox(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              items: widget.availableTimeSlots.map((timeSlot) {
                return DropdownMenuItem<TimeOfDay>(
                  value: timeSlot,
                  child: Text(
                    _formatTime(timeSlot),
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (TimeOfDay? newTime) {
                if (newTime != null) {
                  setState(() {
                    selectedTime = newTime;
                  });
                }
              },
            ),
          ),

          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[400]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Hủy"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onConfirm(selectedDate, selectedTime);
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.secondaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Xác nhận"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final timeLabels = {
      'SLOT_07_00': '07:00 - 09:00',
      'SLOT_09_00': '09:00 - 11:00',
      'SLOT_11_00': '11:00 - 13:00',
      'SLOT_13_00': '13:00 - 15:00',
      'SLOT_15_00': '15:00 - 17:00',
    };
    return timeLabels['SLOT_${time.hour.toString().padLeft(2, '0')}_00'] ??
        '${time.hour.toString().padLeft(2, '0')}:00';
  }
}
