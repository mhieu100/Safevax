import {
  CalendarOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  CloseCircleOutlined,
  EditOutlined,
  PhoneOutlined,
  ReloadOutlined,
  ScheduleOutlined,
  UserOutlined,
} from '@ant-design/icons';
import { Avatar, Button, Card, Space, Tag, Tooltip, Typography } from 'antd';
import dayjs from 'dayjs';
import queryString from 'query-string';
import { useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { sfEqual, sfLike } from 'spring-filter-query-builder';
import DataTable from '@/components/data-table';
import { TIME_SLOT_LABELS } from '@/constants';
import {
  AppointmentStatus,
  formatPaymentAmount,
  getAppointmentStatusColor,
  getPaymentStatusColor,
  PaymentStatus,
} from '@/constants/enums';
import { useAppointmentStore } from '@/stores/useAppointmentStore';
import AppointmentDetailModal from '../pending-appointment/AppointmentDetailModal';

const { Text } = Typography;

const AllAppointmentsPage = () => {
  const { t } = useTranslation(['staff']);
  const tableRef = useRef();

  const isFetching = useAppointmentStore((state) => state.isFetching);
  const meta = useAppointmentStore((state) => state.meta);
  const appointments = useAppointmentStore((state) => state.result);
  const fetchAppointmentOfCenter = useAppointmentStore((state) => state.fetchAppointmentOfCenter);

  const [openDetailModal, setOpenDetailModal] = useState(false);
  const [detailAppointmentId, setDetailAppointmentId] = useState(null);
  const [_searchText, _setSearchText] = useState('');
  const [_statusFilter, setStatusFilter] = useState(null);

  const reloadTable = () => {
    tableRef?.current?.reload();
  };

  const getStatusIcon = (status) => {
    switch (status) {
      case AppointmentStatus.COMPLETED:
        return <CheckCircleOutlined />;
      case AppointmentStatus.SCHEDULED:
        return <ScheduleOutlined />;
      case AppointmentStatus.PENDING:
        return <ClockCircleOutlined />;
      case AppointmentStatus.RESCHEDULE:
        return <EditOutlined />;
      case AppointmentStatus.CANCELLED:
        return <CloseCircleOutlined />;
      default:
        return null;
    }
  };

  const columns = [
    {
      title: t('staff:appointments.columns.code'),
      dataIndex: 'id',
      width: 80,
      render: (text) => (
        <Text strong style={{ color: '#1890ff' }}>
          #{text}
        </Text>
      ),
    },
    {
      title: t('staff:appointments.columns.patient'),
      dataIndex: 'patientName',
      width: 220,
      render: (text, record) => (
        <Space direction="vertical" size={2}>
          <Space>
            <Avatar icon={<UserOutlined />} size="small" style={{ backgroundColor: '#1890ff' }} />
            <Text strong>{text}</Text>
          </Space>
          <span className="text-xs text-slate-500 flex items-center gap-1 pl-6">
            <PhoneOutlined /> {record.patientPhone || 'N/A'}
          </span>
        </Space>
      ),
    },
    {
      title: t('staff:appointments.columns.vaccine'),
      dataIndex: 'vaccineName',
      width: 180,
      render: (text, record) => (
        <Space direction="vertical" size={1}>
          <Text strong className="text-slate-700">
            {text}
          </Text>
          <Tag className="m-0 text-[10px] w-fit">
            {t('staff:dashboard.urgentList.dose', { number: record.doseNumber || 1 })}
          </Tag>
        </Space>
      ),
    },
    {
      title: t('staff:appointments.columns.registerDate'),
      dataIndex: 'scheduledDate',
      width: 180,
      render: (_text, record) => {
        const dateToShow = record.scheduledDate;
        const timeSlotToShow = record.scheduledTimeSlot;
        const actualTime = record.actualScheduledTime;

        return (
          <Space direction="vertical" size={2}>
            <div className="flex items-center gap-2 text-slate-700">
              <CalendarOutlined />
              <span className="font-medium">
                {dateToShow ? dayjs(dateToShow).format('DD/MM/YYYY') : 'N/A'}
              </span>
            </div>
            {actualTime ? (
              <div className="flex items-center gap-2 text-slate-500 text-xs pl-6">
                <ClockCircleOutlined />
                {actualTime}
              </div>
            ) : timeSlotToShow ? (
              <div className="flex items-center gap-2 text-slate-500 text-xs pl-6">
                <ClockCircleOutlined />
                {TIME_SLOT_LABELS[timeSlotToShow] || timeSlotToShow}
              </div>
            ) : null}
          </Space>
        );
      },
    },
    {
      title: t('staff:appointments.columns.centerDoctor'),
      dataIndex: 'centerName',
      width: 200,
      render: (centerName, record) => (
        <Space direction="vertical" size={1}>
          <Text className="text-slate-700">{centerName}</Text>
          {record.doctorName ? (
            <span className="text-xs text-green-600">BS. {record.doctorName}</span>
          ) : (
            <span className="text-xs text-orange-500">
              {t('staff:appointments.tags.waitingDoctor')}
            </span>
          )}
        </Space>
      ),
    },
    {
      title: t('staff:appointments.columns.status'),
      dataIndex: 'appointmentStatus',
      width: 150,
      render: (status) => (
        <Tag
          color={getAppointmentStatusColor(status)}
          icon={getStatusIcon(status)}
          className="flex items-center gap-1 w-fit"
        >
          {t(`staff:appointments.status.${status}`)}
        </Tag>
      ),
    },
    {
      title: t('staff:appointments.columns.payment'),
      dataIndex: 'paymentStatus',
      width: 180,
      render: (status, record) => {
        const paymentInfo = formatPaymentAmount(
          record.paymentAmount,
          record.paymentMethod,
          record.paymentCurrency
        );
        return (
          <Space direction="vertical" size={1}>
            <Tag color={getPaymentStatusColor(status)}>
              {status === PaymentStatus.SUCCESS
                ? t('staff:appointments.payment.success')
                : status === PaymentStatus.PROCESSING || status === PaymentStatus.INITIATED
                  ? t('staff:appointments.payment.processing')
                  : record.paymentMethod === 'CASH'
                    ? t('staff:appointments.payment.cash')
                    : t('staff:appointments.payment.unpaid')}
            </Tag>
            {record.paymentAmount && (
              <Text className="text-xs text-slate-600">{paymentInfo.display}</Text>
            )}
          </Space>
        );
      },
    },
    {
      title: t('staff:appointments.columns.actions'),
      key: 'actions',
      width: 100,
      render: (_, record) => (
        <Tooltip title={t('staff:appointments.view')}>
          <Button
            type="primary"
            ghost
            icon={<EditOutlined />}
            onClick={() => {
              setDetailAppointmentId(record.id);
              setOpenDetailModal(true);
            }}
          />
        </Tooltip>
      ),
    },
  ];

  const buildQuery = (params, _sort) => {
    const clone = { ...params };
    const q = {
      page: params.current,
      size: params.pageSize,
      filter: '',
    };

    const filters = [];

    if (searchText) {
      filters.push(`(${sfLike('patientName', searchText)} or ${sfLike('id', searchText)})`);
    }
    if (statusFilter) {
      filters.push(sfEqual('appointmentStatus', statusFilter));
    }
    if (clone.vaccineName) {
      filters.push(sfLike('vaccineName', clone.vaccineName));
    }
    if (clone.centerName) {
      filters.push(sfLike('centerName', clone.centerName));
    }

    q.filter = filters.join(' and ');
    if (!q.filter) delete q.filter;

    return queryString.stringify(q);
  };

  const _handleSearch = () => {
    reloadTable();
  };

  const _handleStatusChange = (value) => {
    setStatusFilter(value);
    setTimeout(() => reloadTable(), 0);
  };

  return (
    <div style={{ padding: '24px', background: '#f0f2f5', minHeight: '100vh' }}>
      <Card
        title={
          <Space>
            <CalendarOutlined />
            <span>{t('staff:appointments.title')}</span>
            <Tag color="blue">
              {meta.total || 0} {t('staff:dashboard.stats.today.suffix')}
            </Tag>
          </Space>
        }
        extra={
          <Button icon={<ReloadOutlined />} onClick={reloadTable}>
            {t('staff:appointments.refresh')}
          </Button>
        }
      >
        <DataTable
          actionRef={tableRef}
          rowKey="id"
          loading={isFetching}
          columns={columns}
          dataSource={appointments}
          request={async (params, sort, filter) => {
            const query = buildQuery(params, sort, filter);
            fetchAppointmentOfCenter(query);
          }}
          pagination={{
            current: meta.page,
            pageSize: meta.pageSize,
            showSizeChanger: true,
            total: meta.total,
            showTotal: (total, range) => (
              <Text>
                {t('staff:appointments.pagination', {
                  range0: range[0],
                  range1: range[1],
                  total: total,
                })}
              </Text>
            ),
          }}
          rowSelection={false}
        />
      </Card>

      <AppointmentDetailModal
        open={openDetailModal}
        onClose={() => setOpenDetailModal(false)}
        appointmentId={detailAppointmentId}
      />
    </div>
  );
};

export default AllAppointmentsPage;
