import {
  CalendarOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  CloseCircleOutlined,
  HistoryOutlined,
  ShoppingOutlined,
  SyncOutlined,
} from '@ant-design/icons';
import { Card, Empty, message, Skeleton, Table, Tag, Typography } from 'antd';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { getMyOrders } from '@/services/order.service';

const { Title, Text } = Typography;

const MyOrdersPage = () => {
  const { t } = useTranslation('client');
  const [loading, setLoading] = useState(false);
  const [orders, setOrders] = useState([]);

  useEffect(() => {
    fetchOrders();
  }, []);

  const fetchOrders = async () => {
    try {
      setLoading(true);
      const response = await getMyOrders();
      if (response) {
        // Ensure array, backend might return wrapped object
        const data = Array.isArray(response) ? response : response.result || [];
        // Sort by date desc
        data.sort((a, b) => new Date(b.orderDate) - new Date(a.orderDate));
        setOrders(data);
      }
    } catch (error) {
      console.error(error);
      message.error(t('orders.loadError'));
    } finally {
      setLoading(false);
    }
  };

  const getStatusConfig = (status) => {
    const configs = {
      SUCCESS: { color: 'success', text: t('orders.status.completed'), icon: CheckCircleOutlined },
      COMPLETED: {
        color: 'success',
        text: t('orders.status.completed'),
        icon: CheckCircleOutlined,
      },
      PENDING: { color: 'processing', text: t('orders.status.pending'), icon: SyncOutlined },
      INITIATED: { color: 'processing', text: t('orders.status.pending'), icon: SyncOutlined },
      PROCESSING: { color: 'geekblue', text: t('orders.status.processing'), icon: SyncOutlined },
      SHIPPED: { color: 'orange', text: t('orders.status.shipped'), icon: SyncOutlined },
      DELIVERED: {
        color: 'success',
        text: t('orders.status.delivered'),
        icon: CheckCircleOutlined,
      },
      FAILED: { color: 'error', text: t('orders.status.failed'), icon: CloseCircleOutlined },
      CANCELLED: {
        color: 'default',
        text: t('orders.status.cancelled'),
        icon: CloseCircleOutlined,
      },
    };
    return configs[status] || { color: 'default', text: status, icon: ClockCircleOutlined };
  };

  const columns = [
    {
      title: t('orders.columns.orderId'),
      dataIndex: 'orderId',
      key: 'orderId',
      render: (text) => (
        <Text copyable className="font-mono text-xs font-bold text-slate-700">
          {text}
        </Text>
      ),
    },
    {
      title: t('orders.columns.orderDate'),
      dataIndex: 'orderDate',
      key: 'orderDate',
      render: (date) => (
        <div className="flex items-center gap-2 text-slate-600">
          <CalendarOutlined className="text-blue-500" />
          <span>{date}</span>
        </div>
      ),
    },
    {
      title: t('orders.columns.itemCount'),
      dataIndex: 'itemCount',
      key: 'itemCount',
      align: 'center',
      render: (count) => (
        <Tag color="cyan" className="rounded-full px-3">
          {count} {t('orders.itemUnit')}
        </Tag>
      ),
    },
    {
      title: t('orders.columns.total'),
      dataIndex: 'total',
      key: 'total',
      align: 'right',
      render: (amount) => (
        <span className="font-bold text-emerald-600 text-base">
          {new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount)}
        </span>
      ),
    },
    {
      title: t('orders.columns.status'),
      dataIndex: 'status',
      key: 'status',
      align: 'center',
      render: (status) => {
        const config = getStatusConfig(status);
        const Icon = config.icon;
        return (
          <Tag
            icon={<Icon spin={status === 'PENDING' || status === 'PROCESSING'} />}
            color={config.color}
            className="rounded-full px-3 py-0.5 border-0 font-medium"
          >
            {config.text}
          </Tag>
        );
      },
    },
  ];

  return (
    <div className="min-h-[calc(100vh-130px)] lg:h-[calc(100vh-130px)] bg-slate-50 py-8 lg:overflow-hidden flex flex-col animate-fade-in">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 w-full lg:h-full lg:overflow-y-auto hide-scrollbar">
        {/* Header Section */}
        <div className="mb-6 flex items-center gap-3">
          <div className="p-3 bg-indigo-600 rounded-xl text-white shadow-lg shadow-indigo-500/30">
            <ShoppingOutlined className="text-2xl" />
          </div>
          <div>
            <Title level={2} className="!mb-0">
              {t('orders.title')}
            </Title>
            <Text type="secondary">{t('orders.subtitle')}</Text>
          </div>
        </div>

        {loading ? (
          <div className="space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
              {[1, 2, 3].map((i) => (
                <Card key={i} className="rounded-2xl shadow-sm border border-slate-100">
                  <Skeleton active paragraph={{ rows: 1 }} title={{ width: 60 }} />
                </Card>
              ))}
            </div>
            <Card className="rounded-3xl shadow-sm border border-slate-100 overflow-hidden">
              <Skeleton active paragraph={{ rows: 5 }} />
            </Card>
          </div>
        ) : (
          <>
            {/* Summary Cards */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
              <Card
                size="small"
                className="rounded-2xl shadow-sm border border-slate-100 bg-gradient-to-br from-indigo-50 to-white"
              >
                <div className="flex items-center justify-between p-2">
                  <div>
                    <Text className="text-slate-500 font-medium uppercase text-xs tracking-wider">
                      {t('orders.summary.totalOrders')}
                    </Text>
                    <div className="text-3xl font-bold text-indigo-600 mt-1">{orders.length}</div>
                  </div>
                  <div className="w-12 h-12 rounded-full bg-indigo-100 flex items-center justify-center">
                    <HistoryOutlined className="text-2xl text-indigo-600" />
                  </div>
                </div>
              </Card>

              <Card
                size="small"
                className="rounded-2xl shadow-sm border border-slate-100 bg-gradient-to-br from-emerald-50 to-white"
              >
                <div className="flex items-center justify-between p-2">
                  <div>
                    <Text className="text-slate-500 font-medium uppercase text-xs tracking-wider">
                      {t('orders.summary.successOrders')}
                    </Text>
                    <div className="text-3xl font-bold text-emerald-600 mt-1">
                      {
                        orders.filter(
                          (o) =>
                            o.status === 'SUCCESS' ||
                            o.status === 'COMPLETED' ||
                            o.status === 'DELIVERED'
                        ).length
                      }
                    </div>
                  </div>
                  <div className="w-12 h-12 rounded-full bg-emerald-100 flex items-center justify-center">
                    <CheckCircleOutlined className="text-2xl text-emerald-600" />
                  </div>
                </div>
              </Card>

              <Card
                size="small"
                className="rounded-2xl shadow-sm border border-slate-100 bg-gradient-to-br from-amber-50 to-white"
              >
                <div className="flex items-center justify-between p-2">
                  <div>
                    <Text className="text-slate-500 font-medium uppercase text-xs tracking-wider">
                      {t('orders.summary.processingOrders')}
                    </Text>
                    <div className="text-3xl font-bold text-amber-600 mt-1">
                      {
                        orders.filter((o) =>
                          ['PENDING', 'PROCESSING', 'INITIATED', 'SHIPPED'].includes(o.status)
                        ).length
                      }
                    </div>
                  </div>
                  <div className="w-12 h-12 rounded-full bg-amber-100 flex items-center justify-center">
                    <ClockCircleOutlined className="text-2xl text-amber-600" />
                  </div>
                </div>
              </Card>
            </div>

            {/* Main Table */}
            <Card
              className="rounded-3xl shadow-sm border border-slate-100 overflow-hidden"
              bodyStyle={{ padding: 0 }}
            >
              {orders.length > 0 ? (
                <Table
                  columns={columns}
                  dataSource={orders}
                  rowKey="orderId"
                  pagination={{ pageSize: 10 }}
                  className="custom-table"
                  scroll={{ x: 'max-content' }}
                />
              ) : (
                <div className="p-12 text-center">
                  <Empty description={t('orders.noOrders')} />
                </div>
              )}
            </Card>
          </>
        )}
      </div>
    </div>
  );
};

export default MyOrdersPage;
