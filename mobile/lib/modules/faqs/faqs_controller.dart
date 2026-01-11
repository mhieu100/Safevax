import 'package:get/get.dart';

class FAQ {
  final String id;
  final String question;
  final String answer;
  final String category;

  FAQ({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
  });
}

class FAQsController extends GetxController {
  final faqs = <FAQ>[].obs;
  final filteredFAQs = <FAQ>[].obs;
  final categories = <String>[].obs;
  final selectedCategory = 'Tất cả'.obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFAQs();
  }

  void loadFAQs() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock data
    faqs.value = [
      FAQ(
        id: '1',
        question: 'Làm thế nào để đặt lịch hẹn với bác sĩ?',
        answer:
            'Để đặt lịch hẹn, bạn có thể:\n\n1. Mở ứng dụng và chọn "Đặt lịch hẹn"\n2. Chọn chuyên khoa và bác sĩ mong muốn\n3. Chọn ngày và giờ phù hợp\n4. Xác nhận thông tin và thanh toán\n\nBạn sẽ nhận được xác nhận qua email và tin nhắn.',
        category: 'Đặt lịch',
      ),
      FAQ(
        id: '2',
        question: 'Tôi có thể hủy hoặc thay đổi lịch hẹn không?',
        answer:
            'Có, bạn có thể hủy hoặc thay đổi lịch hẹn miễn phí trước 24 giờ. Để thực hiện:\n\n1. Vào mục "Lịch hẹn" trong hồ sơ\n2. Chọn lịch hẹn cần thay đổi\n3. Chọn "Hủy" hoặc "Thay đổi"\n4. Làm theo hướng dẫn trên màn hình\n\nNếu hủy trong vòng 24 giờ, có thể áp dụng phí hủy.',
        category: 'Đặt lịch',
      ),
      FAQ(
        id: '3',
        question: 'Làm thế nào để xem kết quả xét nghiệm?',
        answer:
            'Kết quả xét nghiệm sẽ được cập nhật trong vòng 24-48 giờ sau khi thực hiện. Để xem:\n\n1. Vào mục "Lịch sử y tế" trong hồ sơ\n2. Chọn tab "Kết quả xét nghiệm"\n3. Tìm và chọn kết quả muốn xem\n\nBạn cũng sẽ nhận được thông báo khi kết quả sẵn sàng.',
        category: 'Kết quả',
      ),
      FAQ(
        id: '4',
        question: 'Tôi quên mật khẩu, phải làm sao?',
        answer:
            'Nếu quên mật khẩu:\n\n1. Trên màn hình đăng nhập, chọn "Quên mật khẩu"\n2. Nhập email đã đăng ký\n3. Kiểm tra email để nhận liên kết đặt lại mật khẩu\n4. Làm theo hướng dẫn trong email\n\nNếu không nhận được email, kiểm tra thư mục spam.',
        category: 'Tài khoản',
      ),
      FAQ(
        id: '5',
        question: 'Ứng dụng có hỗ trợ nhiều ngôn ngữ không?',
        answer:
            'Hiện tại ứng dụng hỗ trợ tiếng Việt và tiếng Anh. Để thay đổi ngôn ngữ:\n\n1. Vào Cài đặt > Ngôn ngữ\n2. Chọn ngôn ngữ mong muốn\n3. Ứng dụng sẽ tự động cập nhật\n\nChúng tôi đang phát triển hỗ trợ thêm nhiều ngôn ngữ khác.',
        category: 'Ứng dụng',
      ),
      FAQ(
        id: '6',
        question: 'Làm thế nào để thanh toán hóa đơn?',
        answer:
            'Bạn có thể thanh toán hóa đơn qua:\n\n• Thẻ tín dụng/ghi nợ\n• Ví điện tử (MoMo, ZaloPay, ViettelPay)\n• Chuyển khoản ngân hàng (VnPay)\n• Thanh toán tại quầy\n\nTất cả phương thức đều an toàn và bảo mật.',
        category: 'Thanh toán',
      ),
      FAQ(
        id: '7',
        question: 'Tôi có thể đặt lịch cho người khác không?',
        answer:
            'Có, bạn có thể đặt lịch cho người thân hoặc bệnh nhân khác bằng cách:\n\n1. Thêm người đó vào "Quản lý gia đình"\n2. Chọn người đó khi đặt lịch\n3. Hoàn tất đặt lịch như bình thường\n\nBạn sẽ nhận được tất cả thông báo về lịch hẹn.',
        category: 'Gia đình',
      ),
      FAQ(
        id: '8',
        question: 'Ứng dụng có bảo mật thông tin không?',
        answer:
            'Chúng tôi cam kết bảo mật thông tin cá nhân của bạn:\n\n• Mã hóa dữ liệu theo chuẩn quốc tế\n• Không chia sẻ thông tin với bên thứ ba\n• Tuân thủ các quy định về bảo mật y tế\n• Xác thực hai yếu tố cho tài khoản\n\nTìm hiểu thêm trong Chính sách Bảo mật.',
        category: 'Bảo mật',
      ),
    ];

    // Extract categories
    final categorySet = {'Tất cả'};
    for (final faq in faqs) {
      categorySet.add(faq.category);
    }
    categories.value = categorySet.toList();

    filteredFAQs.value = faqs;
    isLoading.value = false;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    filterFAQs();
  }

  void searchFAQs(String query) {
    searchQuery.value = query;
    filterFAQs();
  }

  void filterFAQs() {
    List<FAQ> filtered = faqs.toList();

    // Filter by category
    if (selectedCategory.value != 'Tất cả') {
      filtered = filtered
          .where((faq) => faq.category == selectedCategory.value)
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered
          .where((faq) =>
              faq.question.toLowerCase().contains(query) ||
              faq.answer.toLowerCase().contains(query))
          .toList();
    }

    filteredFAQs.value = filtered;
  }

  void contactSupport() {
    Get.snackbar(
      'Liên hệ hỗ trợ',
      'Tính năng liên hệ hỗ trợ đang được phát triển!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
