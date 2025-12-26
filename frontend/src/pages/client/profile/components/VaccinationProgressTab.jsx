import {
  CalendarOutlined,
  CheckCircleFilled,
  ClockCircleFilled,
  InfoCircleOutlined,
  RightOutlined,
  SafetyCertificateOutlined,
} from '@ant-design/icons';
import {
  Alert,
  Button,
  Card,
  Empty,
  Progress,
  Skeleton,
  Steps,
  Tag,
  Tooltip,
  Typography,
} from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import apiClient from '@/services/apiClient';
import { getGroupedBookingHistory } from '@/services/booking.service';
import useAccountStore from '@/stores/useAccountStore';

const { Title, Text } = Typography;

const VaccinationProgressTab = () => {
  const { t } = useTranslation(['client']);
  const { user } = useAccountStore();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [journeyData, setJourneyData] = useState([]);
  const [recommendation, setRecommendation] = useState(null);
  const [stats, setStats] = useState({ total: 0, completed: 0, verified: 0 });

  useEffect(() => {
    const fetchData = async () => {
      if (!user?.id) return;
      try {
        setLoading(true);

        const [bookingResponse, recordResponse] = await Promise.all([
          getGroupedBookingHistory(),
          apiClient.post('/api/vaccine-records/my-records').catch(() => ({ data: [] })),
        ]);

        const routes = bookingResponse.data || [];
        const records = recordResponse.data || [];

        let nextVaccine = null;
        let totalDoses = 0;
        let completedDoses = 0;
        let verifiedDoses = 0;

        const journeyList = routes.map((route) => {
          const steps = [];
          const appointments = route.appointments || [];

          for (let i = 1; i <= route.requiredDoses; i++) {
            const apt = appointments.find((a) => (a.doseNumber || 0) === i);

            let stepStatus = 'wait';
            let description = t('client:records.vaccinationHistory.notScheduled');
            const title = `${t('client:records.vaccinationHistory.dose')} ${i}`;
            let date = null;
            let isVerified = false;

            if (apt) {
              // Check verification for MAIN user ONLY (since we fetched my-records)
              if (!route.isFamily) {
                const record = records.find(
                  (r) =>
                    (r.appointmentId && r.appointmentId === apt.id) ||
                    (r.vaccineSlug === route.vaccineSlug && r.doseNumber === i)
                );
                if (record) {
                  isVerified = true;
                  verifiedDoses++;
                }
              }

              if (apt.appointmentStatus === 'COMPLETED') {
                stepStatus = 'finish';
                description = t('client:records.vaccinationHistory.completed');
                date = apt.vaccinationDate || apt.scheduledDate;
                if (!route.isFamily) completedDoses++;
              } else if (apt.appointmentStatus !== 'CANCELLED') {
                stepStatus = 'process';
                description = t('client:records.vaccinationHistory.scheduled');
                date = apt.scheduledDate;
              }
            } else {
              const prevApt = appointments.find((a) => (a.doseNumber || 0) === i - 1);

              if (i === 1 && !apt) {
                stepStatus = 'wait';
                description = t('client:records.progress.readyToBook');
                // Recommendation Logic (Prioritize User's In-Progress)
                if (!nextVaccine && !route.isFamily && route.status === 'IN_PROGRESS') {
                  // prioritized
                }
              } else if (prevApt && prevApt.appointmentStatus === 'COMPLETED') {
                stepStatus = 'wait';
                description = t('client:records.progress.needToBook');
              }
            }

            // Set Recommendation
            if (!nextVaccine && stepStatus === 'wait' && !route.isFamily) {
              nextVaccine = {
                vaccineName: route.vaccineName,
                doseNumber: i,
                vaccineSlug: route.vaccineSlug,
                vaccinationCourseId: route.routeId,
              };
            }

            if (!route.isFamily) totalDoses++;

            steps.push({
              title,
              description,
              status: stepStatus,
              date: date ? dayjs(date).format('DD/MM/YYYY') : null,
              doseNumber: i,
              isVerified,
            });
          }

          return {
            vaccinationCourseId: route.routeId,
            vaccineName: route.vaccineName,
            vaccineSlug: route.vaccineSlug,
            patientName: route.patientName,
            isFamily: route.isFamily,
            requiredDoses: route.requiredDoses,
            cycleIndex: route.cycleIndex,
            steps,
            status: route.status,
          };
        });

        const activeJourneys = journeyList.filter(
          (journey) =>
            journey.steps.filter((s) => s.status === 'finish').length < journey.requiredDoses
        );

        setJourneyData(activeJourneys);
        setRecommendation(nextVaccine);
        setStats({ total: totalDoses, completed: completedDoses, verified: verifiedDoses });
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [user?.id, t]);

  if (loading) {
    return <Skeleton active />;
  }
  return (
    <div className="space-y-6">
      <div className="mb-4">
        <Title level={4}>{t('client:records.progress.title')}</Title>
        <Text type="secondary">{t('client:records.progress.subtitle')}</Text>
      </div>

      {/* My Status Section */}
      <div className="bg-white p-4 rounded-xl shadow-sm border border-slate-100 mb-6">
        <div className="flex flex-col md:flex-row gap-4 justify-between items-center">
          <div className="flex-1 w-full">
            <h4 className="text-gray-600 mb-2 font-medium">
              {t('client:records.progress.myProtectionStatus')}
            </h4>
            <Progress
              percent={stats.total > 0 ? Math.round((stats.completed / stats.total) * 100) : 0}
              strokeColor={{ '0%': '#108ee9', '100%': '#87d068' }}
            />
          </div>
          <div className="flex gap-4">
            <div className="text-center">
              <div className="text-2xl font-bold text-green-600">{stats.verified}</div>
              <div className="text-xs text-gray-400 uppercase tracking-wider">
                {t('client:records.progress.verified')}
              </div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">{stats.completed}</div>
              <div className="text-xs text-gray-400 uppercase tracking-wider">
                {t('client:records.progress.completed')}
              </div>
            </div>
          </div>
        </div>
      </div>

      {recommendation && (
        <Alert
          message={
            <span className="font-semibold text-blue-800">
              {t('client:records.progress.recommendation')}
            </span>
          }
          description={
            <div className="flex flex-col gap-2 mt-1">
              <span className="text-blue-700">
                {t('client:records.progress.recommendationDesc')}
                <b>
                  {' '}
                  {recommendation.vaccineName} - Dose {recommendation.doseNumber}
                </b>
              </span>
              <Button
                type="primary"
                size="small"
                className="w-fit bg-blue-600"
                onClick={() =>
                  navigate(
                    `/booking?slug=${recommendation.vaccineSlug}&doseNumber=${recommendation.doseNumber}&vaccinationCourseId=${recommendation.vaccinationCourseId}`
                  )
                }
              >
                {t('client:records.progress.bookNow')}
              </Button>
            </div>
          }
          type="info"
          showIcon
          icon={<InfoCircleOutlined className="text-blue-600" />}
          className="border-blue-100 bg-blue-50 rounded-xl mb-6"
        />
      )}

      {journeyData.length === 0 ? (
        <Empty description={t('client:dashboard.noData')} className="py-8" />
      ) : (
        journeyData.map((journey) => (
          <Card
            key={journey.vaccinationCourseId}
            className="shadow-sm rounded-2xl border-slate-100"
          >
            <div className="flex justify-between items-start mb-6">
              <div>
                <h3 className="text-lg font-bold text-blue-800">{journey.vaccineName}</h3>
                <div className="text-slate-500 text-sm">
                  {t('client:records.progress.patient')}:{' '}
                  <span className="font-medium text-slate-700">{journey.patientName}</span>
                  {journey.isFamily && (
                    <Tag color="purple" className="ml-2">
                      {t('client:records.progress.relative')}
                    </Tag>
                  )}
                </div>
              </div>

              {journey.steps.filter((s) => s.status === 'finish').length >=
              journey.requiredDoses ? (
                <Tag color="green" icon={<CheckCircleFilled />}>
                  {t('client:records.vaccinationHistory.completed')}
                </Tag>
              ) : journey.steps.some((s) => s.status === 'process') ? (
                <Tag color="blue" icon={<ClockCircleFilled />}>
                  {t('client:records.vaccinationHistory.scheduled')}
                </Tag>
              ) : (
                <Button
                  type="primary"
                  size="small"
                  icon={<RightOutlined />}
                  onClick={() =>
                    navigate(
                      `/booking?slug=${journey.vaccineSlug}&doseNumber=${
                        journey.steps.filter((s) => s.status === 'finish').length + 1
                      }&vaccinationCourseId=${journey.vaccinationCourseId}`
                    )
                  }
                >
                  {t('client:records.progress.bookNext')}
                </Button>
              )}
            </div>

            <Steps
              current={
                journey.steps.findIndex((s) => s.status === 'process') !== -1
                  ? journey.steps.findIndex((s) => s.status === 'process')
                  : journey.steps.filter((s) => s.status === 'finish').length
              }
              items={journey.steps.map((step) => ({
                title: (
                  <div className="flex items-center gap-1">
                    <span>{step.title}</span>
                    {step.isVerified && (
                      <Tooltip title={t('client:records.progress.verifiedOnBlockchain')}>
                        <SafetyCertificateOutlined className="text-emerald-500" />
                      </Tooltip>
                    )}
                  </div>
                ),
                description: (
                  <div>
                    <div>{step.description}</div>
                    {step.date && <div className="text-xs text-slate-400">{step.date}</div>}
                  </div>
                ),
                status: step.status,
                icon:
                  step.status === 'finish' ? (
                    <CheckCircleFilled />
                  ) : step.status === 'process' ? (
                    <ClockCircleFilled />
                  ) : (
                    <CalendarOutlined />
                  ),
              }))}
            />
          </Card>
        ))
      )}
    </div>
  );
};

export default VaccinationProgressTab;
