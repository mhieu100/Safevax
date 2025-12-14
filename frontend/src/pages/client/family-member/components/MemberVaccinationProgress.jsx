import {
  CalendarOutlined,
  CheckCircleFilled,
  ClockCircleFilled,
  InfoCircleOutlined,
  RightOutlined,
  SafetyCertificateOutlined,
} from '@ant-design/icons';
import { Alert, Button, Card, Progress, Skeleton, Steps, Tooltip } from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import apiClient from '@/services/apiClient';
import { callGetFamilyMemberRecords } from '@/services/family.service';

const MemberVaccinationProgress = ({ memberId, customData }) => {
  const { t } = useTranslation(['client']);
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [journeyData, setJourneyData] = useState([]);
  const [recommendation, setRecommendation] = useState(null);
  const [stats, setStats] = useState({ total: 0, completed: 0, verified: 0 });

  useEffect(() => {
    const processData = (routes, records = []) => {
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
          let description = t('client:vaccinationHistory.notScheduled');
          const title = `${t('client:vaccinationHistory.dose')} ${i}`;
          let date = null;
          let isVerified = false;

          if (apt) {
            // Check if this appointment has a blockchain record
            // Assuming apt.id match record.appointmentId or we match by vaccineSlug and dose
            const record = records.find(
              (r) =>
                (r.appointmentId && r.appointmentId === apt.id) ||
                (r.vaccineSlug === route.vaccineSlug && r.doseNumber === i)
            );

            if (record) {
              isVerified = true;
              verifiedDoses++;
            }

            if (apt.appointmentStatus === 'COMPLETED') {
              stepStatus = 'finish';
              description = t('client:vaccinationHistory.completed');
              date = apt.vaccinationDate || apt.scheduledDate;
              completedDoses++;
            } else if (apt.appointmentStatus !== 'CANCELLED') {
              stepStatus = 'process';
              description = t('client:vaccinationHistory.scheduled');
              date = apt.scheduledDate;
            }
          } else {
            const prevApt = appointments.find((a) => (a.doseNumber || 0) === i - 1);
            if (i === 1 && !apt) {
              stepStatus = 'wait';
              description = t('client:progress.readyToBook');
              // Found a potential recommendation
              if (!nextVaccine && route.status === 'IN_PROGRESS') {
                // Prioritize IN_PROGRESS routes
              }
            } else if (prevApt && prevApt.appointmentStatus === 'COMPLETED') {
              stepStatus = 'wait';
              description = t('client:progress.needToBook');
            }
          }

          // Determine recommendation
          if (!nextVaccine && stepStatus === 'wait') {
            nextVaccine = {
              vaccineName: route.vaccineName,
              doseNumber: i,
              vaccineSlug: route.vaccineSlug,
              vaccinationCourseId: route.routeId,
            };
          }

          totalDoses++;

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
          requiredDoses: route.requiredDoses,
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
    };

    const fetchData = async () => {
      if (!memberId && !customData) return;

      try {
        setLoading(true);

        // Fetch Booking History (if not provided)
        let routes = customData;
        if (!routes) {
          const response = await apiClient.post('/api/family-members/booking-history-grouped', {
            id: memberId,
          });
          routes = response.data || [];
        }

        // Fetch Blockchain Records (Always fetch to get verification status)
        let records = [];
        try {
          // We can use the service we imported
          const recordResponse = await callGetFamilyMemberRecords(memberId);
          records = recordResponse.data || [];
        } catch (e) {
          console.warn('Could not fetch blockchain records', e);
        }

        processData(routes, records);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [memberId, customData, t]);

  if (loading) return <Skeleton active />;

  if (journeyData.length === 0) {
    return (
      <div className="p-4 bg-slate-50 rounded-xl text-center text-gray-500">
        {t('client:dashboard.noData')}
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Summary / Status Section */}
      <div className="bg-white p-4 rounded-xl shadow-sm border border-slate-100">
        <div className="flex flex-col md:flex-row gap-4 justify-between items-center">
          <div className="flex-1 w-full">
            <h4 className="text-gray-600 mb-2 font-medium">Protection Status</h4>
            <Progress
              percent={stats.total > 0 ? Math.round((stats.completed / stats.total) * 100) : 0}
              strokeColor={{ '0%': '#108ee9', '100%': '#87d068' }}
            />
          </div>
          <div className="flex gap-4">
            <div className="text-center">
              <div className="text-2xl font-bold text-green-600">{stats.verified}</div>
              <div className="text-xs text-gray-400 uppercase tracking-wider">Verified</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-blue-600">{stats.completed}</div>
              <div className="text-xs text-gray-400 uppercase tracking-wider">Completed</div>
            </div>
          </div>
        </div>
      </div>

      {/* Recommendation Section */}
      {recommendation && (
        <Alert
          message={<span className="font-semibold text-blue-800">{t('Recommendation')}</span>}
          description={
            <div className="flex flex-col gap-2 mt-1">
              <span className="text-blue-700">
                To ensure full protection, the next recommended step is:
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
                    `/booking?slug=${recommendation.vaccineSlug}&doseNumber=${recommendation.doseNumber}&vaccinationCourseId=${recommendation.vaccinationCourseId}&familyMemberId=${memberId}`
                  )
                }
              >
                Book Now
              </Button>
            </div>
          }
          type="info"
          showIcon
          icon={<InfoCircleOutlined className="text-blue-600" />}
          className="border-blue-100 bg-blue-50 rounded-xl"
        />
      )}

      {/* Timeline Section */}
      <div className="p-4 bg-slate-50 rounded-xl">
        <h3 className="font-semibold text-gray-700 mb-4">{t('client:progress.title')}</h3>
        {journeyData.length === 0 ? (
          <div className="text-center text-gray-500 py-4">{t('client:dashboard.noData')}</div>
        ) : (
          journeyData.map((journey) => (
            <Card
              key={journey.vaccinationCourseId}
              className="shadow-sm rounded-xl border-slate-200 mb-4"
              size="small"
            >
              <div className="flex justify-between items-start mb-4">
                <div>
                  <h4 className="font-bold text-blue-800 m-0">{journey.vaccineName}</h4>
                </div>
                {/* Action Button */}
                {journey.steps.filter((s) => s.status === 'finish').length <
                  journey.requiredDoses &&
                  !journey.steps.some((s) => s.status === 'process') && (
                    <Button
                      type="primary"
                      size="small"
                      icon={<RightOutlined />}
                      onClick={() =>
                        navigate(
                          `/booking?slug=${journey.vaccineSlug}&doseNumber=${
                            journey.steps.filter((s) => s.status === 'finish').length + 1
                          }&vaccinationCourseId=${journey.vaccinationCourseId}&familyMemberId=${memberId}`
                        )
                      }
                    >
                      {t('client:progress.bookNext')}
                    </Button>
                  )}
              </div>

              <Steps
                size="small"
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
                        <Tooltip title="Verified on Blockchain">
                          <SafetyCertificateOutlined className="text-emerald-500" />
                        </Tooltip>
                      )}
                    </div>
                  ),
                  description: (
                    <div>
                      <div>{step.description}</div>
                      {step.date && <span className="text-xs text-gray-400">{step.date}</span>}
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
    </div>
  );
};

export default MemberVaccinationProgress;
