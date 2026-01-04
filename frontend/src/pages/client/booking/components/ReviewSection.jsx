import {
  BarcodeOutlined,
  CalendarOutlined,
  ClockCircleOutlined,
  EnvironmentOutlined,
  MedicineBoxOutlined,
  UserOutlined,
} from '@ant-design/icons';
import { Button, Checkbox, Divider, Tag } from 'antd';
import dayjs from 'dayjs';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { DEFAULT_PAGE, DEFAULT_PAGE_SIZE } from '@/constants';
import { useCenter } from '@/hooks/useCenter';
import { useFamilyMember } from '@/hooks/useFamilyMember';
import { formatPrice } from '@/utils/formatPrice';

const ReviewSection = ({ bookingData, vaccine, setCurrentStep, handleBookingSubmit, loading }) => {
  const { t } = useTranslation('client');
  const [acceptTerms, setAcceptTerms] = useState(false);
  const [acceptPolicy, setAcceptPolicy] = useState(false);

  const filter = {
    current: DEFAULT_PAGE,
    pageSize: DEFAULT_PAGE_SIZE,
  };

  const { data: centers } = useCenter(filter);
  const { data: families } = useFamilyMember(filter);

  const vaccineInfo = vaccine;
  const paymentMethod = bookingData.paymentMethod || 'CASH';
  const totalPrice = vaccineInfo?.price || 0;

  const getCenterById = (centerId) => {
    return centers?.result?.find((center) => String(center.centerId) === String(centerId));
  };

  const getFamilyMemberById = (memberId) => {
    return families?.result?.find((member) => member.id === memberId);
  };

  const _handleReviewPrev = () => {
    setCurrentStep(1);
  };

  const handleConfirm = async () => {
    if (!acceptTerms || !acceptPolicy) {
      return;
    }
    await handleBookingSubmit();
  };

  return (
    <div className="animate-fade-in max-w-6xl mx-auto">
      <div className="text-center mb-10">
        <h2 className="text-3xl font-bold text-slate-900 mb-3">{t('review.title')}</h2>
        <p className="text-slate-500 text-lg">{t('review.subtitle')}</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {}
        <div className="lg:col-span-2 space-y-6">
          {}
          <div className="bg-white p-6 rounded-3xl shadow-sm border border-slate-100">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-blue-600">
                <MedicineBoxOutlined className="text-xl" />
              </div>
              <h3 className="text-lg font-bold text-slate-800 m-0">
                {t('review.vaccineInformation')}
              </h3>
            </div>

            <div className="flex gap-4">
              <div className="w-24 h-24 rounded-xl overflow-hidden bg-slate-100 flex-shrink-0">
                <img
                  src={vaccineInfo?.image}
                  alt={vaccineInfo?.name}
                  className="w-full h-full object-cover"
                />
              </div>
              <div>
                <h4 className="text-xl font-bold text-slate-900 mb-1">{vaccineInfo?.name}</h4>
                <div className="flex flex-wrap gap-2 mb-2">
                  <Tag color="blue">{vaccineInfo?.country}</Tag>
                  <Tag color="cyan">
                    {vaccineInfo?.dosesRequired} {t('booking.doses')}
                  </Tag>
                </div>
                <p className="text-slate-500 text-sm">
                  {t('booking.interval')}: {vaccineInfo?.duration} {t('booking.days')}
                </p>
              </div>
            </div>
          </div>

          {}
          <div className="bg-white p-6 rounded-3xl shadow-sm border border-slate-100">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 rounded-full bg-purple-50 flex items-center justify-center text-purple-600">
                <CalendarOutlined className="text-xl" />
              </div>
              <h3 className="text-lg font-bold text-slate-800 m-0">
                {t('review.appointmentDetails')}
              </h3>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="bg-slate-50 p-4 rounded-2xl">
                <div className="text-slate-500 text-xs font-bold uppercase tracking-wider mb-1">
                  {t('review.dateTime')}
                </div>
                <div className="flex items-center gap-2 text-slate-800 font-bold text-lg">
                  <CalendarOutlined className="text-blue-500" />
                  {bookingData.appointmentDate
                    ? dayjs(bookingData.appointmentDate).format('DD/MM/YYYY')
                    : 'N/A'}
                </div>
                <div className="flex items-center gap-2 text-slate-600 font-medium mt-1">
                  <ClockCircleOutlined className="text-blue-500" />
                  {bookingData.appointmentTime || 'N/A'}
                </div>
              </div>

              <div className="bg-slate-50 p-4 rounded-2xl">
                <div className="text-slate-500 text-xs font-bold uppercase tracking-wider mb-1">
                  {t('review.location')}
                </div>
                <div className="flex items-start gap-2 text-slate-800 font-bold">
                  <EnvironmentOutlined className="text-red-500 mt-1" />
                  <span>
                    {getCenterById(bookingData.appointmentCenter)?.name ||
                      t('review.unknownCenter')}
                  </span>
                </div>
              </div>

              <div className="bg-slate-50 p-4 rounded-2xl md:col-span-2">
                <div className="text-slate-500 text-xs font-bold uppercase tracking-wider mb-1">
                  {t('review.patient')}
                </div>
                <div className="flex items-center gap-2 text-slate-800 font-bold text-lg">
                  <UserOutlined className="text-green-500" />
                  {bookingData.bookingFor === 'self'
                    ? t('booking.myself')
                    : getFamilyMemberById(bookingData.familyMemberId)?.fullName ||
                      t('booking.familyMember')}
                </div>
                <Tag color={bookingData.bookingFor === 'self' ? 'blue' : 'green'} className="mt-2">
                  {bookingData.bookingFor === 'self'
                    ? t('review.selfBooking')
                    : t('review.familyBooking')}
                </Tag>
              </div>
            </div>
          </div>

          {}
          <div className="bg-white p-6 rounded-3xl shadow-sm border border-slate-100">
            <div className="space-y-3">
              <Checkbox checked={acceptTerms} onChange={(e) => setAcceptTerms(e.target.checked)}>
                <span className="text-slate-600">
                  {t('review.iAgreeTo')}{' '}
                  <a href="/terms" className="text-blue-600 font-medium hover:underline">
                    {t('review.termsOfService')}
                  </a>
                </span>
              </Checkbox>
              <Checkbox checked={acceptPolicy} onChange={(e) => setAcceptPolicy(e.target.checked)}>
                <span className="text-slate-600">
                  {t('review.iAgreeTo')}{' '}
                  <a href="/privacy" className="text-blue-600 font-medium hover:underline">
                    {t('review.privacyPolicy')}
                  </a>
                </span>
              </Checkbox>
            </div>
          </div>
        </div>

        {}
        <div className="lg:col-span-1">
          <div className="sticky top-24">
            <div className="bg-white rounded-3xl shadow-xl overflow-hidden border border-slate-100 relative">
              {}
              <div className="bg-slate-900 p-6 text-white relative overflow-hidden">
                <div className="absolute top-0 right-0 w-32 h-32 bg-blue-500 rounded-full blur-3xl opacity-20 -translate-y-1/2 translate-x-1/2" />
                <div className="relative z-10 flex justify-between items-start">
                  <div>
                    <div className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">
                      {t('review.totalAmount')}
                    </div>
                    <div className="text-3xl font-bold text-white">{formatPrice(totalPrice)}</div>
                  </div>
                  <div className="bg-white/10 backdrop-blur-md p-2 rounded-lg">
                    <BarcodeOutlined className="text-3xl text-white/80" />
                  </div>
                </div>
              </div>

              {}
              <div className="p-6 relative">
                {}
                <div className="absolute top-0 left-0 w-full -translate-y-1/2 flex justify-between px-4">
                  <div className="w-6 h-6 bg-slate-50 rounded-full" />
                  <div className="flex-1 border-t-2 border-dashed border-slate-200 mx-2 self-center" />
                  <div className="w-6 h-6 bg-slate-50 rounded-full" />
                </div>

                <div className="space-y-4 mt-2">
                  <div className="flex justify-between items-center">
                    <span className="text-slate-500">{t('checkout.paymentMethod')}</span>
                    <span className="font-bold text-slate-900">{paymentMethod}</span>
                  </div>
                  <Divider className="my-2" />
                  <div className="flex justify-between items-center">
                    <span className="text-slate-500">{t('checkout.vaccinePrice')}</span>
                    <span className="font-medium text-slate-900">
                      {formatPrice(vaccineInfo?.price)}
                    </span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="text-slate-500">{t('booking.doses')}</span>
                    <span className="font-medium text-slate-900">{t('review.firstDose')}</span>
                  </div>
                </div>

                <Button
                  type="primary"
                  size="large"
                  onClick={handleConfirm}
                  disabled={!acceptTerms || !acceptPolicy}
                  loading={loading}
                  className="w-full mt-6 h-12 rounded-xl font-bold text-lg shadow-lg shadow-blue-500/30 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 border-none"
                >
                  {t('booking.confirmBooking')}
                </Button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ReviewSection;
