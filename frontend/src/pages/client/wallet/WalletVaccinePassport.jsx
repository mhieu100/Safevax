import {
  CalendarOutlined,
  CheckCircleFilled,
  MedicineBoxOutlined,
  QrcodeOutlined,
  SafetyCertificateOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  Alert,
  Button,
  Card,
  Descriptions,
  Empty,
  Modal,
  QRCode,
  Skeleton,
  Table,
  Tabs,
  Tag,
  Typography,
} from 'antd';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import BlockchainBadge from '@/components/common/BlockchainBadge';
import BlockchainVerificationModal from '@/components/common/BlockchainVerificationModal';
import apiClient from '@/services/apiClient';
import { callGetFamilyMemberRecords, callGetMyFamilyMembers } from '@/services/family.service';
import useAccountStore from '@/stores/useAccountStore';

const { Title, Text } = Typography;

const WalletVaccinePassport = () => {
  const { t, i18n } = useTranslation(['client']);
  const { user } = useAccountStore();
  const [records, setRecords] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [selectedRecord, setSelectedRecord] = useState(null);
  const [verificationModalOpen, setVerificationModalOpen] = useState(false);
  const [qrModalOpen, setQrModalOpen] = useState(false);
  const [qrUrl, setQrUrl] = useState('');

  const [activeTab, setActiveTab] = useState('me');
  const [familyMembers, setFamilyMembers] = useState([]);

  useEffect(() => {
    const fetchFamilyMembers = async () => {
      if (!user?.id) return;
      try {
        const response = await callGetMyFamilyMembers();
        if (response.data) {
          setFamilyMembers(response.data);
        }
      } catch (err) {
        console.error('Error fetching family members:', err);
      }
    };
    fetchFamilyMembers();
  }, [user?.id]);

  useEffect(() => {
    const fetchVaccineRecords = async () => {
      if (!user?.id) return;

      try {
        setLoading(true);
        setError(null);
        let response;

        if (activeTab === 'me') {
          response = await apiClient.post('/api/vaccine-records/my-records');
        } else {
          response = await callGetFamilyMemberRecords(activeTab);
        }

        if (response.data) {
          setRecords(response.data);
        } else {
          setRecords([]);
        }
      } catch (err) {
        console.error('Error fetching vaccine records:', err);
        setError(t('client:vaccinePassport.errorFetch'));
      } finally {
        setLoading(false);
      }
    };

    fetchVaccineRecords();
  }, [user?.id, activeTab]);

  const handleShowQr = (record) => {
    if (record.ipfsHash) {
      setQrUrl(`https://safevax.mhieu100.space/verify/${record.ipfsHash}`);
      setSelectedRecord(record);
      setQrModalOpen(true);
    }
  };

  const columns = [
    {
      title: t('client:vaccinePassport.vaccine'),
      dataIndex: 'vaccineName',
      key: 'vaccineName',
      width: 200,
      render: (text, record) => (
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center flex-shrink-0">
            <MedicineBoxOutlined className="text-blue-600 text-lg" />
          </div>
          <div>
            <div className="font-medium text-slate-800 line-clamp-2">{text}</div>
            <Text type="secondary" className="text-xs">
              {t('client:vaccinePassport.dose')} #{record.doseNumber}
            </Text>
          </div>
        </div>
      ),
    },
    {
      title: t('client:vaccinePassport.date'),
      dataIndex: 'vaccinationDate',
      key: 'vaccinationDate',
      width: 140,
      render: (date) => (
        <div className="flex items-center gap-2 text-slate-600">
          <CalendarOutlined className="text-emerald-500" />
          <span>{new Date(date).toLocaleDateString(i18n.language)}</span>
        </div>
      ),
    },
    {
      title: t('client:vaccinePassport.site'),
      dataIndex: 'site',
      key: 'site',
      width: 120,
      render: (site) => (
        <Tag color="blue" className="rounded-md border-0 bg-blue-50 text-blue-600">
          {site?.replace('_', ' ') || 'N/A'}
        </Tag>
      ),
    },
    {
      title: t('client:vaccinePassport.center'),
      dataIndex: 'centerName',
      key: 'centerName',
      width: 200,
      render: (name) => (
        <Text className="text-slate-500 line-clamp-2" title={name}>
          {name || 'N/A'}
        </Text>
      ),
    },
    {
      title: t('client:vaccinePassport.status'),
      key: 'status',
      width: 160,
      render: (_, record) => (
        <div className="flex items-center gap-2">
          <Tag icon={<CheckCircleFilled />} color="success" className="rounded-full px-3 border-0">
            {t('client:vaccinePassport.completed')}
          </Tag>
          {record.transactionHash && <BlockchainBadge verified={true} compact={true} />}
        </div>
      ),
    },
    {
      title: t('client:vaccinePassport.actions'),
      key: 'actions',
      width: 120,
      fixed: 'right',
      render: (_, record) =>
        record.transactionHash && (
          <div className="flex gap-2">
            <Button
              type="primary"
              size="small"
              icon={<QrcodeOutlined />}
              onClick={() => handleShowQr(record)}
            >
              QR
            </Button>
            <Button
              type="link"
              size="small"
              icon={<SafetyCertificateOutlined />}
              onClick={() => {
                setSelectedRecord(record);
                setVerificationModalOpen(true);
              }}
            >
              {t('client:vaccinePassport.verify')}
            </Button>
          </div>
        ),
    },
  ];

  const tabItems = [
    {
      key: 'me',
      label: (
        <span className="flex items-center gap-2">
          <UserOutlined />
          My Records
        </span>
      ),
    },
    ...familyMembers.map((member) => ({
      key: member.id,
      label: (
        <span className="flex items-center gap-2">
          <UserOutlined />
          {member.fullName} ({member.relationship})
        </span>
      ),
    })),
  ];

  return (
    <div className="min-h-[calc(100vh-90px)] lg:h-[calc(100vh-90px)] bg-slate-50 py-8 lg:overflow-hidden flex flex-col animate-fade-in">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 w-full lg:h-full lg:overflow-y-auto hide-scrollbar">
        <div className="mb-6 flex items-center gap-3">
          <div className="p-3 bg-blue-600 rounded-xl text-white shadow-lg shadow-blue-500/30">
            <QrcodeOutlined className="text-2xl" />
          </div>
          <div>
            <Title level={2} className="!mb-0">
              Wallet Vaccine Passport
            </Title>
            <Text type="secondary">Digital storage for your verified vaccination records</Text>
          </div>
        </div>

        <Tabs
          activeKey={activeTab}
          onChange={setActiveTab}
          items={tabItems}
          className="mb-6 custom-tabs"
          type="card"
        />

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
        ) : error ? (
          <Alert type="error" message={error} showIcon className="mb-4 rounded-xl" />
        ) : (
          <>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
              <Card
                size="small"
                className="rounded-2xl shadow-sm border border-slate-100 bg-gradient-to-br from-blue-50 to-white"
              >
                <div className="flex items-center justify-between p-2">
                  <div>
                    <Text className="text-slate-500 font-medium uppercase text-xs tracking-wider">
                      {t('client:vaccinePassport.totalRecords')}
                    </Text>
                    <div className="text-3xl font-bold text-blue-600 mt-1">{records.length}</div>
                  </div>
                  <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                    <SafetyCertificateOutlined className="text-2xl text-blue-600" />
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
                      {t('client:vaccinePassport.vaccinesTaken')}
                    </Text>
                    <div className="text-3xl font-bold text-emerald-600 mt-1">
                      {new Set(records.map((r) => r.vaccineName)).size}
                    </div>
                  </div>
                  <div className="w-12 h-12 rounded-full bg-emerald-100 flex items-center justify-center">
                    <MedicineBoxOutlined className="text-2xl text-emerald-600" />
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
                      {t('client:vaccinePassport.lastVaccination')}
                    </Text>
                    <div className="text-lg font-bold text-purple-600 mt-2">
                      {records.length > 0
                        ? new Date(
                            Math.max(...records.map((r) => new Date(r.vaccinationDate)))
                          ).toLocaleDateString(i18n.language)
                        : 'N/A'}
                    </div>
                  </div>
                  <div className="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center">
                    <CalendarOutlined className="text-2xl text-purple-600" />
                  </div>
                </div>
              </Card>
            </div>

            <Card className="rounded-3xl shadow-sm border border-slate-100 overflow-hidden">
              {records.length > 0 ? (
                <Table
                  columns={columns}
                  dataSource={records.map((record) => ({
                    ...record,
                    key: record.id,
                  }))}
                  pagination={{
                    pageSize: 10,
                    showSizeChanger: true,
                    showTotal: (total) =>
                      t('client:vaccinePassport.totalRecordsCount', { count: total }),
                  }}
                  scroll={{ x: 'max-content' }}
                  expandable={{
                    expandedRowRender: (record) => (
                      <div className="p-4 bg-slate-50 rounded-xl border border-slate-100 m-2">
                        <Descriptions
                          bordered
                          size="small"
                          column={2}
                          className="bg-white rounded-lg"
                        >
                          <Descriptions.Item
                            label={t('client:vaccinePassport.patientIdentityHash')}
                            span={2}
                          >
                            <Text className="font-mono text-xs text-slate-500">
                              {record.patientIdentityHash}
                            </Text>
                          </Descriptions.Item>
                          <Descriptions.Item label={t('client:vaccinePassport.appointmentId')}>
                            <span className="font-mono text-slate-700">{record.appointmentId}</span>
                          </Descriptions.Item>

                          {record.transactionHash && (
                            <>
                              <Descriptions.Item
                                label={t('client:vaccinePassport.transactionHash')}
                                span={2}
                              >
                                <Text className="font-mono text-xs text-emerald-600 break-all">
                                  {record.transactionHash}
                                </Text>
                              </Descriptions.Item>
                              <Descriptions.Item
                                label={t('client:vaccinePassport.ipfsHash')}
                                span={2}
                              >
                                <div className="flex items-center gap-2">
                                  <Text className="font-mono text-xs text-blue-600">
                                    {record.ipfsHash || 'N/A'}
                                  </Text>
                                  {record.ipfsHash && (
                                    <Button
                                      type="link"
                                      size="small"
                                      href={`https://ipfs.io/ipfs/${record.ipfsHash}`}
                                      target="_blank"
                                    >
                                      {t('client:vaccinePassport.viewOnIpfs')}
                                    </Button>
                                  )}
                                </div>
                              </Descriptions.Item>
                            </>
                          )}
                        </Descriptions>
                      </div>
                    ),
                  }}
                  className="custom-table"
                />
              ) : (
                <Empty
                  image={Empty.PRESENTED_IMAGE_SIMPLE}
                  description={t('client:vaccinePassport.noRecords')}
                />
              )}
            </Card>
          </>
        )}

        <BlockchainVerificationModal
          open={verificationModalOpen}
          onClose={() => setVerificationModalOpen(false)}
          record={selectedRecord}
        />

        <Modal
          open={qrModalOpen}
          onCancel={() => setQrModalOpen(false)}
          footer={null}
          centered
          title={
            <div className="flex items-center gap-2">
              <QrcodeOutlined className="text-blue-600" />
              <span>Digital Vaccine Verification</span>
            </div>
          }
        >
          <div className="flex flex-col items-center justify-center p-4">
            <div className="p-4 bg-white rounded-xl border-2 border-blue-100 shadow-inner mb-4">
              <QRCode value={qrUrl} size={250} icon="/logo.png" />
            </div>
            <Text type="secondary" className="text-center mb-2">
              Scan this QR code to verify the vaccine record on the blockchain.
            </Text>
            <div className="p-2 bg-slate-50 rounded-lg w-full break-all text-center font-mono text-xs text-slate-500">
              {qrUrl}
            </div>
          </div>
        </Modal>
      </div>
    </div>
  );
};

export default WalletVaccinePassport;
