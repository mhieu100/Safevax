part of 'app_pages.dart';

abstract class Routes {
  // app base
  static const onboard = '/onboard';
  static const auth = '/auth';
  static const home = '/';

  // New code
  static const splash = '/splash';

  // home
  static const bottomNav = '/bottomNav';

  // dashboard
  static const dashboard = '/dashboard';
  static const dashboardNoti = '/dashboardNoti';
  static const appointmentList = '/appointmentList';
  static const vaccineSchedule = '/vaccineSchedule';
  static const vaccineManagement = '/vaccineManagement';
  static const vaccinationHistory = '/vaccination-history';
  static const vaccineManagementAppointmentDetail =
      '/vaccine-management-appointment-detail';
  static const vaccinationCertificate = '/vaccination-certificate';
  static const vaccineConsultation = '/vaccineConsultation';
  static const vaccinePassport = '/vaccinePassport';
  static const vaccineInfo = '/vaccineInfo';
  static const vaccinePayment = '/vaccinePayment';
  static const vaccineMissing = '/vaccineMissing';
  static const vaccineScheduleDetail = '/vaccineScheduleDetail';
  static const vaccineList = '/vaccineList';
  static const vaccineListDetail = '/vaccineListDetail';
  static const shippingInfo = '/shippingInfo';
  static const facilitySelection = '/facilitySelection';
  static const facilityMap = '/facilityMap';
  static const scheduleSelection = '/scheduleSelection';
  static const bookingSummary = '/bookingSummary';
  static const bookingVaccines = '/bookingVaccines';
  static const personSelection = '/personSelection';
  static const paymentSuccess = '/paymentSuccess';
  static const qrScanner = '/qrScanner';
  static const NOTIFICATIONS = '/NOTIFICATIONS';

  // profile
  static const profile = '/profile';
  static const savedItems = '/savedItems';
  static const paymentMethods = '/paymentMethods';
  static const faqs = '/faqs';
  static const familyManagement = '/familyManagement';
  static const familyMemberDetail = '/familyMemberDetail';
  static const editProfile = '/editProfile';

  // medical
  static const medicalAlerts = '/medicalAlerts';
  static const medicalProfile = '/medicalProfile';
  static const medicalAlertsDetail = '/medicalAlertsDetail';
  static const medicalNews = '/medicalNews';
  static const medicalNewsDetail = '/medicalNewsDetail';

  // account
  static const accountSecurity = '/accountSecurity';
  static const changePassword = '/changePassword';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgotPassword';
  static const verification = '/verification';
  static const completeProfile = '/complete-profile';
}
