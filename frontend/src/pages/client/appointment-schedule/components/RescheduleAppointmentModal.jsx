import { DatePicker, Form, Input, Modal, message, Select } from 'antd';
import dayjs from 'dayjs';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { rescheduleAppointment } from '@/services/booking.service';
import { formatAppointmentTime } from '@/utils/appointment';

const { TextArea } = Input;

const RescheduleAppointmentModal = ({ open, onClose, appointment, onSuccess }) => {
  const { t } = useTranslation(['client']);
  const [form] = Form.useForm();
  const [loading, setLoading] = useState(false);

  const timeSlots = [
    { value: 'SLOT_07_00', label: '07:00 - 09:00' },
    { value: 'SLOT_09_00', label: '09:00 - 11:00' },
    { value: 'SLOT_11_00', label: '11:00 - 13:00' },
    { value: 'SLOT_13_00', label: '13:00 - 15:00' },
    { value: 'SLOT_15_00', label: '15:00 - 17:00' },
  ];

  const handleSubmit = async () => {
    try {
      const values = await form.validateFields();
      setLoading(true);

      const payload = {
        appointmentId: appointment.appointmentId,
        desiredDate: dayjs(values.date).format('YYYY-MM-DD'),
        desiredTimeSlot: values.time,
        reason: values.reason || '',
      };

      await rescheduleAppointment(payload);

      message.success(t('client:appointments.rescheduleSuccess'));
      form.resetFields();
      onSuccess();
      onClose();
    } catch (error) {
      const ERROR_MAPPING = {
        PAID_PENDING_APPOINTMENT: 'client:appointments.errorPaidPending',
        CASH_PENDING_APPOINTMENT: 'client:appointments.errorCashPending',
        ACTIVE_APPOINTMENT_EXISTS: 'client:appointments.errorActiveExists',
      };

      const errorKey = ERROR_MAPPING[error?.message];
      const errorMessage = errorKey
        ? t(errorKey)
        : error?.message || t('client:appointments.rescheduleFailed');

      message.error(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const handleCancel = () => {
    form.resetFields();
    onClose();
  };

  const disabledDate = (current) => {
    return current && current < dayjs().startOf('day');
  };

  return (
    <Modal
      title={t('client:appointments.rescheduleTitle')}
      open={open}
      onOk={handleSubmit}
      onCancel={handleCancel}
      confirmLoading={loading}
      okText={t('client:appointments.confirm')}
      cancelText={t('client:appointments.cancel')}
      width={500}
      centered
    >
      <div className="mb-6 p-4 bg-slate-50 border border-slate-100 rounded-2xl">
        <div className="flex flex-col gap-3">
          <div className="flex justify-between items-center border-b border-slate-200 pb-3">
            <span className="text-slate-500 text-sm">{t('client:appointments.oldSchedule')}</span>
            <span className="font-semibold text-slate-700">
              {dayjs(appointment.scheduledDate).format('DD/MM/YYYY')}{' '}
              {formatAppointmentTime(appointment)}
            </span>
          </div>
          <div className="flex justify-between items-center">
            <span className="text-slate-500 text-sm">Trung tâm</span>
            <span className="font-medium text-slate-700">{appointment.centerName}</span>
          </div>
        </div>
      </div>

      <Form
        form={form}
        layout="vertical"
        initialValues={{
          date: dayjs(appointment.scheduledDate),
          time: appointment.scheduledTimeSlot,
        }}
        className="space-y-4"
      >
        <div className="grid grid-cols-2 gap-4">
          <Form.Item
            label={t('client:appointments.newDate')}
            name="date"
            rules={[{ required: true, message: t('client:appointments.requireDate') }]}
            className="mb-0"
          >
            <DatePicker
              className="w-full rounded-xl"
              format="DD/MM/YYYY"
              disabledDate={disabledDate}
              placeholder={t('client:appointments.selectDate')}
            />
          </Form.Item>

          <Form.Item
            label={t('client:appointments.newTimeSlot')}
            name="time"
            rules={[{ required: true, message: t('client:appointments.requireTimeSlot') }]}
            className="mb-0"
          >
            <Select
              placeholder={t('client:appointments.selectTimeSlot')}
              options={timeSlots}
              className="rounded-xl"
            />
          </Form.Item>
        </div>

        <Form.Item label={t('client:appointments.reason')} name="reason" className="mb-0">
          <TextArea
            rows={3}
            placeholder={t('client:appointments.reasonPlaceholder')}
            maxLength={500}
            showCount
            className="rounded-xl"
          />
        </Form.Item>
      </Form>

      <div className="mt-6 pt-4 border-t border-slate-100">
        <div className="flex items-start gap-2 text-xs text-slate-500">
          <div className="mt-0.5">📌</div>
          <div>
            <div>{t('client:appointments.rescheduleRule1')}</div>
            <div>
              {t('client:appointments.rescheduleRule2')} <strong>{appointment.centerName}</strong>
            </div>
          </div>
        </div>
      </div>
    </Modal>
  );
};

export default RescheduleAppointmentModal;
