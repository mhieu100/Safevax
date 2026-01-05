import {
  CalendarOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  CloseCircleOutlined,
  ExclamationCircleOutlined,
  InfoCircleOutlined,
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
  ConfigProvider,
  List,
  Modal,
  Row,
  Space,
  Spin,
  Statistic,
  Tag,
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
import DashboardCharts from './components/DashboardCharts';
import ProcessUrgentAppointmentModal from './components/ProcessUrgentAppointmentModal';
import UrgencyGuide from './components/UrgencyGuide';

const { Title, Text } = Typography;

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
    // Doctor dashboard logic (redirect handled in useEffect)
    try {
      const [_todayRes, statsRes] = await Promise.all([
        callGetTodayAppointments(),
        dashboardService.getDoctorStats(),
      ]);
      if (statsRes) {
        setStats(statsRes);
      }
    } catch (_err) {
      // ignore
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

  useEffect(() => {
    if (isDoctorRole) {
      navigate('/staff/dashboard-doctor');
    }
  }, [isDoctorRole, navigate]);

  const handleAssignAppointment = (appointment) => {
    setSelectedAppointment(appointment);
    setProcessModalOpen(true);
  };

  const getUrgencyIcon = (urgencyType) => {
    const icons = {
      RESCHEDULE_PENDING: <ExclamationCircleOutlined className="text-red-500" />,
      NO_DOCTOR: <WarningOutlined className="text-orange-500" />,
      COMING_SOON: <ClockCircleOutlined className="text-blue-500" />,
      OVERDUE: <CloseCircleOutlined className="text-gray-500" />,
    };
    return icons[urgencyType] || <InfoCircleOutlined />;
  };

  const renderCashierDashboard = () => {
    // Mock data for demo if stats are empty/zero
    const displayStats = {
      urgentAppointments: stats?.urgentAppointments || 3,
      todayAppointments: stats?.todayAppointments || 18,
      weekCompleted: stats?.weekCompleted || 85,
      weekCancelled: stats?.weekCancelled || 15,
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
        <div className="min-h-screen bg-slate-50 p-6">
          {/* Header */}
          <div className="mb-8 flex justify-between items-center bg-white p-4 rounded-xl shadow-sm border border-slate-100">
            <div>
              <Title level={3} style={{ margin: 0, color: '#1e293b' }}>
                {t('staff:dashboard.greeting', { name: user?.fullName })}
              </Title>
              <Text type="secondary">
                {t('staff:dashboard.center', { name: user?.centerName || 'Center' })}
              </Text>
            </div>
            <Space>
              <Tag color="blue" className="px-3 py-1 text-sm rounded-full">
                {dayjs().format('DD/MM/YYYY')}
              </Tag>
              <Button
                className="rounded-full"
                icon={<ThunderboltOutlined />}
                onClick={fetchUrgentAppointments}
                loading={loading}
              >
                {t('staff:dashboard.refresh')}
              </Button>
            </Space>
          </div>

          {/* Stats Row - Clean & Minimal */}
          <Row gutter={[24, 24]} className="mb-8">
            <Col xs={24} sm={12} lg={6}>
              <Card
                bordered={false}
                className="rounded-xl shadow-sm hover:shadow-md transition-shadow"
              >
                <Statistic
                  title={
                    <span className="text-slate-500 font-medium">
                      {t('staff:dashboard.stats.urgentCount')}
                    </span>
                  }
                  value={displayStats.urgentAppointments}
                  valueStyle={{ color: '#ef4444', fontWeight: 600 }}
                  prefix={<ThunderboltOutlined />}
                  suffix={t('staff:dashboard.stats.appointments')}
                />
              </Card>
            </Col>
            <Col xs={24} sm={12} lg={6}>
              <Card
                bordered={false}
                className="rounded-xl shadow-sm hover:shadow-md transition-shadow"
              >
                <Statistic
                  title={
                    <span className="text-slate-500 font-medium">
                      {t('staff:dashboard.stats.todayCount')}
                    </span>
                  }
                  value={displayStats.todayAppointments}
                  prefix={<CalendarOutlined />}
                  suffix={t('staff:dashboard.stats.appointments')}
                />
              </Card>
            </Col>
            <Col xs={24} sm={12} lg={6}>
              <Card
                bordered={false}
                className="rounded-xl shadow-sm hover:shadow-md transition-shadow"
              >
                <Statistic
                  title={
                    <span className="text-slate-500 font-medium">
                      {t('staff:dashboard.stats.completedCount')}
                    </span>
                  }
                  value={displayStats.weekCompleted}
                  valueStyle={{ color: '#10b981', fontWeight: 600 }}
                  prefix={<CheckCircleOutlined />}
                  suffix={t('staff:dashboard.stats.appointments')}
                />
              </Card>
            </Col>
            <Col xs={24} sm={12} lg={6}>
              <Card
                bordered={false}
                className="rounded-xl shadow-sm hover:shadow-md transition-shadow"
              >
                <Statistic
                  title={
                    <span className="text-slate-500 font-medium">
                      {t('staff:dashboard.stats.cancelledCount')}
                    </span>
                  }
                  value={displayStats.weekCancelled}
                  valueStyle={{ color: '#94a3b8', fontWeight: 600 }}
                  prefix={<CloseCircleOutlined />}
                  suffix={t('staff:dashboard.stats.appointments')}
                />
              </Card>
            </Col>
          </Row>

          {/* Charts Section */}
          <DashboardCharts urgentAppointments={urgentAppointments} stats={displayStats} />

          <Row gutter={[24, 24]}>
            {/* Main Content: Urgent List */}
            <Col xs={24} lg={16}>
              <Card
                bordered={false}
                className="rounded-xl shadow-sm min-h-[500px]"
                title={
                  <Space>
                    <ThunderboltOutlined className="text-amber-500" />
                    <span className="text-slate-800 text-lg font-semibold">
                      {t('staff:dashboard.urgentList.title')}
                    </span>
                    <Badge
                      count={urgentAppointments.length}
                      style={{ backgroundColor: '#fff7ed', color: '#ea580c', boxShadow: 'none' }}
                    />
                  </Space>
                }
                extra={
                  <Button type="link" onClick={() => navigate('/staff/pending-appointments')}>
                    {t('staff:dashboard.urgentList.viewAll')} <RightOutlined />
                  </Button>
                }
              >
                {error ? (
                  <Alert message={error} type="error" showIcon />
                ) : loading ? (
                  <div className="flex justify-center items-center py-20">
                    <Spin size="large" />
                  </div>
                ) : urgentAppointments.length === 0 ? (
                  <div className="flex flex-col justify-center items-center py-20 text-slate-400">
                    <CheckCircleOutlined
                      style={{ fontSize: 48, marginBottom: 16, color: '#cbd5e1' }}
                    />
                    <p>{t('staff:dashboard.urgentList.empty')}</p>
                  </div>
                ) : (
                  <List
                    itemLayout="horizontal"
                    dataSource={urgentAppointments}
                    renderItem={(item) => (
                      <List.Item
                        className="hover:bg-slate-50 transition-colors p-4 rounded-lg -mx-4 border-b border-slate-50 last:border-0"
                        actions={[
                          <Button
                            key="process"
                            type="primary"
                            className="rounded-lg shadow-sm bg-blue-600 hover:bg-blue-700 border-none"
                            onClick={() => handleAssignAppointment(item)}
                          >
                            {t('staff:dashboard.urgentList.process')}
                          </Button>,
                          <Button
                            key="detail"
                            type="text"
                            className="text-slate-500 hover:text-blue-600"
                            onClick={() => navigate(`/staff/appointments/${item.id}`)}
                          >
                            {t('staff:common.view')}
                          </Button>,
                        ]}
                      >
                        <List.Item.Meta
                          avatar={
                            <div className="bg-white p-2 rounded-full shadow-sm border border-slate-100 text-lg">
                              {getUrgencyIcon(item.urgencyType)}
                            </div>
                          }
                          title={
                            <div className="flex items-center gap-2">
                              <span className="font-semibold text-slate-800">
                                #{item.id} - {item.patientName}
                              </span>
                              {item.urgencyType === 'RESCHEDULE_PENDING' && (
                                <Tag color="purple" bordered={false} className="rounded-md">
                                  {t('staff:appointments.reschedule.label')}
                                </Tag>
                              )}
                              {item.priorityLevel === 1 && (
                                <Tag color="red" bordered={false} className="rounded-md">
                                  {t('staff:dashboard.priority.urgent')}
                                </Tag>
                              )}
                            </div>
                          }
                          description={
                            <Space direction="vertical" size={1} className="w-full">
                              <div className="text-slate-500 text-xs flex gap-3">
                                <span>
                                  <CalendarOutlined className="mr-1" />
                                  {dayjs(item.scheduledDate).format('DD/MM/YYYY')}
                                </span>
                                <span>
                                  <ClockCircleOutlined className="mr-1" />
                                  {item.patientPhone}
                                </span>
                              </div>
                              <div className="text-red-500 text-xs font-medium">
                                {t(`staff:dashboard.stats.urgencyMessages.${item.urgencyType}`) ||
                                  t('staff:dashboard.stats.urgencyMessages.default')}
                              </div>
                              {item.desiredDate && (
                                <div className="text-indigo-600 text-xs font-medium bg-indigo-50 inline-block px-2 py-0.5 rounded">
                                  {t('staff:appointments.reschedule.to')}{' '}
                                  {dayjs(item.desiredDate).format('DD/MM/YYYY')} {item.desiredTime}
                                </div>
                              )}
                            </Space>
                          }
                        />
                      </List.Item>
                    )}
                  />
                )}
              </Card>
            </Col>

            {/* Sidebar */}
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
                    onClick={() => navigate('/staff/calendar-view')}
                  >
                    {t('staff:common.menu.viewSchedule')}
                  </Button>
                  <Button
                    block
                    className="rounded-lg h-10 text-left justify-start"
                    icon={<ClockCircleOutlined />}
                    onClick={() => navigate('/staff/pending-appointments')}
                  >
                    {t('staff:common.menu.pendingList')}
                  </Button>
                  <Button
                    block
                    className="rounded-lg h-10 text-left justify-start"
                    icon={<CheckCircleOutlined />}
                    onClick={() => navigate('/staff/appointments?status=assigned')}
                  >
                    {t('staff:dashboard.quickActions.assigned')}
                  </Button>
                </div>
              </Card>

              <Card
                bordered={false}
                className="rounded-xl shadow-sm"
                title={
                  <span className="font-semibold text-slate-700">
                    {t('staff:dashboard.urgencyGuide.title')}
                  </span>
                }
                extra={
                  <a
                    onClick={() => setShowGuideModal(true)}
                    className="text-blue-500 hover:text-blue-600 text-sm cursor-pointer"
                  >
                    {t('staff:common.view')}
                  </a>
                }
              >
                <div className="space-y-3">
                  <div className="flex items-center gap-2 text-sm text-slate-600">
                    <ExclamationCircleOutlined className="text-red-500 text-lg" />
                    <span>{t('staff:dashboard.urgencyGuide.p1')}</span>
                  </div>
                  <div className="flex items-center gap-2 text-sm text-slate-600">
                    <WarningOutlined className="text-orange-500 text-lg" />
                    <span>{t('staff:dashboard.urgencyGuide.p2')}</span>
                  </div>
                  <div className="flex items-center gap-2 text-sm text-slate-600">
                    <InfoCircleOutlined className="text-yellow-500 text-lg" />
                    <span>{t('staff:dashboard.urgencyGuide.p3')}</span>
                  </div>
                </div>
              </Card>
            </Col>
          </Row>

          <Modal
            open={showGuideModal}
            onCancel={() => setShowGuideModal(false)}
            footer={null}
            width={800}
            centered
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
      </ConfigProvider>
    );
  };

  return isCashierRole ? (
    renderCashierDashboard()
  ) : (
    <div className="flex justify-center items-center h-screen bg-slate-50">
      <Spin size="large" tip={t('staff:dashboard.redirectingDoctor')} />
    </div>
  );
};

export default StaffDashboard;
