import { CheckCircleOutlined, MailOutlined } from '@ant-design/icons';
import { Button, Card, Result } from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { callGetAppointmentById } from '@/services/appointment.service';
import { getTransactionResult } from '@/services/payment.service';
import { formatPrice } from '@/utils/formatPrice';

const SuccessPage = () => {
  const navigate = useNavigate();
  const { t } = useTranslation(['client', 'common']);
  const [searchParams] = useSearchParams();
  const [loading, setLoading] = useState(true);
  const [result, setResult] = useState(null);

  const paymentId = searchParams.get('payment');
  const appointmentId = searchParams.get('id');

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
              patientName: data.patientName,
              vaccineName: data.vaccineName,
              scheduledTime: data.scheduledTimeSlot,
              scheduledDate: dayjs(data.scheduledDate).format('DD/MM/YYYY'),
              centerName: data.centerName,
              emailSentTo: data.patientEmail,
              paymentMethod: data.paymentMethod,
              paymentAmount: data.paymentAmount,
              paymentCurrency: data.paymentCurrency,
              paymentStatus: data.paymentStatus,
            });
          }
        } else if (paymentId) {
          const data = await getTransactionResult(paymentId);
          setResult(data);
        }
      } catch (error) {
        console.error('Failed to fetch transaction result:', error);
      } finally {
        setLoading(false);
      }
    };
    fetchResult();
  }, [paymentId, appointmentId]);

  return (
    <div className="min-h-[calc(100vh-90px)] bg-gradient-to-br from-green-50 to-blue-50 py-8 flex items-center justify-center">
      <div className="max-w-2xl mx-auto px-4">
        <Card className="rounded-2xl shadow-xl">
          <Result
            status="success"
            icon={<CheckCircleOutlined className="text-green-600" />}
            title={t('client:payment.success.title')}
            subTitle={
              loading ? (
                t('client:payment.success.loading')
              ) : (
                <div className="space-y-2 text-slate-600">
                  <p className="text-lg">
                    {t('client:payment.success.thankYou')}{' '}
                    <span className="font-semibold text-slate-800">{result?.patientName}</span>!
                  </p>
                  {result && (
                    <>
                      <p>
                        {t('client:payment.success.bookingSuccess')}{' '}
                        <span className="font-semibold text-blue-600">{result.vaccineName}</span>{' '}
                        {t('client:payment.success.vaccinationAppointment')}
                      </p>
                      <p>
                        {t('client:payment.success.time')}:{' '}
                        <span className="font-semibold">
                          {result.scheduledTime} - {result.scheduledDate}
                        </span>
                      </p>
                      <p>
                        {t('client:payment.success.location')}:{' '}
                        <span className="font-semibold">{result.centerName}</span>
                      </p>
                      {result.paymentMethod && (
                        <p>
                          {t('client:checkout.paymentMethod')}:{' '}
                          <span className="font-semibold">{result.paymentMethod}</span>
                        </p>
                      )}
                      {result.paymentAmount !== undefined && (
                        <p>
                          {t('client:review.totalAmount')}:{' '}
                          <span className="font-semibold text-green-600">
                            {formatPrice(
                              result.paymentAmount,
                              result.currency || result.paymentCurrency
                            )}
                          </span>
                        </p>
                      )}
                      <div className="mt-4 p-4 bg-green-50 rounded-lg border border-green-200">
                        <MailOutlined className="mr-2 text-green-600" />
                        <span>
                          {t('client:payment.success.emailNotice')}:{' '}
                          <span className="font-semibold text-green-700">{result.emailSentTo}</span>
                        </span>
                      </div>
                    </>
                  )}
                  <p className="mt-4 text-sm text-slate-500">
                    {t('client:payment.success.checkEmail')}
                  </p>
                </div>
              )
            }
            extra={[
              <Button
                type="primary"
                key="profile"
                onClick={() => navigate('/profile')}
                size="large"
              >
                {t('client:payment.success.viewProfile')}
              </Button>,
              <Button key="home" onClick={() => navigate('/')} size="large">
                {t('common:header.home')}
              </Button>,
            ]}
          />
        </Card>
      </div>
    </div>
  );
};

export default SuccessPage;
