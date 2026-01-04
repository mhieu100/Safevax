import {
  CheckCircleOutlined,
  ClockCircleOutlined,
  ExclamationCircleOutlined,
  InfoCircleOutlined,
  ThunderboltOutlined,
} from '@ant-design/icons';
import { Card, ConfigProvider, Steps, Table, Tag, Typography } from 'antd';

const { Title, Text } = Typography;

const UrgencyGuide = () => {
  const priorityData = [
    {
      key: '1',
      priority: 'Priority 1',
      tagColor: 'red',
      icon: <ExclamationCircleOutlined />,
      label: 'CỰC KHẨN',
      description:
        'Yêu cầu đổi lịch (RESCHEDULE_PENDING) hoặc Lịch trong 24h chưa có bác sĩ (NO_DOCTOR).',
      action: 'Xử lý ngay lập tức.',
    },
    {
      key: '2',
      priority: 'Priority 2',
      tagColor: 'orange',
      icon: <ClockCircleOutlined />,
      label: 'KHẨN',
      description: 'Lịch quá hạn xử lý (OVERDUE).',
      action: 'Kiểm tra và cập nhật trạng thái.',
    },
    {
      key: '3',
      priority: 'Priority 3',
      tagColor: 'gold',
      icon: <InfoCircleOutlined />,
      label: 'CAO',
      description: 'Sắp đến giờ hẹn trong 4h tới (COMING_SOON).',
      action: 'Chuẩn bị đón tiếp.',
    },
  ];

  const columns = [
    {
      title: 'Mức độ',
      dataIndex: 'priority',
      key: 'priority',
      render: (text, record) => (
        <Tag color={record.tagColor} icon={record.icon}>
          {text} - {record.label}
        </Tag>
      ),
      width: 180,
    },
    {
      title: 'Mô tả',
      dataIndex: 'description',
      key: 'description',
    },
    {
      title: 'Hành động',
      dataIndex: 'action',
      key: 'action',
      render: (text) => <Text type="secondary">{text}</Text>,
    },
  ];

  return (
    <ConfigProvider
      theme={{
        components: {
          Steps: {
            colorPrimary: '#1890ff',
          },
        },
      }}
    >
      <div className="p-4">
        <div className="flex items-center gap-3 mb-6">
          <InfoCircleOutlined style={{ fontSize: 24, color: '#1890ff' }} />
          <Title level={3} style={{ margin: 0 }}>
            Quy Định Xử Lý
          </Title>
        </div>

        <Card bordered={false} className="shadow-sm mb-8 bg-slate-50">
          <Steps
            current={-1}
            items={[
              {
                title: 'Kiểm tra',
                description: 'Hệ thống tự động sắp xếp ưu tiên.',
                icon: <ThunderboltOutlined />,
              },
              {
                title: 'Xử lý Priority 1',
                description: 'Ưu tiên đổi lịch & thiếu bác sĩ.',
                icon: <ExclamationCircleOutlined />,
              },
              {
                title: 'Phân công',
                description: 'Gán bác sĩ cho các lịch hẹn.',
                icon: <CheckCircleOutlined />,
              },
            ]}
          />
        </Card>

        <Title level={4} className="mb-4">
          Phân Loại Ưu Tiên
        </Title>
        <Table
          columns={columns}
          dataSource={priorityData}
          pagination={false}
          bordered
          size="middle"
          rowClassName="bg-white"
        />
      </div>
    </ConfigProvider>
  );
};

export default UrgencyGuide;
