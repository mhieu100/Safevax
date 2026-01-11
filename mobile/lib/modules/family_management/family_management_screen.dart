// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_boilerplate/models/models.dart';
import 'package:flutter_getx_boilerplate/routes/routes.dart';
import 'package:get/get.dart';
import 'family_management_controller.dart';

class FamilyManangementScreen extends GetView<FamilyManangementController> {
  const FamilyManangementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        title: const Text(
          'Quản lý người thân',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF199A8E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Family Summary Header with gradient
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF199A8E), Color(0xFF17B8A6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryItem(
                      '${controller.familyMembers.length}',
                      'Thành viên',
                      Icons.group,
                    ),
                    _buildSummaryItem(
                      '${controller.familyMembers.where((m) => m.nextVaccine != 'None scheduled').length}',
                      'Tiêm chủng',
                      Icons.vaccines,
                    ),
                  ],
                )),
          ),
          // Family Members List
          Expanded(
            child: Obx(() {
              // Show loading only when explicitly loading and no data yet
              if (controller.isInitialized.value == false) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF199A8E)),
                  ),
                );
              }

              if (controller.familyMembers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.family_restroom,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chưa có thành viên nào',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nhấn nút + để thêm thành viên mới',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.familyMembers.length,
                itemBuilder: (context, index) {
                  final member = controller.familyMembers[index];
                  return _buildMemberCard(context, member);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF199A8E),
        onPressed: () => _showAddMemberDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Thêm thành viên',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCard(BuildContext context, FamilyMember member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey[100]!,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.toNamed(Routes.familyMemberDetail, arguments: member);
          },
          splashColor: const Color(0xFF199A8E).withOpacity(0.1),
          highlightColor: const Color(0xFF199A8E).withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF199A8E).withOpacity(0.2),
                        const Color(0xFF17B8A6).withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: member.avatar.isNotEmpty &&
                            member.avatar != 'assets/images/circle_avatar.png'
                        ? (member.avatar.startsWith('http')
                            ? NetworkImage(member.avatar)
                                as ImageProvider<Object>
                            : AssetImage(member.avatar))
                        : null,
                    backgroundColor: Colors.white,
                    child: member.avatar.isEmpty ||
                            member.avatar == 'assets/images/circle_avatar.png'
                        ? Icon(
                            Icons.person,
                            color: const Color(0xFF199A8E),
                            size: 28,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                // Main content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        member.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                                  Icons.family_restroom,
                                  size: 12,
                                  color: const Color(0xFF1976D2),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  member.relation,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF1976D2),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (member.gender != null &&
                              member.gender!.isNotEmpty)
                            const SizedBox(width: 8),

                          // Gender component
                          if (member.gender != null &&
                              member.gender!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCE4EC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    member.gender == 'MALE'
                                        ? Icons.male
                                        : Icons.female,
                                    size: 12,
                                    color: const Color(0xFFC2185B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    member.gender == 'MALE' ? 'Nam' : 'Nữ',
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
                          if (member.phone != null && member.phone!.isNotEmpty)
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
                                    member.phone!,
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

                          if (member.phone != null &&
                              member.phone!.isNotEmpty &&
                              member.dob.isNotEmpty)
                            const SizedBox(height: 6),

                          // Date of birth
                          if (member.dob.isNotEmpty)
                            Row(
                              children: [
                                Icon(
                                  Icons.cake,
                                  size: 14,
                                  color: const Color(0xFFe53e3e),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Sinh ngày: ${_formatDateForDisplay(member.dob)}',
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
                // Action button
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF199A8E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFF199A8E),
                      size: 20,
                    ),
                    onPressed: () => _showEditMemberDialog(context, member),
                    tooltip: 'Chỉnh sửa',
                    splashRadius: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final nameController = TextEditingController();
    String? selectedRelation;
    String? selectedGender;
    final dobController = TextEditingController();
    final phoneController = TextEditingController();
    final identityNumberController = TextEditingController();
    final nameFocusNode = FocusNode();
    final relationFocusNode = FocusNode();
    final genderFocusNode = FocusNode();
    final dobFocusNode = FocusNode();
    final phoneFocusNode = FocusNode();
    final identityNumberFocusNode = FocusNode();

    // Format DOB input as user types
    dobController.addListener(() {
      final text = dobController.text;
      final formatted = _formatDOBInput(text);
      if (formatted != text) {
        dobController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    });

    // Predefined relationship options (comprehensive list, sorted alphabetically)
    final List<String> relationshipOptions = [
      'Anh',
      'Anh rể',
      'Bà',
      'Bà nội',
      'Bà ngoại',
      'Bác',
      'Bạn bè',
      'Cha',
      'Cha chồng',
      'Cha vợ',
      'Cháu',
      'Cháu gái',
      'Cháu trai',
      'Chị',
      'Chị dâu',
      'Chồng',
      'Chú',
      'Cậu',
      'Con gái',
      'Con trai',
      'Cô',
      'Dì',
      'Em gái',
      'Em trai',
      'Mẹ',
      'Mẹ chồng',
      'Mẹ vợ',
      'Mợ',
      'Người thân khác',
      'Ông',
      'Ông nội',
      'Ông ngoại',
      'Thím',
      'Vợ',
      'Vợ/Chồng',
    ];

    // Gender options
    final List<String> genderOptions = [
      'MALE',
      'FEMALE',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 16,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxWidth: 400, minWidth: 350, maxHeight: 600),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with gradient
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF199A8E), Color(0xFF17B8A6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person_add,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Thêm thành viên mới',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form content
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Name field
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
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
                                controller: nameController,
                                focusNode: nameFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Họ và tên',
                                  hintText: 'Nhập họ và tên đầy đủ',
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Color(0xFF199A8E),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Relation dropdown
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                value: selectedRelation,
                                focusNode: relationFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Quan hệ',
                                  hintText: selectedRelation == null
                                      ? 'Chọn quan hệ'
                                      : null,
                                  prefixIcon: const Icon(
                                    Icons.family_restroom,
                                    color: Color(0xFF199A8E),
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF199A8E),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                dropdownColor: Colors.white,
                                style: const TextStyle(
                                  color: Color(0xFF2D3748),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                menuMaxHeight:
                                    400, // Show about 8 items initially, rest scrollable
                                selectedItemBuilder: (BuildContext context) {
                                  return relationshipOptions
                                      .map((String relation) {
                                    return Text(
                                      relation,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2D3748),
                                      ),
                                    );
                                  }).toList();
                                },
                                items:
                                    relationshipOptions.map((String relation) {
                                  return DropdownMenuItem<String>(
                                    value: relation,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 4),
                                      child: Text(
                                        relation,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedRelation = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn quan hệ';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                                icon: const SizedBox
                                    .shrink(), // Hide default dropdown icon since we have suffixIcon
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Gender dropdown
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                value: selectedGender,
                                focusNode: genderFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Giới tính',
                                  hintText: selectedGender == null
                                      ? 'Chọn giới tính'
                                      : null,
                                  prefixIcon: const Icon(
                                    Icons.wc,
                                    color: Color(0xFF199A8E),
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF199A8E),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                dropdownColor: Colors.white,
                                style: const TextStyle(
                                  color: Color(0xFF2D3748),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                selectedItemBuilder: (BuildContext context) {
                                  return genderOptions.map((String gender) {
                                    return Text(
                                      gender == 'MALE' ? 'Nam' : 'Nữ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2D3748),
                                      ),
                                    );
                                  }).toList();
                                },
                                items: genderOptions.map((String gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 4),
                                      child: Text(
                                        gender == 'MALE' ? 'Nam' : 'Nữ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedGender = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn giới tính';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                                icon: const SizedBox.shrink(),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Phone number field
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
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
                                controller: phoneController,
                                focusNode: phoneFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Số điện thoại',
                                  hintText: 'Nhập số điện thoại',
                                  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: Color(0xFF199A8E),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Identity number field
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
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
                                controller: identityNumberController,
                                focusNode: identityNumberFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Số CMND/CCCD',
                                  hintText: 'Nhập số CMND hoặc CCCD',
                                  prefixIcon: const Icon(
                                    Icons.badge,
                                    color: Color(0xFF199A8E),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(12),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Date of birth field
                            TextField(
                              controller: dobController,
                              focusNode: dobFocusNode,
                              decoration: InputDecoration(
                                labelText: 'Ngày sinh',
                                hintText: 'DD/MM/YYYY',
                                prefixIcon: const Icon(
                                  Icons.cake,
                                  color: Color(0xFF199A8E),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Colors.green, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                counterText: '', // Hide character counter
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    8), // DDMMYYYY = 8 digits
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Buttons
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: const BorderSide(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Hủy',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // Validate name
                                        if (nameController.text
                                            .trim()
                                            .isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Vui lòng nhập họ và tên'),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                          return;
                                        }

                                        // Validate relation
                                        if (selectedRelation == null ||
                                            selectedRelation!.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Vui lòng chọn quan hệ'),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                          return;
                                        }

                                        // Validate gender
                                        if (selectedGender == null ||
                                            selectedGender!.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Vui lòng chọn giới tính'),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                          return;
                                        }

                                        // Validate phone number
                                        if (phoneController.text
                                            .trim()
                                            .isNotEmpty) {
                                          final phoneError =
                                              _validatePhoneNumber(
                                                  phoneController.text.trim());
                                          if (phoneError != null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(phoneError),
                                                backgroundColor: Colors.orange,
                                                duration:
                                                    const Duration(seconds: 1),
                                              ),
                                            );
                                            return;
                                          }
                                        }

                                        // Validate identity number
                                        if (identityNumberController.text
                                            .trim()
                                            .isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Vui lòng nhập số CMND/CCCD'),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                          return;
                                        }

                                        // Validate date of birth
                                        if (dobController.text.trim().isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Vui lòng nhập ngày sinh'),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                          return;
                                        }

                                        // Validate date format and logic
                                        final dateError = _validateDateOfBirth(
                                            dobController.text.trim());
                                        if (dateError != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(dateError),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                          return;
                                        }

                                        final newMember = FamilyMember(
                                          name: nameController.text.trim(),
                                          relation: selectedRelation!,
                                          dob: _formatDateForApi(
                                              dobController.text.trim()),
                                          nextVaccine: 'None scheduled',
                                          avatar:
                                              'assets/images/circle_avatar.png',
                                          healthStatus: 'Healthy',
                                          lastCheckup: DateTime.now()
                                              .toString()
                                              .split(' ')[0],
                                          gender: selectedGender,
                                          phone: phoneController.text
                                                  .trim()
                                                  .isNotEmpty
                                              ? phoneController.text.trim()
                                              : null,
                                          identityNumber:
                                              identityNumberController.text
                                                  .trim(),
                                        );

                                        await controller
                                            .addFamilyMember(newMember);

                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Row(
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                      'Đã thêm thành viên mới thành công!'),
                                                ],
                                              ),
                                              backgroundColor:
                                                  const Color(0xFF199A8E),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF199A8E),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: const Text(
                                        'Thêm thành viên',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
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
              ),
            );
          },
        );
      },
    );
  }

  String? _validateDateOfBirth(String dateString) {
    // Check format DD/MM/YYYY
    final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dateRegex.hasMatch(dateString)) {
      return 'Định dạng ngày sinh không hợp lệ. Vui lòng nhập theo định dạng DD/MM/YYYY';
    }

    try {
      final parts = dateString.split('/');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      // Validate month
      if (month < 1 || month > 12) {
        return 'Tháng không hợp lệ. Phải từ 1-12';
      }

      // Validate day based on month
      final daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
      if (month == 2 && _isLeapYear(year)) {
        daysInMonth[1] = 29; // February in leap year
      }

      if (day < 1 || day > daysInMonth[month - 1]) {
        return 'Ngày không hợp lệ cho tháng $month';
      }

      // Validate year (reasonable range)
      final currentYear = DateTime.now().year;
      if (year < 1900 || year > currentYear) {
        return 'Năm sinh không hợp lệ. Phải từ 1900 đến $currentYear';
      }

      // Check if date is not in the future
      final birthDate = DateTime(year, month, day);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (birthDate.isAfter(today)) {
        return 'Ngày sinh không thể là ngày trong tương lai';
      }

      // Check if person is not too old (reasonable limit)
      final age = currentYear - year;
      if (age > 150) {
        return 'Tuổi không hợp lệ. Vui lòng kiểm tra lại năm sinh';
      }

      return null; // Valid date
    } catch (e) {
      return 'Định dạng ngày sinh không hợp lệ';
    }
  }

  bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  String? _validatePhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Check length (Vietnamese phone numbers are 10 digits)
    if (digitsOnly.length != 10) {
      return 'Số điện thoại phải có 10 chữ số';
    }

    // Check if it starts with valid prefixes
    final validPrefixes = ['03', '05', '07', '08', '09', '02'];
    final prefix = digitsOnly.substring(0, 2);

    if (!validPrefixes.contains(prefix)) {
      return 'Số điện thoại không hợp lệ. Phải bắt đầu bằng 02, 03, 05, 07, 08 hoặc 09';
    }

    return null; // Valid phone number
  }

  String _formatDOBInput(String input) {
    // Remove all non-digit characters
    final digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), '');

    // Format as DD/MM/YYYY
    if (digitsOnly.length <= 2) {
      return digitsOnly;
    } else if (digitsOnly.length <= 4) {
      return '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2)}';
    } else if (digitsOnly.length <= 8) {
      return '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2, 4)}/${digitsOnly.substring(4)}';
    } else {
      return '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2, 4)}/${digitsOnly.substring(4, 8)}';
    }
  }

  String _formatDateForApi(String dateString) {
    // Convert from DD/MM/YYYY to YYYY-MM-DD format
    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];
        return '$year-$month-$day';
      }
      return dateString; // Return as is if format is unexpected
    } catch (e) {
      return dateString;
    }
  }

  String _formatDateForDisplay(String dateString) {
    // Convert from YYYY-MM-DD to DD/MM/YYYY format for display
    try {
      final parts = dateString.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        return '$day/$month/$year';
      }
      return dateString; // Return as is if format is unexpected
    } catch (e) {
      return dateString;
    }
  }

  void _showEditMemberDialog(BuildContext context, FamilyMember member) {
    final nameController = TextEditingController(text: member.name);
    String? selectedRelation = member.relation;
    String? selectedGender = member.gender;
    final dobController =
        TextEditingController(text: _formatDateForDisplay(member.dob));
    final phoneController = TextEditingController(text: member.phone ?? '');
    final identityNumberController =
        TextEditingController(text: member.identityNumber ?? '');
    final nameFocusNode = FocusNode();
    final relationFocusNode = FocusNode();
    final genderFocusNode = FocusNode();
    final dobFocusNode = FocusNode();
    final phoneFocusNode = FocusNode();
    final identityNumberFocusNode = FocusNode();

    // Format DOB input as user types
    dobController.addListener(() {
      final text = dobController.text;
      final formatted = _formatDOBInput(text);
      if (formatted != text) {
        dobController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    });

    // Predefined relationship options (comprehensive list, sorted alphabetically)
    final List<String> relationshipOptions = [
      'Anh',
      'Anh rể',
      'Bà',
      'Bà nội',
      'Bà ngoại',
      'Bác',
      'Bạn bè',
      'Cha',
      'Cha chồng',
      'Cha vợ',
      'Cháu',
      'Cháu gái',
      'Cháu trai',
      'Chị',
      'Chị dâu',
      'Chồng',
      'Chú',
      'Cậu',
      'Con gái',
      'Con trai',
      'Cô',
      'Dì',
      'Em gái',
      'Em trai',
      'Mẹ',
      'Mẹ chồng',
      'Mẹ vợ',
      'Mợ',
      'Người thân khác',
      'Ông',
      'Ông nội',
      'Ông ngoại',
      'Thím',
      'Vợ',
      'Vợ/Chồng',
    ];

    // Gender options
    final List<String> genderOptions = [
      'MALE',
      'FEMALE',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 16,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxWidth: 400, minWidth: 350, maxHeight: 600),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with gradient
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF199A8E), Color(0xFF17B8A6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Chỉnh sửa thành viên',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form content
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Name field
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
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
                                controller: nameController,
                                focusNode: nameFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Họ và tên',
                                  hintText: 'Nhập họ và tên đầy đủ',
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Color(0xFF199A8E),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Relation dropdown
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                value: selectedRelation,
                                focusNode: relationFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Quan hệ',
                                  hintText: selectedRelation == null
                                      ? 'Chọn quan hệ'
                                      : null,
                                  prefixIcon: const Icon(
                                    Icons.family_restroom,
                                    color: Color(0xFF199A8E),
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF199A8E),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                dropdownColor: Colors.white,
                                style: const TextStyle(
                                  color: Color(0xFF2D3748),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                menuMaxHeight: 400,
                                selectedItemBuilder: (BuildContext context) {
                                  return relationshipOptions
                                      .map((String relation) {
                                    return Text(
                                      relation,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2D3748),
                                      ),
                                    );
                                  }).toList();
                                },
                                items:
                                    relationshipOptions.map((String relation) {
                                  return DropdownMenuItem<String>(
                                    value: relation,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 4),
                                      child: Text(
                                        relation,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedRelation = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn quan hệ';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                                icon: const SizedBox.shrink(),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Gender dropdown
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                value: selectedGender,
                                focusNode: genderFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Giới tính',
                                  hintText: selectedGender == null
                                      ? 'Chọn giới tính'
                                      : null,
                                  prefixIcon: const Icon(
                                    Icons.wc,
                                    color: Color(0xFF199A8E),
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xFF199A8E),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                dropdownColor: Colors.white,
                                style: const TextStyle(
                                  color: Color(0xFF2D3748),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                selectedItemBuilder: (BuildContext context) {
                                  return genderOptions.map((String gender) {
                                    return Text(
                                      gender == 'MALE' ? 'Nam' : 'Nữ',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2D3748),
                                      ),
                                    );
                                  }).toList();
                                },
                                items: genderOptions.map((String gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 4),
                                      child: Text(
                                        gender == 'MALE' ? 'Nam' : 'Nữ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedGender = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng chọn giới tính';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                                icon: const SizedBox.shrink(),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Phone number field
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
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
                                controller: phoneController,
                                focusNode: phoneFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Số điện thoại',
                                  hintText: 'Nhập số điện thoại',
                                  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: Color(0xFF199A8E),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Date of birth field
                            TextField(
                              controller: dobController,
                              focusNode: dobFocusNode,
                              decoration: InputDecoration(
                                labelText: 'Ngày sinh',
                                hintText: 'DD/MM/YYYY',
                                prefixIcon: const Icon(
                                  Icons.cake,
                                  color: Color(0xFF199A8E),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Colors.green, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                counterText: '',
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(8),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Buttons
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: const BorderSide(
                                            color: Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Hủy',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // Validate name
                                        if (nameController.text
                                            .trim()
                                            .isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Vui lòng nhập họ và tên'),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                          return;
                                        }

                                        // Validate relation
                                        if (selectedRelation == null ||
                                            selectedRelation!.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Vui lòng chọn quan hệ'),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                          return;
                                        }

                                        // Validate gender
                                        if (selectedGender == null ||
                                            selectedGender!.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Vui lòng chọn giới tính'),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                          return;
                                        }

                                        // Validate phone number
                                        if (phoneController.text
                                            .trim()
                                            .isNotEmpty) {
                                          final phoneError =
                                              _validatePhoneNumber(
                                                  phoneController.text.trim());
                                          if (phoneError != null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(phoneError),
                                                backgroundColor: Colors.orange,
                                                duration:
                                                    const Duration(seconds: 1),
                                              ),
                                            );
                                            return;
                                          }
                                        }

                                        // Validate date of birth
                                        if (dobController.text.trim().isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Vui lòng nhập ngày sinh'),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                          return;
                                        }

                                        // Validate date format and logic
                                        final dateError = _validateDateOfBirth(
                                            dobController.text.trim());
                                        if (dateError != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(dateError),
                                              backgroundColor: Colors.orange,
                                              duration:
                                                  const Duration(seconds: 1),
                                            ),
                                          );
                                          return;
                                        }

                                        final updatedMember = FamilyMember(
                                          id: member.id,
                                          name: nameController.text.trim(),
                                          relation: selectedRelation!,
                                          dob: _formatDateForApi(
                                              dobController.text.trim()),
                                          nextVaccine: member.nextVaccine,
                                          avatar: member.avatar,
                                          healthStatus: member.healthStatus,
                                          lastCheckup: member.lastCheckup,
                                          gender: selectedGender,
                                          phone: phoneController.text
                                                  .trim()
                                                  .isNotEmpty
                                              ? phoneController.text.trim()
                                              : null,
                                          identityNumber:
                                              identityNumberController.text
                                                  .trim(),
                                        );

                                        await controller.updateFamilyMember(
                                            member.id?.toString() ??
                                                member.name,
                                            updatedMember);

                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Row(
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                      'Đã cập nhật thành viên thành công!'),
                                                ],
                                              ),
                                              backgroundColor:
                                                  const Color(0xFF199A8E),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF199A8E),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: const Text(
                                        'Cập nhật',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
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
              ),
            );
          },
        );
      },
    );
  }
}
