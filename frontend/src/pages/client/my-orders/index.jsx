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
import { getMyOrders } from '@/services/order.service';

const { Title, Text } = Typography;

const MyOrdersPage = () => {
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
      message.error('Không thể tải lịch sử đơn hàng');
    } finally {
      setLoading(false);
    }
  };

  const columns = [
    {
      title: 'Mã Đơn',
      dataIndex: 'orderId',
      key: 'orderId',
      render: (text) => (
        <Text copyable className="font-mono text-xs font-bold text-slate-700">
          {text}
        </Text>
      ),
    },
    {
      title: 'Ngày đặt',
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
      title: 'Sản phẩm',
      dataIndex: 'itemCount',
      key: 'itemCount',
      align: 'center',
      render: (count) => (
        <Tag color="cyan" className="rounded-full px-3">
          {count} sản phẩm
        </Tag>
      ),
    },
    {
      title: 'Tổng tiền',
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
      title: 'Trạng thái',
      dataIndex: 'status',
      key: 'status',
      align: 'center',
      render: (status) => {
        let color = 'default';
        let text = status;
        let Icon = ClockCircleOutlined;

        switch (status) {
          case 'SUCCESS':
          case 'COMPLETED':
            color = 'success';
            text = 'Hoàn thành';
            Icon = CheckCircleOutlined;
            break;
          case 'PENDING':
          case 'INITIATED':
            color = 'processing';
            text = 'Đang xử lý';
            Icon = SyncOutlined;
            break;
          case 'PROCESSING':
            color = 'geekblue';
            text = 'Đang giao hàng'; // Or processing payment
            Icon = SyncOutlined;
            break;
          case 'FAILED':
            color = 'error';
            text = 'Thất bại';
            Icon = CloseCircleOutlined;
            break;
          case 'CANCELLED':
            color = 'default';
            text = 'Đã hủy';
            Icon = CloseCircleOutlined;
            break;
        }

        return (
          <Tag
            icon={<Icon spin={status === 'PENDING' || status === 'PROCESSING'} />}
            color={color}
            className="rounded-full px-3 py-0.5 border-0 font-medium"
          >
            {text}
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
              Đơn hàng của tôi
            </Title>
            <Text type="secondary">Quản lý và theo dõi trạng thái các đơn hàng vắc xin</Text>
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
                      Tổng đơn hàng
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
                      Đơn thành công
                    </Text>
                    <div className="text-3xl font-bold text-emerald-600 mt-1">
                      {
                        orders.filter((o) => o.status === 'SUCCESS' || o.status === 'COMPLETED')
                          .length
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
                      Đang xử lý
                    </Text>
                    <div className="text-3xl font-bold text-amber-600 mt-1">
                      {
                        orders.filter((o) =>
                          ['PENDING', 'PROCESSING', 'INITIATED'].includes(o.status)
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
                  <Empty description="Bạn chưa có đơn hàng nào" />
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
