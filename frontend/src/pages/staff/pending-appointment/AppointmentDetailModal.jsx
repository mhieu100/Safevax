import {
  CalendarOutlined,
  EnvironmentOutlined,
  MailOutlined,
  MedicineBoxOutlined,
  PhoneOutlined,
  UserOutlined,
} from '@ant-design/icons';
import { Button, Modal, Spin, Tag } from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { TIME_SLOT_LABELS } from '@/constants';
import { callGetAppointmentById } from '@/services/appointment.service';

const AppointmentDetailModal = ({ open, onClose, appointmentId }) => {
  const { t } = useTranslation(['staff']);
  const [loading, setLoading] = useState(false);
  const [data, setData] = useState(null);

  const fetchDetail = async () => {
    if (!appointmentId) return;
    setLoading(true);
    try {
      const res = await callGetAppointmentById(appointmentId);
      if (res?.data) {
        setData(res.data);
      }
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (open && appointmentId) {
      fetchDetail();
    } else {
      setData(null);
    }
  }, [open, appointmentId]);

  const statusColors = {
    PENDING: 'orange',
    SCHEDULED: 'blue',
    COMPLETED: 'green',
    CANCELLED: 'red',
    RESCHEDULE: 'purple',
  };

  return (
    <Modal
      open={open}
      onCancel={onClose}
      footer={null}
      width={800}
      title={null}
      centered
      styles={{
        body: { padding: 0, borderRadius: '16px', overflow: 'hidden' },
        content: { padding: 0, borderRadius: '16px' },
      }}
      closeIcon={null}
    >
      {loading ? (
        <div className="flex justify-center items-center h-64">
          <Spin size="large" />
        </div>
      ) : !data ? (
        <div className="p-8 text-center text-gray-500">
          {t('staff:appointments.detail.notFound', 'Không tìm thấy thông tin')}
          <Button onClick={onClose} className="mt-4">
            Đóng
          </Button>
        </div>
      ) : (
        <div className="bg-slate-50 min-h-[500px]">
          {/* Header with Patient Info & Status */}
          <div className="bg-white p-6 border-b border-slate-100 flex justify-between items-start">
            <div className="flex gap-4">
              <div className="w-16 h-16 rounded-full bg-blue-50 flex items-center justify-center text-blue-600 font-bold text-2xl border-2 border-blue-100 shrink-0">
                {data.patientName?.charAt(0)}
              </div>
              <div>
                <h2 className="text-xl font-bold text-slate-800 m-0">{data.patientName}</h2>
                <div className="flex items-center gap-2 text-slate-500 mt-1 text-sm">
                  <PhoneOutlined /> <span>{data.patientPhone}</span>
                  {data.patientEmail && (
                    <>
                      <span className="w-1 h-1 bg-slate-300 rounded-full"></span>
                      <MailOutlined /> <span>{data.patientEmail}</span>
                    </>
                  )}
                </div>
                <div className="mt-3 flex gap-2 items-center">
                  <Tag color="cyan">#{data.id}</Tag>
                  <Tag color={statusColors[data.appointmentStatus]} className="font-semibold px-2">
                    {data.appointmentStatus}
                  </Tag>
                  {data.createdAt && (
                    <span className="text-xs text-slate-400 ml-2">
                      {t('staff:common.created', 'Tạo')}:{' '}
                      {dayjs(data.createdAt).format('DD/MM/YYYY HH:mm')}
                    </span>
                  )}
                </div>
              </div>
            </div>
            <Button
              type="text"
              icon={<span className="text-xl">×</span>}
              onClick={onClose}
              className="text-slate-400 hover:text-slate-600 w-8 h-8 flex items-center justify-center rounded-full hover:bg-slate-100"
            />
          </div>

          <div className="p-6 grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Left Column: Medical & Schedule */}
            <div className="flex flex-col gap-4">
              <div className="bg-white p-5 rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.04)] border border-slate-100 h-full">
                <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                  <MedicineBoxOutlined /> {t('staff:appointments.columns.vaccine')}
                </h3>

                <div className="flex items-start gap-4 mb-5">
                  <div className="p-3 bg-emerald-50 rounded-xl text-emerald-600 shrink-0">
                    <MedicineBoxOutlined className="text-xl" />
                  </div>
                  <div>
                    <div className="font-bold text-lg text-slate-800 leading-tight">
                      {data.vaccineName}
                    </div>
                    <div className="flex items-center gap-2 mt-1">
                      <Tag
                        color="blue"
                        className="m-0 border-0 bg-blue-50 text-blue-600 font-medium"
                      >
                        {t('staff:dashboard.urgentList.dose', { number: data.doseNumber })}
                        {data.vaccineTotalDoses ? ` / ${data.vaccineTotalDoses}` : ''}
                      </Tag>
                    </div>
                  </div>
                </div>

                <div className="border-t border-slate-50 pt-4 flex-1">
                  <div className="flex items-start gap-3 mb-4">
                    <div className="mt-0.5 text-slate-400">
                      <CalendarOutlined />
                    </div>
                    <div>
                      <div className="text-[10px] text-slate-400 font-bold uppercase tracking-wide">
                        {t('staff:appointments.columns.registerDate')}
                      </div>
                      <div className="font-medium text-slate-700">
                        {data.desiredDate ? dayjs(data.desiredDate).format('DD/MM/YYYY') : 'N/A'}
                      </div>
                      {data.desiredTimeSlot && (
                        <div className="text-xs text-slate-500 mt-0.5">
                          {TIME_SLOT_LABELS[data.desiredTimeSlot] || data.desiredTimeSlot}
                        </div>
                      )}
                    </div>
                  </div>

                  {data.rescheduledAt && (
                    <div className="flex items-start gap-3 mb-4 pl-3 border-l-2 border-orange-200">
                      <div>
                        <div className="text-[10px] text-orange-400 font-bold uppercase tracking-wide">
                          {t('staff:appointments.tags.rescheduledAt', 'Yêu cầu dời lịch')}
                        </div>
                        <div className="text-sm text-slate-600">
                          {dayjs(data.rescheduledAt).format('DD/MM/YYYY HH:mm')}
                        </div>
                      </div>
                    </div>
                  )}

                  {data.scheduledDate && (
                    <div className="flex items-start gap-3 text-emerald-700 bg-emerald-50/50 p-3 rounded-lg mt-3 border border-emerald-100/50">
                      <div className="mt-0.5">
                        <CalendarOutlined />
                      </div>
                      <div>
                        <div className="text-[10px] font-bold uppercase tracking-wide opacity-80 mb-0.5">
                          {t('staff:appointments.columns.officialDate')}
                        </div>
                        <div className="font-bold text-base">
                          {dayjs(data.scheduledDate).format('DD/MM/YYYY')}
                        </div>
                        <div className="text-sm opacity-90">
                          {data.actualScheduledTime ||
                            TIME_SLOT_LABELS[data.scheduledTimeSlot] ||
                            data.scheduledTimeSlot}
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              </div>

              <div className="bg-white p-5 rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.04)] border border-slate-100">
                <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                  <EnvironmentOutlined /> {t('staff:appointments.columns.centerDoctor')}
                </h3>
                <div className="space-y-4">
                  <div className="flex gap-3">
                    <div className="w-2 h-2 rounded-full bg-red-400 mt-2 shrink-0"></div>
                    <div>
                      <div className="font-semibold text-slate-700">{data.centerName}</div>
                      <div className="text-xs text-slate-500 mt-1 leading-relaxed">
                        {data.centerAddress}
                      </div>
                    </div>
                  </div>
                  {data.doctorName && (
                    <div className="flex gap-3 items-center pt-3 border-t border-slate-50">
                      <div className="w-8 h-8 rounded-full bg-blue-50 flex items-center justify-center text-blue-500 shrink-0">
                        <UserOutlined className="text-sm" />
                      </div>
                      <div className="font-medium text-slate-700">
                        <div className="text-[10px] text-slate-400 uppercase font-bold tracking-wide mb-0.5">
                          {t('staff:appointments.detail.doctor', 'Bác sĩ')}
                        </div>
                        {data.doctorName}
                      </div>
                    </div>
                  )}
                  {data.cashierName && (
                    <div className="flex gap-3 items-center pt-2">
                      <div className="w-8 h-8 rounded-full bg-orange-50 flex items-center justify-center text-orange-500 shrink-0">
                        <UserOutlined className="text-sm" />
                      </div>
                      <div className="font-medium text-slate-700">
                        <div className="text-[10px] text-slate-400 uppercase font-bold tracking-wide mb-0.5">
                          Thu ngân
                        </div>
                        {data.cashierName}
                      </div>
                    </div>
                  )}
                </div>
              </div>
            </div>

            {/* Right Column: Payment & Summary */}
            <div className="flex flex-col gap-4">
              <div className="bg-white p-5 rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.04)] border border-slate-100 flex-1 relative overflow-hidden">
                <div className="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br from-emerald-50 to-transparent rounded-bl-full -mr-10 -mt-10 opacity-60"></div>
                <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-8 flex items-center gap-2 relative z-10">
                  {t('staff:appointments.columns.payment')}
                </h3>

                <div className="flex flex-col items-center justify-center py-4 relative z-10">
                  <div className="text-4xl font-bold text-slate-800 tracking-tight">
                    {new Intl.NumberFormat('vi-VN', {
                      style: 'currency',
                      currency: data.paymentCurrency || 'VND',
                    }).format(data.paymentAmount || 0)}
                  </div>
                  <Tag
                    color={data.paymentStatus === 'SUCCESS' ? 'success' : 'warning'}
                    className="mt-3 px-4 py-1 text-sm rounded-full border-0 font-semibold"
                  >
                    {data.paymentStatus || 'UNPAID'}
                  </Tag>
                </div>

                <div className="space-y-4 mt-8 bg-slate-50/50 p-4 rounded-lg border border-slate-100 relative z-10">
                  <div className="flex justify-between text-sm items-center">
                    <span className="text-slate-500">
                      {t('staff:appointments.detail.method', 'Phương thức')}
                    </span>
                    <span className="font-medium text-slate-700 bg-white px-2 py-1 rounded border border-slate-200 text-xs shadow-sm">
                      {data.paymentMethod || 'N/A'}
                    </span>
                  </div>
                  {data.paymentId && (
                    <div className="flex justify-between text-sm items-start">
                      <span className="text-slate-500 mt-0.5">Trans. ID</span>
                      <span className="font-mono text-[10px] text-slate-500 bg-white px-2 py-1 rounded border border-slate-200 max-w-[140px] break-all text-right shadow-sm select-all">
                        {data.paymentId}
                      </span>
                    </div>
                  )}
                  <div className="flex justify-between text-sm border-t border-slate-200 pt-3 mt-2">
                    <span className="text-slate-500">Mã Lịch Hẹn</span>
                    <span className="font-medium text-slate-700">#{data.id}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </Modal>
  );
};

export default AppointmentDetailModal;
