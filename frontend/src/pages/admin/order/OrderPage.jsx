import {
  CalendarOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  CloseCircleOutlined,
  EyeOutlined,
  SearchOutlined,
  ShoppingOutlined,
  SyncOutlined,
  UserOutlined,
} from '@ant-design/icons';
import { Button, Card, Input, message, Space, Table, Tag, Tooltip, Typography } from 'antd';
import { useEffect, useState } from 'react';
import { getAllOrdersAdmin } from '@/services/order.service';

const { Title, Text } = Typography;

const AdminOrderPage = () => {
  const [loading, setLoading] = useState(false);
  const [orders, setOrders] = useState([]);
  const [searchText, setSearchText] = useState('');

  useEffect(() => {
    fetchOrders();
  }, []);

  const fetchOrders = async () => {
    try {
      setLoading(true);
      const response = await getAllOrdersAdmin();
      if (response) {
        // Handle wrapped/unwrapped response
        const data = Array.isArray(response) ? response : response.result || [];
        // Sort by date desc
        data.sort((a, b) => new Date(b.orderDate) - new Date(a.orderDate));
        setOrders(data);
      }
    } catch (error) {
      console.error(error);
      message.error('Không thể tải danh sách đơn hàng');
    } finally {
      setLoading(false);
    }
  };

  const filteredOrders = orders.filter(
    (order) =>
      order.orderId.toString().includes(searchText) ||
      (order.customerName && order.customerName.toLowerCase().includes(searchText.toLowerCase()))
  );

  const columns = [
    {
      title: 'Mã Đơn',
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
      title: 'Khách hàng',
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
      title: 'Ngày đặt',
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
      title: 'SL',
      dataIndex: 'itemCount',
      key: 'itemCount',
      align: 'center',
      width: 80,
      render: (count) => <Tag>{count}</Tag>,
    },
    {
      title: 'Tổng tiền',
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
            text = 'Chờ xử lý';
            Icon = SyncOutlined;
            break;
          case 'PROCESSING':
            color = 'geekblue';
            text = 'Đang giao';
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
            icon={<Icon spin={['PENDING', 'PROCESSING'].includes(status)} />}
            color={color}
            className="min-w-[100px] text-center"
          >
            {text}
          </Tag>
        );
      },
    },
    {
      title: 'Hành động',
      key: 'action',
      align: 'center',
      width: 100,
      render: (_, record) => (
        <Space size="small">
          <Tooltip title="Xem chi tiết">
            <Button
              type="text"
              shape="circle"
              icon={<EyeOutlined className="text-blue-500" />}
              onClick={() => message.info('Tính năng xem chi tiết đang phát triển')}
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
            <ShoppingOutlined /> Quản lý đơn hàng
          </Title>
          <Text type="secondary">Xem và quản lý tất cả đơn hàng vắc xin</Text>
        </div>

        <Input
          placeholder="Tìm theo mã đơn hoặc tên khách..."
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
    </div>
  );
};

export default AdminOrderPage;
