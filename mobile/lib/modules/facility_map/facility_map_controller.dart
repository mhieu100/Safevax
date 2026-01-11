// lib/modules/facility_map/facility_map_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vietnam_address/vietnam_address.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/repositories/facility_map_repository.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FacilityMapController extends BaseController<FacilityMapRepository> {
  FacilityMapController(super.repository);

  // Reactive variables
  final facilities = <HealthcareFacility>[].obs;
  final vaccine = Rx<VaccineModel?>(null);
  final selectedFacility = Rx<HealthcareFacility?>(null);
  final isLoading = false.obs;

  // Map related
  late GoogleMapController mapController;
  final markers = <Marker>{}.obs;
  final currentLocation =
      const LatLng(10.8231, 106.6297).obs; // Ho Chi Minh City center

  @override
  void onInit() {
    super.onInit();
    _loadVaccineData();
    loadFacilities();
  }

  Future<void> loadFacilities() async {
    try {
      isLoading.value = true;
      final result = await repository.getHealthcareFacilities();
      facilities.assignAll(result);

      // Debug log: Log loaded facilities
      print('Loaded ${facilities.length} facilities');
      for (var facility in facilities) {
        print(
            'Facility: ${facility.name}, Address: ${facility.address}, Lat: ${facility.latitude}, Lng: ${facility.longitude}');
      }

      if (facilities.isNotEmpty && selectedFacility.value == null) {
        selectedFacility.value = facilities.first;
        // Show bottom sheet for the first facility
        Future.delayed(const Duration(milliseconds: 500), () {
          _showFacilityBottomSheet(facilities.first);
        });
      }

      _createMarkers();
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể tải danh sách cơ sở tiêm chủng',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _createMarkers() {
    final newMarkers = <Marker>{};

    for (final facility in facilities) {
      // Check if coordinates are valid (not null)
      if (facility.latitude != null && facility.longitude != null) {
        print(
            'Creating marker for ${facility.name} at ${facility.latitude}, ${facility.longitude}');
        final marker = Marker(
          markerId: MarkerId(facility.id),
          position: LatLng(facility.latitude!, facility.longitude!),
          onTap: () => selectFacility(facility),
          infoWindow: InfoWindow(
            title: facility.name,
            snippet: facility.address,
            onTap: () => selectFacility(facility),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            selectedFacility.value?.id == facility.id
                ? BitmapDescriptor.hueBlue
                : BitmapDescriptor.hueRed,
          ),
        );
        newMarkers.add(marker);
      } else {
        print(
            'Skipping marker for ${facility.name} - no coordinates available');
      }
    }

    print(
        'Created ${newMarkers.length} markers out of ${facilities.length} facilities');
    markers.assignAll(newMarkers);
  }

  void selectFacility(HealthcareFacility facility) {
    selectedFacility.value = facility;
    _createMarkers(); // Update markers to show selection
    _showFacilityBottomSheet(facility);
  }

  void _showFacilityBottomSheet(HealthcareFacility facility) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle indicator
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Facility header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_hospital,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    facility.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Facility details
            _buildBottomSheetInfoRow(
              Icons.location_on,
              facility.address,
              Colors.red.shade600,
            ),
            const SizedBox(height: 8),
            _buildBottomSheetInfoRow(
              Icons.phone,
              facility.phone,
              Colors.green.shade600,
            ),
            const SizedBox(height: 8),
            _buildBottomSheetInfoRow(
              Icons.access_time,
              facility.hours,
              Colors.purple.shade600,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildBottomSheetInfoRow(
                    Icons.directions_car,
                    '${facility.distance.toStringAsFixed(1)} km',
                    Colors.orange.shade600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        facility.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Action buttons
            Row(
              children: [
                // Directions button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final directionsUrl =
                          'https://www.google.com/maps/dir/?api=1&destination=${facility.latitude},${facility.longitude}';
                      if (await canLaunch(directionsUrl)) {
                        await launch(directionsUrl);
                      } else {
                        Get.snackbar(
                          'Lỗi',
                          'Không thể mở chỉ đường',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text(
                      'Chỉ đường',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Call button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final phoneUrl = 'tel:${facility.phone}';
                      if (await canLaunch(phoneUrl)) {
                        await launch(phoneUrl);
                      } else {
                        Get.snackbar(
                          'Lỗi',
                          'Không thể gọi điện',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text(
                      'Gọi điện',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildBottomSheetInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  void onMapCreated(GoogleMapController controller) {
    print('GoogleMap onMapCreated called, controller assigned');
    mapController = controller;
    // Optionally animate to current location or markers
    if (markers.isNotEmpty) {
      final firstMarker = markers.first.position;
      mapController
          .animateCamera(CameraUpdate.newLatLngZoom(firstMarker, 12.0));
      print('Animated camera to first marker: $firstMarker');
    }
  }

  void _loadVaccineData() {
    try {
      final vaccineId = Get.parameters['vaccineId'];
      if (vaccineId != null) {
        vaccine.value = VaccineModel(
          id: vaccineId,
          name: 'Vaccine',
          manufacturer: '',
          description: '',
          prevention: [],
          numberOfDoses: 2,
          recommendedAge: '',
          price: 0,
        );
      }
    } catch (e) {
      // print('Error loading vaccine data: $e');
    }
  }

  void confirmSelection() {
    if (selectedFacility.value != null) {
      // Return the selected facility when navigating back
      Get.back(result: selectedFacility.value);
    } else {
      // Show error or message if no facility is selected
      Get.snackbar('Lỗi', 'Vui lòng chọn cơ sở tiêm chủng');
    }
  }

  void cancelSelection() {
    Get.back(); // Return without a result
  }

  void showFacilitiesList() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle indicator
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Danh sách cơ sở tiêm chủng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Facilities list
            Expanded(
              child: ListView.builder(
                itemCount: facilities.length,
                itemBuilder: (context, index) {
                  final facility = facilities[index];
                  return InkWell(
                    onTap: () {
                      Get.back(); // Close list bottom sheet
                      // Animate camera to facility location
                      if (facility.latitude != null &&
                          facility.longitude != null) {
                        mapController.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            LatLng(facility.latitude!, facility.longitude!),
                            15.0, // Zoom in closer
                          ),
                        );
                      }
                      selectFacility(facility); // Show facility details
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Facility icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.local_hospital,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Facility info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  facility.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  facility.address,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 14,
                                      color: Colors.green.shade600,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      facility.phone,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.amber.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.amber[700],
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            facility.rating.toStringAsFixed(1),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.amber[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Arrow icon
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
