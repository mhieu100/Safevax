import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import enAdminDashboard from './locales/en/admin/adminDashboard.json';
import enAdminCenters from './locales/en/admin/centers.json';
import enAdminCommon from './locales/en/admin/common.json';
import enAdminNews from './locales/en/admin/news.json';
import enAdminOrders from './locales/en/admin/orders.json';
import enAdminPermissions from './locales/en/admin/permissions.json';
import enAdminRoles from './locales/en/admin/roles.json';
import enAdminUsers from './locales/en/admin/users.json';
import enAdminVaccines from './locales/en/admin/vaccines.json';
import enClientAbout from './locales/en/client/about.json';
import enClientAppointments from './locales/en/client/appointments.json';
import enClientBooking from './locales/en/client/booking.json';
import enClientCheckout from './locales/en/client/checkout.json';
import enClientContact from './locales/en/client/contact.json';
import enClientDashboard from './locales/en/client/dashboard.json';
import enClientFamily from './locales/en/client/family.json';
import enClientHome from './locales/en/client/home.json';
import enClientLayout from './locales/en/client/layout.json';
import enClientNews from './locales/en/client/news.json';
import enClientOrders from './locales/en/client/orders.json';
import enClientPayment from './locales/en/client/payment.json';
import enClientProfile from './locales/en/client/profile.json';
import enClientRecords from './locales/en/client/records.json';
import enClientReview from './locales/en/client/review.json';
import enClientSearch from './locales/en/client/search.json';
import enClientSettings from './locales/en/client/settings.json';
import enClientTour from './locales/en/client/tour.json';
import enCommonAuth from './locales/en/common/auth.json';
import enCommonBlockchain from './locales/en/common/blockchain.json';
import enCommonCart from './locales/en/common/cart.json';
import enCommonErrors from './locales/en/common/errors.json';
import enCommonFooter from './locales/en/common/footer.json';
import enCommonHeader from './locales/en/common/header.json';
import enCommonHero from './locales/en/common/hero.json';
import enCommonRoles from './locales/en/common/roles.json';
import enCommonService from './locales/en/common/service.json';
import enCommonUser from './locales/en/common/user.json';
import enCommonVaccinationHistory from './locales/en/common/vaccinationHistory.json';
import enCommonVaccine from './locales/en/common/vaccine.json';
import enStaffAppointments from './locales/en/staff/appointments.json';
import enStaffCalendar from './locales/en/staff/calendar.json';
import enStaffCommon from './locales/en/staff/common.json';
import enStaffDashboard from './locales/en/staff/dashboard.json';
import enStaffDoctorSchedule from './locales/en/staff/doctorSchedule.json';
import enStaffProfile from './locales/en/staff/profile.json';
import enStaffWalkIn from './locales/en/staff/walkIn.json';
import viAdminDashboard from './locales/vi/admin/adminDashboard.json';
import viAdminCenters from './locales/vi/admin/centers.json';
import viAdminCommon from './locales/vi/admin/common.json';
import viAdminNews from './locales/vi/admin/news.json';
import viAdminOrders from './locales/vi/admin/orders.json';
import viAdminPermissions from './locales/vi/admin/permissions.json';
import viAdminRoles from './locales/vi/admin/roles.json';
import viAdminUsers from './locales/vi/admin/users.json';
import viAdminVaccines from './locales/vi/admin/vaccines.json';
import viClientAbout from './locales/vi/client/about.json';
import viClientAppointments from './locales/vi/client/appointments.json';
import viClientBooking from './locales/vi/client/booking.json';
import viClientCheckout from './locales/vi/client/checkout.json';
import viClientContact from './locales/vi/client/contact.json';
import viClientDashboard from './locales/vi/client/dashboard.json';
import viClientFamily from './locales/vi/client/family.json';
import viClientHome from './locales/vi/client/home.json';
import viClientLayout from './locales/vi/client/layout.json';
import viClientNews from './locales/vi/client/news.json';
import viClientOrders from './locales/vi/client/orders.json';
import viClientPayment from './locales/vi/client/payment.json';
import viClientProfile from './locales/vi/client/profile.json';
import viClientRecords from './locales/vi/client/records.json';
import viClientReview from './locales/vi/client/review.json';
import viClientSearch from './locales/vi/client/search.json';
import viClientSettings from './locales/vi/client/settings.json';
import viClientTour from './locales/vi/client/tour.json';
import viCommonAuth from './locales/vi/common/auth.json';
import viCommonBlockchain from './locales/vi/common/blockchain.json';
import viCommonCart from './locales/vi/common/cart.json';
import viCommonErrors from './locales/vi/common/errors.json';
import viCommonFooter from './locales/vi/common/footer.json';
import viCommonHeader from './locales/vi/common/header.json';
import viCommonHero from './locales/vi/common/hero.json';
import viCommonRoles from './locales/vi/common/roles.json';
import viCommonService from './locales/vi/common/service.json';
import viCommonUser from './locales/vi/common/user.json';
import viCommonVaccinationHistory from './locales/vi/common/vaccinationHistory.json';
import viCommonVaccine from './locales/vi/common/vaccine.json';
import viStaffAppointments from './locales/vi/staff/appointments.json';
import viStaffCalendar from './locales/vi/staff/calendar.json';
import viStaffCommon from './locales/vi/staff/common.json';
import viStaffDashboard from './locales/vi/staff/dashboard.json';
import viStaffDoctorSchedule from './locales/vi/staff/doctorSchedule.json';
import viStaffProfile from './locales/vi/staff/profile.json';
import viStaffWalkIn from './locales/vi/staff/walkIn.json';

