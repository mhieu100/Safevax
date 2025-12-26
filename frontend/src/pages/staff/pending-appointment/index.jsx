import {
  CalendarOutlined,
  CheckCircleOutlined,
  CheckSquareOutlined,
  ClockCircleOutlined,
  EditOutlined,
  PhoneOutlined,
  ReloadOutlined,
  UserOutlined,
} from '@ant-design/icons';
import { Avatar, Button, Card, Space, Tag, Tooltip, Typography } from 'antd';
import dayjs from 'dayjs';
import queryString from 'query-string';
import { useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { sfLike } from 'spring-filter-query-builder';
import DataTable from '@/components/data-table';
import { TIME_SLOT_LABELS } from '@/constants';
import {
  AppointmentStatus,
  formatPaymentAmount,
  getAppointmentStatusColor,
  getAppointmentStatusDisplay,
  getPaymentMethodDisplay,
  getPaymentStatusColor,
  PaymentStatus,
} from '@/constants/enums';
import { useAppointmentStore } from '@/stores/useAppointmentStore';
import ProcessUrgentAppointmentModal from '../dashboard/components/ProcessUrgentAppointmentModal';

const { Text } = Typography;

const PendingAppointmentPage = () => {
  const { t } = useTranslation(['staff']);
  const tableRef = useRef();

  const isFetching = useAppointmentStore((state) => state.isFetching);
  const meta = useAppointmentStore((state) => state.meta);
  const appointments = useAppointmentStore((state) => state.result);
  const fetchAppointmentOfCenter = useAppointmentStore((state) => state.fetchAppointmentOfCenter);
  const [openAssignModal, setOpenAssignModal] = useState(false);
  const [selectedAppointment, setSelectedAppointment] = useState(null);

  const [searchText] = useState('');
  const [vaccineFilter] = useState('');
  const reloadTable = () => {
    tableRef?.current?.reload();
  };

  const handleAssignAppointment = (record) => {
    setSelectedAppointment(record);
    setOpenAssignModal(true);
  };

  const columns = [
    {
      title: t('staff:appointments.columns.code'),
      dataIndex: 'id',
      width: 100,
      fixed: 'left',
      render: (text) => (
        <Text strong style={{ color: '#1890ff' }}>
          #{text}
        </Text>
      ),
    },
    {
      title: t('staff:appointments.columns.patient'),
      dataIndex: 'patientName',
      width: 200,
      render: (text, record) => (
        <Space direction="vertical" size={4}>
          <Space>
            <Avatar icon={<UserOutlined />} size="small" style={{ backgroundColor: '#1890ff' }} />
            <Text strong>{text}</Text>
          </Space>
          {record.appointmentStatus === 'RESCHEDULE' && (
            <Tag color="orange" icon={<EditOutlined />} style={{ fontSize: 11 }}>
              {t('staff:appointments.tags.editSchedule')}
            </Tag>
          )}
          <Text type="secondary" style={{ fontSize: 12 }}>
            <PhoneOutlined /> {record.patientPhone || 'N/A'}
          </Text>
        </Space>
      ),
    },
    {
      title: t('staff:appointments.columns.vaccine'),
      dataIndex: 'vaccineName',
      width: 150,
      render: (text) => <Tag color="blue">{text}</Tag>,
    },
    {
      title: t('staff:appointments.columns.registerDate'),
      dataIndex: 'desiredDate',
      width: 160,
      render: (_text, record) => {
        const dateToShow = record.desiredDate || record.scheduledDate;
        const timeSlotToShow = record.desiredTimeSlot || record.scheduledTimeSlot;
        const isUrgent = dateToShow && dayjs(dateToShow).diff(dayjs(), 'day') <= 1;

        return (
          <Space direction="vertical" size={4}>
            <Space>
              <ClockCircleOutlined style={{ color: isUrgent ? '#ff4d4f' : '#1890ff' }} />
              <Text strong style={{ color: isUrgent ? '#ff4d4f' : undefined }}>
                {dateToShow ? dayjs(dateToShow).format('DD/MM/YYYY') : 'N/A'}
              </Text>
            </Space>
            {timeSlotToShow && (
              <Text type="secondary" style={{ fontSize: 12 }}>
                {TIME_SLOT_LABELS[timeSlotToShow] || timeSlotToShow}
              </Text>
            )}
            {isUrgent && (
              <Tag color="red" icon={<ClockCircleOutlined />} style={{ fontSize: 11 }}>
                {t('staff:appointments.tags.urgent')}
              </Tag>
            )}
          </Space>
        );
      },
    },
    {
      title: t('staff:appointments.columns.officialDate'),
      dataIndex: 'scheduledDate',
      width: 180,
      render: (_text, record) => {
        const scheduledDate = record.scheduledDate;
        const actualTime = record.actualScheduledTime || record.actualDesiredTime;
        const isReschedule = record.appointmentStatus === 'RESCHEDULE';
        const isPending = record.appointmentStatus === AppointmentStatus.PENDING;

        if (!scheduledDate || isPending) {
          return (
            <Space direction="vertical" size={4}>
              <Text type="secondary" style={{ fontSize: 12, fontStyle: 'italic' }}>
                {t('staff:appointments.tags.waitingSchedule')}
              </Text>
              {isReschedule && record.rescheduledAt && (
                <Text type="warning" style={{ fontSize: 11 }}>
                  {t('staff:appointments.tags.rescheduledAt')}{' '}
                  {dayjs(record.rescheduledAt).format('DD/MM HH:mm')}
                </Text>
              )}
            </Space>
          );
        }

        return (
          <Space direction="vertical" size={4}>
            <Space>
              <CalendarOutlined style={{ color: '#52c41a' }} />
              <Text strong style={{ color: '#52c41a' }}>
                {dayjs(scheduledDate).format('DD/MM/YYYY')}
              </Text>
            </Space>
            {actualTime && (
              <Text strong style={{ fontSize: 12, color: '#52c41a' }}>
                {t('staff:appointments.tags.officialTime')} {actualTime.substring(0, 5)}
              </Text>
            )}
            {isReschedule && record.rescheduledAt && (
              <Text type="warning" style={{ fontSize: 11 }}>
                {t('staff:appointments.tags.rescheduledAt')}{' '}
                {dayjs(record.rescheduledAt).format('DD/MM HH:mm')}
              </Text>
            )}
          </Space>
        );
      },
    },
    {
      title: t('staff:appointments.columns.centerDoctor'),
      dataIndex: 'centerName',
      width: 220,
      render: (text, record) => {
        const doctorName = record.doctorName;
        return (
          <Space direction="vertical" size={4}>
            <Text strong>{text}</Text>
            {doctorName ? (
              <Space>
                <UserOutlined style={{ color: '#52c41a', fontSize: 12 }} />
                <Text type="secondary" style={{ fontSize: 12 }}>
                  {doctorName}
                </Text>
              </Space>
            ) : (
              <Text type="secondary" style={{ fontSize: 12, fontStyle: 'italic' }}>
                {t('staff:appointments.tags.waitingDoctor')}
              </Text>
            )}
          </Space>
        );
      },
    },
    {
      title: t('staff:appointments.columns.status'),
      dataIndex: 'appointmentStatus',
      width: 150,
      render: (appointmentStatus) => (
        <Tag color={getAppointmentStatusColor(appointmentStatus)}>
          {getAppointmentStatusDisplay(appointmentStatus)}
        </Tag>
      ),
    },
    {
      title: t('staff:appointments.columns.payment'),
      dataIndex: 'paymentStatus',
      width: 180,
      render: (paymentStatus, record) => {
        const statusLabels = {
          [PaymentStatus.SUCCESS]: t('staff:appointments.payment.success'),
          [PaymentStatus.PROCESSING]: t('staff:appointments.payment.processing'),
          [PaymentStatus.INITIATED]: t('staff:appointments.payment.cash'),
          [PaymentStatus.FAILED]: t('staff:appointments.payment.failed'),
        };

        const paymentDisplay =
          record.paymentAmount != null && record.paymentMethod
            ? formatPaymentAmount(record.paymentAmount, record.paymentMethod)
            : null;

        return (
          <Space direction="vertical" size={4}>
            <Tag color={getPaymentStatusColor(paymentStatus)} style={{ marginBottom: 4 }}>
              {statusLabels[paymentStatus] || paymentStatus || 'Chưa có'}
            </Tag>
            {paymentDisplay ? (
              <>
                {record.paymentMethod && (
                  <Text type="secondary" style={{ fontSize: 12 }}>
                    {getPaymentMethodDisplay(record.paymentMethod)}
                  </Text>
                )}

                <Text strong style={{ fontSize: 14, color: '#1890ff' }}>
                  {paymentDisplay.display}
                </Text>
              </>
            ) : (
              <Text type="secondary" style={{ fontSize: 12 }}>
                {t('staff:appointments.payment.unpaid')}
              </Text>
            )}
          </Space>
        );
      },
    },
    {
      title: t('staff:appointments.columns.actions'),
      key: 'actions',
      width: 200,
      fixed: 'right',
      render: (_, record) => {
        const isPendingSchedule = record.appointmentStatus === AppointmentStatus.PENDING;
        const isPendingApproval = record.appointmentStatus === AppointmentStatus.RESCHEDULE;
        const needsAction = isPendingSchedule || isPendingApproval;

        if (needsAction) {
          return (
            <Space direction="vertical" size={8} style={{ width: '100%' }}>
              {isPendingApproval ? (
                <>
                  <Button
                    type="primary"
                    danger
                    icon={<CheckSquareOutlined />}
                    onClick={() => handleAssignAppointment(record)}
                    block
                    style={{
                      background: '#ff7a45',
                      borderColor: '#ff7a45',
                    }}
                  >
                    {t('staff:appointments.actions.approveReschedule')}
                  </Button>
                  <Text type="warning" style={{ fontSize: 11, textAlign: 'center' }}>
                    {t('staff:appointments.actions.rescheduleRequest')}
                  </Text>
                </>
              ) : (
                <Tooltip title={t('staff:appointments.actions.assignTooltip')}>
                  <Button
                    type="primary"
                    icon={<CalendarOutlined />}
                    onClick={() => handleAssignAppointment(record)}
                    block
                  >
                    {t('staff:appointments.actions.assign')}
                  </Button>
                </Tooltip>
              )}
            </Space>
          );
        }

        return (
          <Tag color="success" icon={<CheckCircleOutlined />} style={{ padding: '4px 12px' }}>
            {t('staff:appointments.tags.assigned')}
          </Tag>
        );
      },
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
    if (vaccineFilter) {
      filters.push(sfLike('vaccineName', vaccineFilter));
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

  return (
    <div style={{ padding: '24px', background: '#f0f2f5', minHeight: '100vh' }}>
      {}
      <Card
        title={
          <Space>
            <ClockCircleOutlined />
            <span>{t('staff:appointments.titleList')}</span>
            <Tag color="warning">
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
          scroll={{ x: 1500 }}
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

      {}
      <ProcessUrgentAppointmentModal
        open={openAssignModal}
        onClose={() => setOpenAssignModal(false)}
        appointment={
          selectedAppointment
            ? {
                ...selectedAppointment,
                urgencyType:
                  selectedAppointment.status === 'RESCHEDULE' ? 'RESCHEDULE_PENDING' : 'NO_DOCTOR',
              }
            : null
        }
        onSuccess={reloadTable}
      />
    </div>
  );
};

export default PendingAppointmentPage;
