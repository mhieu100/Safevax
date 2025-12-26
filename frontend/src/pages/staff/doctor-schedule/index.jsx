import {
  CalendarOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  CloseCircleOutlined,
  EyeOutlined,
  LoadingOutlined,
  MedicineBoxOutlined,
  PhoneOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  Avatar,
  Badge,
  Button,
  Card,
  Col,
  DatePicker,
  Descriptions,
  List,
  Modal,
  message,
  Row,
  Segmented,
  Space,
  Spin,
  Statistic,
  Tag,
  Typography,
} from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { getDoctorsWithScheduleAPI } from '@/services/doctor.service';

const { Title, Text } = Typography;

const DoctorSchedule = () => {
  const { t } = useTranslation(['staff']);
  const [selectedDate, setSelectedDate] = useState(dayjs());
  const [viewMode, setViewMode] = useState('today');
  const [selectedDoctor, setSelectedDoctor] = useState(null);
  const [detailModalOpen, setDetailModalOpen] = useState(false);
  const [selectedSlot, setSelectedSlot] = useState(null);
  const [doctors, setDoctors] = useState([]);
  const [loading, setLoading] = useState(false);
  const fetchDoctorsWithSchedule = async () => {
    try {
      setLoading(true);
      const dateStr = selectedDate.format('YYYY-MM-DD');
      const response = await getDoctorsWithScheduleAPI(dateStr);

      const transformedDoctors = response.data.map((doctor) => ({
        id: `BS${String(doctor.doctorId).padStart(3, '0')}`,
        doctorId: doctor.doctorId,
        name: doctor.doctorName,
        specialty: doctor.specialization || 'Đa khoa',
        phone: doctor.phone || doctor.email,
        workingHours: doctor.workingHoursToday || '08:00 - 17:00',
        color: getColorForDoctor(doctor.doctorId),
        availableSlots: doctor.availableSlotsToday || 0,
        bookedSlots: doctor.bookedSlotsToday || 0,
        schedule: (doctor.todaySchedule || []).map((slot) => ({
          slotId: slot.slotId,
          time: `${slot.startTime?.substring(0, 5)} - ${slot.endTime?.substring(0, 5)}`,
          status: slot.status === 'AVAILABLE' ? 'available' : 'booked',
          patient: slot.appointmentId ? 'Bệnh nhân' : null,
          vaccine: slot.notes || '',
        })),
      }));

      setDoctors(transformedDoctors);
    } catch (_error) {
      message.error(t('staff:doctorSchedule.error'));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchDoctorsWithSchedule();
  }, [selectedDate]);

  const getColorForDoctor = (doctorId) => {
    const colors = ['blue', 'green', 'cyan', 'orange', 'purple', 'magenta'];
    return colors[doctorId % colors.length];
  };

  const summary = {
    totalDoctors: doctors.length,
    totalAvailableSlots: doctors.reduce((sum, doc) => sum + doc.availableSlots, 0),
    totalBookedSlots: doctors.reduce((sum, doc) => sum + doc.bookedSlots, 0),
  };
  summary.availabilityRate = Math.round(
    (summary.totalAvailableSlots / (summary.totalAvailableSlots + summary.totalBookedSlots)) * 100
  );

  const handleViewModeChange = (mode) => {
    setViewMode(mode);
    if (mode === 'today') {
      setSelectedDate(dayjs());
    } else if (mode === 'tomorrow') {
      setSelectedDate(dayjs().add(1, 'day'));
    }
  };

  const handleDateChange = (date) => {
    setSelectedDate(date);
    setViewMode('custom');
  };

  const handleSlotClick = (doctor, slot) => {
    if (slot.status === 'available') {
      setSelectedDoctor(doctor);
      setSelectedSlot(slot);
      setDetailModalOpen(true);
    }
  };

  const handleViewDoctorDetail = (doctor) => {
    setSelectedDoctor(doctor);
    setSelectedSlot(null);
    setDetailModalOpen(true);
  };

  const renderTimeSlot = (doctor, slot, index) => {
    const isAvailable = slot.status === 'available';

    return (
      <button
        type="button"
        key={slot.slotId || index}
        onClick={() => handleSlotClick(doctor, slot)}
        onKeyDown={(e) => e.key === 'Enter' && handleSlotClick(doctor, slot)}
        style={{
          border: '1px solid #d9d9d9',
          padding: '10px',
          marginBottom: '5px',
          borderRadius: '6px',
          cursor: isAvailable ? 'pointer' : 'not-allowed',
          background: isAvailable ? '#f6ffed' : '#fff2f0',
          borderColor: isAvailable ? '#b7eb8f' : '#ffccc7',
          transition: 'all 0.2s',
          width: '100%',
          textAlign: 'left',
        }}
        onMouseEnter={(e) => {
          if (isAvailable) {
            e.currentTarget.style.borderColor = '#52c41a';
            e.currentTarget.style.background = '#d9f7be';
          }
        }}
        onMouseLeave={(e) => {
          if (isAvailable) {
            e.currentTarget.style.borderColor = '#b7eb8f';
            e.currentTarget.style.background = '#f6ffed';
          }
        }}
      >
        <Row justify="space-between" align="middle">
          <Col>
            <Space>
              <ClockCircleOutlined />
              <Text>{slot.time}</Text>
            </Space>
          </Col>
          <Col>
            <Badge
              status={isAvailable ? 'success' : 'error'}
              text={
                isAvailable
                  ? t('staff:doctorSchedule.doctorCard.emptyLabel')
                  : t('staff:doctorSchedule.doctorCard.bookedLabel')
              }
            />
          </Col>
        </Row>
        {!isAvailable && slot.patient && (
          <div style={{ marginTop: '4px', fontSize: '12px', color: '#666' }}>
            <Text type="secondary">
              {slot.patient} - {slot.vaccine}
            </Text>
          </div>
        )}
      </button>
    );
  };

  return (
    <div style={{ padding: '24px' }}>
      {}
      <Card
        style={{
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          marginBottom: '24px',
          borderRadius: '12px',
        }}
        styles={{ body: { padding: '30px' } }}
      >
        <Row justify="space-between" align="middle">
          <Col>
            <Title level={2} style={{ color: 'white', margin: 0 }}>
              <CalendarOutlined /> {t('staff:doctorSchedule.title')}
            </Title>
            <Text style={{ color: 'rgba(255,255,255,0.9)' }}>
              {t('staff:doctorSchedule.subtitle')}
            </Text>
          </Col>
          <Col style={{ textAlign: 'right' }}>
            <Title level={4} style={{ color: 'white', margin: 0 }}>
              {dayjs().format('DD MMMM, YYYY')}
            </Title>
            <Text style={{ color: 'rgba(255,255,255,0.9)' }}>{dayjs().format('dddd')}</Text>
          </Col>
        </Row>
      </Card>

      {}
      {loading && (
        <div style={{ textAlign: 'center', padding: '50px' }}>
          <Spin size="large" indicator={<LoadingOutlined style={{ fontSize: 48 }} spin />} />
          <div style={{ marginTop: '16px' }}>
            <Text type="secondary">{t('staff:doctorSchedule.loading')}</Text>
          </div>
        </div>
      )}

      {}
      {!loading && (
        <>
          {}
          <Card style={{ marginBottom: '24px' }}>
            <Row gutter={[16, 16]} align="middle">
              <Col xs={24} sm={12} md={16}>
                <Space wrap>
                  <Segmented
                    value={viewMode}
                    onChange={handleViewModeChange}
                    options={[
                      { label: t('staff:doctorSchedule.viewMode.today'), value: 'today' },
                      { label: t('staff:doctorSchedule.viewMode.tomorrow'), value: 'tomorrow' },
                      { label: t('staff:doctorSchedule.viewMode.week'), value: 'week' },
                    ]}
                  />
                </Space>
              </Col>
              <Col xs={24} sm={12} md={8} style={{ textAlign: 'right' }}>
                <DatePicker
                  value={selectedDate}
                  onChange={handleDateChange}
                  format="DD/MM/YYYY"
                  style={{ width: '100%' }}
                />
              </Col>
            </Row>
          </Card>

          {}
          <Card
            style={{
              marginBottom: '24px',
              background: '#e6f7ff',
              borderColor: '#91d5ff',
            }}
            styles={{ body: { padding: '12px 24px' } }}
          >
            <Space>
              <CalendarOutlined style={{ color: '#1890ff', fontSize: '18px' }} />
              <Text strong style={{ color: '#1890ff' }}>
                {t('staff:doctorSchedule.viewingDate', {
                  date: selectedDate.format('DD/MM/YYYY'),
                  day: selectedDate.format('dddd'),
                })}
              </Text>
            </Space>
          </Card>

          {}
          <Row gutter={[16, 16]} style={{ marginBottom: '24px' }}>
            {doctors.length === 0 ? (
              <Col span={24}>
                <Card style={{ textAlign: 'center', padding: '50px' }}>
                  <UserOutlined style={{ fontSize: 64, color: '#d9d9d9', marginBottom: 16 }} />
                  <Title level={4} type="secondary">
                    {t('staff:doctorSchedule.noDoctors.title')}
                  </Title>
                  <Text type="secondary">{t('staff:doctorSchedule.noDoctors.desc')}</Text>
                </Card>
              </Col>
            ) : (
              doctors.map((doctor) => (
                <Col key={doctor.id} xs={24} sm={12} lg={6}>
                  <Card
                    hoverable
                    style={{ height: '100%' }}
                    styles={{
                      header: {
                        background:
                          doctor.color === 'blue'
                            ? '#1890ff'
                            : doctor.color === 'green'
                              ? '#52c41a'
                              : doctor.color === 'cyan'
                                ? '#13c2c2'
                                : doctor.color === 'orange'
                                  ? '#fa8c16'
                                  : '#1890ff',
                        color: 'white',
                      },
                    }}
                    title={
                      <Space>
                        <Avatar
                          size={40}
                          icon={<UserOutlined />}
                          style={{ background: 'rgba(255,255,255,0.3)' }}
                        />
                        <div>
                          <div style={{ fontWeight: 'bold' }}>BS. {doctor.name}</div>
                          <small>
                            {t('staff:doctorSchedule.doctorCard.specialty', {
                              specialty: doctor.specialty,
                            })}
                          </small>
                        </div>
                      </Space>
                    }
                  >
                    <div style={{ marginBottom: '16px' }}>
                      <Space orientation="vertical" size="small" style={{ width: '100%' }}>
                        <Space>
                          <ClockCircleOutlined />
                          <Text type="secondary" style={{ fontSize: '13px' }}>
                            {t('staff:doctorSchedule.doctorCard.shift', {
                              shift: doctor.workingHours,
                            })}
                          </Text>
                        </Space>
                        <Space>
                          <PhoneOutlined />
                          <Text type="secondary" style={{ fontSize: '13px' }}>
                            {t('staff:doctorSchedule.doctorCard.phone', { phone: doctor.phone })}
                          </Text>
                        </Space>
                      </Space>
                    </div>

                    <div style={{ marginBottom: '16px' }}>
                      <Text strong>{t('staff:doctorSchedule.doctorCard.statusToday')}</Text>
                      <div style={{ marginTop: '8px' }}>
                        <Space>
                          <Badge
                            count={`${doctor.availableSlots} ${t('staff:doctorSchedule.doctorCard.available')}`}
                            style={{ backgroundColor: '#52c41a' }}
                          />
                          <Badge
                            count={`${doctor.bookedSlots} ${t('staff:doctorSchedule.doctorCard.booked')}`}
                            style={{ backgroundColor: '#f5222d' }}
                          />
                        </Space>
                      </div>
                    </div>

                    <div
                      style={{
                        borderTop: '1px solid #f0f0f0',
                        paddingTop: '16px',
                        marginBottom: '16px',
                      }}
                    >
                      <Text strong style={{ display: 'block', marginBottom: '8px' }}>
                        {t('staff:doctorSchedule.doctorCard.availableSchedule')}
                      </Text>
                      <div style={{ maxHeight: '300px', overflowY: 'auto' }}>
                        {doctor.schedule.map((slot, index) => renderTimeSlot(doctor, slot, index))}
                      </div>
                    </div>

                    <Button
                      type="primary"
                      ghost
                      icon={<EyeOutlined />}
                      block
                      onClick={() => handleViewDoctorDetail(doctor)}
                    >
                      {t('staff:doctorSchedule.doctorCard.viewDetail')}
                    </Button>
                  </Card>
                </Col>
              ))
            )}
          </Row>

          {}
          <Card
            title={
              <Space>
                <MedicineBoxOutlined />
                <Text strong>{t('staff:doctorSchedule.summary.title')}</Text>
              </Space>
            }
          >
            <Row gutter={16}>
              <Col xs={12} sm={6}>
                <Statistic
                  title={t('staff:doctorSchedule.summary.totalDoctors')}
                  value={summary.totalDoctors}
                  styles={{ content: { color: '#1890ff' } }}
                  prefix={<UserOutlined />}
                />
              </Col>
              <Col xs={12} sm={6}>
                <Statistic
                  title={t('staff:doctorSchedule.summary.availableSlots')}
                  value={summary.totalAvailableSlots}
                  styles={{ content: { color: '#52c41a' } }}
                  prefix={<CheckCircleOutlined />}
                />
              </Col>
              <Col xs={12} sm={6}>
                <Statistic
                  title={t('staff:doctorSchedule.summary.bookedSlots')}
                  value={summary.totalBookedSlots}
                  styles={{ content: { color: '#f5222d' } }}
                  prefix={<CloseCircleOutlined />}
                />
              </Col>
              <Col xs={12} sm={6}>
                <Statistic
                  title={t('staff:doctorSchedule.summary.availabilityRate')}
                  value={summary.availabilityRate}
                  styles={{ content: { color: '#13c2c2' } }}
                  suffix="%"
                />
              </Col>
            </Row>
          </Card>
        </>
      )}

      {}
      <Modal
        title={
          selectedSlot ? (
            <Space>
              <ClockCircleOutlined />
              <Text strong>{t('staff:doctorSchedule.modal.slotInfoTitle')}</Text>
            </Space>
          ) : (
            <Space>
              <UserOutlined />
              <Text strong>{t('staff:doctorSchedule.modal.doctorDetailTitle')}</Text>
            </Space>
          )
        }
        open={detailModalOpen}
        onCancel={() => setDetailModalOpen(false)}
        footer={[
          <Button key="close" onClick={() => setDetailModalOpen(false)}>
            {t('staff:doctorSchedule.modal.close')}
          </Button>,
          selectedSlot && (
            <Button
              key="assign"
              type="primary"
              onClick={() => {
                message.success(t('staff:doctorSchedule.modal.developing'));
                setDetailModalOpen(false);
              }}
            >
              {t('staff:doctorSchedule.modal.assign')}
            </Button>
          ),
        ]}
        width={700}
      >
        {selectedDoctor && (
          <>
            <Descriptions column={2} bordered style={{ marginBottom: '16px' }}>
              <Descriptions.Item label={t('staff:doctorSchedule.modal.doctor')} span={2}>
                <Space>
                  <Avatar icon={<UserOutlined />} />
                  <Text strong>BS. {selectedDoctor.name}</Text>
                </Space>
              </Descriptions.Item>
              <Descriptions.Item label={t('staff:doctorSchedule.modal.specialty')}>
                {selectedDoctor.specialty}
              </Descriptions.Item>
              <Descriptions.Item label={t('staff:doctorSchedule.modal.phone')}>
                <Space>
                  <PhoneOutlined />
                  {selectedDoctor.phone}
                </Space>
              </Descriptions.Item>
              <Descriptions.Item label={t('staff:doctorSchedule.modal.shift')} span={2}>
                <Space>
                  <ClockCircleOutlined />
                  {selectedDoctor.workingHours}
                </Space>
              </Descriptions.Item>
            </Descriptions>

            {selectedSlot ? (
              <Card
                title={t('staff:doctorSchedule.modal.selectedSlotInfo')}
                style={{ background: '#f6ffed' }}
              >
                <Descriptions column={1}>
                  <Descriptions.Item label={t('staff:doctorSchedule.modal.time')}>
                    <Tag color="blue" icon={<ClockCircleOutlined />}>
                      {selectedSlot.time}
                    </Tag>
                  </Descriptions.Item>
                  <Descriptions.Item label={t('staff:doctorSchedule.modal.status')}>
                    <Badge
                      status={selectedSlot.status === 'available' ? 'success' : 'error'}
                      text={
                        selectedSlot.status === 'available'
                          ? t('staff:doctorSchedule.modal.statusAvailable')
                          : t('staff:doctorSchedule.modal.statusBooked')
                      }
                    />
                  </Descriptions.Item>
                </Descriptions>
                {selectedSlot.status === 'available' && (
                  <div
                    style={{
                      marginTop: '16px',
                      padding: '12px',
                      background: '#fff',
                      borderRadius: '6px',
                    }}
                  >
                    <Text type="secondary">
                      <CheckCircleOutlined style={{ color: '#52c41a', marginRight: '8px' }} />
                      {t('staff:doctorSchedule.modal.canAssign')}
                    </Text>
                  </div>
                )}
              </Card>
            ) : (
              <Card
                title={t('staff:doctorSchedule.modal.detailSchedule')}
                style={{ marginTop: '16px' }}
              >
                <List
                  size="small"
                  dataSource={selectedDoctor.schedule}
                  renderItem={(slot) => (
                    <List.Item>
                      <Row style={{ width: '100%' }} justify="space-between" align="middle">
                        <Col>
                          <Space>
                            <ClockCircleOutlined />
                            <Text>{slot.time}</Text>
                          </Space>
                        </Col>
                        <Col>
                          {slot.status === 'available' ? (
                            <Tag color="success">
                              {t('staff:doctorSchedule.doctorCard.emptyLabel')}
                            </Tag>
                          ) : (
                            <Space>
                              <Tag color="error">
                                {t('staff:doctorSchedule.doctorCard.bookedLabel')}
                              </Tag>
                              <Text type="secondary" style={{ fontSize: '12px' }}>
                                {slot.patient} - {slot.vaccine}
                              </Text>
                            </Space>
                          )}
                        </Col>
                      </Row>
                    </List.Item>
                  )}
                />
              </Card>
            )}
          </>
        )}
      </Modal>
    </div>
  );
};

export default DoctorSchedule;
