import {
  CalendarOutlined,
  CheckCircleFilled,
  DownloadOutlined,
  FilePdfOutlined,
  MedicineBoxOutlined,
  SafetyCertificateOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  Alert,
  Button,
  Card,
  Descriptions,
  Empty,
  message,
  Skeleton,
  Table,
  Tag,
  Typography,
} from 'antd';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import BlockchainBadge from '@/components/common/BlockchainBadge';
import BlockchainVerificationModal from '@/components/common/BlockchainVerificationModal';
import apiClient from '@/services/apiClient';
import { callGetFamilyMemberRecords } from '@/services/family.service';
import useAccountStore from '@/stores/useAccountStore';

const { Title, Text } = Typography;

const VaccineRecordTab = ({ familyMemberId }) => {
  const { t, i18n } = useTranslation(['client']);
  const { user } = useAccountStore();
  const [records, setRecords] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [selectedRecord, setSelectedRecord] = useState(null);
  const [verificationModalOpen, setVerificationModalOpen] = useState(false);

  const handleDownloadPdf = async () => {
    try {
      // Determine the user ID to request (family member or current user)
      // Note: The backend currently takes ?userId=.
      // If familyMemberId is present, we should probably pass that ID if it's a user ID,
      // but family members might not have a full User ID in the same way depending on schema.
      // However, the backend PdfService expects a User ID to look up User.
      // If family Member is just a dependent, they might not have a User entry.
      // For now, let's stick to the current user's report or the generic report.
      // Refined: We'll pass the current user's ID for now as requested.

      const targetUserId = user?.id;

      const response = await apiClient.get('/api/pdf/generate', {
        params: { userId: targetUserId },
        responseType: 'blob',
        headers: {
          Accept: 'application/pdf',
        },
      });

      // apiClient interceptor returns response.data directly, which IS the blob
      const blob = new Blob([response], { type: 'application/pdf' });
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `safevax_report_${targetUserId || 'user'}.pdf`);
      document.body.appendChild(link);
      link.click();
      link.remove();
      window.URL.revokeObjectURL(url);
    } catch (err) {
      console.error('Failed to download PDF', err);
      message.error(t('client:records.vaccinePassport.downloadError', 'Failed to download PDF'));
    }
  };

  const handleDownloadRecordPdf = async (recordId) => {
    try {
      const response = await apiClient.get('/api/pdf/generate/record', {
        params: { recordId },
        responseType: 'blob',
        headers: {
          Accept: 'application/pdf',
        },
      });

      const blob = new Blob([response], { type: 'application/pdf' });
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `vaccine_passport_${recordId}.pdf`);
      document.body.appendChild(link);
      link.click();
      link.remove();
      window.URL.revokeObjectURL(url);
      message.success(
        t(
          'client:records.vaccinePassport.downloadSuccess',
          'Vaccine passport downloaded successfully'
        )
      );
    } catch (err) {
      console.error('Failed to download vaccine passport', err);
      message.error(t('client:records.vaccinePassport.downloadError', 'Failed to download PDF'));
    }
  };

  useEffect(() => {
    const fetchVaccineRecords = async () => {
      if (!user?.id && !familyMemberId) return;

      try {
        setLoading(true);
        setError(null);

        let response;
        if (familyMemberId) {
          response = await callGetFamilyMemberRecords(familyMemberId);
        } else {
          response = await apiClient.post('/api/vaccine-records/my-records');
        }

        if (response.data) {
          setRecords(response.data);
        }
      } catch (err) {
        console.error('Error fetching vaccine records:', err);
        setError(t('client:records.vaccinePassport.errorFetch'));
      } finally {
        setLoading(false);
      }
    };

    fetchVaccineRecords();
  }, [user?.id, familyMemberId]);

  const columns = [
    {
      title: t('client:records.vaccinePassport.vaccine'),
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
              {t('client:records.vaccinePassport.dose')} #{record.doseNumber}
            </Text>
          </div>
        </div>
      ),
    },
    {
      title: t('client:records.vaccinePassport.date'),
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
      title: t('client:records.vaccinePassport.site'),
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
      title: t('client:records.vaccinePassport.doctor'),
      dataIndex: 'doctorName',
      key: 'doctorName',
      width: 180,
      render: (name) => (
        <div className="flex items-center gap-2 text-slate-600">
          <UserOutlined className="text-slate-400" />
          <span className="line-clamp-1" title={name}>
            {name || 'N/A'}
          </span>
        </div>
      ),
    },
    {
      title: t('client:records.vaccinePassport.center'),
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
      title: t('client:records.vaccinePassport.status'),
      key: 'status',
      width: 160,
      render: (_, record) => (
        <div className="flex items-center gap-2">
          <Tag icon={<CheckCircleFilled />} color="success" className="rounded-full px-3 border-0">
            {t('client:records.vaccinePassport.completed')}
          </Tag>
          {record.transactionHash && <BlockchainBadge verified={true} compact={true} />}
        </div>
      ),
    },
    {
      title: t('client:records.vaccinePassport.actions'),
      key: 'actions',
      width: 180,
      fixed: 'right',
      render: (_, record) => (
        <div className="flex items-center gap-1">
          <Button
            type="link"
            size="small"
            icon={<DownloadOutlined />}
            onClick={() => handleDownloadRecordPdf(record.id)}
            title={t('client:records.vaccinePassport.exportPassport', 'Export Vaccine Passport')}
          >
            {t('client:records.vaccinePassport.export', 'Export')}
          </Button>
          {record.transactionHash && (
            <Button
              type="link"
              size="small"
              icon={<SafetyCertificateOutlined />}
              onClick={() => {
                setSelectedRecord(record);
                setVerificationModalOpen(true);
              }}
            >
              {t('client:records.vaccinePassport.verify')}
            </Button>
          )}
        </div>
      ),
    },
  ];

  if (loading) {
    return (
      <div className="space-y-6 animate-fade-in">
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
    );
  }

  if (error) {
    return <Alert type="error" message={error} showIcon className="mb-4 rounded-xl" />;
  }

  return (
    <div className="animate-fade-in">
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <Card
          size="small"
          className="rounded-2xl shadow-sm border border-slate-100 bg-gradient-to-br from-blue-50 to-white"
        >
          <div className="flex items-center justify-between p-2">
            <div>
              <Text className="text-slate-500 font-medium uppercase text-xs tracking-wider">
                {t('client:records.vaccinePassport.totalRecords')}
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
                {t('client:records.vaccinePassport.vaccinesTaken')}
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
                {t('client:records.vaccinePassport.lastVaccination')}
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

      <div className="flex justify-end mb-4">
        <Button
          type="primary"
          icon={<FilePdfOutlined />}
          onClick={handleDownloadPdf}
          className="bg-red-500 hover:bg-red-600 border-red-500"
        >
          {t('client:records.vaccinePassport.downloadPdf', 'Download PDF Report')}
        </Button>
      </div>

      <Card className="rounded-3xl shadow-sm border border-slate-100 overflow-hidden">
        <div className="mb-4 px-2">
          <Title level={4} className="!mb-1 text-slate-800">
            {t('client:records.vaccinePassport.recordsTitle')}
          </Title>
          <Text className="text-slate-500">
            {t('client:records.vaccinePassport.recordsSubtitle')}
          </Text>
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
                t('client:records.vaccinePassport.totalRecordsCount', { count: total }),
            }}
            scroll={{ x: 1200 }}
            expandable={{
              expandedRowRender: (record) => (
                <div className="p-4 bg-slate-50 rounded-xl border border-slate-100 m-2">
                  <Descriptions bordered size="small" column={2} className="bg-white rounded-lg">
                    <Descriptions.Item
                      label={t('client:records.vaccinePassport.patientIdentityHash')}
                      span={2}
                    >
                      <Text className="font-mono text-xs text-slate-500">
                        {record.patientIdentityHash}
                      </Text>
                    </Descriptions.Item>
                    <Descriptions.Item label={t('client:records.vaccinePassport.appointmentId')}>
                      <span className="font-mono text-slate-700">{record.appointmentId}</span>
                    </Descriptions.Item>

                    {}
                    {record.transactionHash && (
                      <>
                        <Descriptions.Item
                          label={t('client:records.vaccinePassport.blockchainRecord')}
                          span={2}
                        >
                          <div className="flex items-center gap-2">
                            <BlockchainBadge verified={true} />
                            <Button
                              type="link"
                              size="small"
                              onClick={() => {
                                setSelectedRecord(record);
                                setVerificationModalOpen(true);
                              }}
                            >
                              {t('client:records.vaccinePassport.viewDetails')}
                            </Button>
                          </div>
                        </Descriptions.Item>
                        <Descriptions.Item
                          label={t('client:records.vaccinePassport.transactionHash')}
                          span={2}
                        >
                          <Text className="font-mono text-xs text-emerald-600 break-all">
                            {record.transactionHash}
                          </Text>
                        </Descriptions.Item>
                      </>
                    )}

                    <Descriptions.Item
                      label={t('client:records.vaccinePassport.ipfsHash')}
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
                            {t('client:records.vaccinePassport.viewOnIpfs')}
                          </Button>
                        )}
                      </div>
                    </Descriptions.Item>
                    <Descriptions.Item label={t('client:records.vaccinePassport.notes')} span={2}>
                      {record.notes || (
                        <span className="text-slate-400 italic">
                          {t('client:records.vaccinePassport.noNotes')}
                        </span>
                      )}
                    </Descriptions.Item>
                  </Descriptions>
                </div>
              ),
            }}
            className="custom-table"
          />
        ) : (
          <Empty
            image={Empty.PRESENTED_IMAGE_SIMPLE}
            description={t('client:records.vaccinePassport.noRecords')}
          />
        )}
      </Card>

      <Card className="bg-gradient-to-r from-blue-50 to-indigo-50 border-blue-100 mt-6 rounded-2xl">
        <Title level={5} className="text-blue-900">
          📋 {t('client:records.vaccinePassport.aboutTitle')}
        </Title>
        <ul className="text-sm text-blue-800 mt-2 space-y-1 list-disc pl-4">
          <li>{t('client:records.vaccinePassport.aboutPoint1')}</li>
          <li>{t('client:records.vaccinePassport.aboutPoint2')}</li>
          <li>{t('client:records.vaccinePassport.aboutPoint3')}</li>
          <li>{t('client:records.vaccinePassport.aboutPoint4')}</li>
        </ul>
      </Card>

      {}
      <BlockchainVerificationModal
        open={verificationModalOpen}
        onClose={() => setVerificationModalOpen(false)}
        record={selectedRecord}
      />
    </div>
  );
};

export default VaccineRecordTab;
