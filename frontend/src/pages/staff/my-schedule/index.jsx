import { CheckOutlined, CloseOutlined, EyeOutlined } from '@ant-design/icons';
import { Badge, Button, message, notification, Space, Tag, Tooltip } from 'antd';
import queryString from 'query-string';
import { useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { sfLike } from 'spring-filter-query-builder';
import DataTable from '@/components/data-table';
import { AppointmentStatus, getAppointmentStatusColor } from '@/constants/enums';
import { callCancelAppointment } from '@/services/appointment.service';
import { useAppointmentStore } from '@/stores/useAppointmentStore';
import { formatAppointmentTime } from '@/utils/appointment';
import CompletionModal from '../dashboard/components/CompletionModal';
import AppointmentDetailModal from '../pending-appointment/AppointmentDetailModal';

const MySchedulePage = () => {
  const { t } = useTranslation(['staff']);
  const tableRef = useRef();

  const isFetching = useAppointmentStore((state) => state.isFetching);
  const meta = useAppointmentStore((state) => state.meta);
  const appointments = useAppointmentStore((state) => state.result);
  const fetchAppointmentOfDoctor = useAppointmentStore((state) => state.fetchAppointmentOfDoctor);

  const [completionModalOpen, setCompletionModalOpen] = useState(false);
  const [detailModalOpen, setDetailModalOpen] = useState(false);
  const [selectedAppointment, setSelectedAppointment] = useState(null);

  const reloadTable = () => {
    tableRef?.current?.reload();
  };

  const handleComplete = (record) => {
    setSelectedAppointment({
      id: record.id,
      patient: record.patientName,
      patientId: record.patientId,
      vaccine: record.vaccineName,
    });
    setCompletionModalOpen(true);
  };

  const handleView = (record) => {
    setSelectedAppointment(record);
    setDetailModalOpen(true);
  };

  const handleCancel = async (id) => {
    if (id) {
      const res = await callCancelAppointment(id);
      if (res) {
        message.success(t('staff:appointments.cancelSuccess'));
        reloadTable();
      } else {
        notification.error({
          message: res.error,
          description: res.message,
        });
      }
    }
  };

  const columns = [
    {
      title: t('staff:appointments.columns.index'),
      key: 'index',
      width: 50,
      align: 'center',
      render: (_text, _record, index) => index + 1,
      hideInSearch: true,
    },
    {
      title: t('staff:appointments.columns.vaccine'),
      dataIndex: 'vaccineName',
    },
    {
      title: t('staff:appointments.columns.patient'),
      dataIndex: 'patientName',
    },
    {
      title: t('staff:appointments.columns.center'),
      dataIndex: 'centerName',
    },
    {
      title: t('staff:appointments.columns.injectionDate'),
      dataIndex: 'scheduledDate',
    },
    {
      title: t('staff:appointments.columns.injectionTime'),
      dataIndex: 'scheduledTime',
      render: (_, record) => formatAppointmentTime(record),
    },
    {
      title: t('staff:appointments.columns.doctor'),
      dataIndex: 'doctorName',
      render: (text) => {
        return text ? (
          <Badge color="green" text={text} />
        ) : (
          <Badge color="red" text={t('staff:appointments.tags.update')} />
        );
      },
    },
    {
      title: t('staff:appointments.columns.cashier'),
      dataIndex: 'cashierName',
      render: (text) => {
        return text ? (
          <Badge color="green" text={text} />
        ) : (
          <Badge color="red" text={t('staff:appointments.tags.update')} />
        );
      },
    },
    {
      title: t('staff:appointments.columns.status'),
      dataIndex: 'appointmentStatus',
      render: (appointmentStatus) => {
        return (
          <Tag color={getAppointmentStatusColor(appointmentStatus)}>
            {t(`staff:appointments.status.${appointmentStatus}`)}
          </Tag>
        );
      },
    },
    {
      title: t('staff:appointments.columns.actions'),
      width: 150,
      render: (_value, entity) => (
        <Space>
          <Tooltip title={t('staff:common.view')}>
            <Button icon={<EyeOutlined />} onClick={() => handleView(entity)} />
          </Tooltip>
          {entity.appointmentStatus === AppointmentStatus.SCHEDULED && (
            <>
              <Tooltip title={t('staff:appointments.actions.confirm')}>
                <Button
                  type="primary"
                  icon={<CheckOutlined />}
                  onClick={() => handleComplete(entity)}
                  style={{ backgroundColor: '#4f46e5', borderColor: '#4f46e5' }}
                />
              </Tooltip>
              <Tooltip title={t('staff:appointments.actions.cancelAppointment')}>
                <Button danger icon={<CloseOutlined />} onClick={() => handleCancel(entity.id)} />
              </Tooltip>
            </>
          )}
        </Space>
      ),
    },
  ];

  const buildQuery = (params, sort) => {
    const clone = { ...params };
    const q = {
      page: params.current,
      size: params.pageSize,
      filter: '',
    };

    if (clone.name) q.filter = `${sfLike('name', clone.name)}`;
    if (clone.manufacturer) {
      q.filter = clone.name
        ? `${q.filter} and ${sfLike('manufacturer', clone.manufacturer)}`
        : `${sfLike('manufacturer', clone.manufacturer)}`;
    }

    if (!q.filter) delete q.filter;

    let temp = queryString.stringify(q);

    let sortBy = '';
    if (sort?.name) {
      sortBy = sort.name === 'ascend' ? 'sort=name,asc' : 'sort=name,desc';
    }
    if (sort?.manufacturer) {
      sortBy = sort.manufacturer === 'ascend' ? 'sort=manufacturer,asc' : 'sort=manufacturer,desc';
    }

    if (sort?.price) {
      sortBy = sort.price === 'ascend' ? 'sort=price,asc' : 'sort=price,desc';
    }
    if (sort?.stockQuantity) {
      sortBy =
        sort.stockQuantity === 'ascend' ? 'sort=stockQuantity,asc' : 'sort=stockQuantity,desc';
    }
    temp = `${temp}&${sortBy}`;

    return temp;
  };

  return (
    <>
      <DataTable
        actionRef={tableRef}
        headerTitle={t('staff:appointments.todayList')}
        rowKey="id"
        loading={isFetching}
        columns={columns}
        dataSource={appointments}
        request={async (params, sort, filter) => {
          const query = buildQuery(params, sort, filter);
          fetchAppointmentOfDoctor(query);
        }}
        scroll={{ x: true }}
        pagination={{
          current: meta.page,
          pageSize: meta.pageSize,
          showSizeChanger: true,
          total: meta.total,
          showTotal: (total, range) => {
            return (
              <div>
                {t('staff:appointments.pagination', {
                  range0: range[0],
                  range1: range[1],
                  total: total,
                })}
              </div>
            );
          },
        }}
        rowSelection={false}
      />
      <CompletionModal
        open={completionModalOpen}
        onCancel={() => setCompletionModalOpen(false)}
        appointment={selectedAppointment}
        onSuccess={() => {
          reloadTable();
        }}
      />
      <AppointmentDetailModal
        open={detailModalOpen}
        onClose={() => setDetailModalOpen(false)}
        appointmentId={selectedAppointment?.id}
      />
    </>
  );
};

export default MySchedulePage;
