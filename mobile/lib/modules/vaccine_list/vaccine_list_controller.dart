// lib/modules/vaccine_list/vaccine_list_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/models/request/vaccine_list_request.dart';
import 'package:flutter_getx_boilerplate/models/response/vaccine_list_response.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_model.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_list_repository.dart';
import 'package:flutter_getx_boilerplate/routes/navigator_helper.dart';
import 'package:flutter_getx_boilerplate/shared/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';

class CartItem {
  final VaccineModel vaccine;
  int quantity;

  CartItem({required this.vaccine, this.quantity = 1});
}

class VaccineListController extends BaseController<VaccineListRepository> {
  VaccineListController(super.repository);

  final scrollController = ScrollController();
  final isLoadingMore = false.obs;

  final vaccines = <VaccineModel>[].obs;
  final cartItems = <CartItem>[].obs;
  final isLoading = false.obs;

  // Filter states
  final minPrice = 0.0.obs;
  final maxPrice = 3000000.0.obs;
  final selectedCountry = ''.obs;
  final availableCountries = <String>[].obs;
  final sortBy = 'name'.obs;
  final sortOrder = 'asc'.obs;
  final currentPage = 1.obs;
  final pageSize = 12.obs;
  final totalItems = 0.obs;

  // list detail
  final vaccine = Rx<VaccineModel?>(null);
  final isFavorite = false.obs;
  final selectedVaccine = Rx<VaccineModel?>(null);
  final selectedTabIndex = 0.obs;
  final isExpanded = false.obs;
  final error = ''.obs;
  final healthcareFacilities = <HealthcareFacility>[].obs;
  final selectedFacility = Rx<HealthcareFacility?>(null);

