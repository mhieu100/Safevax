import {
  CalendarOutlined,
  CheckCircleFilled,
  ClockCircleOutlined,
  CloseCircleFilled,
  MedicineBoxOutlined,
  SyncOutlined,
} from '@ant-design/icons';
import { Alert, Card, Empty, Skeleton, Table, Tag, Typography } from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { getVaccinationHistory } from '@/services/booking.service';
import { formatAppointmentTime } from '@/utils/appointment';

const { Title, Text } = Typography;

const VaccinationHistoryTab = ({ customData }) => {
  const { t } = useTranslation(['client']);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [appointments, setAppointments] = useState([]);
  const [stats, setStats] = useState({ total: 0, completed: 0, cancelled: 0, pending: 0 });

  const fetchHistory = async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await getVaccinationHistory();
      const appointmentList = response.data || [];

      setAppointments(appointmentList);

      setStats({
        total: appointmentList.length,
        completed: appointmentList.filter((a) => a.appointmentStatus === 'COMPLETED').length,
        cancelled: appointmentList.filter((a) => a.appointmentStatus === 'CANCELLED').length,
        pending: appointmentList.filter((a) =>
          ['PENDING', 'SCHEDULED', 'RESCHEDULE'].includes(a.appointmentStatus)
        ).length,
      });
    } catch (_err) {
      console.error(_err);
      setError(t('client:records.vaccinationHistory.errorLoadHistory'));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (customData) {
      setAppointments(customData);
      setStats({
        total: customData.length,
        completed: customData.filter((a) => a.appointmentStatus === 'COMPLETED').length,
        cancelled: customData.filter((a) => a.appointmentStatus === 'CANCELLED').length,
        pending: customData.filter((a) =>
          ['PENDING', 'SCHEDULED', 'RESCHEDULE'].includes(a.appointmentStatus)
        ).length,
      });
    } else {
      fetchHistory();
    }
  }, [customData]);

  const getStatusConfig = (status) => {
    switch (status) {
      case 'COMPLETED':
        return {
          color: 'success',
          icon: <CheckCircleFilled />,
          text: t('client:records.vaccinationHistory.completed'),
        };
      case 'CANCELLED':
        return {
          color: 'error',
          icon: <CloseCircleFilled />,
          text: t('client:appointments.cancelled'),
        };
      case 'SCHEDULED':
        return {
          color: 'processing',
          icon: <CalendarOutlined />,
          text: t('client:appointments.scheduled'),
        };
      case 'PENDING':
        return {
          color: 'warning',
          icon: <ClockCircleOutlined />,
          text: t('client:records.blockchain.pending'),
        };
      case 'RESCHEDULE':
        return {
          color: 'gold',
          icon: <SyncOutlined spin />,
          text: t('client:appointments.rescheduling'),
        };
      default:
        return { color: 'default', icon: null, text: status };
    }
  };

  const formatPrice = (price) => {
    if (!price) return '—';
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND',
    }).format(price);
  };

  if (loading) {
    return <Skeleton active />;
  }

  if (error) {
    return <Alert message={error} type="error" showIcon />;
  }

  const columns = [
    {
      title: t('client:records.vaccinationHistory.vaccine'),
      key: 'vaccine',
      render: (_, record) => (
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-100 flex items-center justify-center text-blue-600">
            <MedicineBoxOutlined className="text-lg" />
          </div>
          <div>
            <Text strong className="text-slate-800 block">
              {record.vaccineName}
            </Text>
            <Text className="text-xs text-slate-500">
              {t('client:records.vaccinationHistory.dose')} {record.doseNumber || 1}
              {record.vaccineTotalDoses && ` / ${record.vaccineTotalDoses}`}
            </Text>
          </div>
        </div>
      ),
    },
    {
      title: t('client:records.vaccinationHistory.patient'),
      key: 'patient',
      render: (_, record) => (
        <div>
          <Text className="font-medium text-slate-700">{record.patientName}</Text>
          {record.isFamily && (
            <Tag
              color="purple"
              className="ml-2 rounded-md bg-purple-50 text-purple-600 border-0 text-[10px]"
            >
              {t('client:records.vaccinationHistory.familyMember')}
            </Tag>
          )}
        </div>
      ),
    },
    {
      title: t('client:records.vaccinationHistory.scheduledDate'),
      key: 'date',
      render: (_, record) => (
        <div>
          <div className="font-medium text-slate-700">
            {record.scheduledDate ? dayjs(record.scheduledDate).format('DD/MM/YYYY') : '—'}
          </div>
          <div className="text-xs text-slate-400">{formatAppointmentTime(record)}</div>
        </div>
      ),
    },
    {
      title: t('client:records.vaccinationHistory.center'),
      dataIndex: 'centerName',
      key: 'center',
      render: (v) => <span className="text-slate-600">{v || 'N/A'}</span>,
    },
    {
      title: t('client:records.vaccinationHistory.totalAmount'),
      key: 'amount',
      render: (_, record) => (
        <span className="font-semibold text-slate-700">{formatPrice(record.paymentAmount)}</span>
      ),
    },
    {
      title: t('client:records.vaccinationHistory.status'),
      key: 'status',
      render: (_, record) => {
        const config = getStatusConfig(record.appointmentStatus);
        return (
          <Tag color={config.color} icon={config.icon} className="rounded-lg px-2 py-0.5">
            {config.text}
          </Tag>
        );
      },
    },
  ];

  return (
    <div className="animate-fade-in space-y-6">
      <div className="mb-6">
        <Title level={3} className="!mb-1 text-slate-800">
          {t('client:records.vaccinationHistory.title')}
        </Title>
        <Text className="text-slate-500 text-lg">
          {t('client:records.vaccinationHistory.trackBookings')}
        </Text>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
        <Card className="rounded-2xl shadow-sm border border-slate-100 bg-gradient-to-br from-blue-50 to-white">
          <div className="text-center">
            <div className="text-3xl font-bold text-blue-600 mb-1">{stats.total}</div>
            <Text className="text-slate-500 font-medium uppercase text-xs tracking-wider">
              {t('client:records.vaccinationHistory.totalBookings')}
            </Text>
          </div>
        </Card>
        <Card className="rounded-2xl shadow-sm border border-slate-100 bg-gradient-to-br from-emerald-50 to-white">
          <div className="text-center">
            <div className="text-3xl font-bold text-emerald-600 mb-1">{stats.completed}</div>
            <Text className="text-slate-500 font-medium uppercase text-xs tracking-wider">
              {t('client:records.vaccinationHistory.completed')}
            </Text>
          </div>
        </Card>
        <Card className="rounded-2xl shadow-sm border border-slate-100 bg-gradient-to-br from-orange-50 to-white">
          <div className="text-center">
            <div className="text-3xl font-bold text-orange-600 mb-1">{stats.pending}</div>
            <Text className="text-slate-500 font-medium uppercase text-xs tracking-wider">
              {t('client:records.blockchain.pending')}
            </Text>
          </div>
        </Card>
        <Card className="rounded-2xl shadow-sm border border-slate-100 bg-gradient-to-br from-red-50 to-white">
          <div className="text-center">
            <div className="text-3xl font-bold text-red-500 mb-1">{stats.cancelled}</div>
            <Text className="text-slate-500 font-medium uppercase text-xs tracking-wider">
              {t('client:appointments.cancelled')}
            </Text>
          </div>
        </Card>
      </div>

      <Card className="rounded-3xl shadow-sm border border-slate-100 overflow-hidden">
        {appointments.length === 0 ? (
          <Empty
            image={Empty.PRESENTED_IMAGE_SIMPLE}
            description={
              <span className="text-slate-500">
                {t('client:records.vaccinationHistory.noHistory')}
              </span>
            }
          />
        ) : (
          <Table
            dataSource={appointments}
            columns={columns}
            rowKey="id"
            pagination={{ pageSize: 10 }}
            scroll={{ x: 800 }}
          />
        )}
      </Card>
    </div>
  );
};

export default VaccinationHistoryTab;
