import {
  CalendarOutlined,
  CheckCircleOutlined,
  EnvironmentOutlined,
  MailOutlined,
  MedicineBoxOutlined,
  UserOutlined,
} from '@ant-design/icons';
import { Button } from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { callGetAppointmentById } from '@/services/appointment.service';
import { getTransactionResult } from '@/services/payment.service';
import { formatAppointmentTime } from '@/utils/appointment';
import { formatPrice } from '@/utils/formatPrice';

const SuccessPage = () => {
  const navigate = useNavigate();
  const { t } = useTranslation(['client', 'common']);
  const [searchParams] = useSearchParams();
  const [loading, setLoading] = useState(true);
  const [result, setResult] = useState(null);

  const paymentId = searchParams.get('payment');
  const appointmentId = searchParams.get('id');

  const txHash = searchParams.get('txHash');

  useEffect(() => {
    const fetchResult = async () => {
      if (!paymentId && !appointmentId) {
        setLoading(false);
        return;
      }

      try {
        if (appointmentId) {
          const res = await callGetAppointmentById(appointmentId);
          if (res?.data) {
            const data = res.data;
            setResult({
              id: data.id,
              patientName: data.patientName,
              patientPhone: data.patientPhone,
              vaccineName: data.vaccineName,
              doseNumber: data.doseNumber,
              vaccineTotalDoses: data.vaccineTotalDoses,
              scheduledTime: formatAppointmentTime(data),
              scheduledDate: dayjs(data.scheduledDate).format('DD/MM/YYYY'),
              centerName: data.centerName,
              centerAddress: data.centerAddress,
              emailSentTo: data.patientEmail,
              paymentMethod: data.paymentMethod,
              paymentAmount: data.paymentAmount,
              paymentCurrency: data.paymentCurrency,
              paymentStatus: data.paymentStatus || 'COMPLETED',
              createdAt: data.createdAt,
              txHash: txHash,
            });
          }
        } else if (paymentId) {
          const data = await getTransactionResult(paymentId);
          setResult({ ...data, txHash });
        }
      } catch (error) {
        console.error('Failed to fetch transaction result:', error);
      } finally {
        setLoading(false);
      }
    };
    fetchResult();
  }, [paymentId, appointmentId, txHash]);

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-5xl mx-auto">
        {loading ? (
          <div className="flex justify-center items-center h-64">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          </div>
        ) : (
          <div className="space-y-8">
            {/* Header Section */}
            <div className="bg-white rounded-2xl p-8 text-center shadow-sm border border-slate-100">
              <div className="w-20 h-20 bg-emerald-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <CheckCircleOutlined className="text-5xl text-emerald-600" />
              </div>
              <h1 className="text-3xl font-bold text-slate-900 mb-2">
                {t('client:payment.success.title')}
              </h1>
              <p className="text-lg text-slate-600 max-w-2xl mx-auto">
                {t('client:payment.success.subtitle')}
              </p>
              <div className="mt-6 inline-flex items-center px-4 py-2 bg-slate-100 rounded-full text-slate-700 font-medium text-sm">
                <span>
                  {t('client:payment.success.bookingId')}:{' '}
                  <span className="text-slate-900 font-bold">#{result?.id}</span>
                </span>
              </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
              {/* Main Content - Left Column */}
              <div className="lg:col-span-2 space-y-6">
                {/* Ticket / Appointment Card */}
                <div className="bg-white rounded-2xl overflow-hidden shadow-sm border border-slate-200">
                  <div className="bg-blue-600 p-4 text-white flex justify-between items-center">
                    <span className="font-bold text-lg flex items-center gap-2">
                      <MedicineBoxOutlined />
                      {t('client:payment.success.ticketTitle')}
                    </span>
                    <span className="bg-white/20 px-3 py-1 rounded-full text-sm font-medium backdrop-blur-sm">
                      {result?.scheduledDate}
                    </span>
                  </div>
                  <div className="p-6">
                    <div className="flex flex-col md:flex-row gap-6">
                      <div className="flex-1">
                        <h3 className="text-2xl font-bold text-slate-800 mb-2">
                          {result?.vaccineName}
                        </h3>
                        <div className="inline-block bg-blue-50 text-blue-700 px-3 py-1 rounded-lg text-sm font-semibold mb-4 border border-blue-100">
                          {t('client:payment.success.dose')} {result?.doseNumber} /{' '}
                          {result?.vaccineTotalDoses || '?'}
                        </div>

                        <div className="space-y-3">
                          <div className="flex items-start gap-3">
                            <CalendarOutlined className="text-slate-400 mt-1" />
                            <div>
                              <div className="text-xs text-slate-500 uppercase font-bold">
                                {t('client:payment.success.time')}
                              </div>
                              <div className="text-slate-800 font-medium">
                                {result?.scheduledTime}
                              </div>
                            </div>
                          </div>
                          <div className="flex items-start gap-3">
                            <EnvironmentOutlined className="text-slate-400 mt-1" />
                            <div>
                              <div className="text-xs text-slate-500 uppercase font-bold">
                                {t('client:payment.success.location')}
                              </div>
                              <div className="text-slate-800 font-medium">{result?.centerName}</div>
                              <div className="text-sm text-slate-500">{result?.centerAddress}</div>
                            </div>
                          </div>
                        </div>
                      </div>

                      <div className="hidden md:block w-px bg-slate-200 border-l border-dashed"></div>

                      <div className="md:w-1/3 flex flex-col justify-center items-center text-center p-4 bg-slate-50 rounded-xl">
                        <div className="text-slate-400 mb-2">
                          <CheckCircleOutlined className="text-4xl text-emerald-500" />
                        </div>
                        <div className="font-bold text-emerald-600">
                          {t('client:payment.success.confirmed')}
                        </div>
                        <div className="text-xs text-slate-400 mt-1">
                          {t('client:payment.success.arriveOnTime')}
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Patient Info */}
                <div className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200">
                  <h3 className="font-bold text-slate-800 mb-4 flex items-center gap-2">
                    <UserOutlined className="text-blue-500" />
                    {t('client:payment.success.patientInfo')}
                  </h3>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="bg-slate-50 p-3 rounded-xl border border-slate-100">
                      <div className="text-xs text-slate-500 mb-1">
                        {t('client:payment.success.patientName')}
                      </div>
                      <div className="font-semibold text-slate-800">{result?.patientName}</div>
                    </div>
                    <div className="bg-slate-50 p-3 rounded-xl border border-slate-100">
                      <div className="text-xs text-slate-500 mb-1">
                        {t('client:payment.success.patientPhone')}
                      </div>
                      <div className="font-semibold text-slate-800">
                        {result?.patientPhone || 'N/A'}
                      </div>
                    </div>
                    <div className="bg-slate-50 p-3 rounded-xl border border-slate-100 md:col-span-2">
                      <div className="text-xs text-slate-500 mb-1">
                        {t('client:payment.success.notificationEmail')}
                      </div>
                      <div className="font-semibold text-slate-800 flex items-center gap-2">
                        <MailOutlined className="text-emerald-500" />
                        {result?.emailSentTo}
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              {/* Sidebar - Right Column */}
              <div className="space-y-6">
                {/* Payment Summary */}
                <div className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200">
                  <h3 className="font-bold text-slate-800 mb-4">
                    {t('client:payment.success.paymentDetails')}
                  </h3>
                  <div className="space-y-3 pb-4 border-b border-slate-100">
                    <div className="flex justify-between text-sm">
                      <span className="text-slate-500">
                        {t('client:payment.success.paymentMethod')}
                      </span>
                      <span className="font-medium text-slate-900">{result?.paymentMethod}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-slate-500">{t('client:payment.success.status')}</span>
                      <span className="font-medium text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded text-xs uppercase">
                        {result?.paymentStatus === 'COMPLETED'
                          ? t('client:payment.success.paid')
                          : result?.paymentStatus}
                      </span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-slate-500">
                        {t('client:payment.success.createdDate')}
                      </span>
                      <span className="font-medium text-slate-900">
                        {result?.createdAt
                          ? dayjs(result.createdAt).format('HH:mm DD/MM/YYYY')
                          : 'Just now'}
                      </span>
                    </div>
                    {result?.txHash && (
                      <div className="flex flex-col text-sm pt-2">
                        <span className="text-slate-500 mb-1">Blockchain TxHash</span>
                        <a
                          href={`https://sepolia.etherscan.io/tx/${result.txHash}`}
                          target="_blank"
                          rel="noreferrer"
                          className="font-mono text-xs text-blue-600 truncate bg-blue-50 p-1.5 rounded border border-blue-100 hover:bg-blue-100 transition-colors"
                        >
                          {result.txHash}
                        </a>
                      </div>
                    )}
                  </div>
                  <div className="pt-4 flex justify-between items-center">
                    <span className="font-bold text-slate-700">
                      {t('client:payment.success.total')}
                    </span>
                    <span className="text-2xl font-bold text-blue-600">
                      {formatPrice(result?.paymentAmount)}
                    </span>
                  </div>
                </div>

                {/* Next Steps */}
                <div className="bg-blue-50 rounded-2xl p-6 border border-blue-100">
                  <h3 className="font-bold text-blue-800 mb-4">
                    {t('client:payment.success.nextSteps')}
                  </h3>
                  <ul className="space-y-4">
                    <li className="flex gap-3">
                      <div className="w-6 h-6 rounded-full bg-blue-200 text-blue-700 font-bold text-xs flex items-center justify-center flex-shrink-0">
                        1
                      </div>
                      <div className="text-sm text-blue-900/80">
                        <span className="font-semibold block text-blue-900">
                          {t('client:payment.success.step1Title')}
                        </span>
                        {t('client:payment.success.step1Desc')}
                      </div>
                    </li>
                    <li className="flex gap-3">
                      <div className="w-6 h-6 rounded-full bg-blue-200 text-blue-700 font-bold text-xs flex items-center justify-center flex-shrink-0">
                        2
                      </div>
                      <div className="text-sm text-blue-900/80">
                        <span className="font-semibold block text-blue-900">
                          {t('client:payment.success.step2Title')}
                        </span>
                        {t('client:payment.success.step2Desc')}
                      </div>
                    </li>
                    <li className="flex gap-3">
                      <div className="w-6 h-6 rounded-full bg-blue-200 text-blue-700 font-bold text-xs flex items-center justify-center flex-shrink-0">
                        3
                      </div>
                      <div className="text-sm text-blue-900/80">
                        <span className="font-semibold block text-blue-900">
                          {t('client:payment.success.step3Title')}
                        </span>
                        {t('client:payment.success.step3Desc')}
                      </div>
                    </li>
                  </ul>
                </div>

                {/* Buttons */}
                <div className="flex flex-col gap-3">
                  <Button
                    type="primary"
                    size="large"
                    onClick={() => navigate('/appointments')}
                    className="w-full h-12 rounded-xl font-bold bg-blue-600 shadow-lg shadow-blue-500/30"
                  >
                    {t('client:payment.success.viewAppointments')}
                  </Button>
                  <Button
                    size="large"
                    onClick={() => navigate('/')}
                    className="w-full h-12 rounded-xl"
                  >
                    {t('client:payment.success.home')}
                  </Button>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default SuccessPage;
