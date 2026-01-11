// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/schedule_selection/schedule_selection_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleSelectionScreen extends GetView<ScheduleSelectionController> {
  const ScheduleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingState();
              }
              return _buildContent();
            }),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildProgressIndicator() {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressStep(1, 'Cơ sở tiêm', true, true),
              _buildProgressStep(
                  2,
                  'Lịch tiêm',
                  controller.selectedDate.value != null,
                  controller.selectedDate.value != null),
              _buildProgressStep(
                  3,
                  'Xác nhận',
                  controller.selectedTimeSlot.value != null,
                  controller.selectedTimeSlot.value != null),
            ],
          ),
        ));
  }

  Widget _buildProgressStep(
      int stepNumber, String title, bool isActive, bool isVisible) {
    if (!isVisible) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            stepNumber.toString(),
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [
                      const Color(0xFF199A8E).withOpacity(0.8),
                      const Color(0xFF17B8A6).withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isActive ? null : Colors.grey[300],
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF199A8E).withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              stepNumber.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF199A8E) : Colors.grey[600],
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF199A8E)),
          ),
          SizedBox(height: 16),
          Text('Đang tải lịch trống...'),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Obx(() {
      if (controller.isInitialized.value == false) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF199A8E)),
          ),
        );
      }

      // Chỉ hiển thị nội dung của bước hiện tại
      if (controller.selectedDate.value == null) {
        // Bước 1: Chọn ngày
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFacilityInfo(),
              const SizedBox(height: 24),
              _buildCalendar(),
            ],
          ),
        );
      } else {
        // Bước 2: Chọn giờ và xem lịch đề xuất
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFacilityInfo(),
              const SizedBox(height: 24),
              _buildCalendar(),
              const SizedBox(height: 24),
              _buildTimeSlots(),
              const SizedBox(height: 24),
              _buildVaccineSchedule(),
            ],
          ),
        );
      }
    });
  }

  Widget _buildFacilityInfo() {
    return Obx(() {
      final facility = controller.selectedFacility.value;
      if (facility == null) return const SizedBox();

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: const Color(0xFF199A8E).withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              // Navigate to facility detail
            },
            splashColor: const Color(0xFF199A8E).withOpacity(0.1),
            highlightColor: const Color(0xFF199A8E).withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF199A8E).withOpacity(0.2),
                              const Color(0xFF17B8A6).withOpacity(0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.local_hospital,
                          color: Color(0xFF199A8E),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Cơ sở tiêm chủng đã chọn',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    facility.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          facility.address,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF199A8E).withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF199A8E).withOpacity(0.2),
                          const Color(0xFF17B8A6).withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF199A8E),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Chọn ngày tiêm mũi 1',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 90)),
                focusedDay: controller.focusedDay.value,
                selectedDayPredicate: (day) {
                  return isSameDay(controller.selectedDate.value, day);
                },
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Tháng',
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFF199A8E),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: const Color(0xFF199A8E).withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false,
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  controller.selectDate(selectedDay);
                },
                onPageChanged: (focusedDay) {
                  controller.focusedDay.value = focusedDay;
                },
                locale: 'vi_VN',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Obx(() {
      if (controller.availableTimeSlots.isEmpty) {
        return const SizedBox();
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: const Color(0xFF199A8E).withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF199A8E).withOpacity(0.2),
                            const Color(0xFF17B8A6).withOpacity(0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.access_time,
                        color: Color(0xFF199A8E),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Chọn khung giờ tiêm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: controller.availableTimeSlots.map((slot) {
                    final isSelected =
                        controller.selectedTimeSlot.value == slot;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ChoiceChip(
                        label: Text(
                          slot,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF199A8E),
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            controller.selectTimeSlot(slot);
                          }
                        },
                        selectedColor: const Color(0xFF199A8E),
                        backgroundColor: Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : const Color(0xFF199A8E).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        elevation: isSelected ? 4 : 0,
                        shadowColor: isSelected
                            ? const Color(0xFF199A8E).withOpacity(0.3)
                            : Colors.transparent,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildVaccineSchedule() {
    return Obx(() {
      if (controller.selectedTimeSlot.value == null) return const SizedBox();

      final vaccine = controller.vaccine.value!;

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: const Color(0xFF199A8E).withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF199A8E).withOpacity(0.2),
                            const Color(0xFF17B8A6).withOpacity(0.2),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.schedule,
                        color: Color(0xFF199A8E),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Lịch tiêm đề xuất',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDoseSchedule(
                  doseNumber: 1,
                  date: controller.selectedDate.value,
                  time: controller.selectedTimeSlot.value,
                  isEditable: false,
                ),
                if (vaccine.numberOfDoses >= 2) ...[
                  const SizedBox(height: 16),
                  _buildDoseSchedule(
                    doseNumber: 2,
                    date: controller.suggestedSecondDoseDate.value,
                    time: controller.selectedTimeSlot.value,
                    isEditable: true,
                    onDateChanged: (newDate) {
                      controller.suggestedSecondDoseDate.value = newDate;
                    },
                  ),
                ],
                if (vaccine.numberOfDoses >= 3) ...[
                  const SizedBox(height: 16),
                  _buildDoseSchedule(
                    doseNumber: 3,
                    date: controller.suggestedThirdDoseDate.value,
                    time: controller.selectedTimeSlot.value,
                    isEditable: true,
                    onDateChanged: (newDate) {
                      controller.suggestedThirdDoseDate.value = newDate;
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDoseSchedule({
    required int doseNumber,
    required DateTime? date,
    required String? time,
    required bool isEditable,
    Function(DateTime)? onDateChanged,
  }) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF199A8E).withOpacity(0.2),
                  const Color(0xFF17B8A6).withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF199A8E).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                doseNumber.toString(),
                style: const TextStyle(
                  color: Color(0xFF199A8E),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mũi $doseNumber',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                if (date != null && time != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.event,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${dateFormat.format(date)} • $time',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ] else if (doseNumber > 1) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Sẽ được đề xuất sau khi chọn mũi 1',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isEditable && date != null) ...[
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF199A8E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Color(0xFF199A8E),
                ),
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: Get.context!,
                    initialDate: date,
                    firstDate: date.subtract(const Duration(days: 30)),
                    lastDate: date.add(const Duration(days: 60)),
                  );

                  if (selectedDate != null && onDateChanged != null) {
                    onDateChanged(selectedDate);
                  }
                },
                tooltip: 'Chỉnh sửa ngày',
                splashRadius: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Obx(() {
      final isEnabled = controller.isSelectionComplete;

      return Container(
        padding: EdgeInsets.fromLTRB(
            20, 16, 20, MediaQuery.of(Get.context!).padding.bottom + 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled ? controller.confirmSelection : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isEnabled ? const Color(0xFF199A8E) : Colors.grey[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: isEnabled ? 4 : 0,
              shadowColor: isEnabled
                  ? const Color(0xFF199A8E).withOpacity(0.3)
                  : Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isEnabled ? Icons.check_circle_outline : Icons.access_time,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  controller.selectedDate.value == null
                      ? 'Tiếp tục chọn giờ'
                      : 'Tiếp tục xác nhận',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
