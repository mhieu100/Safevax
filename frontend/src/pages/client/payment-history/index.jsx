import {
  CalendarOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  DollarOutlined,
  HistoryOutlined,
  SafetyCertificateOutlined,
} from '@ant-design/icons';
import { Card, Empty, message, Skeleton, Table, Tag, Typography } from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { getMyPaymentHistory } from '@/services/payment.service';

const { Title, Text } = Typography;

const PaymentHistoryPage = () => {
  const [loading, setLoading] = useState(false);
  const [payments, setPayments] = useState([]);

  useEffect(() => {
    fetchHistory();
  }, []);

  const fetchHistory = async () => {
    try {
      setLoading(true);
      const response = await getMyPaymentHistory();
      if (response?.result) {
        setPayments(response.result);
      } else if (Array.isArray(response)) {
        setPayments(response);
      } else {
        setPayments([]);
      }
    } catch (error) {
      console.error(error);
      message.error('Không thể tải lịch sử giao dịch');
    } finally {
      setLoading(false);
    }
  };

  const totalSpent = payments
    .filter((p) => p.status === 'SUCCESS')
    .reduce((sum, p) => sum + (p.amount || 0), 0);

  // Sort logic handled by backend usually, but let's be safe to pick the latest
  // Assuming backend sorts recent first, or we can sort here if needed.
  const lastTransaction = payments.length > 0 ? payments[0].scheduledDate : null;

  const columns = [
    {
      title: 'Mã GD',
      dataIndex: 'transactionId',
      key: 'transactionId',
      render: (text) => (
        <Text copyable className="font-mono text-xs">
          {text}
        </Text>
      ),
    },
    {
      title: 'Vắc xin',
      dataIndex: 'vaccineName',
      key: 'vaccineName',
      render: (text, record) => (
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-full bg-blue-50 flex items-center justify-center flex-shrink-0">
            <SafetyCertificateOutlined className="text-blue-600" />
          </div>
          <div>
            <div className="font-medium text-slate-800">{text}</div>
            <Text type="secondary" className="text-xs">
              {record.centerName}
            </Text>
          </div>
        </div>
      ),
    },
    {
      title: 'Ngày tiêm',
      dataIndex: 'scheduledDate',
      key: 'scheduledDate',
      render: (date, record) => (
        <div className="flex items-center gap-2 text-slate-600">
          <CalendarOutlined className="text-emerald-500" />
          <span>{date ? dayjs(date).format('DD/MM/YYYY') : 'N/A'}</span>
          <span className="text-xs text-gray-400">({record.scheduledTime})</span>
        </div>
      ),
    },
    {
      title: 'Phương thức',
      dataIndex: 'method',
      key: 'method',
      render: (method) => {
        let color = 'default';
        let icon = null;
        if (method === 'METAMASK') {
          color = 'orange';
          icon = '🦊';
        }
        if (method === 'PAYPAL') {
          color = 'blue';
          icon = '🅿️';
        }
        if (method === 'BANK') {
          color = 'green';
          icon = '🏦';
        }
        if (method === 'CASH') {
          color = 'purple';
          icon = '💵';
        }

        return (
          <Tag color={color} className="rounded-md border-0 px-2 py-0.5">
            {icon} {method || 'N/A'}
          </Tag>
        );
      },
    },
    {
      title: 'Số tiền',
      dataIndex: 'amount',
      key: 'amount',
      align: 'right',
      render: (amount) => (
        <span className="font-bold text-slate-700">
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
            color = 'success';
            text = 'Thành công';
            Icon = CheckCircleOutlined;
            break;
          case 'PENDING':
          case 'INITIATED':
            color = 'processing';
            text = 'Đang xử lý';
            Icon = ClockCircleOutlined;
            break;
          case 'FAILED':
            color = 'error';
            text = 'Thất bại';
            Icon = ClockCircleOutlined;
            break;
          case 'CANCELLED':
            color = 'warning';
            text = 'Đã hủy';
            break;
        }

        return (
          <Tag icon={<Icon />} color={color} className="rounded-full px-3 border-0">
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
          <div className="p-3 bg-blue-600 rounded-xl text-white shadow-lg shadow-blue-500/30">
            <HistoryOutlined className="text-2xl" />
          </div>
          <div>
            <Title level={2} className="!mb-0">
              Lịch sử thanh toán
            </Title>
            <Text type="secondary">Theo dõi chi tiết các giao dịch của bạn</Text>
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
                className="rounded-2xl shadow-sm border border-slate-100 bg-gradient-to-br from-blue-50 to-white"
              >
                <div className="flex items-center justify-between p-2">
                  <div>
                    <Text className="text-slate-500 font-medium uppercase text-xs tracking-wider">
                      Tổng giao dịch
                    </Text>
                    <div className="text-3xl font-bold text-blue-600 mt-1">{payments.length}</div>
                  </div>
                  <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                    <HistoryOutlined className="text-2xl text-blue-600" />
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
                      Tổng chi tiêu
                    </Text>
                    <div className="text-3xl font-bold text-emerald-600 mt-1">
                      {new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND',
                        maximumFractionDigits: 0,
                      }).format(totalSpent)}
                    </div>
                  </div>
                  <div className="w-12 h-12 rounded-full bg-emerald-100 flex items-center justify-center">
                    <DollarOutlined className="text-2xl text-emerald-600" />
                  </div>
                </div>
              </Card>

              <Card
                size="small"
                className="rounded-2xl shadow-sm border border-slate-100 bg-gradient-to-br from-purple-50 to-white"
              >
                <div className="flex items-center justify-between p-2">
                  <div>
                    <Text className="text-slate-500 font-medium uppercase text-xs tracking-wider">
                      Giao dịch gần nhất
                    </Text>
                    <div className="text-lg font-bold text-purple-600 mt-2">
                      {lastTransaction ? dayjs(lastTransaction).format('DD/MM/YYYY') : 'N/A'}
                    </div>
                  </div>
                  <div className="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center">
                    <CalendarOutlined className="text-2xl text-purple-600" />
                  </div>
                </div>
              </Card>
            </div>

            {/* Main Table */}
            <Card
              className="rounded-3xl shadow-sm border border-slate-100 overflow-hidden"
              bodyStyle={{ padding: 0 }}
            >
              {payments.length > 0 ? (
                <Table
                  columns={columns}
                  dataSource={payments}
                  rowKey="transactionId"
                  pagination={{ pageSize: 10 }}
                  className="custom-table"
                  scroll={{ x: 'max-content' }}
                />
              ) : (
                <div className="p-12 text-center">
                  <Empty description="Chưa có giao dịch nào" />
                </div>
              )}
            </Card>
          </>
        )}
      </div>
    </div>
  );
};

export default PaymentHistoryPage;
