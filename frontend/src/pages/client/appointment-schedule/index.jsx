import {
  CalendarOutlined,
  CheckCircleFilled,
  ClockCircleFilled,
  CloseCircleOutlined,
  EnvironmentOutlined,
  MedicineBoxOutlined,
  SyncOutlined,
} from '@ant-design/icons';
import {
  Alert,
  Button,
  Card,
  Empty,
  Modal,
  message,
  Progress,
  Skeleton,
  Tag,
  Timeline,
  Typography,
} from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { callCancelAppointment } from '@/services/appointment.service';
import { getActiveGroupedBookings } from '@/services/booking.service';
import { formatAppointmentTime } from '@/utils/appointment';
import RescheduleAppointmentModal from './components/RescheduleAppointmentModal';

const { Title, Text } = Typography;

const AppointmentSchedulePage = () => {
  const { t } = useTranslation(['client']);
  const [routes, setRoutes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [rescheduleModalOpen, setRescheduleModalOpen] = useState(false);
  const [selectedAppointment, setSelectedAppointment] = useState(null);

  const fetchBookings = async () => {
    try {
      setLoading(true);
      const response = await getActiveGroupedBookings();
      if (response?.data) {
        setRoutes(response.data);
      }
    } catch (err) {
      setError(err?.message || t('client:appointments.errorLoading'));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchBookings();
  }, []);

  const getStatusColor = (status) => {
    switch (status) {
      case 'COMPLETED':
        return 'blue';
      case 'SCHEDULED':
        return 'cyan';
      case 'PENDING':
        return 'orange';
      case 'RESCHEDULE':
        return 'gold';
      case 'CANCELLED':
        return 'red';
      default:
        return 'default';
    }
  };

  const getStatusText = (status) => {
    switch (status) {
      case 'COMPLETED':
        return t('client:records.vaccinationHistory.completed');
      case 'SCHEDULED':
        return t('client:appointments.scheduled');
      case 'PENDING':
        return t('client:records.blockchain.pending');
      case 'RESCHEDULE':
        return t('client:appointments.rescheduling');
      case 'CANCELLED':
        return t('client:appointments.cancelled');
      default:
        return status;
    }
  };

  const handleReschedule = (appointment) => {
    setSelectedAppointment({ ...appointment, appointmentId: appointment.id });
    setRescheduleModalOpen(true);
  };

  const handleRescheduleSuccess = () => {
    fetchBookings();
  };

  const handleCancelAppointment = (appointment) => {
    Modal.confirm({
      title: t('client:appointments.cancelAppointment'),
      content: (
        <div>
          <p>{t('client:appointments.confirmCancel')}</p>
          <div className="mt-3 p-3 bg-slate-50 rounded-xl border border-slate-100 text-sm">
            <p className="mb-1">
              <span className="font-semibold">
                {t('client:records.vaccinationHistory.vaccine')}:
              </span>{' '}
              {appointment.vaccineName}
            </p>
            <p className="mb-1">
              <span className="font-semibold">{t('client:records.vaccinationHistory.dose')}:</span>{' '}
              {appointment.doseNumber}
            </p>
            <p className="mb-1">
              <span className="font-semibold">{t('client:records.vaccinationHistory.date')}:</span>{' '}
              {dayjs(appointment.scheduledDate).format('DD/MM/YYYY')}
            </p>
            <p className="mb-0">
              <span className="font-semibold">
                {t('client:records.vaccinationHistory.center')}:
              </span>{' '}
              {appointment.centerName}
            </p>
          </div>
        </div>
      ),
      okText: t('client:appointments.yesCancel'),
      cancelText: t('client:appointments.goBack'),
      okButtonProps: { danger: true, shape: 'round' },
      cancelButtonProps: { shape: 'round' },
      onOk: async () => {
        try {
          await callCancelAppointment(appointment.id);
          message.success(t('client:appointments.cancelSuccess'));
          fetchBookings();
        } catch (error) {
          message.error(error?.message || t('client:appointments.cancelFailed'));
        }
      },
    });
  };

  // Backend already filters for active appointments (PENDING, SCHEDULED, RESCHEDULE)
  // No need to filter on frontend anymore
  const selfRoutes = routes.filter((r) => !r.isFamily);
  const familyRoutes = routes.filter((r) => r.isFamily);

  if (loading) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-8 space-y-6 animate-fade-in min-h-[calc(100vh-90px)]">
        <div className="flex justify-between items-end mb-4">
          <div>
            <Skeleton.Input active size="small" className="!w-48 mb-2" />
            <Skeleton.Input active size="small" className="!w-64 block" />
          </div>
        </div>
        {[1, 2].map((i) => (
          <Card key={i} className="rounded-3xl shadow-sm border border-slate-100 overflow-hidden">
            <div className="flex justify-between mb-6">
              <div className="flex gap-4">
                <Skeleton.Avatar active size="large" shape="square" />
                <div>
                  <Skeleton.Input active size="small" className="!w-32 mb-1" />
                  <Skeleton.Input active size="small" className="!w-24" />
                </div>
              </div>
              <Skeleton.Button active size="small" />
            </div>
            <Skeleton active paragraph={{ rows: 2 }} />
          </Card>
        ))}
      </div>
    );
  }

  if (error) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-8 min-h-[calc(100vh-90px)]">
        <Alert
          type="error"
          title={t('client:appointments.errorLoading')}
          description={error}
          showIcon
          className="rounded-xl"
        />
      </div>
    );
  }

  if (routes.length === 0) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 py-12 text-center min-h-[calc(100vh-90px)]">
        <div className="mb-6">
          <Title level={3} className="!mb-1 text-slate-800">
            {t('client:layout.sidebar.appointments')}
          </Title>
          <Text className="text-slate-500 text-lg">{t('client:appointments.manageSchedules')}</Text>
        </div>
        <Empty
          image={Empty.PRESENTED_IMAGE_SIMPLE}
          description={
            <span className="text-slate-500">{t('client:appointments.noUpcoming')}</span>
          }
        />
        <Button
          type="primary"
          className="mt-4 rounded-xl shadow-lg shadow-blue-500/20"
          href="/vaccines"
        >
          {t('client:appointments.bookNew')}
        </Button>
      </div>
    );
  }

  const renderVaccineTimeline = (route) => {
    // Sort appointments: COMPLETED first, then by Dose Number
    const sortedAppointments = [...route.appointments].sort(
      (a, b) => (a.doseNumber || 0) - (b.doseNumber || 0)
    );

    const percent = Math.round((route.completedCount / route.requiredDoses) * 100);

    return (
      <Card
        className="!mb-6 rounded-3xl shadow-sm border border-slate-200 overflow-hidden hover:shadow-lg transition-shadow"
        key={route.routeId}
        styles={{ body: { padding: '24px' } }}
      >
        {/* Header Section */}
        <div className="flex flex-col md:flex-row justify-between items-start gap-6 pb-6 border-b border-slate-100">
          <div className="flex items-start gap-4 flex-1">
            <div className="w-14 h-14 rounded-2xl bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-100 flex items-center justify-center text-blue-600 shadow-sm">
              <MedicineBoxOutlined className="text-2xl" />
            </div>
            <div className="flex-1">
              <div className="flex items-center gap-2 mb-1">
                <Title level={4} className="!mb-0 text-slate-800">
                  {route.vaccineName}
                </Title>
                <Tag color="geekblue" className="rounded-full px-2.5 text-xs font-semibold">
                  {route.totalAmount
                    ? `${parseFloat(route.totalAmount).toLocaleString()} VND`
                    : 'Standard'}
                </Tag>
              </div>

              <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-slate-500">
                <span className="flex items-center gap-1.5">
                  <div className="w-2 h-2 rounded-full bg-slate-300" />
                  {t('client:records.vaccinationHistory.patient')}:{' '}
                  <span className="font-medium text-slate-700">{route.patientName}</span>
                </span>
                <span className="flex items-center gap-1.5">
                  <div className="w-2 h-2 rounded-full bg-slate-300" />
                  Mã lộ trình: <span className="font-mono text-slate-600">#{route.routeId}</span>
                </span>
              </div>
            </div>
          </div>

          <div className="w-full md:w-48 flex flex-col gap-1">
            <div className="flex justify-between text-xs font-medium text-slate-500 mb-1">
              <span>Tiến độ tiêm chủng</span>
              <span className="text-blue-600">
                {route.completedCount}/{route.requiredDoses} mũi
              </span>
            </div>
            <Progress
              percent={percent}
              strokeColor={{ '0%': '#108ee9', '100%': '#87d068' }}
              showInfo={false}
              size="small"
            />
          </div>
        </div>

        {/* Timeline Section */}
        <div className="mt-8 px-2">
          <Timeline
            className="custom-timeline"
            items={sortedAppointments.map((apt) => {
              const isCompleted = apt.appointmentStatus === 'COMPLETED';
              const isUrgent = apt.appointmentStatus === 'RESCHEDULE';

              return {
                dot: isCompleted ? (
                  <div className="w-8 h-8 rounded-full bg-emerald-100 flex items-center justify-center border-4 border-white shadow-sm">
                    <CheckCircleFilled className="text-emerald-500 text-lg" />
                  </div>
                ) : (
                  <div className="w-8 h-8 rounded-full bg-blue-50 flex items-center justify-center border-4 border-white shadow-sm">
                    <ClockCircleFilled
                      className={`text-lg ${isUrgent ? 'text-amber-500' : 'text-blue-500'}`}
                    />
                  </div>
                ),
                children: (
                  <div className="pl-4 pb-8">
                    <div
                      className={`p-5 rounded-2xl border transition-all ${
                        isCompleted
                          ? 'bg-slate-50 border-slate-200'
                          : 'bg-white border-blue-100 shadow-sm hover:border-blue-300 hover:shadow-md'
                      }`}
                    >
                      {/* Card Header: Dose & Status */}
                      <div className="flex flex-wrap justify-between items-center gap-3 mb-4 border-b border-dashed border-slate-200 pb-3">
                        <div className="flex items-center gap-3">
                          <span
                            className={`flex items-center justify-center w-8 h-8 rounded-lg font-bold text-sm ${
                              isCompleted
                                ? 'bg-slate-200 text-slate-600'
                                : 'bg-blue-100 text-blue-700'
                            }`}
                          >
                            M{apt.doseNumber}
                          </span>
                          <Text strong className="text-slate-700 text-lg">
                            {t('client:records.vaccinationHistory.dose')} {apt.doseNumber}
                          </Text>
                          <Tag
                            color={getStatusColor(apt.appointmentStatus)}
                            className="rounded-lg px-2 py-0.5 border-0 font-semibold"
                          >
                            {getStatusText(apt.appointmentStatus)}
                          </Tag>
                        </div>
                        {apt.paymentStatus && (
                          <Tag
                            color={apt.paymentStatus === 'SUCCESS' ? 'success' : 'warning'}
                            bordered={false}
                          >
                            {apt.paymentStatus === 'SUCCESS' ? 'Đã thanh toán' : 'Chưa thanh toán'}
                          </Tag>
                        )}
                      </div>

                      {/* Card Content: Info Grid */}
                      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                        {/* Time & Date */}
                        <div className="flex items-start gap-3">
                          <div className="mt-1 p-1.5 bg-blue-50 text-blue-500 rounded-md">
                            <CalendarOutlined />
                          </div>
                          <div>
                            <div className="text-xs text-slate-400 uppercase font-semibold tracking-wider mb-0.5">
                              Thời gian
                            </div>
                            <div className="font-medium text-slate-700">
                              {dayjs(apt.scheduledDate).format('dddd, DD/MM/YYYY')}
                            </div>
                            {apt.appointmentStatus !== 'PENDING' &&
                              apt.appointmentStatus !== 'INITIAL' && (
                                <div className="text-sm text-slate-500 mt-0.5">
                                  {formatAppointmentTime(apt)}
                                </div>
                              )}
                          </div>
                        </div>

                        {/* Center Location */}
                        <div className="flex items-start gap-3">
                          <div className="mt-1 p-1.5 bg-red-50 text-red-500 rounded-md">
                            <EnvironmentOutlined />
                          </div>
                          <div>
                            <div className="text-xs text-slate-400 uppercase font-semibold tracking-wider mb-0.5">
                              Địa điểm
                            </div>
                            <div className="font-medium text-slate-700">{apt.centerName}</div>
                            <div className="text-xs text-slate-500 mt-1 truncate max-w-[200px]">
                              {/* Assuming center address exists or can be added later */}
                              Trung tâm tiêm chủng
                            </div>
                          </div>
                        </div>

                        {/* Doctor Info */}
                        <div className="flex items-start gap-3">
                          <div className="mt-1 p-1.5 bg-purple-50 text-purple-500 rounded-md">
                            <MedicineBoxOutlined />
                          </div>
                          <div>
                            <div className="text-xs text-slate-400 uppercase font-semibold tracking-wider mb-0.5">
                              Bác sĩ phụ trách
                            </div>
                            <div className="font-medium text-slate-700">
                              {apt.doctorName || (
                                <span className="italic text-slate-400">Chưa phân công</span>
                              )}
                            </div>
                          </div>
                        </div>
                      </div>

                      {/* Actions / Notifications */}
                      <div className="mt-4 pt-3 border-t border-slate-50 flex flex-col md:flex-row justify-between items-center gap-4">
                        <div className="flex-1 w-full">
                          {apt.appointmentStatus === 'RESCHEDULE' && (
                            <div className="p-3 bg-amber-50 rounded-xl border border-amber-100 flex items-center gap-3">
                              <SyncOutlined spin className="text-amber-500 text-lg" />
                              <div>
                                <div className="font-medium text-amber-700 text-sm">
                                  Yêu cầu đổi lịch đang xử lý
                                </div>
                                <div className="text-amber-600 text-xs">
                                  Vui lòng chờ nhân viên xác nhận lịch mới của bạn.
                                </div>
                              </div>
                            </div>
                          )}
                        </div>

                        {['PENDING', 'SCHEDULED', 'RESCHEDULE'].includes(apt.appointmentStatus) && (
                          <div className="flex gap-3 w-full md:w-auto justify-end">
                            <Button
                              className="rounded-xl border-slate-200 text-slate-600 hover:text-blue-600 hover:border-blue-200 hover:bg-blue-50 font-medium px-5"
                              icon={<SyncOutlined />}
                              onClick={() => handleReschedule(apt)}
                            >
                              {t('client:appointments.reschedule')}
                            </Button>
                            <Button
                              danger
                              className="rounded-xl border-red-100 text-red-500 hover:bg-red-50 hover:border-red-200 font-medium px-5"
                              icon={<CloseCircleOutlined />}
                              onClick={() => handleCancelAppointment(apt)}
                            >
                              {t('client:profile.cancel')}
                            </Button>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                ),
              };
            })}
          />
        </div>
      </Card>
    );
  };

  return (
    <div className="min-h-[calc(100vh-90px)] bg-slate-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 animate-fade-in">
        <div className="mb-6">
          <Title level={3} className="!mb-1 text-slate-800">
            {t('client:layout.sidebar.appointments')}
          </Title>
          <Text className="text-slate-500 text-lg">{t('client:appointments.manageSchedules')}</Text>
        </div>

        {selfRoutes.length > 0 && (
          <div className="mb-8">
            <div className="mb-4 flex items-center gap-3">
              <h4 className="text-lg font-bold text-slate-700 m-0">
                {t('client:appointments.mySchedule')}
              </h4>
              <Tag color="blue" className="rounded-full px-2">
                {selfRoutes.length}
              </Tag>
            </div>
            {selfRoutes.map((route) => renderVaccineTimeline(route))}
          </div>
        )}

        {familyRoutes.length > 0 && (
          <div className="mb-8">
            <div className="mb-4 flex items-center gap-3">
              <h4 className="text-lg font-bold text-slate-700 m-0">
                {t('client:appointments.familySchedule')}
              </h4>
              <Tag color="purple" className="rounded-full px-2">
                {familyRoutes.length}
              </Tag>
            </div>
            {familyRoutes.map((route) => renderVaccineTimeline(route))}
          </div>
        )}

        {/* Instructions Card ... (unchanged) */}
        <Card className="mt-6 bg-gradient-to-r from-blue-50 to-indigo-50 border-blue-100 rounded-3xl">
          <div className="flex items-start gap-4">
            <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 flex-shrink-0">
              <CalendarOutlined />
            </div>
            <div>
              <Title level={5} className="!mb-2 text-blue-900">
                {t('client:appointments.preVaccinationInstructions')}
              </Title>
              <ul className="text-sm text-blue-800 space-y-2 m-0 pl-4 list-disc">
                <li>{t('client:appointments.instruction1')}</li>
                <li>{t('client:appointments.instruction2')}</li>
                <li>{t('client:appointments.instruction3')}</li>
                <li>{t('client:appointments.instruction4')}</li>
                <li>{t('client:appointments.instruction5')}</li>
              </ul>
            </div>
          </div>
        </Card>

        {selectedAppointment && (
          <RescheduleAppointmentModal
            open={rescheduleModalOpen}
            onClose={() => setRescheduleModalOpen(false)}
            appointment={selectedAppointment}
            onSuccess={handleRescheduleSuccess}
          />
        )}
      </div>
    </div>
  );
};

export default AppointmentSchedulePage;
