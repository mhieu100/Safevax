import { Form, Modal, message } from 'antd';
import { ethers } from 'ethers';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { callCreateBooking } from '@/services/booking.service';
import { updatePaymentMetaMask } from '@/services/payment.service';
import { callGetBySlug } from '@/services/vaccine.service';
import AppointmentSection from './components/AppointmentSection';
import PaymentSection from './components/PaymentSection';
import ReviewSection from './components/ReviewSection';
import TopCheckoutSection from './components/TopCheckoutSection';

const BookingPage = () => {
  const { t } = useTranslation('client');
  const [bookingForm] = Form.useForm();
  const [paymentForm] = Form.useForm();
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();

  const [modal, contextHolder] = Modal.useModal();
  const [currentStep, setCurrentStep] = useState(0);
  const [vaccine, setVaccine] = useState(null);
  const [loading, setLoading] = useState(false);
  const [bookingData, setBookingData] = useState({
    vaccineId: null,
    vaccinationCourseId: null,
    doseNumber: null,
    bookingFor: 'self',
    familyMemberId: null,
    appointmentDate: null,
    appointmentTime: '',
    appointmentCenter: null,
    paymentMethod: 'CASH',
  });

  const fetchVaccineData = async (slug) => {
    try {
      const response = await callGetBySlug(slug);

      let vaccineData = null;
      if (response?.result) {
        vaccineData = response.result;
      } else if (response?.data) {
        vaccineData = response.data;
      } else if (response) {
        vaccineData = response;
      }

      if (vaccineData) {
        if (!vaccineData.dosesRequired) {
        }
        if (!vaccineData.duration) {
        }

        setVaccine(vaccineData);

        setBookingData((prev) => ({
          ...prev,
          vaccineId: vaccineData.id,
        }));
      } else {
        message.error(t('booking.bookingFailed'));
      }
    } catch (_error) {
      message.error(t('booking.bookingFailed'));
    }
  };

  useEffect(() => {
    const slug = searchParams.get('slug');
    const courseId = searchParams.get('vaccinationCourseId');
    const doseNum = searchParams.get('doseNumber');
    const familyMemberId = searchParams.get('familyMemberId');

    if (slug) {
      fetchVaccineData(slug);
    }

    setBookingData((prev) => {
      const newData = {
        ...prev,
        vaccinationCourseId: courseId || prev.vaccinationCourseId,
        doseNumber: doseNum || prev.doseNumber,
      };

      if (familyMemberId) {
        newData.bookingFor = 'family';
        newData.familyMemberId = Number(familyMemberId);

        bookingForm.setFieldsValue({
          bookingFor: 'family',
          familyMemberId: Number(familyMemberId),
        });
      }

      return newData;
    });
  }, [searchParams]);

  useEffect(() => {
    const interval = setInterval(() => {
      const bookingValues = bookingForm.getFieldsValue();
      const paymentValues = paymentForm.getFieldsValue();

      setBookingData((prev) => ({
        ...prev,
        ...bookingValues,
        ...paymentValues,
      }));
    }, 1000);

    return () => clearInterval(interval);
  }, [bookingForm, paymentForm]);

  useEffect(() => {
    if (window.ethereum) {
      const handleAccountsChanged = (accounts) => {
        if (accounts.length > 0) {
          message.info(t('booking.paymentSuccess'));
        } else {
          message.warning(t('booking.paymentFailed'));
        }
      };

      window.ethereum.on('accountsChanged', handleAccountsChanged);

      return () => {
        window.ethereum.removeListener('accountsChanged', handleAccountsChanged);
      };
    }
  }, []);

  const handleBookingSubmit = async () => {
    try {
      setLoading(true);

      await bookingForm.validateFields();
      await paymentForm.validateFields();

      const totalAmount = vaccine?.price || 0;

      let response;

      if (bookingData.vaccinationCourseId) {
        const { callBookNextDose } = await import('@/services/booking.service');
        const nextDosePayload = {
          vaccinationCourseId: bookingData.vaccinationCourseId,
          appointmentDate:
            bookingData.appointmentDate?.format?.('YYYY-MM-DD') || bookingData.appointmentDate,
          appointmentTime: bookingData.appointmentTime,
          appointmentCenter: bookingData.appointmentCenter,
          amount: totalAmount,
          paymentMethod: bookingData.paymentMethod || 'CASH',
        };
        response = await callBookNextDose(nextDosePayload);
      } else {
        const bookingPayload = {
          vaccineId: bookingData.vaccineId || vaccine?.id,
          familyMemberId: bookingData.bookingFor === 'family' ? bookingData.familyMemberId : null,
          appointmentDate:
            bookingData.appointmentDate?.format?.('YYYY-MM-DD') || bookingData.appointmentDate,
          appointmentTime: bookingData.appointmentTime,
          appointmentCenter: bookingData.appointmentCenter,
          amount: totalAmount,
          paymentMethod: bookingData.paymentMethod || 'CASH',
        };

        response = await callCreateBooking(bookingPayload);
      }

      const paymentData = response?.data;
      const error = response?.error;
      if (paymentData) {
        if (paymentData.method === 'PAYPAL' && paymentData.paymentURL) {
          window.location.href = paymentData.paymentURL;
        } else if (paymentData.method === 'BANK' && paymentData.paymentURL) {
          window.location.href = paymentData.paymentURL;
        } else if (paymentData.method === 'METAMASK') {
          await handleMetamaskPayment(paymentData);
        } else {
          try {
            navigate(`/success?id=${paymentData.referenceId || ''}`);
          } catch (_e) {
            navigate('/success');
          }
        }
      }
      if (error) {
        modal.warning({
          title: t('booking.bookingFailed'),
          content: error,
          okText: t('client:appointments.viewDetails'),
          cancelText: t('payment.cancelled'),
          closable: true,
          maskClosable: true,
          onOk: () => navigate('/appointments'),
        });
      }
    } catch (error) {
      console.error(error);
      message.error(error.message || t('booking.bookingFailed'));
    } finally {
      setLoading(false);
    }
  };

  const handleMetamaskPayment = async (paymentData) => {
    try {
      if (!window.ethereum) {
        throw new Error(t('booking.paymentFailed'));
      }

      await window.ethereum.request({ method: 'eth_requestAccounts' });
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();

      // Use environment variable or fallback to a test address
      const receiverAddress =
        import.meta.env.VITE_RECEIVER_ADDRESS || '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266';

      const tx = await signer.sendTransaction({
        to: receiverAddress,
        value: ethers.parseEther(paymentData.amount.toString()),
      });

      message.loading(t('booking.processing'));
      await tx.wait();

      const result = await updatePaymentMetaMask({
        paymentId: paymentData.paymentId,
        referenceId: paymentData.referenceId,
        type: 'APPOINTMENT',
      });

      message.success(t('booking.paymentSuccess'));
      navigate(
        `/success?id=${result?.referenceId || paymentData.referenceId || ''}&txHash=${tx.hash}`
      );
    } catch (error) {
      console.error(error);
      message.error(error.message || t('booking.paymentFailed'));
    }
  };

  const renderStep = () => {
    switch (currentStep) {
      case 0:
        return (
          <AppointmentSection
            bookingForm={bookingForm}
            vaccine={vaccine}
            setCurrentStep={setCurrentStep}
            setBookingData={setBookingData}
            bookingData={bookingData} // Pass bookingData
          />
        );
      case 1:
        return (
          <PaymentSection
            paymentForm={paymentForm}
            setCurrentStep={setCurrentStep}
            setBookingData={setBookingData}
          />
        );
      case 2:
        return (
          <ReviewSection
            bookingData={bookingData}
            vaccine={vaccine}
            setCurrentStep={setCurrentStep}
            handleBookingSubmit={handleBookingSubmit}
            loading={loading}
          />
        );
      default:
        return null;
    }
  };

  return (
    <div className="min-h-screen bg-slate-50 py-12">
      {contextHolder}
      <div className="container mx-auto px-4 max-w-7xl">
        <TopCheckoutSection
          currentStep={currentStep}
          setCurrentStep={setCurrentStep}
          doseNumber={bookingData.doseNumber}
        />
        {renderStep()}
      </div>
    </div>
  );
};

export default BookingPage;
