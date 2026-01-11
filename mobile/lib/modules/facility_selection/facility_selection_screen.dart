// ignore_for_file: deprecated_member_use

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vietnam_address/vietnam_address.dart';
import 'package:flutter_getx_boilerplate/modules/facility_selection/facility_selection_controller.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:get/get.dart';

class FacilitySelectionScreen extends GetView<FacilitySelectionController> {
  const FacilitySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chọn cơ sở tiêm chủng',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Get.toNamed(Routes.facilityMap);
            },
            tooltip: 'Xem bản đồ',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorConstants.secondaryGreen.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSearchBar(),
                _buildAllFiltersSection(),
                Obx(() {
                  if (controller.isLoading.value) {
                    return _buildLoadingState();
                  }
                  return _buildFacilityList();
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onChanged: controller.setSearchQuery,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm cơ sở tiêm chủng...',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16.sp),
            prefixIcon: Icon(
              Icons.search,
              color: ColorConstants.secondaryGreen,
              size: 20.w,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: ColorConstants.secondaryGreen,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        ),
      ),
    );
  }

  Widget _buildAllFiltersSection() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title for all filters
            Text(
              'Bộ lọc:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 12.h),

            // Sort filters (Gần nhất, Đánh giá cao) - in one row
            Row(
              children: [
                _buildSortFilterChip(
                  'Gần nhất',
                  controller.filterByDistance.value,
                  () => controller.toggleDistanceFilter(),
                ),
                SizedBox(width: 8.w),
                _buildSortFilterChip(
                  'Đánh giá cao',
                  controller.filterByRating.value,
                  () => controller.toggleRatingFilter(),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            if (controller.provinces.isNotEmpty) ...[
              Text(
                'Lọc theo địa chỉ:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  // Province filter
                  _buildLocationDropdown(
                    'Tỉnh/Thành phố',
                    controller.selectedProvince.value,
                    controller.provinces,
                    (value) =>
                        controller.selectProvince(value as VietnamProvince?),
                  ),

                  // District filter
                  if (controller.selectedProvince.value != null &&
                      controller.districts.isNotEmpty)
                    _buildLocationDropdown(
                      'Quận/Huyện',
                      controller.selectedDistrict.value,
                      controller.districts,
                      (value) =>
                          controller.selectDistrict(value as VietnamDistrict?),
                    ),

                  // Ward filter
                  if (controller.selectedDistrict.value != null &&
                      controller.wards.isNotEmpty)
                    _buildLocationDropdown(
                      'Phường/Xã',
                      controller.selectedWard.value,
                      controller.wards,
                      (value) => controller.selectWard(value as VietnamWard?),
                    ),

                  // Clear filter button
                  if (controller.selectedProvince.value != null ||
                      controller.selectedDistrict.value != null ||
                      controller.selectedWard.value != null)
                    _buildClearFilterButton(),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildSortFilterChip(
      String label, bool isSelected, VoidCallback onTap) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: ColorConstants.buttontGreen,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor:
            isSelected ? ColorConstants.buttontGreen : Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color:
                isSelected ? ColorConstants.buttontGreen : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        elevation: isSelected ? 4 : 0,
        shadowColor: ColorConstants.buttontGreen.withOpacity(0.3),
      ),
    );
  }

  Widget _buildClearFilterButton() {
    return InputChip(
      label: const Text(
        'Xóa bộ lọc',
        style: TextStyle(fontSize: 12),
      ),
      onPressed: controller.clearLocationFilters,
      backgroundColor: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildLocationDropdown(
    String label,
    dynamic selectedValue,
    List<dynamic> items,
    Function(dynamic)? onChanged,
  ) {
    return Container(
      constraints: BoxConstraints(minWidth: 120, maxWidth: 160.w),
      child: DropdownSearch<dynamic>(
        selectedItem: selectedValue,
        dropdownBuilder: (context, selectedItem) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedItem != null
                        ? (selectedItem.name.length > 15
                            ? '${selectedItem.name.substring(0, 15)}...'
                            : selectedItem.name)
                        : 'Chọn $label',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm $label',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          menuProps: const MenuProps(
            elevation: 1,
            backgroundColor: Colors.white,
            // constraints: BoxConstraints(maxHeight: 250),
          ),
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                item.name.length > 15
                    ? '${item.name.substring(0, 15)}...'
                    : item.name,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
              selected: isSelected,
            );
          },
          searchDelay: const Duration(milliseconds: 100),
        ),
        items: items,
        compareFn: (item1, item2) => item1 == item2,
        itemAsString: (item) => item.name,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.4,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải danh sách cơ sở tiêm chủng...'),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityList() {
    return Obx(() {
      if (controller.filteredFacilities.isEmpty) {
        return _buildEmptyState();
      }

      return Container(
        height: MediaQuery.of(Get.context!).size.height *
            0.6, // Fixed height for list
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.filteredFacilities.length,
          itemBuilder: (context, index) {
            final facility = controller.filteredFacilities[index];
            return Obx(() {
              final isSelected =
                  controller.selectedFacility.value?.id == facility.id;
              return _buildFacilityCard(facility, isSelected);
            });
          },
        ),
      );
    });
  }

  Widget _buildFacilityCard(HealthcareFacility facility, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      key: ValueKey(facility.id),
      margin: EdgeInsets.only(bottom: 16.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
              ? const BorderSide(color: ColorConstants.buttontGreen, width: 3)
              : BorderSide.none,
        ),
        elevation: isSelected ? 8 : 3,
        shadowColor: isSelected
            ? ColorConstants.buttontGreen.withOpacity(0.3)
            : Colors.grey.withOpacity(0.2),
        child: InkWell(
          onTap: () {
            controller.selectFacility(facility);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        ColorConstants.buttontGreen.withOpacity(0.05),
                        ColorConstants.buttontGreen.withOpacity(0.1),
                      ],
                    )
                  : null,
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorConstants.buttontGreen.withOpacity(0.1)
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.local_hospital,
                          color: isSelected
                              ? ColorConstants.buttontGreen
                              : Colors.blue.shade600,
                          size: 24.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          facility.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? ColorConstants.buttontGreen
                                : Colors.black87,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(
                            color: ColorConstants.buttontGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16.w,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoRow(
                    Icons.location_on,
                    facility.address,
                    Colors.red.shade600,
                  ),
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    Icons.phone,
                    facility.phone,
                    Colors.green.shade600,
                  ),
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    Icons.access_time,
                    facility.hours,
                    Colors.purple.shade600,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoRow(
                          Icons.directions_car,
                          '${facility.distance.toStringAsFixed(1)} km',
                          Colors.orange.shade600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 14.w,
                              color: Colors.amber[700],
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              facility.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (isSelected) ...[
                    SizedBox(height: 16.h),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: ColorConstants.buttontGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorConstants.buttontGreen.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: ColorConstants.buttontGreen,
                            size: 20.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Đã chọn cơ sở này',
                            style: TextStyle(
                              color: ColorConstants.buttontGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: iconColor),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.4,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 60.w, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              'Không tìm thấy cơ sở tiêm chủng nào',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                'Hãy thử điều chỉnh bộ lọc hoặc tìm kiếm với từ khóa khác.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => controller.loadFacilities(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.buttontGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Thử lại',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Obx(() {
      final isEnabled = controller.selectedFacility.value != null;

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled ? () => controller.confirmSelection() : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isEnabled ? ColorConstants.buttontGreen : Colors.grey[300],
              foregroundColor: isEnabled ? Colors.white : Colors.grey[500],
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Xác nhận',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }
}
