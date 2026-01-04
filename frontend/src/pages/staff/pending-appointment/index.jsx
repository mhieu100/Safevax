import {
  CalendarOutlined,
  CheckSquareOutlined,
  ClockCircleOutlined,
  EditOutlined,
  InfoCircleOutlined,
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
import { useAppointmentStore } from '@/stores/useAppointmentStore';
import ProcessUrgentAppointmentModal from '../dashboard/components/ProcessUrgentAppointmentModal';
import AppointmentDetailModal from './AppointmentDetailModal';

const { Text } = Typography;

const PendingAppointmentPage = () => {
  const { t } = useTranslation(['staff']);
  const tableRef = useRef();

  const isFetching = useAppointmentStore((state) => state.isFetching);
  const meta = useAppointmentStore((state) => state.meta);
  const appointments = useAppointmentStore((state) => state.result);
  const fetchPendingAppointmentOfCenter = useAppointmentStore(
    (state) => state.fetchPendingAppointmentOfCenter
  );
  const [openAssignModal, setOpenAssignModal] = useState(false);
  const [selectedAppointment, setSelectedAppointment] = useState(null);
  const [openDetailModal, setOpenDetailModal] = useState(false);
  const [detailAppointmentId, setDetailAppointmentId] = useState(null);

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
      width: 250,
      render: (text, record) => (
        <Space direction="vertical" size={2}>
          <Space>
            <Avatar icon={<UserOutlined />} size="small" style={{ backgroundColor: '#1890ff' }} />
            <Text strong>{text}</Text>
          </Space>
          <Space split={<div className="w-[1px] h-3 bg-slate-300 mx-1" />}>
            <span className="text-xs text-slate-500 flex items-center gap-1">
              <PhoneOutlined /> {record.patientPhone || 'N/A'}
            </span>
            {record.appointmentStatus === 'RESCHEDULE' && (
              <Tag
                color="orange"
                icon={<EditOutlined />}
                className="m-0 text-[10px] leading-4 h-5 px-1"
              >
                {t('staff:appointments.tags.editSchedule')}
              </Tag>
            )}
          </Space>
        </Space>
      ),
    },
    {
      title: t('staff:appointments.columns.vaccine'),
      dataIndex: 'vaccineName',
      width: 200,
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
      title: t('staff:appointments.columns.registerDate'), // Target Schedule
      dataIndex: 'desiredDate',
      width: 200,
      render: (_text, record) => {
        const dateToShow = record.desiredDate || record.scheduledDate;
        const timeSlotToShow = record.desiredTimeSlot || record.scheduledTimeSlot;
        // Logic to highlight if it's close? content already handles logic but let's keep it simple
        const isUrgent = dateToShow && dayjs(dateToShow).diff(dayjs(), 'day') <= 1;

        return (
          <Space direction="vertical" size={2}>
            <div
              className={`flex items-center gap-2 ${isUrgent ? 'text-red-500' : 'text-slate-700'}`}
            >
              <CalendarOutlined />
              <span className="font-medium">
                {dateToShow ? dayjs(dateToShow).format('DD/MM/YYYY') : 'N/A'}
              </span>
            </div>
            {timeSlotToShow && (
              <div className="flex items-center gap-2 text-slate-500 text-xs pl-6">
                <ClockCircleOutlined />
                {TIME_SLOT_LABELS[timeSlotToShow] || timeSlotToShow}
              </div>
            )}
            {isUrgent && (
              <span className="text-[10px] text-red-500 font-medium pl-6">
                {t('staff:appointments.tags.urgent')}
              </span>
            )}
          </Space>
        );
      },
    },
    {
      title: t('staff:appointments.columns.actions'),
      key: 'actions',
      width: 150,
      render: (_, record) => {
        // Both Pending and Reschedule need assignment/processing
        const isReschedule = record.appointmentStatus === 'RESCHEDULE';

        return (
          <Space>
            <Tooltip
              title={
                isReschedule
                  ? t('staff:appointments.actions.approveReschedule')
                  : t('staff:appointments.actions.assign')
              }
            >
              <Button
                type="primary"
                // Use distinct colors for Reschedule vs Initial
                className={`${isReschedule ? 'bg-orange-500 hover:bg-orange-600' : 'bg-blue-600 hover:bg-blue-700'} border-none shadow-sm`}
                icon={isReschedule ? <CheckSquareOutlined /> : <CalendarOutlined />}
                onClick={() => handleAssignAppointment(record)}
              />
            </Tooltip>
            <Tooltip title={t('staff:appointments.actions.detail')}>
              <Button
                type="default"
                icon={<InfoCircleOutlined />}
                onClick={() => {
                  setDetailAppointmentId(record.id);
                  setOpenDetailModal(true);
                }}
              />
            </Tooltip>
          </Space>
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
            fetchPendingAppointmentOfCenter(query);
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
      <AppointmentDetailModal
        open={openDetailModal}
        onClose={() => setOpenDetailModal(false)}
        appointmentId={detailAppointmentId}
      />
    </div>
  );
};

export default PendingAppointmentPage;
