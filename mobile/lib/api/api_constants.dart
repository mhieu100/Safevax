class ApiConstants {
  static const baseUrlDev = 'https://backend.mhieu100.space/api/';
  static const baseUrlProd = 'https://backend.mhieu100.space/api/';
}

class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = 'auth/login/password';
  static const String googleLogin = 'auth/login/google';
  static const String googleMobileLogin = 'auth/login/google-mobile';
  static const String register = 'auth/register';
  static const String completeProfile = 'auth/complete-profile';
  static const String account = 'auth/account';
  static const String refresh = 'auth/refrehsh';
  static const String me = 'auth/me';
  static const String logout = 'auth/logout';
  static const String updateAccount = 'profile/patient';
  static const String updatePassword = 'auth/update-password';
  static const String booking = 'auth/booking';
  static const String bookingHistoryGrouped = 'auth/booking-history-grouped';
  static const String updateAvatar = 'profile/avatar';

  // Vaccines
  static const String vaccines = 'vaccines';
  static const String createSchedule = 'vaccines/create-schedule';

  // Appointments
  static const String rescheduleAppointment = 'appointments/reschedule';
  static String cancelAppointment(String appointmentId) =>
      'appointments/$appointmentId/cancel';

  // Family Members
  static const String familyMembers = 'family-members';

  // News
  static const String featuredNews = 'news/featured';
  static const String news = 'news';

  // Bookings
  static const String bookings = 'bookings';

  // Files
  static const String uploadFile = 'files';

  // Vaccine Consultation
  static const String ragChat = 'rag/chat';
  static const String ragConsult = 'rag/consult';
}
