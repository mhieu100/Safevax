import { Tabs } from 'antd';
import { useTranslation } from 'react-i18next';
import VaccinationHistoryTab from './VaccinationHistoryTab';
import VaccineRecordTab from './VaccineRecordTab';

const MyRecordsTab = () => {
  const { t } = useTranslation(['client']);
  const items = [
    {
      key: 'history',
      label: t('client:records.myRecords.vaccinationHistory'),
      children: <VaccinationHistoryTab />,
    },
    {
      key: 'records',
      label: t('client:records.myRecords.medicalRecords'),
      children: <VaccineRecordTab />,
    },
  ];

  return (
    <div className="bg-white p-6 rounded-3xl shadow-sm border border-slate-100">
      <Tabs defaultActiveKey="history" items={items} type="card" />
    </div>
  );
};

export default MyRecordsTab;