const LANGUAGE_KEY = 'lang';

i18n.use(initReactI18next).init({
  resources: {
    en: {
      common: {
        auth: enCommonAuth,
        blockchain: enCommonBlockchain,
        cart: enCommonCart,
        errors: enCommonErrors,
        footer: enCommonFooter,
        header: enCommonHeader,
        hero: enCommonHero,
        roles: enCommonRoles,
        service: enCommonService,
        user: enCommonUser,
        vaccinationHistory: enCommonVaccinationHistory,
        vaccine: enCommonVaccine,
      },
      admin: {
        centers: enAdminCenters,
        common: enAdminCommon,
        dashboard: enAdminDashboard,
        news: enAdminNews,
        orders: enAdminOrders,
        permissions: enAdminPermissions,
        roles: enAdminRoles,
        users: enAdminUsers,
        vaccines: enAdminVaccines,
      },
      staff: {
        appointments: enStaffAppointments,
        calendar: enStaffCalendar,
        common: enStaffCommon,
        dashboard: enStaffDashboard,
        doctorSchedule: enStaffDoctorSchedule,
        profile: enStaffProfile,
        walkIn: enStaffWalkIn,
      },
      client: {
        about: enClientAbout,
        layout: enClientLayout,
        news: enClientNews,
        booking: enClientBooking,
        contact: enClientContact,
        checkout: enClientCheckout,
        records: enClientRecords,
        profile: enClientProfile,
        review: enClientReview,
        dashboard: enClientDashboard,
        family: enClientFamily,
        appointments: enClientAppointments,
        settings: enClientSettings,
        search: enClientSearch,
        tour: enClientTour,
        home: enClientHome,
        orders: enClientOrders,
        payment: enClientPayment,
      },
    },
    vi: {
      common: {
        auth: viCommonAuth,
        blockchain: viCommonBlockchain,
        cart: viCommonCart,
        errors: viCommonErrors,
        footer: viCommonFooter,
        header: viCommonHeader,
        hero: viCommonHero,
        roles: viCommonRoles,
        service: viCommonService,
        user: viCommonUser,
        vaccinationHistory: viCommonVaccinationHistory,
        vaccine: viCommonVaccine,
      },
      admin: {
        centers: viAdminCenters,
        common: viAdminCommon,
        dashboard: viAdminDashboard,
        news: viAdminNews,
        orders: viAdminOrders,
        permissions: viAdminPermissions,
        roles: viAdminRoles,
        users: viAdminUsers,
        vaccines: viAdminVaccines,
      },
      staff: {
        appointments: viStaffAppointments,
        calendar: viStaffCalendar,
        common: viStaffCommon,
        dashboard: viStaffDashboard,
        doctorSchedule: viStaffDoctorSchedule,
        profile: viStaffProfile,
        walkIn: viStaffWalkIn,
      },
      client: {
        about: viClientAbout,
        layout: viClientLayout,
        news: viClientNews,
        booking: viClientBooking,
        checkout: viClientCheckout,
        records: viClientRecords,
        profile: viClientProfile,
        review: viClientReview,
        dashboard: viClientDashboard,
        family: viClientFamily,
        appointments: viClientAppointments,
        settings: viClientSettings,
        search: viClientSearch,
        tour: viClientTour,
        home: viClientHome,
        orders: viClientOrders,
        payment: viClientPayment,
        contact: viClientContact,
      },
    },
  },
  lng: typeof window !== 'undefined' ? localStorage.getItem(LANGUAGE_KEY) || 'vi' : 'vi',
  fallbackLng: 'en',
  ns: ['common', 'admin', 'staff', 'client'],
  defaultNS: 'common',
  interpolation: {
    escapeValue: false,
  },
});

export const changeLanguage = (lang) => {
  i18n.changeLanguage(lang);
  if (typeof window !== 'undefined') {
    localStorage.setItem(LANGUAGE_KEY, lang);
  }
};

export default i18n;
// Force HMR refresh for translations
