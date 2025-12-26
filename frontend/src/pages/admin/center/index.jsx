import { DeleteOutlined, EditOutlined, PlusOutlined } from '@ant-design/icons';
import { Button, message, notification, Popconfirm, Space } from 'antd';
import queryString from 'query-string';
import { useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { sfLike } from 'spring-filter-query-builder';
import DataTable from '@/components/data-table';
import { callDeleteCenter } from '@/services/center.service';
import { useCenterStore } from '@/stores/useCenterStore';
import ModalCenter from './components/CenterModal';

const CenterPage = () => {
  const { t } = useTranslation(['admin']);
  const tableRef = useRef();

  const reloadTable = () => {
    tableRef?.current?.reload();
  };

  const [dataInit, setDataInit] = useState(null);

  const isFetching = useCenterStore((state) => state.isFetching);
  const meta = useCenterStore((state) => state.meta);
  const centers = useCenterStore((state) => state.result);
  const fetchCenter = useCenterStore((state) => state.fetchCenter);
  const [openModal, setOpenModal] = useState(false);

  const handleDeleteCompany = async (id) => {
    if (id) {
      const res = await callDeleteCenter(id);
      message.success(t('admin:centers.deleteSuccess'));
      reloadTable();
      if (res) {
        notification.error({
          message: t('admin:centers.error'),
          description: res.message,
        });
      }
    }
  };

  const columns = [
    {
      title: t('admin:centers.stt'),
      key: 'index',
      width: 50,
      align: 'center',
      render: (_text, _record, index) => {
        return <>{index + 1 + (meta.page - 1) * meta.pageSize}</>;
      },
      hideInSearch: true,
    },
    {
      title: t('admin:centers.image'),
      dataIndex: 'image',
      hideInSearch: true,
      render: (text) => (
        <img
          src={text}
          alt="center"
          style={{
            width: '50px',
            height: 'auto',
            objectFit: 'cover',
            borderRadius: '8px',
          }}
        />
      ),
    },
    {
      title: t('admin:centers.centerName'),
      dataIndex: 'name',
      sorter: true,
    },
    {
      title: t('admin:centers.address'),
      dataIndex: 'address',
      sorter: true,
    },
    {
      title: t('admin:centers.phone'),
      dataIndex: 'phoneNumber',
      hideInSearch: true,
    },
    {
      title: t('admin:centers.capacity'),
      dataIndex: 'capacity',
      hideInSearch: true,
      sorter: true,
    },
    {
      title: t('admin:centers.workingHours'),
      hideInSearch: true,
      dataIndex: 'workingHours',
    },
    {
      title: t('admin:centers.actions'),
      hideInSearch: true,
      width: 50,
      render: (_value, entity) => (
        <Space>
          <EditOutlined
            style={{
              fontSize: 20,
              color: '#ffa500',
            }}
            onClick={() => {
              setOpenModal(true);
              setDataInit(entity);
            }}
          />

          <Popconfirm
            placement="leftTop"
            title={t('admin:centers.confirmDeleteTitle')}
            description={t('admin:centers.confirmDelete')}
            onConfirm={() => handleDeleteCompany(entity.centerId)}
            okText={t('common:modal.confirm')}
            cancelText={t('common:modal.cancel')}
          >
            <span style={{ cursor: 'pointer', margin: '0 10px' }}>
              <DeleteOutlined
                style={{
                  fontSize: 20,
                  color: '#ff4d4f',
                }}
              />
            </span>
          </Popconfirm>
        </Space>
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
    if (clone.name) {
      filters.push(sfLike('name', clone.name));
    }
    if (clone.address) {
      filters.push(sfLike('address', clone.address));
    }

    if (filters.length > 0) {
      q.filter = filters.join(' and ');
    }

    if (sort?.name) {
      q.sort = `name,${sort.name === 'ascend' ? 'asc' : 'desc'}`;
    }
    if (sort?.address) {
      q.sort = `address,${sort.address === 'ascend' ? 'asc' : 'desc'}`;
    }
    if (sort?.capacity) {
      q.sort = `capacity,${sort.capacity === 'ascend' ? 'asc' : 'desc'}`;
    }
    if (!q.sort) {
      q.sort = 'name,asc';
    }

    return queryString.stringify(q);
  };

  return (
    <>
      <DataTable
        actionRef={tableRef}
        headerTitle={t('admin:centers.centerList')}
        rowKey="centerId"
        loading={isFetching}
        columns={columns}
        dataSource={centers}
        request={async (params, sort, filter) => {
          const query = buildQuery(params, sort, filter);
          fetchCenter(query);
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
                {t('admin:centers.pagination', {
                  range0: range[0],
                  range1: range[1],
                  total: total,
                })}
              </div>
            );
          },
        }}
        rowSelection={false}
        toolBarRender={() => {
          return (
            <Button icon={<PlusOutlined />} type="primary" onClick={() => setOpenModal(true)}>
              {t('admin:centers.addCenter')}
            </Button>
          );
        }}
      />
      <ModalCenter
        openModal={openModal}
        setOpenModal={setOpenModal}
        reloadTable={reloadTable}
        dataInit={dataInit}
        setDataInit={setDataInit}
      />
    </>
  );
};
export default CenterPage;
