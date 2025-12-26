import {
  BellOutlined,
  CalendarOutlined,
  CalendarTwoTone,
  CheckCircleOutlined,
  ClockCircleOutlined,
  CloseCircleOutlined,
  EnvironmentOutlined,
  EyeOutlined,
  MedicineBoxOutlined,
  PhoneOutlined,
  PlayCircleOutlined,
  RightOutlined,
  StarFilled,
  TeamOutlined,
  TrophyOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  Avatar,
  Badge,
  Button,
  Card,
  Col,
  Descriptions,
  Divider,
  Empty,
  Modal,
  message,
  Progress,
  Row,
  Segmented,
  Space,
  Spin,
  Statistic,
  Tag,
  Timeline,
  Tooltip,
  Typography,
} from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { formatTimeSlot } from '@/constants';
import { callGetTodayAppointments } from '@/services/appointment.service';
import dashboardService from '@/services/dashboard.service';
import { useAccountStore } from '@/stores/useAccountStore';
import { formatAppointmentTime } from '@/utils/appointment';
import CompletionModal from '../dashboard/components/CompletionModal';

const { Title, Text } = Typography;
// Force HMR

const DoctorDashboard = () => {
  const { t } = useTranslation(['staff']);
  const user = useAccountStore((state) => state.user);
  const [viewMode, setViewMode] = useState('timeline');
  const [detailModalOpen, setDetailModalOpen] = useState(false);
  const [selectedAppointment, setSelectedAppointment] = useState(null);
  const [completionModalOpen, setCompletionModalOpen] = useState(false);
  const [todayAppointments, setTodayAppointments] = useState([]);
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);

  const fetchData = async () => {
    try {
      setLoading(true);
      const [appointmentsRes, statsRes] = await Promise.all([
        callGetTodayAppointments(),
        dashboardService.getDoctorStats(),
      ]);

      if (appointmentsRes?.data) {
        const sorted = [...appointmentsRes.data].sort((a, b) => {
          const timeA = a.scheduledTimeSlot || '00:00';
          const timeB = b.scheduledTimeSlot || '00:00';
          return timeA.localeCompare(timeB);
        });
        setTodayAppointments(sorted);
      }
      if (statsRes) {
        setStats(statsRes);
      }
    } catch (_err) {
      message.error(t('staff:dashboard.error.load'));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
    const interval = setInterval(fetchData, 120000);
    return () => clearInterval(interval);
  }, []);

  const completedCount = todayAppointments.filter(
    (a) => a.appointmentStatus === 'COMPLETED'
  ).length;

  const weeklyStats = {
    completed: {
      value: stats?.weekCompleted || 0,
      total: stats?.weekAppointments || 0,
      percentage: stats?.weekAppointments
        ? Math.round((stats.weekCompleted / stats.weekAppointments) * 100)
        : 0,
    },
    inProgress: {
      value: stats?.weekInProgress || 0,
      total: stats?.weekAppointments || 0,
      percentage: stats?.weekAppointments
        ? Math.round((stats.weekInProgress / stats.weekAppointments) * 100)
        : 0,
    },
    cancelled: {
      value: stats?.weekCancelled || 0,
      total: stats?.weekAppointments || 0,
      percentage: stats?.weekAppointments
        ? Math.round((stats.weekCancelled / stats.weekAppointments) * 100)
        : 0,
    },
  };

  const getStatusConfig = (status) => {
    const configs = {
      COMPLETED: {
        color: 'success',
        text: t('staff:dashboard.doctor.status.completed'),
        icon: <CheckCircleOutlined />,
        tagColor: 'green',
      },
      IN_PROGRESS: {
        color: 'processing',
        text: t('staff:dashboard.doctor.status.inProgress'),
        icon: <PlayCircleOutlined />,
        tagColor: 'blue',
      },
      SCHEDULED: {
        color: 'default',
        text: t('staff:dashboard.doctor.status.scheduled'),
        icon: <ClockCircleOutlined />,
        tagColor: 'default',
      },
      CANCELLED: {
        color: 'error',
        text: t('staff:dashboard.doctor.status.cancelled'),
        icon: <CloseCircleOutlined />,
        tagColor: 'red',
      },
      RESCHEDULE: {
        color: 'warning',
        text: t('staff:dashboard.doctor.status.pendingApproval'),
        icon: <ClockCircleOutlined />,
        tagColor: 'orange',
      },
    };
    return configs[status] || configs.SCHEDULED;
  };

  const mapAppointment = (apt) => ({
    id: apt.id,
    time: formatAppointmentTime(apt),
    patient: apt.patientName,
    phone: apt.patientPhone || 'N/A',
    vaccine: apt.vaccineName,
    vaccineColor: 'blue',
    notes: apt.notes || t('staff:dashboard.doctor.modal.notesDefault'),
    status: apt.appointmentStatus,
    urgent: apt.appointmentStatus === 'RESCHEDULE' || false,
    doseNumber: apt.doseNumber,
    patientId: apt.patientId,
  });

  const handleViewAppointment = (appointment) => {
    setSelectedAppointment(appointment);
    setDetailModalOpen(true);
  };

  const handleStartAppointment = (appointment) => {
    Modal.confirm({
      title: t('staff:dashboard.doctor.modal.startVaccination'),
      content: t('staff:dashboard.doctor.modal.confirmStart', { name: appointment.patient }),
      okText: t('staff:dashboard.doctor.modal.okStart'),
      cancelText: t('staff:dashboard.doctor.modal.cancel'),
      onOk: () =>
        message.success(t('staff:dashboard.doctor.modal.startedSuccess', { id: appointment.id })),
    });
  };

  const handleCompleteAppointment = (appointment) => {
    setSelectedAppointment(appointment);
    setCompletionModalOpen(true);
  };

  const renderTimelineItem = (apt) => {
    const appointment = mapAppointment(apt);
    const statusConfig = getStatusConfig(appointment.status);
    const isPending = appointment.status === 'SCHEDULED';

    return (
      <Timeline.Item
        color={
          statusConfig.color === 'default'
            ? 'gray'
            : statusConfig.color === 'processing'
              ? 'blue'
              : statusConfig.color
        }
        dot={statusConfig.icon}
      >
        <Card
          size="small"
          hoverable
          style={{
            borderLeft: `4px solid ${statusConfig.tagColor === 'default' ? '#d9d9d9' : statusConfig.tagColor === 'blue' ? '#1890ff' : statusConfig.tagColor === 'green' ? '#52c41a' : '#ff4d4f'}`,
            marginBottom: 8,
            borderRadius: 8,
          }}
          onClick={() => handleViewAppointment(appointment)}
        >
          <Row justify="space-between" align="middle">
            <Col>
              <Space>
                <Text strong style={{ fontSize: 16 }}>
                  {appointment.time}
                </Text>
                <Divider type="vertical" />
                <Text strong>{appointment.patient}</Text>
                <Tag color={appointment.vaccineColor}>{appointment.vaccine}</Tag>
                {appointment.urgent && <Tag color="red">GẤP</Tag>}
              </Space>
              <div style={{ marginTop: 4 }}>
                <Text type="secondary" style={{ fontSize: 12 }}>
                  <PhoneOutlined /> {appointment.phone}
                </Text>
              </div>
            </Col>
            <Col>
              <Space>
                <Tag color={statusConfig.tagColor}>{statusConfig.text}</Tag>
                {(isPending || appointment.status === 'IN_PROGRESS') && (
                  <Button
                    type="primary"
                    size="small"
                    shape="circle"
                    icon={isPending ? <PlayCircleOutlined /> : <CheckCircleOutlined />}
                    style={!isPending ? { background: '#52c41a', borderColor: '#52c41a' } : {}}
                    onClick={(e) => {
                      e.stopPropagation();
                      if (isPending) {
                        handleStartAppointment(appointment);
                      } else {
                        handleCompleteAppointment(appointment);
                      }
                    }}
                  />
                )}
                <Button size="small" shape="circle" icon={<RightOutlined />} />
              </Space>
            </Col>
          </Row>
        </Card>
      </Timeline.Item>
    );
  };

  return (
    <div style={{ padding: '24px', minHeight: '100vh', background: '#f5f7fa' }}>
      {}
      <div style={{ marginBottom: 24 }}>
        <Row justify="space-between" align="middle">
          <Col>
            <Title level={2} style={{ margin: 0 }}>
              {t('staff:dashboard.doctor.greeting', { name: user?.fullName })}
            </Title>
            <Text type="secondary">
              {t('staff:dashboard.doctor.greetingSub', { count: todayAppointments.length })}
            </Text>
          </Col>
          <Col>
            <Space>
              <Card size="small" style={{ borderRadius: 8 }}>
                <Space>
                  <CalendarOutlined style={{ color: '#1890ff' }} />
                  <Text strong>{dayjs().format('DD/MM/YYYY')}</Text>
                </Space>
              </Card>
              <Button icon={<ClockCircleOutlined />} onClick={fetchData} loading={loading}>
                {t('staff:dashboard.refresh')}
              </Button>
            </Space>
          </Col>
        </Row>
      </div>

      {}
      <Row gutter={[16, 16]} style={{ marginBottom: 24 }}>
        <Col xs={24} sm={12} lg={6}>
          <Card hoverable style={{ borderRadius: 12 }}>
            <Statistic
              title={t('staff:dashboard.doctor.todaySchedule')}
              value={stats?.todayAppointments || 0}
              prefix={<TeamOutlined style={{ color: '#1890ff' }} />}
              suffix={t('staff:dashboard.doctor.patients')}
              valueStyle={{ color: '#1890ff' }}
            />
            <Progress
              percent={
                todayAppointments.length > 0
                  ? Math.round((completedCount / todayAppointments.length) * 100)
                  : 0
              }
              size="small"
              status="active"
              strokeColor="#1890ff"
              style={{ marginTop: 8 }}
            />
            <Text type="secondary" style={{ fontSize: 12 }}>
              {t('staff:dashboard.doctor.completedRatio', {
                completed: completedCount,
                total: todayAppointments.length,
              })}
            </Text>
          </Card>
        </Col>

        <Col xs={24} sm={12} lg={6}>
          <Card hoverable style={{ borderRadius: 12 }}>
            <Statistic
              title={t('staff:dashboard.doctor.thisWeek')}
              value={stats?.weekAppointments || 0}
              prefix={<CalendarOutlined style={{ color: '#722ed1' }} />}
              suffix={t('staff:dashboard.stats.today.suffix')}
              valueStyle={{ color: '#722ed1' }}
            />
            <div style={{ marginTop: 16 }}>
              <Text type="secondary" style={{ fontSize: 12 }}>
                <TrophyOutlined /> {t('staff:dashboard.doctor.stablePerformance')}
              </Text>
            </div>
          </Card>
        </Col>

        <Col xs={24} sm={12} lg={6}>
          <Card hoverable style={{ borderRadius: 12 }}>
            <Statistic
              title={t('staff:dashboard.doctor.completedMonth')}
              value={stats?.monthCompleted || 0}
              prefix={<CheckCircleOutlined style={{ color: '#52c41a' }} />}
              suffix={t('staff:dashboard.doctor.inMonth')}
              valueStyle={{ color: '#52c41a' }}
            />
            <div style={{ marginTop: 16 }}>
              <Text type="secondary" style={{ fontSize: 12 }}>
                <StarFilled style={{ color: '#faad14' }} />{' '}
                {t('staff:dashboard.doctor.rating', { rating: stats?.rating || 4.8 })}
              </Text>
            </div>
          </Card>
        </Col>

        <Col xs={24} sm={12} lg={6}>
          <Card hoverable style={{ borderRadius: 12 }}>
            <Statistic
              title={t('staff:dashboard.doctor.nextSchedule')}
              value={
                stats?.nextAppointment?.actualScheduledTime
                  ? stats.nextAppointment.actualScheduledTime.substring(0, 5)
                  : formatTimeSlot(stats?.nextAppointment?.time) || '--:--'
              }
              prefix={<BellOutlined style={{ color: '#faad14' }} />}
              valueStyle={{ color: '#faad14' }}
            />
            <div
              style={{
                marginTop: 16,
                whiteSpace: 'nowrap',
                overflow: 'hidden',
                textOverflow: 'ellipsis',
              }}
            >
              <Text type="secondary" style={{ fontSize: 12 }}>
                {stats?.nextAppointment
                  ? `${stats.nextAppointment.patientName}`
                  : t('staff:dashboard.doctor.noUpcoming')}
              </Text>
            </div>
          </Card>
        </Col>
      </Row>

      <Row gutter={[24, 24]}>
        {}
        <Col xs={24} lg={16}>
          <Card
            title={
              <Space>
                <ClockCircleOutlined style={{ color: '#1890ff' }} />
                <Text strong style={{ fontSize: 16 }}>
                  {t('staff:dashboard.doctor.todaysTimeline')}
                </Text>
                <Tag color="blue">
                  {t('staff:dashboard.doctor.appointmentsCount', {
                    count: todayAppointments.length,
                  })}
                </Tag>
              </Space>
            }
            extra={
              <Segmented
                value={viewMode}
                onChange={setViewMode}
                options={[
                  {
                    label: t('staff:dashboard.doctor.viewMode.timeline'),
                    value: 'timeline',
                    icon: <ClockCircleOutlined />,
                  },
                  {
                    label: t('staff:dashboard.doctor.viewMode.grid'),
                    value: 'grid',
                    icon: <CalendarTwoTone />,
                  },
                ]}
              />
            }
            style={{ borderRadius: 12, minHeight: 500 }}
          >
            {loading ? (
              <div style={{ textAlign: 'center', padding: '60px 0' }}>
                <Spin size="large" />
              </div>
            ) : todayAppointments.length === 0 ? (
              <Empty
                image={Empty.PRESENTED_IMAGE_SIMPLE}
                description={t('staff:dashboard.doctor.noAppointments')}
              />
            ) : viewMode === 'timeline' ? (
              <div style={{ padding: '0 12px' }}>
                <Timeline mode="left">
                  {todayAppointments.map((apt) => renderTimelineItem(apt))}
                </Timeline>
              </div>
            ) : (
              <Row gutter={[16, 16]}>
                {todayAppointments.map((apt) => {
                  const appointment = mapAppointment(apt);
                  const statusConfig = getStatusConfig(appointment.status);
                  return (
                    <Col xs={24} md={12} key={apt.id}>
                      <Card
                        hoverable
                        size="small"
                        style={{
                          borderTop: `3px solid ${statusConfig.tagColor === 'green' ? '#52c41a' : statusConfig.tagColor === 'blue' ? '#1890ff' : '#d9d9d9'}`,
                          borderRadius: 8,
                        }}
                        actions={[
                          <Tooltip
                            key="view"
                            title={t('staff:dashboard.urgentList.actions.detail')}
                          >
                            <EyeOutlined onClick={() => handleViewAppointment(appointment)} />
                          </Tooltip>,
                          appointment.status === 'SCHEDULED' && (
                            <Tooltip key="start" title={t('staff:dashboard.doctor.modal.startInt')}>
                              <PlayCircleOutlined
                                key="start"
                                style={{ color: '#1890ff' }}
                                onClick={() => handleStartAppointment(appointment)}
                              />
                            </Tooltip>
                          ),
                          appointment.status === 'IN_PROGRESS' && (
                            <Tooltip
                              key="complete"
                              title={t('staff:dashboard.doctor.modal.completeInt')}
                            >
                              <CheckCircleOutlined
                                key="complete"
                                style={{ color: '#52c41a' }}
                                onClick={() => handleCompleteAppointment(appointment)}
                              />
                            </Tooltip>
                          ),
                        ].filter(Boolean)}
                      >
                        <Card.Meta
                          avatar={
                            <Avatar
                              style={{
                                backgroundColor:
                                  statusConfig.tagColor === 'default'
                                    ? '#ccc'
                                    : statusConfig.tagColor,
                              }}
                              icon={<UserOutlined />}
                            />
                          }
                          title={
                            <Space>
                              <Text strong>{appointment.patient}</Text>
                              <Tag color={statusConfig.tagColor}>{statusConfig.text}</Tag>
                            </Space>
                          }
                          description={
                            <Space direction="vertical" size={2}>
                              <Text type="secondary">
                                <ClockCircleOutlined /> {appointment.time}
                              </Text>
                              <Text type="secondary">
                                <MedicineBoxOutlined /> {appointment.vaccine}
                              </Text>
                            </Space>
                          }
                        />
                      </Card>
                    </Col>
                  );
                })}
              </Row>
            )}
          </Card>
        </Col>

        {}
        <Col xs={24} lg={8}>
          {}
          <Card
            title={
              <Space>
                <TrophyOutlined style={{ color: '#722ed1' }} />
                <Text strong>{t('staff:dashboard.doctor.weeklyOverview')}</Text>
              </Space>
            }
            style={{ borderRadius: 12, marginBottom: 24 }}
          >
            <Space direction="vertical" size="large" style={{ width: '100%' }}>
              <div>
                <Row justify="space-between" style={{ marginBottom: 4 }}>
                  <Text>{t('staff:dashboard.doctor.completed')}</Text>
                  <Text strong>
                    {weeklyStats.completed.value}/{weeklyStats.completed.total}
                  </Text>
                </Row>
                <Progress percent={weeklyStats.completed.percentage} strokeColor="#52c41a" />
              </div>
              <div>
                <Row justify="space-between" style={{ marginBottom: 4 }}>
                  <Text>{t('staff:dashboard.doctor.processing')}</Text>
                  <Text strong>
                    {weeklyStats.inProgress.value}/{weeklyStats.inProgress.total}
                  </Text>
                </Row>
                <Progress percent={weeklyStats.inProgress.percentage} strokeColor="#faad14" />
              </div>
              <div>
                <Row justify="space-between" style={{ marginBottom: 4 }}>
                  <Text>{t('staff:dashboard.doctor.cancelled')}</Text>
                  <Text strong>
                    {weeklyStats.cancelled.value}/{weeklyStats.cancelled.total}
                  </Text>
                </Row>
                <Progress percent={weeklyStats.cancelled.percentage} strokeColor="#ff4d4f" />
              </div>
            </Space>
          </Card>

          {}
          <Card
            title={
              <Space>
                <StarFilled style={{ color: '#faad14' }} />
                <Text strong>{t('staff:dashboard.doctor.quickNotes')}</Text>
              </Space>
            }
            style={{ borderRadius: 12 }}
          >
            <Empty
              description={t('staff:dashboard.doctor.noNotes')}
              image={Empty.PRESENTED_IMAGE_SIMPLE}
            />
            <Button type="dashed" block style={{ marginTop: 16 }}>
              {t('staff:dashboard.doctor.addNote')}
            </Button>
          </Card>
        </Col>
      </Row>

      {}
      <CompletionModal
        open={completionModalOpen}
        onCancel={() => setCompletionModalOpen(false)}
        appointment={selectedAppointment}
        onSuccess={() => {
          fetchData();
        }}
      />
      <Modal
        title={
          <Space>
            <MedicineBoxOutlined style={{ color: '#1890ff' }} />
            <Text strong style={{ fontSize: 18 }}>
              {t('staff:dashboard.doctor.modal.detailTitle', { id: selectedAppointment?.id })}
            </Text>
          </Space>
        }
        open={detailModalOpen}
        onCancel={() => setDetailModalOpen(false)}
        footer={[
          <Button key="close" onClick={() => setDetailModalOpen(false)}>
            {t('staff:dashboard.doctor.modal.close')}
          </Button>,
          selectedAppointment?.status === 'SCHEDULED' && (
            <Button
              key="start"
              type="primary"
              icon={<PlayCircleOutlined />}
              onClick={() => {
                handleStartAppointment(selectedAppointment);
                setDetailModalOpen(false);
              }}
            >
              {t('staff:dashboard.doctor.modal.startInt')}
            </Button>
          ),
          (selectedAppointment?.status === 'IN_PROGRESS' ||
            selectedAppointment?.status === 'SCHEDULED') && (
            <Button
              key="complete"
              type="primary"
              style={{ background: '#52c41a' }}
              icon={<CheckCircleOutlined />}
              onClick={() => {
                handleCompleteAppointment(selectedAppointment);
                setDetailModalOpen(false);
              }}
            >
              {t('staff:dashboard.doctor.modal.completeInt')}
            </Button>
          ),
        ]}
        width={700}
      >
        {selectedAppointment && (
          <Row gutter={24}>
            <Col span={24}>
              <Descriptions bordered column={1} labelStyle={{ width: '150px', fontWeight: 'bold' }}>
                <Descriptions.Item label={t('staff:dashboard.doctor.modal.time')}>
                  <Tag icon={<ClockCircleOutlined />} color="blue">
                    {selectedAppointment.time}
                  </Tag>
                  <Text type="secondary" style={{ marginLeft: 8 }}>
                    {dayjs().format('DD/MM/YYYY')}
                  </Text>
                </Descriptions.Item>
                <Descriptions.Item label={t('staff:dashboard.doctor.modal.patient')}>
                  <Space>
                    <Avatar icon={<UserOutlined />} />
                    <Text strong>{selectedAppointment.patient}</Text>
                  </Space>
                </Descriptions.Item>
                <Descriptions.Item label={t('staff:dashboard.doctor.modal.contact')}>
                  <Space>
                    <PhoneOutlined /> {selectedAppointment.phone}
                  </Space>
                </Descriptions.Item>
                <Descriptions.Item label={t('staff:dashboard.doctor.modal.vaccine')}>
                  <Space direction="vertical">
                    <Tag color="cyan" style={{ fontSize: 14, padding: '4px 8px' }}>
                      {selectedAppointment.vaccine}
                    </Tag>
                    {selectedAppointment.doseNumber && (
                      <Text type="secondary">
                        {t('staff:dashboard.doctor.modal.dose', {
                          number: selectedAppointment.doseNumber,
                        })}
                      </Text>
                    )}
                  </Space>
                </Descriptions.Item>
                <Descriptions.Item label={t('staff:dashboard.doctor.modal.status')}>
                  <Badge
                    status={getStatusConfig(selectedAppointment.status).color}
                    text={getStatusConfig(selectedAppointment.status).text}
                  />
                </Descriptions.Item>
                <Descriptions.Item label={t('staff:dashboard.doctor.modal.notes')}>
                  <Text>{selectedAppointment.notes}</Text>
                </Descriptions.Item>
                {selectedAppointment.urgent && (
                  <Descriptions.Item label={t('staff:dashboard.doctor.modal.priority')}>
                    <Tag color="red" icon={<EnvironmentOutlined />}>
                      {t('staff:dashboard.doctor.modal.urgentAction')}
                    </Tag>
                  </Descriptions.Item>
                )}
              </Descriptions>
            </Col>
          </Row>
        )}
      </Modal>
    </div>
  );
};

export default DoctorDashboard;
