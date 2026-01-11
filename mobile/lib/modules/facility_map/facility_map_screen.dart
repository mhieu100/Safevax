// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/modules/facility_map/facility_map_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:flutter_getx_boilerplate/shared/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class _MapWidget extends StatelessWidget {
  const _MapWidget();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FacilityMapController>();
    print(
        'Building GoogleMap widget with ${controller.markers.length} markers');
    try {
      return Obx(() => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: controller.currentLocation.value,
              zoom: 12.0,
            ),
            markers: controller.markers,
            onMapCreated: controller.onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            onCameraMove: (position) =>
                print('Camera moved to: ${position.target}'),
          ));
    } catch (e) {
      print('Error building GoogleMap: $e');
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Text('Error loading map: $e'),
        ),
      );
    }
  }
}

class FacilityMapScreen extends GetView<FacilityMapController> {
  const FacilityMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bản đồ cơ sở tiêm chủng',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => controller.showFacilitiesList(),
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
          child: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState();
            }
            return _buildMapView();
          }),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải bản đồ cơ sở tiêm chủng...'),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Obx(() {
      if (controller.markers.isEmpty) {
        return _buildNoFacilitiesView();
      }
      return const _MapWidget();
    });
  }

  Widget _buildNoFacilitiesView() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80.w,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'Không có cơ sở tiêm chủng có tọa độ',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                'Các cơ sở tiêm chủng chưa có thông tin vị trí trên bản đồ. Vui lòng thử lại sau.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => controller.loadFacilities(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.buttontGreen,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
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
}
