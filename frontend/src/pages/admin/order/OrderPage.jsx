import {
  CalendarOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  CloseCircleOutlined,
  EyeOutlined,
  MailOutlined,
  PhoneOutlined,
  SearchOutlined,
  ShoppingOutlined,
  SyncOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  Avatar,
  Button,
  Card,
  Descriptions,
  Divider,
  Image,
  Input,
  List,
  Modal,
  message,
  Select,
  Space,
  Table,
  Tag,
  Tooltip,
  Typography,
} from 'antd';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import {
  getAllOrdersAdmin,
  getOrderDetailAdmin,
  updateOrderStatus,
} from '@/services/order.service';

const { Title, Text } = Typography;

const AdminOrderPage = () => {
  const { t } = useTranslation('admin');
  const [loading, setLoading] = useState(false);
  const [orders, setOrders] = useState([]);
  const [searchText, setSearchText] = useState('');
  const [detailModalVisible, setDetailModalVisible] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [detailLoading, setDetailLoading] = useState(false);
  const [statusUpdateLoading, setStatusUpdateLoading] = useState(false);

  useEffect(() => {
    fetchOrders();
  }, []);

  const fetchOrders = async () => {
    try {
      setLoading(true);
      const response = await getAllOrdersAdmin();
      if (response) {
        const data = Array.isArray(response) ? response : response.result || [];
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

  const handleViewDetail = async (orderId) => {
    try {
      setDetailLoading(true);
      setDetailModalVisible(true);
      const response = await getOrderDetailAdmin(orderId);
      setSelectedOrder(response);
    } catch (error) {
      console.error(error);
      message.error(t('orders.loadDetailError'));
    } finally {
      setDetailLoading(false);
    }
  };

  const handleStatusChange = async (newStatus) => {
    if (!selectedOrder) return;
    try {
      setStatusUpdateLoading(true);
      await updateOrderStatus(selectedOrder.orderId, newStatus);
      message.success(t('orders.statusUpdateSuccess'));

      // Update local state
      setSelectedOrder({ ...selectedOrder, status: newStatus });
      setOrders(
        orders.map((o) => (o.orderId === selectedOrder.orderId ? { ...o, status: newStatus } : o))
      );
    } catch (error) {
      console.error(error);
      message.error(t('orders.statusUpdateError'));
    } finally {
      setStatusUpdateLoading(false);
    }
  };

  const filteredOrders = orders.filter(
    (order) =>
      order.orderId.toString().includes(searchText) ||
      order.customerName?.toLowerCase().includes(searchText.toLowerCase())
  );

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
      width: 100,
      render: (text) => (
        <Text copyable className="font-mono font-bold text-blue-600">
          {text}
        </Text>
      ),
    },
    {
      title: t('orders.columns.customer'),
      dataIndex: 'customerName',
      key: 'customerName',
      render: (text) => (
        <div className="flex items-center gap-2">
          <UserOutlined className="text-slate-400" />
          <span className="font-medium text-slate-700">{text || 'N/A'}</span>
        </div>
      ),
    },
    {
      title: t('orders.columns.orderDate'),
      dataIndex: 'orderDate',
      key: 'orderDate',
      render: (date) => (
        <div className="flex items-center gap-2 text-slate-500">
          <CalendarOutlined />
          <span>{date}</span>
        </div>
      ),
    },
    {
      title: t('orders.columns.itemCount'),
      dataIndex: 'itemCount',
      key: 'itemCount',
      align: 'center',
      width: 80,
      render: (count) => <Tag>{count}</Tag>,
    },
    {
      title: t('orders.columns.total'),
      dataIndex: 'total',
      key: 'total',
      align: 'right',
      render: (amount) => (
        <span className="font-bold text-emerald-600">
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
            icon={<Icon spin={['PENDING', 'PROCESSING'].includes(status)} />}
            color={config.color}
            className="min-w-[100px] text-center"
          >
            {config.text}
          </Tag>
        );
      },
    },
    {
      title: t('orders.columns.actions'),
      key: 'action',
      align: 'center',
      width: 100,
      render: (_, record) => (
        <Space size="small">
          <Tooltip title={t('orders.viewDetail')}>
            <Button
              type="text"
              shape="circle"
              icon={<EyeOutlined className="text-blue-500" />}
              onClick={() => handleViewDetail(record.orderId)}
            />
          </Tooltip>
        </Space>
      ),
    },
  ];

  return (
    <div className="p-6">
      <div className="mb-6 flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <Title level={2} className="!mb-0 flex items-center gap-3">
            <ShoppingOutlined /> {t('orders.title')}
          </Title>
          <Text type="secondary">{t('orders.subtitle')}</Text>
        </div>

        <Input
          placeholder={t('orders.searchPlaceholder')}
          prefix={<SearchOutlined className="text-slate-400" />}
          className="max-w-md h-10 rounded-lg"
          value={searchText}
          onChange={(e) => setSearchText(e.target.value)}
        />
      </div>

      <Card className="shadow-sm rounded-xl border border-slate-100" bodyStyle={{ padding: 0 }}>
        <Table
          columns={columns}
          dataSource={filteredOrders}
          rowKey="orderId"
          loading={loading}
          pagination={{ pageSize: 10, showSizeChanger: true }}
        />
      </Card>

      {/* Order Detail Modal */}
      <Modal
        title={
          <div className="flex items-center gap-2">
            <ShoppingOutlined className="text-blue-600" />
            <span>
              {t('orders.detailModal.title')} #{selectedOrder?.orderId}
            </span>
          </div>
        }
        open={detailModalVisible}
        onCancel={() => {
          setDetailModalVisible(false);
          setSelectedOrder(null);
        }}
        footer={null}
        width={700}
        loading={detailLoading}
      >
        {selectedOrder && (
          <div className="space-y-6">
            {/* Customer Info */}
            <div>
              <Title level={5} className="!mb-3">
                <UserOutlined className="mr-2" />
                {t('orders.detailModal.customerInfo')}
              </Title>
              <Descriptions bordered size="small" column={1}>
                <Descriptions.Item label={t('orders.detailModal.customerName')}>
                  {selectedOrder.customerName || 'N/A'}
                </Descriptions.Item>
                <Descriptions.Item
                  label={
                    <>
                      <MailOutlined className="mr-1" /> Email
                    </>
                  }
                >
                  {selectedOrder.customerEmail || 'N/A'}
                </Descriptions.Item>
                <Descriptions.Item
                  label={
                    <>
                      <PhoneOutlined className="mr-1" /> {t('orders.detailModal.phone')}
                    </>
                  }
                >
                  {selectedOrder.customerPhone || 'N/A'}
                </Descriptions.Item>
              </Descriptions>
            </div>

            <Divider />

            {/* Order Info */}
            <div>
              <Title level={5} className="!mb-3">
                <CalendarOutlined className="mr-2" />
                {t('orders.detailModal.orderInfo')}
              </Title>
              <Descriptions bordered size="small" column={2}>
                <Descriptions.Item label={t('orders.detailModal.orderDate')}>
                  {selectedOrder.orderDate}
                </Descriptions.Item>
                <Descriptions.Item label={t('orders.detailModal.paymentMethod')}>
                  <Tag color="blue">{selectedOrder.paymentMethod || 'N/A'}</Tag>
                </Descriptions.Item>
                <Descriptions.Item label={t('orders.detailModal.paymentStatus')}>
                  <Tag color={selectedOrder.paymentStatus === 'SUCCESS' ? 'success' : 'processing'}>
                    {selectedOrder.paymentStatus || 'N/A'}
                  </Tag>
                </Descriptions.Item>
                <Descriptions.Item label={t('orders.detailModal.status')}>
                  <Select
                    value={selectedOrder.status}
                    onChange={handleStatusChange}
                    loading={statusUpdateLoading}
                    style={{ width: 150 }}
                    options={[
                      { value: 'PENDING', label: t('orders.status.pending') },
                      { value: 'PROCESSING', label: t('orders.status.processing') },
                      { value: 'SHIPPED', label: t('orders.status.shipped') },
                      { value: 'DELIVERED', label: t('orders.status.delivered') },
                      { value: 'CANCELLED', label: t('orders.status.cancelled') },
                    ]}
                  />
                </Descriptions.Item>
              </Descriptions>
            </div>

            <Divider />

            {/* Order Items */}
            <div>
              <Title level={5} className="!mb-3">
                {t('orders.detailModal.orderItems')} ({selectedOrder.itemCount})
              </Title>
              <List
                itemLayout="horizontal"
                dataSource={selectedOrder.items || []}
                renderItem={(item) => (
                  <List.Item>
                    <List.Item.Meta
                      avatar={
                        <Avatar
                          shape="square"
                          size={64}
                          src={
                            item.vaccineImage ? (
                              <Image
                                src={item.vaccineImage}
                                alt={item.vaccineName}
                                preview={false}
                              />
                            ) : null
                          }
                          icon={!item.vaccineImage && <ShoppingOutlined />}
                        />
                      }
                      title={<span className="font-medium">{item.vaccineName}</span>}
                      description={
                        <div className="text-sm text-slate-500">
                          <div>
                            {t('orders.detailModal.quantity')}: {item.quantity}
                          </div>
                          <div>
                            {t('orders.detailModal.price')}:{' '}
                            {new Intl.NumberFormat('vi-VN', {
                              style: 'currency',
                              currency: 'VND',
                            }).format(item.price)}
                          </div>
                        </div>
                      }
                    />
                    <div className="font-bold text-emerald-600">
                      {new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND',
                      }).format(item.subtotal)}
                    </div>
                  </List.Item>
                )}
              />
            </div>

            <Divider />

            {/* Total */}
            <div className="flex justify-between items-center bg-slate-50 p-4 rounded-lg">
              <span className="text-lg font-medium">{t('orders.detailModal.total')}:</span>
              <span className="text-2xl font-bold text-emerald-600">
                {new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(
                  selectedOrder.total
                )}
              </span>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
};

export default AdminOrderPage;
