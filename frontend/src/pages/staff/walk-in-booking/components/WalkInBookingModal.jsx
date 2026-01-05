import { CalendarOutlined, ClockCircleOutlined, UserOutlined } from '@ant-design/icons';
import {
  Card,
  Col,
  DatePicker,
  Empty,
  Form,
  Input,
  Modal,
  message,
  notification,
  Radio,
  Row,
  Select,
  Space,
  Spin,
  Tag,
  Typography,
} from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { TIME_SLOT_LABELS } from '@/constants';
import { TimeSlotTime } from '@/constants/enums';
import { callCreateWalkInBooking } from '@/services/booking.service';
import { callFetchCenter } from '@/services/center.service';
import { getAvailableSlotsByCenterAndTimeSlotAPI } from '@/services/doctor.service';
import { callGetPatientFamilyMembers } from '@/services/family.service';
import { callFetchVaccine } from '@/services/vaccine.service';

const { Text } = Typography;
const { Option } = Select;
const { TextArea } = Input;

const WalkInBookingModal = ({ open, setOpen, patient, onSuccess }) => {
  const { t } = useTranslation(['staff']);
  const [form] = Form.useForm();
  const [loading, setLoading] = useState(false);
  const [vaccines, setVaccines] = useState([]);
  const [centers, setCenters] = useState([]);
  const [_selectedVaccine, setSelectedVaccine] = useState(null);

  const [loadingSlots, setLoadingSlots] = useState(false);
  const [selectedSlotId, setSelectedSlotId] = useState(null);
  const [selectedSlot, setSelectedSlot] = useState(null);
  const [availableSlots, setAvailableSlots] = useState([]);

  const [appointmentFor, setAppointmentFor] = useState('self');
  const [familyMembers, setFamilyMembers] = useState([]);

  useEffect(() => {
    if (open) {
      fetchVaccines();
      fetchCenters();
      if (patient?.id) {
        fetchFamilyMembers(patient.id);
      }
    } else {
      form.resetFields();
      setSelectedVaccine(null);
      setSelectedSlotId(null);
      setSelectedSlot(null);
      setAvailableSlots([]);
      setAppointmentFor('self');
      setFamilyMembers([]);
    }
  }, [open, patient]);

  const fetchFamilyMembers = async (patientId) => {
    try {
      const res = await callGetPatientFamilyMembers(patientId);
      if (res?.data) {
        setFamilyMembers(res.data);
      }
    } catch (error) {
      console.error('Failed to fetch family members', error);
    }
  };

  const fetchVaccines = async () => {
    try {
      const res = await callFetchVaccine('');
      if (res?.data?.result) {
        setVaccines(res.data.result);
      }
    } catch (_error) {
      notification.error({
        message: t('staff:walkIn.messages.errorTitle'),
        description: t('staff:walkIn.messages.loadVaccines'),
      });
    }
  };

  const fetchCenters = async () => {
    try {
      const res = await callFetchCenter('');
      if (res?.data?.result) {
        setCenters(res.data.result);
      }
    } catch (_error) {
      notification.error({
        message: t('staff:walkIn.messages.errorTitle'),
        description: t('staff:walkIn.messages.loadCenters'),
      });
    }
  };

  const handleVaccineChange = (vaccineId) => {
    const vaccine = vaccines.find((v) => v.id === vaccineId);
    setSelectedVaccine(vaccine);
  };

  const handleSlotSelect = (uniqueId, slot) => {
    setSelectedSlotId(uniqueId);
    setSelectedSlot(slot);
  };

  const fetchAvailableSlots = async (centerId, date, timeSlot) => {
    if (!centerId || !date || !timeSlot) {
      setAvailableSlots([]);
      return;
    }

    try {
      setLoadingSlots(true);
      const res = await getAvailableSlotsByCenterAndTimeSlotAPI(centerId, date, timeSlot);

      if (res?.data) {
        setAvailableSlots(res.data);
        setSelectedSlotId(null);
        setSelectedSlot(null);
      }
    } catch (error) {
      notification.error({
        message: t('staff:walkIn.messages.errorTitle'),
        description: error?.response?.data?.message || t('staff:walkIn.messages.loadSlots'),
      });
      setAvailableSlots([]);
    } finally {
      setLoadingSlots(false);
    }
  };

  const handleFormValuesChange = (changedValues, allValues) => {
    const { appointmentCenter, appointmentDate, appointmentTime } = allValues;

    if (changedValues.appointmentTime && appointmentCenter && appointmentDate && appointmentTime) {
      fetchAvailableSlots(appointmentCenter, appointmentDate.format('YYYY-MM-DD'), appointmentTime);
    }

    if (
      changedValues.appointmentCenter !== undefined ||
      changedValues.appointmentDate !== undefined ||
      (changedValues.appointmentTime !== undefined && !changedValues.appointmentTime)
    ) {
      setAvailableSlots([]);
      setSelectedSlotId(null);
      setSelectedSlot(null);
    }
  };

  const handleOk = async () => {
    try {
      setLoading(true);
      const values = await form.validateFields();

      if (!patient) {
        message.error(t('staff:walkIn.messages.noPatient'));
        return;
      }

      if (!selectedSlot) {
        message.error(t('staff:walkIn.messages.selectDoctor'));
        return;
      }

      const bookingPayload = {
        patientId: patient.id,
        familyMemberId: appointmentFor === 'family' ? values.familyMemberId : null,
        centerId: values.appointmentCenter,
        vaccineId: values.vaccineId,
        doctorId: selectedSlot.doctorId,
        appointmentDate: values.appointmentDate.format('YYYY-MM-DD'),
        appointmentTime: TimeSlotTime[values.appointmentTime],
        actualScheduledTime: selectedSlot.startTime,
        slotId: selectedSlot.slotId || null,
        notes: values.notes || '',
        paymentMethod: 'CASH',
      };

      const response = await callCreateWalkInBooking(bookingPayload);

      if (response?.data) {
        notification.success({
          message: t('staff:walkIn.messages.successTitle'),
          description: t('staff:walkIn.messages.successDesc', {
            patientName: patient.fullName,
            doctorName: selectedSlot.doctorName,
          }),
        });
        form.resetFields();
        setSelectedVaccine(null);
        setSelectedSlotId(null);
        setSelectedSlot(null);
        setAvailableSlots([]);
        onSuccess();
      }
    } catch (error) {
      notification.error({
        message: t('staff:walkIn.messages.errorTitle'),
        description: error?.response?.data?.message || t('staff:walkIn.messages.bookingFailed'),
      });
    } finally {
      setLoading(false);
    }
  };

  const handleCancel = () => {
    form.resetFields();
    setSelectedVaccine(null);
    setSelectedSlotId(null);
    setSelectedSlot(null);
    setAvailableSlots([]);
    setOpen(false);
  };

  const renderAvailableSlots = () => {
    if (loadingSlots) {
      return (
        <div style={{ textAlign: 'center', padding: '20px' }}>
          <Spin spinning tip={t('staff:walkIn.slots.loading')}>
            <div style={{ minHeight: 50 }} />
          </Spin>
        </div>
      );
    }

    if (availableSlots.length === 0) {
      const values = form.getFieldsValue();
      const timeSlotLabel = values.appointmentTime ? TIME_SLOT_LABELS[values.appointmentTime] : '';

      return (
        <Empty
          image={Empty.PRESENTED_IMAGE_SIMPLE}
          description={
            <Space direction="vertical">
              <span>
                {values.appointmentTime
                  ? t('staff:walkIn.slots.empty', { slot: timeSlotLabel })
                  : t('staff:walkIn.slots.emptyHint')}
              </span>
              {values.appointmentTime && values.appointmentCenter && values.appointmentDate && (
                <Text type="secondary" style={{ fontSize: 12 }}>
                  {t('staff:walkIn.slots.emptyDetail')}
                </Text>
              )}
            </Space>
          }
        />
      );
    }

    return (
      <div
        style={{
          maxHeight: '300px',
          overflowY: 'auto',
          border: '1px solid #d9d9d9',
          borderRadius: 8,
          padding: 12,
        }}
      >
        <Radio.Group value={selectedSlotId} style={{ width: '100%' }}>
          <Row gutter={[12, 12]}>
            {availableSlots.map((slot, index) => {
              const uniqueId = slot.slotId || `virtual_${slot.doctorId}_${slot.startTime}_${index}`;

              return (
                <Col key={uniqueId} xs={24} sm={12}>
                  <Radio
                    value={uniqueId}
                    disabled={slot.status !== 'AVAILABLE'}
                    onClick={() => handleSlotSelect(uniqueId, slot)}
                    style={{
                      width: '100%',
                      height: '100%',
                      padding: 12,
                      background: slot.status === 'AVAILABLE' ? '#f6ffed' : '#fff2e8',
                      border: `2px solid ${
                        selectedSlotId === uniqueId
                          ? '#1890ff'
                          : slot.status === 'AVAILABLE'
                            ? '#b7eb8f'
                            : '#ffbb96'
                      }`,
                      borderRadius: 8,
                      display: 'flex',
                      alignItems: 'flex-start',
                    }}
                  >
                    <Space direction="vertical" size="small" style={{ width: '100%' }}>
                      <Space>
                        <ClockCircleOutlined style={{ color: '#1890ff' }} />
                        <Text strong style={{ fontSize: 14 }}>
                          {slot.startTime?.substring(0, 5)} - {slot.endTime?.substring(0, 5)}
                        </Text>
                      </Space>
                      <Tag color="blue" icon={<UserOutlined />} style={{ marginLeft: 0 }}>
                        Bs. {slot.doctorName}
                      </Tag>
                      <Tag
                        color={slot.status === 'AVAILABLE' ? 'success' : 'error'}
                        style={{ marginLeft: 0 }}
                      >
                        {slot.status === 'AVAILABLE'
                          ? t('staff:walkIn.slots.available')
                          : t('staff:walkIn.slots.booked')}
                      </Tag>
                    </Space>
                  </Radio>
                </Col>
              );
            })}
          </Row>
        </Radio.Group>
      </div>
    );
  };

  return (
    <Modal
      title={
        <Space>
          <CalendarOutlined />
          <span>{t('staff:walkIn.modal.title')}</span>
        </Space>
      }
      open={open}
      onOk={handleOk}
      onCancel={handleCancel}
      confirmLoading={loading}
      width={800}
      okText={t('staff:walkIn.modal.okText')}
      cancelText={t('staff:walkIn.modal.cancelText')}
    >
      {patient && (
        <Card size="small" style={{ marginBottom: 16, backgroundColor: '#f0f5ff' }}>
          <Space direction="vertical" size="small" style={{ width: '100%' }}>
            <Text strong>
              <UserOutlined /> {t('staff:walkIn.patientInfo.patient')}: {patient.fullName}
            </Text>
            <Text type="secondary">
              {t('staff:walkIn.patientInfo.email')}: {patient.email} •{' '}
              {t('staff:walkIn.patientInfo.phone')}: {patient.patientProfile?.phone}
            </Text>
          </Space>
        </Card>
      )}

      <Form
        form={form}
        layout="vertical"
        onValuesChange={handleFormValuesChange}
        initialValues={{ appointmentFor: 'self' }}
      >
        <Row gutter={16}>
          {}
          <Col xs={24}>
            <Form.Item name="appointmentFor" label={t('staff:walkIn.form.appointmentFor.label')}>
              <Radio.Group
                onChange={(e) => {
                  setAppointmentFor(e.target.value);
                  form.setFieldsValue({ familyMemberId: null });
                }}
              >
                <Radio value="self">
                  {t('staff:walkIn.form.appointmentFor.self')} ({patient?.fullName})
                </Radio>
                <Radio value="family">{t('staff:walkIn.form.appointmentFor.family')}</Radio>
              </Radio.Group>
            </Form.Item>
          </Col>

          {}
          {appointmentFor === 'family' && (
            <Col xs={24}>
              <Form.Item
                name="familyMemberId"
                label={t('staff:walkIn.form.familyMember.label')}
                rules={[
                  {
                    required: true,
                    message: t('staff:walkIn.form.familyMember.required'),
                  },
                ]}
              >
                <Select placeholder={t('staff:walkIn.form.familyMember.placeholder')}>
                  {familyMembers.map((member) => (
                    <Option key={member.id} value={member.id}>
                      {member.fullName} ({member.relationship})
                    </Option>
                  ))}
                </Select>
              </Form.Item>
            </Col>
          )}

          <Col xs={24} md={12}>
            <Form.Item
              name="vaccineId"
              label={t('staff:walkIn.form.vaccine.label')}
              rules={[{ required: true, message: t('staff:walkIn.form.vaccine.required') }]}
            >
              <Select
                placeholder={t('staff:walkIn.form.vaccine.placeholder')}
                showSearch
                filterOption={(input, option) =>
                  (option?.label ?? '').toLowerCase().includes(input.toLowerCase())
                }
                onChange={handleVaccineChange}
              >
                {vaccines.map((vaccine) => (
                  <Option key={vaccine.id} value={vaccine.id} label={vaccine.name}>
                    <Space direction="vertical" size={0}>
                      <Text strong>{vaccine.name} </Text>
                    </Space>
                  </Option>
                ))}
              </Select>
            </Form.Item>
          </Col>

          <Col xs={24} md={12}>
            <Form.Item
              name="appointmentCenter"
              label={t('staff:walkIn.form.center.label')}
              rules={[{ required: true, message: t('staff:walkIn.form.center.required') }]}
            >
              <Select
                placeholder={t('staff:walkIn.form.center.placeholder')}
                showSearch
                filterOption={(input, option) =>
                  (option?.label ?? '').toLowerCase().includes(input.toLowerCase())
                }
              >
                {centers.map((center) => (
                  <Option key={center.centerId} value={center.centerId} label={center.name}>
                    <Space direction="vertical" size={0}>
                      <Text strong>{center.name}</Text>
                    </Space>
                  </Option>
                ))}
              </Select>
            </Form.Item>
          </Col>

          <Col xs={24} md={12}>
            <Form.Item
              name="appointmentDate"
              label={t('staff:walkIn.form.date.label')}
              rules={[{ required: true, message: t('staff:walkIn.form.date.required') }]}
            >
              <DatePicker
                style={{ width: '100%' }}
                format="DD/MM/YYYY"
                placeholder={t('staff:walkIn.form.date.placeholder')}
                disabledDate={(current) => current && current < dayjs().startOf('day')}
              />
            </Form.Item>
          </Col>

          <Col xs={24} md={12}>
            <Form.Item
              name="appointmentTime"
              label={t('staff:walkIn.form.time.label')}
              rules={[{ required: true, message: t('staff:walkIn.form.time.required') }]}
            >
              <Select placeholder={t('staff:walkIn.form.time.placeholder')}>
                {Object.entries(TIME_SLOT_LABELS).map(([key, label]) => (
                  <Option key={key} value={key}>
                    <ClockCircleOutlined /> {label}
                  </Option>
                ))}
              </Select>
            </Form.Item>
          </Col>

          <Col xs={24}>
            <Form.Item
              name="doctorSlot"
              label={
                <Space>
                  <Text strong>{t('staff:walkIn.form.doctor.label')}</Text>
                  <Text type="secondary" style={{ fontSize: 12 }}>
                    {t('staff:walkIn.form.doctor.hint')}
                  </Text>
                </Space>
              }
              rules={[{ required: true, message: t('staff:walkIn.form.doctor.required') }]}
              tooltip={t('staff:walkIn.form.doctor.tooltip')}
            >
              {renderAvailableSlots()}
            </Form.Item>
          </Col>

          <Col xs={24}>
            <Form.Item name="notes" label={t('staff:walkIn.form.notes.label')}>
              <TextArea rows={3} placeholder={t('staff:walkIn.form.notes.placeholder')} />
            </Form.Item>
          </Col>

          <Col xs={24}>
            <Card size="small" style={{ backgroundColor: '#fffbe6' }}>
              <Text strong>💵 {t('staff:walkIn.form.payment')}</Text>
            </Card>
          </Col>
        </Row>
      </Form>
    </Modal>
  );
};

export default WalkInBookingModal;
