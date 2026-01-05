import {
  BellOutlined,
  CalendarOutlined,
  CalendarTwoTone,
  CheckCircleOutlined,
  ClockCircleOutlined,
  CloseCircleOutlined,
  EyeOutlined,
  MedicineBoxOutlined,
  PhoneOutlined,
  PlayCircleOutlined,
  RightOutlined,
  TeamOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  Avatar,
  Button,
  Card,
  Col,
  ConfigProvider,
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
import DashboardCharts from '../dashboard/components/DashboardCharts';
import AppointmentDetailModal from '../pending-appointment/AppointmentDetailModal';

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

  const displayStats = {
    todayAppointments: stats?.todayAppointments || todayAppointments.length || 0,
    weekCompleted: stats?.weekCompleted || 0,
    weekCancelled: stats?.weekCancelled || 0,
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
    <ConfigProvider
      theme={{
        token: {
          fontFamily: 'Inter, sans-serif',
          colorBgContainer: '#ffffff',
        },
      }}
    >
      <div style={{ padding: '24px', minHeight: '100vh', background: '#f8fafc' }}>
        {/* Header */}
        <div className="mb-8 flex justify-between items-center bg-white p-4 rounded-xl shadow-sm border border-slate-100">
          <div>
            <Title level={3} style={{ margin: 0, color: '#1e293b' }}>
              {t('staff:dashboard.doctor.greeting', { name: user?.fullName })}
            </Title>
            <Text type="secondary">
              {t('staff:dashboard.doctor.greetingSub', { count: todayAppointments.length })}
            </Text>
          </div>
          <Space>
            <Tag color="blue" className="px-3 py-1 text-sm rounded-full">
              {dayjs().format('DD/MM/YYYY')}
            </Tag>
            <Button icon={<ClockCircleOutlined />} onClick={fetchData} loading={loading}>
              {t('staff:dashboard.refresh')}
            </Button>
          </Space>
        </div>

        {/* Stats Row */}
        <Row gutter={[24, 24]} className="mb-8">
          <Col xs={24} sm={12} lg={6}>
            <Card
              bordered={false}
              className="rounded-xl shadow-sm hover:shadow-md transition-shadow"
            >
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
            <Card
              bordered={false}
              className="rounded-xl shadow-sm hover:shadow-md transition-shadow"
            >
              <Statistic
                title={t('staff:dashboard.doctor.thisWeek')}
                value={stats?.weekAppointments || 0}
                prefix={<CalendarOutlined style={{ color: '#722ed1' }} />}
                suffix={t('staff:dashboard.stats.today.suffix')}
                valueStyle={{ color: '#722ed1' }}
              />
            </Card>
          </Col>

          <Col xs={24} sm={12} lg={6}>
            <Card
              bordered={false}
              className="rounded-xl shadow-sm hover:shadow-md transition-shadow"
            >
              <Statistic
                title={t('staff:dashboard.doctor.completedMonth')}
                value={stats?.monthCompleted || 0}
                prefix={<CheckCircleOutlined style={{ color: '#52c41a' }} />}
                suffix={t('staff:dashboard.doctor.inMonth')}
                valueStyle={{ color: '#52c41a' }}
              />
            </Card>
          </Col>

          <Col xs={24} sm={12} lg={6}>
            <Card
              bordered={false}
              className="rounded-xl shadow-sm hover:shadow-md transition-shadow"
            >
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

        {/* Charts Section */}
        <DashboardCharts stats={displayStats} />

        <Row gutter={[24, 24]}>
          {/* Main Content: Timeline/List */}
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
              bordered={false}
              className="rounded-xl shadow-sm"
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
                              <Tooltip
                                key="start"
                                title={t('staff:dashboard.doctor.modal.startInt')}
                              >
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
          <Col xs={24} lg={8}>
            <Card
              bordered={false}
              className="rounded-xl shadow-sm mb-6"
              title={
                <span className="font-semibold text-slate-700">
                  {t('staff:dashboard.quickActions.title')}
                </span>
              }
            >
              <div className="flex flex-col gap-3">
                <Button
                  block
                  className="rounded-lg h-10 text-left justify-start"
                  icon={<CalendarOutlined />}
                  // onClick={() => navigate('/staff/calendar-view')}
                >
                  {t('staff:common.menu.viewSchedule')}
                </Button>
                <Button
                  block
                  className="rounded-lg h-10 text-left justify-start"
                  icon={<ClockCircleOutlined />}
                >
                  {t('staff:common.menu.pendingList')}
                </Button>
                <Button
                  block
                  className="rounded-lg h-10 text-left justify-start"
                  icon={<CheckCircleOutlined />}
                >
                  {t('staff:dashboard.quickActions.assigned')}
                </Button>
              </div>
            </Card>
          </Col>
        </Row>

        <CompletionModal
          open={completionModalOpen}
          onCancel={() => setCompletionModalOpen(false)}
          appointment={selectedAppointment}
          onSuccess={() => {
            fetchData();
          }}
        />
        <AppointmentDetailModal
          open={detailModalOpen}
          onClose={() => setDetailModalOpen(false)}
          appointmentId={selectedAppointment?.id}
        />
      </div>
    </ConfigProvider>
  );
};

export default DoctorDashboard;
