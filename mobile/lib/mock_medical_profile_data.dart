// Mock data for medical profile creation testing
// This file contains sample data to populate the medical profile form for testing purposes
//
// Usage:
// 1. Import this file in your test files or controller
// 2. Use MockMedicalProfileData.getProfileByIndex(index) to get specific profile
// 3. Use MockMedicalProfileData.getRandomProfile() for random testing
// 4. In debug mode, use the buttons on the medical profile screen to load mock data
//
// Data Structure:
// - ho_ten: Full name (String)
// - dia_chi: Address (String)
// - chieu_cao_cm: Height in cm (int)
// - can_nang_kg: Weight in kg (int)
// - so_dien_thoai: Phone number (String)
// - ngay_sinh: Birth date in YYYY-MM-DD format (String)
// - gioi_tinh: Gender - 'Nam', 'Nữ', or 'Khác' (String)
// - so_dinh_danh: Identity number (String)
// - nhom_mau: Blood type - 'A', 'B', 'AB', or 'O' (String)

class MockMedicalProfileData {
  // Sample medical profile data for testing
  static const Map<String, dynamic> sampleProfile1 = {
    'ho_ten': 'Nguyễn Văn An',
    'dia_chi': '123 Đường Lê Lợi, Quận 1, TP.HCM',
    'chieu_cao_cm': 175,
    'can_nang_kg': 70,
    'so_dien_thoai': '0901234567',
    'ngay_sinh': '1990-05-15',
    'gioi_tinh': 'Nam',
    'so_dinh_danh': '123456789012',
    'nhom_mau': 'A',
  };

  static const Map<String, dynamic> sampleProfile2 = {
    'ho_ten': 'Trần Thị Bình',
    'dia_chi': '456 Đường Nguyễn Huệ, Quận 3, TP.HCM',
    'chieu_cao_cm': 160,
    'can_nang_kg': 55,
    'so_dien_thoai': '0912345678',
    'ngay_sinh': '1985-08-22',
    'gioi_tinh': 'Nữ',
    'so_dinh_danh': '987654321098',
    'nhom_mau': 'B',
  };

  static const Map<String, dynamic> sampleProfile3 = {
    'ho_ten': 'Lê Văn Cường',
    'dia_chi': '789 Đường Trần Hưng Đạo, Quận 5, TP.HCM',
    'chieu_cao_cm': 180,
    'can_nang_kg': 85,
    'so_dien_thoai': '0923456789',
    'ngay_sinh': '1995-12-10',
    'gioi_tinh': 'Nam',
    'so_dinh_danh': '456789123456',
    'nhom_mau': 'AB',
  };

  static const Map<String, dynamic> sampleProfile4 = {
    'ho_ten': 'Phạm Thị Dung',
    'dia_chi': '321 Đường Cách Mạng Tháng 8, Quận 10, TP.HCM',
    'chieu_cao_cm': 165,
    'can_nang_kg': 60,
    'so_dien_thoai': '0934567890',
    'ngay_sinh': '1992-03-28',
    'gioi_tinh': 'Nữ',
    'so_dinh_danh': '789123456789',
    'nhom_mau': 'O',
  };

  static const Map<String, dynamic> sampleProfile5 = {
    'ho_ten': 'Hoàng Văn Em',
    'dia_chi': '654 Đường Võ Văn Tần, Quận 3, TP.HCM',
    'chieu_cao_cm': 172,
    'can_nang_kg': 75,
    'so_dien_thoai': '0945678901',
    'ngay_sinh': '1988-11-05',
    'gioi_tinh': 'Nam',
    'so_dinh_danh': '321654987321',
    'nhom_mau': 'A',
  };

  // List of all sample profiles
  static const List<Map<String, dynamic>> allProfiles = [
    sampleProfile1,
    sampleProfile2,
    sampleProfile3,
    sampleProfile4,
    sampleProfile5,
  ];

  // Get a random profile for testing
  static Map<String, dynamic> getRandomProfile() {
    final random = DateTime.now().millisecondsSinceEpoch % allProfiles.length;
    return allProfiles[random];
  }

  // Get profile by index (0-4)
  static Map<String, dynamic> getProfileByIndex(int index) {
    if (index < 0 || index >= allProfiles.length) {
      return sampleProfile1; // Default fallback
    }
    return allProfiles[index];
  }

  // Edge case profiles for testing validation
  static const Map<String, dynamic> edgeCaseProfileMinValues = {
    'ho_ten': 'A B', // Minimum name length
    'dia_chi': '123 ABC', // Minimum address length
    'chieu_cao_cm': 100, // Minimum reasonable height
    'can_nang_kg': 30, // Minimum reasonable weight
    'so_dien_thoai': '0900000000', // Valid phone format
    'ngay_sinh': '1920-01-01', // Oldest reasonable birth date
    'gioi_tinh': 'Nam',
    'so_dinh_danh': '000000000000', // Minimum ID length
    'nhom_mau': 'A',
  };

  static const Map<String, dynamic> edgeCaseProfileMaxValues = {
    'ho_ten': 'Nguyễn Văn An Bình Cường Dương Em Gia Huy', // Long name
    'dia_chi':
        'Số 123 Đường Lê Lợi, Phường Bến Nghé, Quận 1, Thành phố Hồ Chí Minh, Việt Nam', // Long address
    'chieu_cao_cm': 250, // Maximum reasonable height
    'can_nang_kg': 200, // Maximum reasonable weight
    'so_dien_thoai': '0999999999', // Valid phone format
    'ngay_sinh': '2010-12-31', // Youngest reasonable birth date
    'gioi_tinh': 'Nữ',
    'so_dinh_danh': '999999999999', // Maximum ID length
    'nhom_mau': 'O',
  };

  // Invalid data for testing error handling
  static const Map<String, dynamic> invalidProfileEmpty = {
    'ho_ten': '',
    'dia_chi': '',
    'chieu_cao_cm': 0,
    'can_nang_kg': 0,
    'so_dien_thoai': '',
    'ngay_sinh': '',
    'gioi_tinh': '',
    'so_dinh_danh': '',
    'nhom_mau': '',
  };

  static const Map<String, dynamic> invalidProfileWrongFormat = {
    'ho_ten': '123456', // Numbers in name
    'dia_chi': 'Valid Address',
    'chieu_cao_cm': -50, // Negative height
    'can_nang_kg': -20, // Negative weight
    'so_dien_thoai': 'invalid-phone', // Invalid phone format
    'ngay_sinh': 'invalid-date', // Invalid date format
    'gioi_tinh': 'Invalid',
    'so_dinh_danh': 'short', // Too short ID
    'nhom_mau': 'XYZ', // Invalid blood type
  };
}
