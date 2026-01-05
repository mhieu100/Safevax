import { CalendarOutlined } from '@ant-design/icons';
import { notification, Tooltip } from 'antd';
import queryString from 'query-string';
import { useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { sfLike } from 'spring-filter-query-builder';
import DataTable from '@/components/data-table';
import { callFetchPatients } from '@/services/user.service';
import WalkInBookingModal from './components/WalkInBookingModal';

const WalkInBookingPage = () => {
  const { t } = useTranslation(['staff']);
  const tableRef = useRef();
  const [openModal, setOpenModal] = useState(false);
  const [loading, setLoading] = useState(false);
  const [selectedPatient, setSelectedPatient] = useState(null);
  const [patients, setPatients] = useState([]);
  const [meta, setMeta] = useState({
    page: 1,
    pageSize: 10,
    total: 0,
    pages: 0,
  });

  const _reloadTable = () => {
    tableRef?.current?.reload();
  };

  const fetchPatients = async (query) => {
    setLoading(true);
    try {
      const res = await callFetchPatients(query);
      if (res?.data) {
        setPatients(res.data.result || []);
        setMeta(res.data.meta || meta);
      }
    } catch (_error) {
      notification.error({
        message: t('staff:walkIn.error.title'),
        description: t('staff:walkIn.error.loadPatients'),
      });
    } finally {
      setLoading(false);
    }
  };

  const handleCreateBooking = (patient) => {
    setSelectedPatient(patient);
    setOpenModal(true);
  };

  const columns = [
    {
      title: t('staff:walkIn.columns.index'),
      key: 'index',
      width: 50,
      align: 'center',
      hideInSearch: true,
      render: (_text, _record, index) => {
        return <>{index + 1 + (meta.page - 1) * meta.pageSize}</>;
      },
    },
    {
      title: t('staff:walkIn.columns.fullName'),
      dataIndex: 'fullName',
      sorter: true,
    },
    {
      title: t('staff:walkIn.columns.email'),
      dataIndex: 'email',
      sorter: true,
    },
    {
      title: t('staff:walkIn.columns.phone'),
      dataIndex: ['patientProfile', 'phone'],
      hideInSearch: true,
    },
    {
      title: t('staff:walkIn.columns.address'),
      dataIndex: ['patientProfile', 'address'],
      sorter: true,
    },
    {
      title: t('staff:walkIn.columns.dob'),
      dataIndex: ['patientProfile', 'birthday'],
      hideInSearch: true,
    },
    {
      title: t('staff:walkIn.columns.actions'),
      hideInSearch: true,
      width: 150,
      align: 'center',
      render: (_value, entity) => (
        <Tooltip title={t('staff:walkIn.actions.book')}>
          <CalendarOutlined
            style={{
              fontSize: 20,
              color: '#1890ff',
              cursor: 'pointer',
            }}
            onClick={() => handleCreateBooking(entity)}
          />
        </Tooltip>
      ),
    },
  ];

  const buildQuery = (params, sort) => {
    const clone = { ...params };
    const q = {
      page: clone.current,
      size: clone.pageSize,
    };

    const filters = [];
    if (clone.fullName) {
      filters.push(sfLike('fullName', clone.fullName));
    }
    if (clone.email) {
      filters.push(sfLike('email', clone.email));
    }
    if (clone.address) {
      filters.push(sfLike('patientProfile.address', clone.address));
    }

    if (filters.length > 0) {
      q.filter = filters.join(' and ');
    }

    if (sort?.fullName) {
      q.sort = `fullName,${sort.fullName === 'ascend' ? 'asc' : 'desc'}`;
    } else if (sort?.email) {
      q.sort = `email,${sort.email === 'ascend' ? 'asc' : 'desc'}`;
    } else if (sort?.address) {
      q.sort = `patientProfile.address,${sort.address === 'ascend' ? 'asc' : 'desc'}`;
    } else {
      q.sort = 'fullName,asc';
    }

    return queryString.stringify(q);
  };

  return (
    <>
      <DataTable
        actionRef={tableRef}
        headerTitle={t('staff:walkIn.title')}
        rowKey="id"
        loading={loading}
        columns={columns}
        dataSource={patients}
        request={async (params, sort, filter) => {
          const query = buildQuery(params, sort, filter);
          await fetchPatients(query);
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
                {t('staff:walkIn.pagination.range', { range0: range[0], range1: range[1], total })}
              </div>
            );
          },
        }}
        rowSelection={false}
      />
      <WalkInBookingModal
        open={openModal}
        setOpen={setOpenModal}
        patient={selectedPatient}
        onSuccess={() => {
          setOpenModal(false);
          setSelectedPatient(null);
        }}
      />
    </>
  );
};

export default WalkInBookingPage;
