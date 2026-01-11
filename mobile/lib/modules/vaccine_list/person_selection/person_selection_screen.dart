import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/vaccine_list/person_selection/person_selection_controller.dart';
import 'package:get/get.dart';

class PersonSelectionScreen extends GetView<PersonSelectionController> {
  const PersonSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFC),
      appBar: AppBar(
        title: const Text('Chọn người đặt lịch',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF199A8E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.persons.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF199A8E)),
            ),
          );
        }

        return Stack(
          children: [
            // Scrollable content (header + persons list)
            ListView(
              padding: const EdgeInsets.fromLTRB(
                  16, 8, 16, 120), // Extra bottom padding for button
              children: [
                // Header section with gradient (now scrolls with content)
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF199A8E), Color(0xFF17B8A6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Chọn người sẽ nhận vaccine',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Vui lòng chọn người dùng hoặc thành viên gia đình để đặt lịch tiêm chủng',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Persons list
                ...controller.persons.map((person) {
                  final isSelected =
                      controller.selectedPerson.value?.id == person.id;
                  return _buildPersonCard(person, isSelected);
                }),
              ],
            ),

            // Confirm button positioned at bottom of screen
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
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
                  child: ElevatedButton(
                    onPressed: controller.selectedPerson.value != null
                        ? () =>
                            Get.back(result: controller.selectedPerson.value)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.selectedPerson.value != null
                          ? const Color(0xFF199A8E)
                          : Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation:
                          controller.selectedPerson.value != null ? 4 : 0,
                      shadowColor: controller.selectedPerson.value != null
                          ? const Color(0xFF199A8E).withOpacity(0.3)
                          : Colors.transparent,
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          controller.selectedPerson.value != null
                              ? Icons.check_circle_outline
                              : Icons.person_add_outlined,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            controller.selectedPerson.value != null
                                ? 'Xác nhận chọn ${controller.selectedPerson.value!.name}'
                                : 'Vui lòng chọn người để tiếp tục',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

  Widget _buildPersonCard(Person person, bool isSelected) {
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
          onTap: () => controller.selectPerson(person),
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
                    backgroundImage: person.avatar.isNotEmpty &&
                            person.avatar != 'assets/images/circle_avatar.png'
                        ? (person.avatar.startsWith('http')
                            ? NetworkImage(person.avatar)
                                as ImageProvider<Object>
                            : AssetImage(person.avatar))
                        : null,
                    backgroundColor: Colors.white,
                    child: person.avatar.isEmpty ||
                            person.avatar == 'assets/images/circle_avatar.png'
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
                        person.name,
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
                                  person.isCurrentUser
                                      ? Icons.person_outline
                                      : Icons.family_restroom,
                                  size: 12,
                                  color: const Color(0xFF1976D2),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  person.relation,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF1976D2),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (person.gender != null &&
                              person.gender!.isNotEmpty)
                            const SizedBox(width: 8),

                          // Gender component
                          if (person.gender != null &&
                              person.gender!.isNotEmpty)
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
                                    person.gender == 'Nam'
                                        ? Icons.male
                                        : Icons.female,
                                    size: 12,
                                    color: const Color(0xFFC2185B),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    person.gender!,
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
                          if (person.phone.isNotEmpty)
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
                                    person.phone,
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

                          if (person.phone.isNotEmpty && person.dob.isNotEmpty)
                            const SizedBox(height: 6),

                          // Date of birth
                          if (person.dob.isNotEmpty)
                            Row(
                              children: [
                                Icon(
                                  Icons.cake,
                                  size: 14,
                                  color: const Color(0xFFe53e3e),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Sinh ngày: ${person.dob}',
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
                // Selection indicator (radio button style)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF199A8E)
                          : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Container(
                          margin: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF199A8E),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
