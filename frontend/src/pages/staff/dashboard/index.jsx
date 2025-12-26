import {
  CalendarOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  CloseCircleOutlined,
  ExclamationCircleOutlined,
  InfoCircleOutlined,
  PhoneOutlined,
  RightOutlined,
  ThunderboltOutlined,
  WarningOutlined,
} from '@ant-design/icons';
import {
  Alert,
  Badge,
  Button,
  Card,
  Col,
  List,
  Modal,
  Progress,
  Row,
  Space,
  Spin,
  Statistic,
  Tag,
  Timeline,
  Typography,
} from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import {
  callGetTodayAppointments,
  callGetUrgentAppointments,
} from '@/services/appointment.service';
import dashboardService from '@/services/dashboard.service';
import { useAccountStore } from '@/stores/useAccountStore';
import ProcessUrgentAppointmentModal from './components/ProcessUrgentAppointmentModal';
import UrgencyGuide from './components/UrgencyGuide';

const { Title, Text } = Typography;
// Force HMR

const StaffDashboard = () => {
  const { t } = useTranslation(['staff']);
  const navigate = useNavigate();
  const user = useAccountStore((state) => state.user);
  const isCashierRole = user?.role === 'CASHIER';
  const isDoctorRole = user?.role === 'DOCTOR';

  const [urgentAppointments, setUrgentAppointments] = useState([]);
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [showGuideModal, setShowGuideModal] = useState(false);
  const [processModalOpen, setProcessModalOpen] = useState(false);
  const [selectedAppointment, setSelectedAppointment] = useState(null);

  const fetchUrgentAppointments = async () => {
    try {
      setLoading(true);
      const [urgentRes, statsRes] = await Promise.all([
        callGetUrgentAppointments(),
        dashboardService.getCashierStats(),
      ]);
      if (urgentRes?.data) {
        setUrgentAppointments(urgentRes.data);
        setError(null);
      }
      if (statsRes) {
        setStats(statsRes);
      }
    } catch (_err) {
      setError(t('staff:dashboard.error.load'));
    } finally {
      setLoading(false);
    }
  };

  const fetchTodayAppointments = async () => {
    try {
      setLoadingToday(true);
      const [todayRes, statsRes] = await Promise.all([
        callGetTodayAppointments(),
        dashboardService.getDoctorStats(),
      ]);
      if (todayRes?.data) {
      }
      if (statsRes) {
        setStats(statsRes);
      }
    } catch (_err) {
    } finally {
      setLoadingToday(false);
    }
  };

  useEffect(() => {
    const fetchData = async () => {
      if (isCashierRole) {
        await fetchUrgentAppointments();
      } else if (isDoctorRole) {
        await fetchTodayAppointments();
      }
    };

    fetchData();
    const interval = setInterval(fetchData, 120000);
    return () => clearInterval(interval);
  }, [isCashierRole, isDoctorRole]);

  const handleAssignAppointment = (appointment) => {
    setSelectedAppointment(appointment);
    setProcessModalOpen(true);
  };

  const getUrgencyIcon = (urgencyType) => {
    const icons = {
      RESCHEDULE_PENDING: <ExclamationCircleOutlined />,
      NO_DOCTOR: <WarningOutlined />,
      COMING_SOON: <ClockCircleOutlined />,
      OVERDUE: <CloseCircleOutlined />,
    };
    return icons[urgencyType] || <InfoCircleOutlined />;
  };

  const getUrgencyColor = (priorityLevel) => {
    const colors = {
      1: 'red',
      2: 'orange',
      3: 'gold',
      4: 'blue',
      5: 'default',
    };
    return colors[priorityLevel] || 'default';
  };

  const getPriorityText = (priorityLevel) => {
    return t(`staff:dashboard.priority.${priorityLevel}`) || t('staff:dashboard.priority.5');
  };

  const renderCashierDashboard = () => (
    <div style={{ padding: '24px', background: '#f5f7fa', minHeight: '100vh' }}>
      {}
      <div style={{ marginBottom: 24 }}>
        <Row justify="space-between" align="middle">
          <Col>
            <Title level={2} style={{ margin: 0 }}>
              {t('staff:dashboard.greeting', { name: user?.fullName })}
            </Title>
            <Text type="secondary">
              {t('staff:dashboard.center', { name: user?.centerName || 'Center' })}
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
              <Button
                icon={<ThunderboltOutlined />}
                onClick={fetchUrgentAppointments}
                loading={loading}
              >
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
              title={t('staff:dashboard.stats.urgent.title')}
              value={stats?.urgentAppointments || 0}
              prefix={<ThunderboltOutlined style={{ color: '#ff4d4f' }} />}
              suffix={t('staff:dashboard.stats.urgent.suffix')}
              valueStyle={{ color: '#ff4d4f' }}
            />
            <Progress
              percent={stats?.urgentAppointments > 0 ? 100 : 0}
              size="small"
              status="exception"
              showInfo={false}
              style={{ marginTop: 8 }}
            />
            <Text type="secondary" style={{ fontSize: 12 }}>
              {t('staff:dashboard.stats.urgent.desc')}
            </Text>
          </Card>
        </Col>

        <Col xs={24} sm={12} lg={6}>
          <Card hoverable style={{ borderRadius: 12 }}>
            <Statistic
              title={t('staff:dashboard.stats.today.title')}
              value={stats?.todayAppointments || 0}
              prefix={<CalendarOutlined style={{ color: '#1890ff' }} />}
              suffix={t('staff:dashboard.stats.today.suffix')}
              valueStyle={{ color: '#1890ff' }}
            />
            <Progress
              percent={70}
              size="small"
              strokeColor="#1890ff"
              showInfo={false}
              style={{ marginTop: 8 }}
            />
            <Text type="secondary" style={{ fontSize: 12 }}>
              {t('staff:dashboard.stats.today.desc')}
            </Text>
          </Card>
        </Col>

        <Col xs={24} sm={12} lg={6}>
          <Card hoverable style={{ borderRadius: 12 }}>
            <Statistic
              title={t('staff:dashboard.stats.weekCompleted.title')}
              value={stats?.weekCompleted || 0}
              prefix={<CheckCircleOutlined style={{ color: '#52c41a' }} />}
              suffix={t('staff:dashboard.stats.weekCompleted.suffix')}
              valueStyle={{ color: '#52c41a' }}
            />
            <Progress
              percent={85}
              size="small"
              strokeColor="#52c41a"
              showInfo={false}
              style={{ marginTop: 8 }}
            />
            <Text type="secondary" style={{ fontSize: 12 }}>
              {t('staff:dashboard.stats.weekCompleted.desc')}
            </Text>
          </Card>
        </Col>

        <Col xs={24} sm={12} lg={6}>
          <Card hoverable style={{ borderRadius: 12 }}>
            <Statistic
              title={t('staff:dashboard.stats.weekCancelled.title')}
              value={stats?.weekCancelled || 0}
              prefix={<CloseCircleOutlined style={{ color: '#faad14' }} />}
              suffix={t('staff:dashboard.stats.weekCancelled.suffix')}
              valueStyle={{ color: '#faad14' }}
            />
            <Progress
              percent={15}
              size="small"
              strokeColor="#faad14"
              showInfo={false}
              style={{ marginTop: 8 }}
            />
            <Text type="secondary" style={{ fontSize: 12 }}>
              {t('staff:dashboard.stats.weekCancelled.desc')}
            </Text>
          </Card>
        </Col>
      </Row>

      <Row gutter={[24, 24]}>
        {}
        <Col xs={24} lg={16}>
          <Card
            title={
              <div style={{ display: 'flex', alignItems: 'center' }}>
                <ThunderboltOutlined style={{ fontSize: 24, color: '#faad14' }} />
                <Text strong style={{ fontSize: 18 }}>
                  {t('staff:dashboard.urgentList.title')}
                </Text>
                <Text
                  style={{ textAlign: 'center', marginLeft: 8, fontSize: 12, color: '#faad14' }}
                >
                  ({urgentAppointments.length} {t('staff:dashboard.urgentList.cases')})
                </Text>
              </div>
            }
            extra={
              <Button type="link" onClick={() => navigate('/staff/pending-appointments')}>
                {t('staff:dashboard.urgentList.viewAll')} <RightOutlined />
              </Button>
            }
            style={{ borderRadius: 12, minHeight: 500 }}
          >
            {error && (
              <Alert
                message="Lỗi"
                description={error}
                type="error"
                showIcon
                closable
                style={{ marginBottom: 16 }}
              />
            )}
            {loading ? (
              <div style={{ textAlign: 'center', padding: '60px 0' }}>
                <Spin size="large" />
              </div>
            ) : urgentAppointments.length === 0 ? (
              <div style={{ textAlign: 'center', padding: '60px 0' }}>
                <CheckCircleOutlined style={{ fontSize: 64, color: '#52c41a', marginBottom: 16 }} />
                <Title level={4}>{t('staff:dashboard.urgentList.empty.title')}</Title>
                <Text type="secondary">{t('staff:dashboard.urgentList.empty.desc')}</Text>
              </div>
            ) : (
              <List
                itemLayout="vertical"
                dataSource={urgentAppointments}
                renderItem={(item) => (
                  <Card
                    hoverable
                    style={{
                      marginBottom: 12,
                      borderLeft: `4px solid ${getUrgencyColor(item.priorityLevel)}`,
                      borderRadius: 8,
                      boxShadow: '0 1px 4px rgba(0,0,0,0.05)',
                    }}
                    styles={{ body: { padding: '12px 16px' } }}
                    actions={[
                      <Button
                        key="process"
                        type="primary"
                        size="small"
                        icon={<ThunderboltOutlined />}
                        style={{ minWidth: 100, borderRadius: 4 }}
                        onClick={() => handleAssignAppointment(item)}
                      >
                        {t('staff:dashboard.urgentList.actions.process')}
                      </Button>,
                      <Button
                        key="view"
                        size="small"
                        style={{ minWidth: 100, borderRadius: 4 }}
                        onClick={() => navigate(`/staff/appointments/${item.id}`)}
                      >
                        {t('staff:dashboard.urgentList.actions.detail')}
                      </Button>,
                    ]}
                  >
                    <div style={{ display: 'flex', alignItems: 'flex-start' }}>
                      {}
                      <div style={{ marginRight: 12, marginTop: 2 }}>
                        <Badge
                          count={item.priorityLevel}
                          offset={[-2, 4]}
                          style={{ backgroundColor: '#ff4d4f', boxShadow: '0 0 0 1px #fff' }}
                        >
                          <div
                            style={{
                              width: 40,
                              height: 40,
                              borderRadius: '50%',
                              background: '#fff1f0',
                              border: '1px solid #ffccc7',
                              display: 'flex',
                              alignItems: 'center',
                              justifyContent: 'center',
                            }}
                          >
                            {getUrgencyIcon(item.urgencyType)}
                          </div>
                        </Badge>
                      </div>

                      {}
                      <div style={{ flex: 1, minWidth: 0 }}>
                        {}
                        <div
                          style={{
                            display: 'flex',
                            justifyContent: 'space-between',
                            alignItems: 'center',
                            marginBottom: 4,
                          }}
                        >
                          <Space size={6} wrap style={{ flex: 1, minWidth: 0 }}>
                            <Text
                              strong
                              style={{
                                fontSize: 15,
                                color: '#262626',
                                whiteSpace: 'nowrap',
                                overflow: 'hidden',
                                textOverflow: 'ellipsis',
                              }}
                            >
                              #{item.id} – {item.patientName}
                            </Text>
                            <Tag
                              color={getUrgencyColor(item.priorityLevel)}
                              style={{ margin: 0, padding: '0 4px', fontSize: 10, fontWeight: 700 }}
                            >
                              {getPriorityText(item.priorityLevel)}
                            </Tag>
                            {item.urgencyType === 'RESCHEDULE_PENDING' && (
                              <Tag
                                color="purple"
                                style={{ margin: 0, padding: '0 4px', fontSize: 10 }}
                              >
                                {t('staff:dashboard.urgentList.reschedule')}
                              </Tag>
                            )}
                          </Space>
                          <Text
                            type="secondary"
                            style={{ fontSize: 12, marginLeft: 8, whiteSpace: 'nowrap' }}
                          >
                            {dayjs(item.scheduledDate).format('DD/MM/YYYY')}
                          </Text>
                        </div>

                        {}
                        <div
                          style={{
                            display: 'flex',
                            flexWrap: 'wrap',
                            alignItems: 'center',
                            gap: 6,
                            marginBottom: 4,
                          }}
                        >
                          <Tag
                            style={{
                              margin: 0,
                              padding: '0 6px',
                              fontSize: 11,
                              border: 'none',
                              background: '#f0f0f0',
                            }}
                          >
                            <PhoneOutlined /> {item.patientPhone}
                          </Tag>
                          <Tag color="blue" style={{ margin: 0, padding: '0 6px', fontSize: 11 }}>
                            {item.vaccineName}
                          </Tag>
                          <Tag style={{ margin: 0, padding: '0 6px', fontSize: 11 }}>
                            {t('staff:dashboard.urgentList.dose', { number: item.doseNumber || 1 })}
                          </Tag>

                          {}
                          <div
                            style={{
                              display: 'flex',
                              alignItems: 'center',
                              color: '#ff4d4f',
                              fontSize: 12,
                            }}
                          >
                            <ExclamationCircleOutlined style={{ marginRight: 4 }} />
                            <Text type="danger" style={{ fontSize: 12 }} ellipsis>
                              {t(`staff:dashboard.stats.urgencyMessages.${item.urgencyType}`) ||
                                t('staff:dashboard.stats.urgencyMessages.default')}
                            </Text>
                          </div>
                        </div>

                        {}
                        {item.desiredDate && (
                          <div style={{ fontSize: 12, color: '#cf1322', marginTop: 2 }}>
                            <ClockCircleOutlined style={{ marginRight: 4 }} />
                            <strong>{t('staff:dashboard.urgentList.changeTo')}</strong>{' '}
                            {dayjs(item.desiredDate).format('DD/MM/YYYY')} {item.desiredTime}
                          </div>
                        )}
                      </div>
                    </div>
                  </Card>
                )}
              />
            )}
          </Card>
        </Col>

        {}
        <Col xs={24} lg={8}>
          <Card
            title={
              <Space>
                <ThunderboltOutlined style={{ color: '#1890ff' }} />
                <Text strong>{t('staff:dashboard.quickActions.title')}</Text>
              </Space>
            }
            style={{ borderRadius: 12, marginBottom: 24 }}
          >
            <Space direction="vertical" style={{ width: '100%' }}>
              <Button
                block
                size="large"
                icon={<CalendarOutlined />}
                onClick={() => navigate('/staff/calendar-view')}
              >
                {t('staff:dashboard.quickActions.viewDoctorSchedule')}
              </Button>
              <Button
                block
                size="large"
                icon={<ClockCircleOutlined />}
                onClick={() => navigate('/staff/pending-appointments')}
              >
                {t('staff:dashboard.quickActions.pendingList')}
              </Button>
              <Button
                block
                size="large"
                icon={<CheckCircleOutlined />}
                onClick={() => navigate('/staff/appointments?status=assigned')}
              >
                {t('staff:dashboard.quickActions.assignedList')}
              </Button>
            </Space>
          </Card>

          <Card
            title={
              <Space>
                <InfoCircleOutlined style={{ color: '#faad14' }} />
                <Text strong>{t('staff:dashboard.urgencyGuide.title')}</Text>
              </Space>
            }
            extra={
              <Button type="link" size="small" onClick={() => setShowGuideModal(true)}>
                {t('staff:dashboard.urgencyGuide.detail')}
              </Button>
            }
            style={{ borderRadius: 12 }}
          >
            <Timeline
              items={[
                {
                  color: 'red',
                  dot: <ExclamationCircleOutlined />,
                  children: <Text strong>{t('staff:dashboard.urgencyGuide.p1')}</Text>,
                },
                {
                  color: 'orange',
                  dot: <WarningOutlined />,
                  children: <Text>{t('staff:dashboard.urgencyGuide.p2')}</Text>,
                },
                {
                  color: 'gold',
                  children: t('staff:dashboard.urgencyGuide.p3'),
                },
                {
                  color: 'blue',
                  children: t('staff:dashboard.urgencyGuide.p4'),
                },
              ]}
            />
          </Card>
        </Col>
      </Row>

      {}
      <Modal
        open={showGuideModal}
        onCancel={() => setShowGuideModal(false)}
        footer={null}
        width={800}
      >
        <UrgencyGuide />
      </Modal>

      {selectedAppointment && (
        <ProcessUrgentAppointmentModal
          open={processModalOpen}
          onClose={() => {
            setProcessModalOpen(false);
            setSelectedAppointment(null);
          }}
          onSuccess={() => {
            setProcessModalOpen(false);
            setSelectedAppointment(null);
            fetchUrgentAppointments();
          }}
          appointment={selectedAppointment}
        />
      )}
    </div>
  );

  useEffect(() => {
    if (isDoctorRole) {
      navigate('/staff/dashboard-doctor');
    }
  }, [isDoctorRole, navigate]);

  const renderDoctorDashboard = () => {
    return (
      <div
        style={{
          padding: '24px',
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          height: '100vh',
        }}
      >
        <Spin size="large" tip={t('staff:dashboard.redirectingDoctor')} />
      </div>
    );
  };

  return isCashierRole ? renderCashierDashboard() : renderDoctorDashboard();
};

export default StaffDashboard;
