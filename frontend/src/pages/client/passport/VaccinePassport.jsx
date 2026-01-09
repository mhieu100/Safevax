import {
  CheckCircleFilled,
  DownloadOutlined,
  GlobalOutlined,
  MedicineBoxOutlined,
  QrcodeOutlined,
  SafetyCertificateOutlined,
  ShareAltOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  Alert,
  Button,
  Card,
  Empty,
  Modal,
  message,
  QRCode,
  Skeleton,
  Space,
  Table,
  Tabs,
  Tag,
  Tooltip,
  Typography,
} from 'antd';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import DigitalPassportCard from '@/components/client/passport/DigitalPassportCard';
import BlockchainBadge from '@/components/common/BlockchainBadge';
import BlockchainVerificationModal from '@/components/common/BlockchainVerificationModal';
import apiClient from '@/services/apiClient';
import { callGetMyFamilyMembers } from '@/services/family.service';
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
          // Default to blockchain records
          response = await apiClient.get('/api/vaccine-records/blockchain/my-records');
        } else {
          response = await apiClient.get(`/api/vaccine-records/blockchain/family/${activeTab}`);
        }

        if (response.data) {
          setRecords(response.data);
        } else {
          setRecords([]);
        }
      } catch (err) {
        console.error('Error fetching vaccine records:', err);
        setError(t('client:records.vaccinePassport.errorFetch'));
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

  const handleDownloadRecordPdf = async (record) => {
    try {
      let response;
      let filename;

      if (record.transactionHash) {
        response = await apiClient.get('/api/pdf/generate/blockchain', {
          params: { txHash: record.transactionHash },
          responseType: 'blob',
          headers: { Accept: 'application/pdf' },
        });
        filename = `blockchain_record_${record.transactionHash.substring(0, 10)}.pdf`;
      } else {
        response = await apiClient.get('/api/pdf/generate/record', {
          params: { recordId: record.id },
          responseType: 'blob',
          headers: { Accept: 'application/pdf' },
        });
        filename = `vaccine_passport_${record.id}.pdf`;
      }

      const blob = new Blob([response], { type: 'application/pdf' });
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', filename);
      document.body.appendChild(link);
      link.click();
      link.remove();
      window.URL.revokeObjectURL(url);
      message.success(t('client:records.vaccinePassport.downloadSuccess'));
    } catch (err) {
      console.error('Failed to download vaccine passport', err);
      message.error(t('client:records.vaccinePassport.downloadError'));
    }
  };

  const handleCopyLink = (record) => {
    if (record.ipfsHash) {
      navigator.clipboard.writeText(`https://safevax.mhieu100.space/verify/${record.ipfsHash}`);
      message.success(t('client:records.vaccinePassport.copyLinkSuccess'));
    }
  };

  const handleExportFullHistory = async () => {
    const identityHash =
      records.length > 0
        ? records[0].patientIdentityHash
        : activeTab === 'me'
          ? user?.blockchainIdentityHash
          : familyMembers.find((f) => f.id === activeTab)?.blockchainIdentityHash;

    if (!identityHash) {
      message.error(t('client:records.vaccinePassport.noIdentityFound'));
      return;
    }

    try {
      const response = await apiClient.get('/api/pdf/generate/identity-hash', {
        params: { identityHash },
        responseType: 'blob',
        headers: { Accept: 'application/pdf' },
      });

      const blob = new Blob([response], { type: 'application/pdf' });
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `vaccine_passport_full_${identityHash.substring(0, 8)}.pdf`);
      document.body.appendChild(link);
      link.click();
      link.remove();
      window.URL.revokeObjectURL(url);
      message.success(t('client:records.vaccinePassport.fullHistoryExportSuccess'));
    } catch (err) {
      console.error(err);
      message.error(t('client:records.vaccinePassport.exportFailed'));
    }
  };

  const columns = [
    {
      title: t('client:records.vaccinePassport.vaccine'),
      dataIndex: 'vaccineName',
      key: 'vaccineName',
      width: 220,
      render: (text, record) => (
        <div className="flex items-center gap-3">
          <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center flex-shrink-0 shadow-lg shadow-blue-500/20">
            <MedicineBoxOutlined className="text-white text-xl" />
          </div>
          <div>
            <div className="font-semibold text-slate-800 line-clamp-1">{text}</div>
            <div className="flex items-center gap-2 mt-1">
              <Tag color="blue" className="rounded-full text-xs px-2 m-0">
                {t('client:records.vaccinePassport.dose')} #{record.doseNumber}
              </Tag>
            </div>
          </div>
        </div>
      ),
    },
    {
      title: t('client:records.vaccinePassport.date'),
      dataIndex: 'vaccinationDate',
      key: 'vaccinationDate',
      width: 130,
      render: (date) => (
        <div className="flex flex-col">
          <span className="font-medium text-slate-700">
            {new Date(date).toLocaleDateString(i18n.language, {
              day: '2-digit',
              month: 'short',
              year: 'numeric',
            })}
          </span>
          <span className="text-xs text-slate-400">
            {new Date(date).toLocaleDateString(i18n.language, { weekday: 'long' })}
          </span>
        </div>
      ),
    },
    {
      title: t('client:records.vaccinePassport.site'),
      dataIndex: 'site',
      key: 'site',
      width: 110,
      render: (site) => (
        <Tag className="rounded-lg border-0 bg-gradient-to-r from-cyan-50 to-blue-50 text-cyan-700 font-medium px-3 py-1">
          {site?.replace('_', ' ') || t('client:records.vaccinePassport.notAvailable')}
        </Tag>
      ),
    },
    {
      title: t('client:records.vaccinePassport.center'),
      dataIndex: 'centerName',
      key: 'centerName',
      width: 180,
      render: (name) => (
        <div className="flex items-center gap-2">
          <GlobalOutlined className="text-slate-400" />
          <Text className="text-slate-600 line-clamp-2" title={name}>
            {name || t('client:records.vaccinePassport.notAvailable')}
          </Text>
        </div>
      ),
    },
    {
      title: t('client:records.vaccinePassport.status'),
      key: 'status',
      width: 180,
      render: (_, record) => (
        <div className="flex flex-col gap-1">
          {(record.transactionHash || record.blockchainRecordId) && (
            <div className="flex items-center gap-1">
              <BlockchainBadge verified={true} compact={true} />
            </div>
          )}
        </div>
      ),
    },
    {
      title: t('client:records.vaccinePassport.actions'),
      key: 'actions',
      width: 160,
      fixed: 'right',
      render: (_, record) => (
        <Space size="small" wrap>
          <Tooltip title={t('client:records.vaccinePassport.tooltipDownload')}>
            <Button
              type="primary"
              size="small"
              icon={<DownloadOutlined />}
              onClick={() => handleDownloadRecordPdf(record)}
              className="bg-gradient-to-r from-blue-500 to-indigo-500 border-0 shadow-md shadow-blue-500/20 hover:shadow-lg hover:shadow-blue-500/30"
            />
          </Tooltip>
          {(record.transactionHash || record.blockchainRecordId) && (
            <>
              <Tooltip title={t('client:records.vaccinePassport.tooltipShowQR')}>
                <Button
                  size="small"
                  icon={<QrcodeOutlined />}
                  onClick={() => handleShowQr(record)}
                  className="border-purple-200 text-purple-600 hover:bg-purple-50 hover:border-purple-300"
                />
              </Tooltip>
              <Tooltip title={t('client:records.vaccinePassport.tooltipCopyLink')}>
                <Button
                  size="small"
                  icon={<ShareAltOutlined />}
                  onClick={() => handleCopyLink(record)}
                  className="border-emerald-200 text-emerald-600 hover:bg-emerald-50 hover:border-emerald-300"
                />
              </Tooltip>
              <Tooltip title={t('client:records.vaccinePassport.tooltipVerify')}>
                <Button
                  size="small"
                  icon={<SafetyCertificateOutlined />}
                  onClick={() => {
                    setSelectedRecord(record);
                    setVerificationModalOpen(true);
                  }}
                  className="border-amber-200 text-amber-600 hover:bg-amber-50 hover:border-amber-300"
                />
              </Tooltip>
            </>
          )}
        </Space>
      ),
    },
  ];

  const tabItems = [
    {
      key: 'me',
      label: (
        <span className="flex items-center gap-2 px-2">
          <div className="w-6 h-6 rounded-full bg-blue-100 flex items-center justify-center">
            <UserOutlined className="text-blue-600 text-xs" />
          </div>
          <span>{t('client:records.vaccinePassport.myRecords')}</span>
        </span>
      ),
    },
    ...familyMembers.map((member) => ({
      key: member.id,
      label: (
        <span className="flex items-center gap-2 px-2">
          <div className="w-6 h-6 rounded-full bg-purple-100 flex items-center justify-center">
            <UserOutlined className="text-purple-600 text-xs" />
          </div>
          <span>{member.fullName}</span>
          <Tag size="small" className="text-xs rounded-full">
            {member.relationship}
          </Tag>
        </span>
      ),
    })),
  ];

  const verifiedRecords = records.filter((r) => r.transactionHash || r.blockchainRecordId);

  return (
    <div className="min-h-[calc(100vh-90px)] bg-gradient-to-br from-slate-50 via-blue-50/30 to-indigo-50/20 py-8 animate-fade-in">
      <div className="max-w-7xl mx-auto px-4 sm:px-6">
        {/* Header Section */}
        <div className="mb-8">
          <div className="flex items-start justify-between flex-wrap gap-4">
            <div className="flex items-center gap-4">
              <div className="p-4 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-2xl text-white shadow-xl shadow-blue-500/30">
                <SafetyCertificateOutlined className="text-3xl" />
              </div>
              <div>
                <Title
                  level={2}
                  className="!mb-1 bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent"
                >
                  {t('client:records.vaccinePassport.title')}
                </Title>
                <Text className="text-slate-500">
                  {t('client:records.vaccinePassport.headerDesc')}
                </Text>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <Tag className="rounded-full px-4 py-1 bg-emerald-50 text-emerald-600 border-emerald-200 font-medium">
                <CheckCircleFilled className="mr-1" /> {verifiedRecords.length}{' '}
                {t('client:records.vaccinePassport.statsVerified')}
              </Tag>
            </div>
          </div>
        </div>

        {/* Digital Passport Card & Tabs Section */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-8">
          {/* Left: Digital Passport Card */}
          <div className="lg:col-span-1">
            <DigitalPassportCard
              user={activeTab === 'me' ? user : familyMembers.find((f) => f.id === activeTab) || {}}
              identityHash={
                records.length > 0
                  ? records[0].patientIdentityHash
                  : activeTab === 'me'
                    ? user?.blockchainIdentityHash
                    : familyMembers.find((f) => f.id === activeTab)?.blockchainIdentityHash
              }
              qrUrl={
                records.length > 0 && records[0].ipfsHash
                  ? `${window.location.origin}/verify/${records[0].ipfsHash}`
                  : ''
              }
            />
            <div className="text-center mt-4">
              <Text className="text-slate-400 text-xs">
                {t('client:records.vaccinePassport.scanQR')}
              </Text>
            </div>
            <div className="mt-4">
              <Button
                type="dashed"
                block
                icon={<DownloadOutlined />}
                onClick={handleExportFullHistory}
                className="border-indigo-200 text-indigo-600 hover:bg-indigo-50 hover:border-indigo-300 h-10 font-medium"
              >
                {t('client:records.vaccinePassport.exportPdfBtn')}
              </Button>
            </div>
          </div>

          {/* Right: Stats & Records */}
          <div className="lg:col-span-2 flex flex-col gap-6">
            {/* Stats Cards - Compact Row */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
              <Card className="rounded-xl shadow-sm border-0 bg-white/60 backdrop-blur">
                <div className="text-center p-2">
                  <div className="text-2xl font-bold text-slate-800">{records.length}</div>
                  <Text className="text-[10px] uppercase text-slate-400 font-bold">
                    {t('client:records.vaccinePassport.statsRecords')}
                  </Text>
                </div>
              </Card>
              <Card className="rounded-xl shadow-sm border-0 bg-white/60 backdrop-blur">
                <div className="text-center p-2">
                  <div className="text-2xl font-bold text-slate-800">{verifiedRecords.length}</div>
                  <Text className="text-[10px] uppercase text-emerald-500 font-bold">
                    {t('client:records.vaccinePassport.statsVerified')}
                  </Text>
                </div>
              </Card>
              <Card className="rounded-xl shadow-sm border-0 bg-white/60 backdrop-blur">
                <div className="text-center p-2">
                  <div className="text-2xl font-bold text-slate-800">
                    {new Set(records.map((r) => r.vaccineName)).size}
                  </div>
                  <Text className="text-[10px] uppercase text-slate-400 font-bold">
                    {t('client:records.vaccinePassport.statsVaccines')}
                  </Text>
                </div>
              </Card>
              <Card className="rounded-xl shadow-sm border-0 bg-white/60 backdrop-blur">
                <div className="text-center p-2">
                  <div className="text-base font-bold text-slate-800 mt-1.5">
                    {records.length > 0
                      ? new Date(
                          Math.max(...records.map((r) => new Date(r.vaccinationDate)))
                        ).toLocaleDateString(i18n.language, { month: 'short', year: '2-digit' })
                      : t('client:records.vaccinePassport.notAvailable')}
                  </div>
                  <Text className="text-[10px] uppercase text-slate-400 font-bold">
                    {t('client:records.vaccinePassport.statsLastDose')}
                  </Text>
                </div>
              </Card>
            </div>

            {/* Tabs */}
            <Card className="rounded-2xl shadow-sm border-0 overflow-hidden">
              <Tabs
                activeKey={activeTab}
                onChange={setActiveTab}
                items={tabItems}
                className="custom-passport-tabs"
              />
            </Card>
          </div>
        </div>

        {loading ? (
          <div className="space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              {[1, 2, 3, 4].map((i) => (
                <Card key={i} className="rounded-2xl shadow-sm border-0">
                  <Skeleton active paragraph={{ rows: 1 }} title={{ width: 80 }} />
                </Card>
              ))}
            </div>
            <Card className="rounded-2xl shadow-sm border-0">
              <Skeleton active paragraph={{ rows: 6 }} />
            </Card>
          </div>
        ) : error ? (
          <Alert type="error" message={error} showIcon className="rounded-xl" />
        ) : (
          <>
            {/* Records Table */}
            <Card className="rounded-2xl shadow-sm border-0 overflow-hidden">
              <div className="p-4 border-b border-slate-100">
                <div className="flex items-center justify-between">
                  <div>
                    <Title level={4} className="!mb-1">
                      {t('client:records.vaccinePassport.recordsHeader')}
                    </Title>
                    <Text className="text-slate-400">
                      {t('client:records.vaccinePassport.recordsSubHeader')}
                    </Text>
                  </div>
                </div>
              </div>

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
                      t('client:records.vaccinePassport.recordsTotal', { count: total }),
                    className: 'px-4',
                  }}
                  scroll={{ x: 'max-content' }}
                  expandable={{
                    expandedRowRender: (record) => (
                      <div className="p-6 bg-gradient-to-br from-slate-50 to-blue-50/50 rounded-xl m-2">
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                          <div className="space-y-4">
                            <div>
                              <Text className="text-xs uppercase tracking-wider text-slate-400 font-medium">
                                {t('client:records.vaccinePassport.patientIdentityHash')}
                              </Text>
                              <div className="mt-1 p-3 bg-white rounded-lg border border-slate-100">
                                <Text className="font-mono text-xs text-slate-600 break-all">
                                  {record.patientIdentityHash}
                                </Text>
                              </div>
                            </div>
                            <div className="grid grid-cols-2 gap-4">
                              <div>
                                <Text className="text-xs uppercase tracking-wider text-slate-400 font-medium">
                                  {t('client:records.vaccinePassport.recordId')}
                                </Text>
                                <div className="mt-1 p-3 bg-white rounded-lg border border-slate-100">
                                  <Text className="font-mono text-sm font-semibold text-slate-700">
                                    {record.id}
                                  </Text>
                                </div>
                              </div>
                            </div>
                          </div>

                          {(record.transactionHash || record.blockchainRecordId) && (
                            <div className="space-y-4">
                              <div>
                                <Text className="text-xs uppercase tracking-wider text-slate-400 font-medium">
                                  {t('client:records.vaccinePassport.transactionHash')}
                                </Text>
                                <div className="mt-1 p-3 bg-gradient-to-r from-emerald-50 to-green-50 rounded-lg border border-emerald-100">
                                  <Text className="font-mono text-xs text-emerald-600 break-all">
                                    {record.transactionHash}
                                  </Text>
                                </div>
                              </div>
                              <div>
                                <Text className="text-xs uppercase tracking-wider text-slate-400 font-medium">
                                  {t('client:records.vaccinePassport.ipfsHash')}
                                </Text>
                                <div className="mt-1 p-3 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-lg border border-blue-100 flex items-center justify-between gap-2">
                                  <Text className="font-mono text-xs text-blue-600 break-all">
                                    {record.ipfsHash ||
                                      t('client:records.vaccinePassport.notAvailable')}
                                  </Text>
                                  {record.ipfsHash && (
                                    <Button
                                      type="link"
                                      size="small"
                                      href={`https://ipfs.io/ipfs/${record.ipfsHash}`}
                                      target="_blank"
                                      className="text-blue-600 shrink-0"
                                    >
                                      {t('client:records.vaccinePassport.viewOnIpfsBtn')} →
                                    </Button>
                                  )}
                                </div>
                              </div>
                            </div>
                          )}
                        </div>
                      </div>
                    ),
                    expandRowByClick: true,
                  }}
                  className="custom-passport-table"
                />
              ) : (
                <div className="p-12">
                  <Empty
                    image={Empty.PRESENTED_IMAGE_SIMPLE}
                    description={
                      <div className="text-center">
                        <Text className="text-slate-400 block mb-2">
                          {t('client:records.vaccinePassport.noRecords')}
                        </Text>
                        <Text className="text-slate-300 text-sm">
                          {t('client:records.vaccinePassport.noRecordsDesc')}
                        </Text>
                      </div>
                    }
                  />
                </div>
              )}
            </Card>
          </>
        )}

        {/* Modals */}
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
          width={420}
          className="qr-modal"
          title={null}
        >
          <div className="flex flex-col items-center justify-center p-6">
            <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center mb-4 shadow-xl shadow-blue-500/30">
              <QrcodeOutlined className="text-3xl text-white" />
            </div>
            <Title level={4} className="!mb-1 text-center">
              {t('client:records.vaccinePassport.digitalVerification')}
            </Title>
            <Text className="text-slate-400 text-center mb-6">
              {t('client:records.vaccinePassport.scanToVerify')}
            </Text>

            <div className="p-6 bg-white rounded-2xl border-2 border-slate-100 shadow-inner mb-6">
              <QRCode value={qrUrl} size={220} icon="/logo.png" />
            </div>

            {selectedRecord && (
              <div className="w-full p-4 bg-gradient-to-r from-slate-50 to-blue-50 rounded-xl mb-4">
                <div className="flex items-center justify-between mb-2">
                  <Text className="text-slate-500 text-sm">
                    {t('client:records.vaccinePassport.vaccine')}
                  </Text>
                  <Text className="font-semibold text-slate-700">{selectedRecord.vaccineName}</Text>
                </div>
                <div className="flex items-center justify-between">
                  <Text className="text-slate-500 text-sm">
                    {t('client:records.vaccinePassport.date')}
                  </Text>
                  <Text className="font-semibold text-slate-700">
                    {new Date(selectedRecord.vaccinationDate).toLocaleDateString()}
                  </Text>
                </div>
              </div>
            )}

            <div className="w-full p-3 bg-slate-50 rounded-xl">
              <Text className="text-xs text-slate-400 block text-center mb-1">
                {t('client:records.vaccinePassport.verificationUrl')}
              </Text>
              <Text className="font-mono text-xs text-slate-600 break-all text-center block">
                {qrUrl}
              </Text>
            </div>

            <div className="flex gap-3 mt-6 w-full">
              <Button
                block
                icon={<ShareAltOutlined />}
                onClick={() => {
                  navigator.clipboard.writeText(qrUrl);
                  message.success(t('client:records.vaccinePassport.copyLinkSuccessShort'));
                }}
              >
                {t('client:records.vaccinePassport.copyLink')}
              </Button>
              <Button
                type="primary"
                block
                icon={<DownloadOutlined />}
                onClick={() => selectedRecord && handleDownloadRecordPdf(selectedRecord)}
                className="bg-gradient-to-r from-blue-500 to-indigo-500 border-0"
              >
                {t('client:records.vaccinePassport.downloadPdf')}
              </Button>
            </div>
          </div>
        </Modal>
      </div>
    </div>
  );
};

export default WalletVaccinePassport;
