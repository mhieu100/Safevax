import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/shipping_info/shipping_info_controller.dart';
import 'package:flutter_getx_boilerplate/shared/constants/colors.dart';
import 'package:get/get.dart';

class ShippingInfoScreen extends GetView<ShippingInfoController> {
  const ShippingInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Thanh toán an toàn',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        backgroundColor: ColorConstants.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shipping Information Form
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thông tin giao hàng',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1F36),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // First Name
                          _buildInputField(
                            label: 'Họ',
                            controller: controller.firstNameController,
                            errorText: controller.firstNameError.value,
                            hintText: 'Nhập họ của bạn',
                          ),
                          const SizedBox(height: 16),

                          // Last Name
                          _buildInputField(
                            label: 'Tên',
                            controller: controller.lastNameController,
                            errorText: controller.lastNameError.value,
                            hintText: 'Nhập tên của bạn',
                          ),
                          const SizedBox(height: 16),

                          // Email Address
                          _buildInputField(
                            label: 'Địa chỉ Email',
                            controller: controller.emailController,
                            errorText: controller.emailError.value,
                            hintText: 'Nhập địa chỉ email',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),

                          // Phone Number
                          _buildInputField(
                            label: 'Số điện thoại',
                            controller: controller.phoneController,
                            errorText: controller.phoneError.value,
                            hintText: 'Nhập số điện thoại',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),

                          // Street Address
                          _buildInputField(
                            label: 'Địa chỉ',
                            controller: controller.streetAddressController,
                            errorText: controller.streetAddressError.value,
                            hintText: 'Nhập địa chỉ',
                          ),
                          const SizedBox(height: 16),

                          // City
                          _buildInputField(
                            label: 'Thành phố',
                            controller: controller.cityController,
                            errorText: controller.cityError.value,
                            hintText: 'Nhập thành phố',
                          ),
                          const SizedBox(height: 16),

                          // State (Dropdown)
                          _buildStateDropdown(),
                          const SizedBox(height: 16),

                          // ZIP Code
                          _buildInputField(
                            label: 'Mã bưu điện',
                            controller: controller.zipCodeController,
                            errorText: controller.zipCodeError.value,
                            hintText: 'Nhập mã bưu điện',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Shipping Method
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Phương thức giao hàng',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1F36),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Standard Shipping
                          _buildShippingMethodOption(
                            title: 'Standard Shipping',
                            description: '5-7 business days',
                            price: 'FREE',
                            isSelected:
                                controller.selectedShippingMethod.value ==
                                    'standard',
                            onTap: () =>
                                controller.selectShippingMethod('standard'),
                          ),

                          const SizedBox(height: 12),

                          // Express Shipping
                          _buildShippingMethodOption(
                            title: 'Express Shipping',
                            description: '2-3 business days',
                            price: '\$15.99',
                            isSelected:
                                controller.selectedShippingMethod.value ==
                                    'express',
                            onTap: () =>
                                controller.selectShippingMethod('express'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Order Summary
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tóm tắt đơn hàng',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1F36),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Order Items
                          ...controller.orderItems
                              .map((item) => _buildOrderItem(item)),

                          const Divider(height: 24),

                          // Subtotal
                          _buildSummaryRow(
                            'Subtotal (${controller.orderItems.length} items)',
                            controller
                                .formatCurrency(controller.subtotal.value),
                          ),

                          const SizedBox(height: 8),

                          // Shipping
                          _buildSummaryRow(
                            'Shipping',
                            controller.shippingCost.value == 0
                                ? 'FREE'
                                : controller.formatCurrencyUSD(
                                    controller.shippingCost.value),
                          ),

                          const SizedBox(height: 8),

                          // Tax
                          _buildSummaryRow(
                            'Tax',
                            controller.formatCurrency(controller.tax.value),
                          ),

                          const Divider(height: 24),

                          // Total
                          _buildSummaryRow(
                            'Total',
                            controller.formatCurrency(controller.total.value),
                            isTotal: true,
                          ),

                          const SizedBox(height: 16),

                          // Promo Code Section
                          _buildPromoCodeSection(),

                          const SizedBox(height: 16),

                          // Security badges
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSecurityBadge('SSL Bảo mật'),
                              const SizedBox(width: 16),
                              _buildSecurityBadge('Thanh toán an toàn'),
                              const SizedBox(width: 16),
                              _buildSecurityBadge('Đảm bảo'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),

            // Bottom Proceed Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.proceedToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String errorText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
            children: required
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFD1D5DB),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color:
                    errorText.isNotEmpty ? Colors.red : const Color(0xFFD1D5DB),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText.isNotEmpty
                    ? Colors.red
                    : ColorConstants.primaryGreen,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShippingMethodOption({
    required String title,
    required String description,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? ColorConstants.primaryGreen
                : const Color(0xFFD1D5DB),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? const Color(0xFFF0FDF4) : Colors.white,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: title.toLowerCase().replaceAll(' ', ''),
              groupValue: controller.selectedShippingMethod.value,
              onChanged: (_) => onTap(),
              activeColor: ColorConstants.primaryGreen,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: price == 'FREE'
                    ? ColorConstants.primaryGreen
                    : const Color(0xFF1A1F36),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.medical_services,
              color: Color(0xFF3B82F6),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1F36),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item['quantity']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Text(
            controller.formatCurrency(
                ((item['price'] as int) * (item['quantity'] as int))
                    .toDouble()),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1F36),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: isTotal ? const Color(0xFF1A1F36) : const Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color:
                isTotal ? ColorConstants.primaryGreen : const Color(0xFF1A1F36),
          ),
        ),
      ],
    );
  }

  Widget _buildStateDropdown() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'State',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
              children: [
                const TextSpan(
                  text: ' (Optional)',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: controller.selectedState.value.isNotEmpty
                ? controller.selectedState.value
                : null,
            decoration: InputDecoration(
              hintText: 'Chọn tỉnh/thành phố',
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1D5DB),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: controller.stateError.value.isNotEmpty
                      ? Colors.red
                      : const Color(0xFFD1D5DB),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: controller.stateError.value.isNotEmpty
                      ? Colors.red
                      : ColorConstants.primaryGreen,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: controller.vietnamStates.map((String state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(
                  state,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              controller.selectedState.value = newValue ?? '';
            },
          ),
          if (controller.stateError.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                controller.stateError.value,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildPromoCodeSection() {
    return Obx(() {
      if (controller.appliedPromoCode.value.isNotEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFBBF7D0),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF16A34A),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đã áp dụng mã giảm giá: ${controller.appliedPromoCode.value}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    Text(
                      'Giảm giá: -${controller.formatCurrency(controller.promoDiscount.value)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Color(0xFF16A34A),
                  size: 20,
                ),
                onPressed: controller.removePromoCode,
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mã giảm giá',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.promoCodeController,
                  decoration: InputDecoration(
                    hintText: 'Nhập mã giảm giá',
                    hintStyle: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFD1D5DB),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: controller.promoError.value.isNotEmpty
                            ? Colors.red
                            : const Color(0xFFD1D5DB),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: controller.promoError.value.isNotEmpty
                            ? Colors.red
                            : ColorConstants.primaryGreen,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: controller.applyPromoCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (controller.promoError.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                controller.promoError.value,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildSecurityBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }
}