  @override
  void onInit() {
    super.onInit();
    loadCartFromStorage();
    loadCountries();
    loadVaccines();

    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadCountries() async {
    try {
      final countries = await repository.getCountries();
      availableCountries.assignAll(countries);
    } catch (e) {
      // Handle error silently or show a message
      print('Error loading countries: $e');
    }
  }

  void loadCartFromStorage() {
    final storedCart = StorageService.vaccineCart;
    if (storedCart != null) {
      final cartItemsList = storedCart.map((item) {
        final vaccine = VaccineModel.fromJson(item['vaccine']);
        final quantity = item['quantity'] as int;
        return CartItem(vaccine: vaccine, quantity: quantity);
      }).toList();
      cartItems.assignAll(cartItemsList);
    }
  }

  void saveCartToStorage() {
    final cartData = cartItems
        .map((item) => {
              'vaccine': item.vaccine.toJson(),
              'quantity': item.quantity,
            })
        .toList();
    StorageService.vaccineCart = cartData;
  }

  Future<void> loadVaccines({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
      currentPage.value = 1; // Reset to first page for new loads
    }

    try {
      final filter = buildFilterString();
      final request = VaccineListRequest(
        page: currentPage.value,
        size: pageSize.value,
        filter: filter,
        sort: '$sortBy,$sortOrder',
      );
      final response = await repository.getVaccines(request: request);
      final vaccineModels = response.data.result
          .map((item) => VaccineModel(
                id: item.id.toString(),
                name: item.name,
                country: item.country,
                descriptionShort: item.descriptionShort,
                dosesRequired: item.dosesRequired,
                manufacturer: item.manufacturer,
                duration: item.duration,
                rating: 0.0, // API doesn't provide rating, default to 0
                description: item.description,
                numberOfDoses: item.dosesRequired,
                price: item.price.toDouble(),
                prevention: [],
                recommendedAge: '',
                originalPrice: item.price.toDouble(),
                sideEffects: [],
                schedule: [],
                doseIntervals: [],
                imageUrl: item.image,
                stock: item.stock,
              ))
          .toList();

      if (isLoadMore) {
        vaccines.addAll(vaccineModels);
      } else {
        vaccines.assignAll(vaccineModels);
      }
      totalItems.value = response.data.meta.total;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách vaccine');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  String buildFilterString() {
    final conditions = <String>[];

    // Price filter
    if (minPrice.value > 0 || maxPrice.value < 3000000) {
      conditions
          .add('(price > ${minPrice.value} and price < ${maxPrice.value})');
    }

    // Country filter
    if (selectedCountry.value.isNotEmpty) {
      conditions.add("(country ~ '${selectedCountry.value}')");
    }

    return conditions.isEmpty ? '' : conditions.join(' and ');
  }

  void updateFilters({
    double? minPrice,
    double? maxPrice,
    String? country,
  }) {
    if (minPrice != null) this.minPrice.value = minPrice;
    if (maxPrice != null) this.maxPrice.value = maxPrice;
    if (country != null) this.selectedCountry.value = country;
    currentPage.value = 1; // Reset to first page
    loadVaccines();
  }

  void updateSorting(String sortBy, String sortOrder) {
    this.sortBy.value = sortBy;
    this.sortOrder.value = sortOrder;
    currentPage.value = 1; // Reset to first page
    loadVaccines();
  }

  void loadNextPage() {
    if (vaccines.length < totalItems.value && !isLoadingMore.value) {
      currentPage.value++;
      loadVaccines(isLoadMore: true);
    }
  }

  void addToCart(VaccineModel vaccine) {
    final existingItemIndex =
        cartItems.indexWhere((item) => item.vaccine.id == vaccine.id);

    if (existingItemIndex >= 0) {
      // Tăng số lượng nếu vaccine đã có trong giỏ
      cartItems[existingItemIndex].quantity++;
      cartItems.refresh();
    } else {
      // Thêm mới vào giỏ hàng
      cartItems.add(CartItem(vaccine: vaccine));
    }

    saveCartToStorage();

    // Get.snackbar(
    //   'Thêm thành công',
    //   'Đã thêm ${vaccine.name} vào giỏ',
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: const Color(0xFF10B981),
    //   colorText: Colors.white,
    // );
  }

  void removeFromCart(String vaccineId) {
    final existingItemIndex =
        cartItems.indexWhere((item) => item.vaccine.id == vaccineId);

    if (existingItemIndex >= 0) {
      if (cartItems[existingItemIndex].quantity > 1) {
        // Giảm số lượng nếu lớn hơn 1
        cartItems[existingItemIndex].quantity--;
        cartItems.refresh();
      } else {
        // Xóa khỏi giỏ hàng nếu số lượng là 1
        cartItems.removeAt(existingItemIndex);
      }
    }

    saveCartToStorage();
  }

  CartItem? getCartItem(String vaccineId) {
    try {
      return cartItems.firstWhere((item) => item.vaccine.id == vaccineId);
    } catch (e) {
      return null;
    }
  }

  int getTotalQuantity() {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double getTotalPrice() {
    return cartItems.fold(
        0, (sum, item) => sum + (item.vaccine.price * item.quantity));
  }

  void confirmSelection(context) {
    NavigatorHelper.toBookingVaccinesScreen(
      useCartOverride: true,
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const BookingSummaryScreen(booking: null,
    //     ),
    //   ),
    // );
  }

  void toVaccineListDetailScreen(VaccineModel? vaccine) {
    // Get the controller instance
    final VaccineListController controller = Get.find<VaccineListController>();

    // Set the selected vaccine in the controller
    if (vaccine != null) {
      controller.selectedVaccine.value = vaccine;
    }

    NavigatorHelper.toVaccineListDetailScreen();
  }

  void toggleExpand() {
    isExpanded.value = !isExpanded.value;
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void selectFacility(HealthcareFacility facility) {
    selectedFacility.value = facility;
  }

  void bookVaccine() {
    if (vaccine.value == null) return;
    NavigatorHelper.toFacilitySelectionScreen();

    // Get.toNamed(
    //   '/booking',
    //   parameters: {
    //     'vaccineId': vaccine.value!.id,
    //     'facilityId': selectedFacility.value?.id ?? ''
    //   }
    // );
  }

  void bookAtFacility(String facilityId) {
    final facility = healthcareFacilities.firstWhere(
      (f) => f.id == facilityId,
      orElse: () => healthcareFacilities.first,
    );

    selectFacility(facility);
    bookVaccine();
  }

  void shareVaccine() {
    if (vaccine.value == null) return;

    // Implement share functionality
    Get.snackbar(
      'Chia sẻ',
      'Tính năng chia sẻ sẽ được triển khai sau',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
