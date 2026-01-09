import {
  ArrowRightOutlined,
  SafetyCertificateOutlined,
  SmileOutlined,
  TeamOutlined,
  UserOutlined,
  WomanOutlined,
} from '@ant-design/icons';
import { Button, Card, Empty, Select, Spin, Tabs, Tag } from 'antd';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';
import FadeIn from '@/components/common/animation/FadeIn';
import { callGetMyFamilyMembers } from '@/services/family.service';
import {
  getEssentialVaccines,
  getPregnancySafeVaccines,
  getRecommendedVaccines,
  getVaccinesByCategory,
} from '@/services/vaccine.service';
import useAccountStore from '@/stores/useAccountStore';

// Tính tuổi theo tháng từ ngày sinh
const calculateAgeInMonths = (birthday) => {
  if (!birthday) return null;
  const birthDate = new Date(birthday);
  const today = new Date();
  const months =
    (today.getFullYear() - birthDate.getFullYear()) * 12 +
    (today.getMonth() - birthDate.getMonth());
  return months;
};

// Format tuổi hiển thị
const formatAge = (ageInMonths, t) => {
  if (ageInMonths === null) return '';
  if (ageInMonths < 12) {
    return `${ageInMonths} ${t('home.recommendedVaccines.monthsOld')}`;
  }
  const years = Math.floor(ageInMonths / 12);
  const remainingMonths = ageInMonths % 12;
  if (remainingMonths === 0) {
    return `${years} ${t('home.recommendedVaccines.yearsOld')}`;
  }
  return `${years} ${t('home.recommendedVaccines.yearsOld')} ${remainingMonths} ${t('home.recommendedVaccines.monthsOld').replace('tuổi', '').trim()}`;
};

// Map priority level sang màu tag
const getPriorityColor = (priority) => {
  switch (priority) {
    case 'ESSENTIAL':
      return 'red';
    case 'RECOMMENDED':
      return 'orange';
    case 'OPTIONAL':
      return 'blue';
    case 'TRAVEL':
      return 'green';
    default:
      return 'default';
  }
};

// Map priority level với i18n
const getPriorityText = (priority, t) => {
  const priorityMap = {
    ESSENTIAL: t('home.recommendedVaccines.priority.essential'),
    RECOMMENDED: t('home.recommendedVaccines.priority.recommended'),
    OPTIONAL: t('home.recommendedVaccines.priority.optional'),
    TRAVEL: t('home.recommendedVaccines.priority.travel'),
  };
  return priorityMap[priority] || priority;
};

// Map target group với i18n
const getTargetGroupText = (group, t) => {
  const groups = {
    NEWBORN: t('home.recommendedVaccines.targetGroup.newborn'),
    INFANT: t('home.recommendedVaccines.targetGroup.infant'),
    TODDLER: t('home.recommendedVaccines.targetGroup.toddler'),
    CHILD: t('home.recommendedVaccines.targetGroup.child'),
    TEEN: t('home.recommendedVaccines.targetGroup.teen'),
    ADULT: t('home.recommendedVaccines.targetGroup.adult'),
    ELDERLY: t('home.recommendedVaccines.targetGroup.elderly'),
    PREGNANT: t('home.recommendedVaccines.targetGroup.pregnant'),
    ALL: t('home.recommendedVaccines.targetGroup.all'),
  };
  return groups[group] || group;
};

// Component hiển thị card vaccine
const VaccineCard = ({ vaccine, t }) => (
  <Link to={`/vaccines/${vaccine.slug}`}>
    <Card
      hoverable
      className="h-full rounded-xl overflow-hidden border border-slate-200 hover:shadow-lg transition-all duration-300"
      cover={
        vaccine.image ? (
          <div className="h-36 overflow-hidden bg-slate-100">
            <img
              src={vaccine.image}
              alt={vaccine.name}
              className="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
            />
          </div>
        ) : (
          <div className="h-36 bg-gradient-to-br from-blue-100 to-purple-100 flex items-center justify-center">
            <SafetyCertificateOutlined className="text-4xl text-blue-400" />
          </div>
        )
      }
    >
      <div className="space-y-2">
        <div className="flex flex-wrap gap-1">
          {vaccine.priorityLevel && (
            <Tag color={getPriorityColor(vaccine.priorityLevel)} className="text-xs">
              {getPriorityText(vaccine.priorityLevel, t)}
            </Tag>
          )}
          {vaccine.targetGroup && vaccine.targetGroup !== 'ALL' && (
            <Tag color="purple" className="text-xs">
              {getTargetGroupText(vaccine.targetGroup, t)}
            </Tag>
          )}
        </div>
        <h4 className="font-semibold text-slate-800 line-clamp-2 min-h-[48px]">{vaccine.name}</h4>
        <p className="text-sm text-slate-500 line-clamp-2">{vaccine.descriptionShort}</p>
        <div className="flex justify-between items-center pt-2 border-t border-slate-100">
          <span className="text-lg font-bold text-blue-600">
            {vaccine.price?.toLocaleString('vi-VN')}đ
          </span>
          {vaccine.dosesRequired && (
            <span className="text-xs text-slate-400">
              {vaccine.dosesRequired} {t('home.recommendedVaccines.doses')}
            </span>
          )}
        </div>
      </div>
    </Card>
  </Link>
);

// Component hiển thị danh sách vaccine
const VaccineGrid = ({ vaccines, loading, emptyText, t }) => {
  if (loading) {
    return (
      <div className="flex justify-center py-12">
        <Spin size="large" />
      </div>
    );
  }

  if (!vaccines || vaccines.length === 0) {
    return (
      <Empty
        description={emptyText || t('home.recommendedVaccines.noVaccinesFound')}
        className="py-8"
        image={Empty.PRESENTED_IMAGE_SIMPLE}
      />
    );
  }

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
      {vaccines.slice(0, 8).map((vaccine, index) => (
        <FadeIn key={vaccine.id} delay={index * 50} direction="up">
          <VaccineCard vaccine={vaccine} t={t} />
        </FadeIn>
      ))}
    </div>
  );
};

const RecommendedVaccinesSection = () => {
  const { t } = useTranslation(['client']);
  const { isAuthenticated, user } = useAccountStore();
  const [activeTab, setActiveTab] = useState('personal');
  const [selectedMember, setSelectedMember] = useState(null);
  const [familyMembers, setFamilyMembers] = useState([]);
  const [vaccines, setVaccines] = useState([]);
  const [loading, setLoading] = useState(false);

  // Fetch family members
  useEffect(() => {
    const fetchFamilyMembers = async () => {
      if (!isAuthenticated) return;
      try {
        const res = await callGetMyFamilyMembers();
        if (res?.data) {
          setFamilyMembers(Array.isArray(res.data) ? res.data : res.data.result || []);
        }
      } catch (error) {
        console.error('Error fetching family members:', error);
      }
    };
    fetchFamilyMembers();
  }, [isAuthenticated]);

  // Fetch vaccines based on active tab and selected person
  useEffect(() => {
    const fetchVaccines = async () => {
      setLoading(true);
      try {
        let res;

        if (activeTab === 'maternity') {
          res = await getPregnancySafeVaccines();
        } else if (activeTab === 'children') {
          res = await getVaccinesByCategory('BASIC_CHILDHOOD');
        } else if (activeTab === 'personal') {
          // Vaccine cho bản thân
          const ageInMonths = calculateAgeInMonths(user?.birthday);
          const gender = user?.gender || 'ALL';
          if (ageInMonths !== null) {
            res = await getRecommendedVaccines(ageInMonths, gender);
          } else {
            res = await getEssentialVaccines(12 * 25); // Default 25 tuổi
          }
        } else if (activeTab === 'family' && selectedMember) {
          // Vaccine cho thành viên gia đình
          const member = familyMembers.find((m) => m.id === selectedMember);
          if (member) {
            const ageInMonths = calculateAgeInMonths(member.dateOfBirth || member.birthday);
            const gender = member.gender || 'ALL';
            if (ageInMonths !== null) {
              res = await getRecommendedVaccines(ageInMonths, gender);
            }
          }
        }

        if (res?.data) {
          setVaccines(Array.isArray(res.data) ? res.data : res.data.result || []);
        } else {
          setVaccines([]);
        }
      } catch (error) {
        console.error('Error fetching vaccines:', error);
        setVaccines([]);
      } finally {
        setLoading(false);
      }
    };

    fetchVaccines();
  }, [activeTab, selectedMember, user?.birthday, user?.gender, familyMembers]);

  // Get display info for current selection
  const getCurrentInfo = () => {
    if (activeTab === 'personal') {
      return null;
    }
    if (activeTab === 'family' && selectedMember) {
      const member = familyMembers.find((m) => m.id === selectedMember);
      if (member) {
        const ageInMonths = calculateAgeInMonths(member.dateOfBirth || member.birthday);
        return {
          name: member.fullName,
          age: formatAge(ageInMonths, t),
          gender:
            member.gender === 'MALE'
              ? t('home.recommendedVaccines.male')
              : member.gender === 'FEMALE'
                ? t('home.recommendedVaccines.female')
                : '',
          relationship: member.relationship,
        };
      }
    }
    return null;
  };

  const currentInfo = getCurrentInfo();

  const tabItems = [
    {
      key: 'personal',
      label: (
        <span className="flex items-center gap-2">
          <UserOutlined />
          {t('home.recommendedVaccines.tabs.personal')}
        </span>
      ),
      disabled: !isAuthenticated,
    },
    {
      key: 'family',
      label: (
        <span className="flex items-center gap-2">
          <TeamOutlined />
          {t('home.recommendedVaccines.tabs.family')}
        </span>
      ),
      disabled: !isAuthenticated || familyMembers.length === 0,
    },
    {
      key: 'children',
      label: (
        <span className="flex items-center gap-2">
          <SmileOutlined />
          {t('home.recommendedVaccines.tabs.children')}
        </span>
      ),
    },
    {
      key: 'maternity',
      label: (
        <span className="flex items-center gap-2">
          <WomanOutlined />
          {t('home.recommendedVaccines.tabs.maternity')}
        </span>
      ),
    },
  ];

  return (
    <section className="relative py-20 bg-gradient-to-b from-white to-slate-50 overflow-hidden">
      {/* Background decoration */}
      <div className="absolute top-0 right-0 w-96 h-96 bg-blue-100/30 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2"></div>
      <div className="absolute bottom-0 left-0 w-96 h-96 bg-purple-100/30 rounded-full blur-3xl translate-y-1/2 -translate-x-1/2"></div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        {/* Header */}
        <FadeIn direction="up">
          <div className="text-center mb-12">
            <span className="text-blue-600 font-semibold tracking-wider uppercase text-sm mb-2 block">
              {t('home.recommendedVaccines.subtitle')}
            </span>
            <h2 className="text-3xl md:text-4xl font-bold text-slate-900 mb-4">
              {t('home.recommendedVaccines.title')}{' '}
              <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600">
                {t('home.recommendedVaccines.titleHighlight')}
              </span>
            </h2>
            <p className="text-lg text-slate-600 max-w-2xl mx-auto">
              {t('home.recommendedVaccines.description')}
            </p>
          </div>
        </FadeIn>

        {/* Tabs */}
        <FadeIn direction="up" delay={100}>
          <div className="bg-white rounded-2xl shadow-sm border border-slate-100 p-6 mb-8">
            <Tabs
              activeKey={activeTab}
              onChange={(key) => {
                setActiveTab(key);
                if (key !== 'family') {
                  setSelectedMember(null);
                }
              }}
              items={tabItems}
              className="vaccine-recommendation-tabs"
            />

            {/* Family member selector */}
            {activeTab === 'family' && familyMembers.length > 0 && (
              <div className="mt-4 flex flex-wrap items-center gap-4">
                <span className="text-slate-600">
                  {t('home.recommendedVaccines.selectFamilyMember')}:
                </span>
                <Select
                  placeholder={t('home.recommendedVaccines.chooseFamilyMember')}
                  className="min-w-[200px]"
                  value={selectedMember}
                  onChange={setSelectedMember}
                  options={familyMembers.map((member) => ({
                    value: member.id,
                    label: `${member.fullName} (${member.relationship || t('home.recommendedVaccines.relative')})`,
                  }))}
                />
              </div>
            )}

            {/* Current selection info */}
            {currentInfo && (
              <div className="mt-4 p-4 bg-blue-50 rounded-lg">
                <div className="flex items-center gap-4 text-sm">
                  <span className="font-medium text-blue-800">
                    {t('home.recommendedVaccines.viewingVaccinesFor')}: {currentInfo.name}
                  </span>
                  {currentInfo.age && (
                    <Tag color="blue" className="m-0">
                      {currentInfo.age}
                    </Tag>
                  )}
                  {currentInfo.gender && (
                    <Tag color={currentInfo.gender === 'Nam' ? 'cyan' : 'magenta'} className="m-0">
                      {currentInfo.gender}
                    </Tag>
                  )}
                  {currentInfo.relationship && (
                    <Tag color="purple" className="m-0">
                      {currentInfo.relationship}
                    </Tag>
                  )}
                </div>
              </div>
            )}

            {/* Login prompt */}
            {!isAuthenticated && (activeTab === 'personal' || activeTab === 'family') && (
              <div className="mt-4 p-4 bg-amber-50 rounded-lg text-center">
                <p className="text-amber-800 mb-2">{t('home.recommendedVaccines.loginPrompt')}</p>
                <Link to="/login">
                  <Button type="primary">{t('home.recommendedVaccines.loginNow')}</Button>
                </Link>
              </div>
            )}
          </div>
        </FadeIn>

        {/* Vaccine Grid */}
        <FadeIn direction="up" delay={200}>
          <VaccineGrid
            vaccines={vaccines}
            loading={loading}
            t={t}
            emptyText={
              !isAuthenticated && (activeTab === 'personal' || activeTab === 'family')
                ? t('home.recommendedVaccines.pleaseLogin')
                : activeTab === 'family' && !selectedMember
                  ? t('home.recommendedVaccines.pleaseSelectMember')
                  : t('home.recommendedVaccines.noVaccinesFound')
            }
          />
        </FadeIn>

        {/* View all button */}
        {vaccines.length > 0 && (
          <FadeIn direction="up" delay={300}>
            <div className="text-center mt-8">
              <Link to="/vaccines">
                <Button
                  type="primary"
                  size="large"
                  icon={<ArrowRightOutlined />}
                  className="rounded-full px-8 h-12"
                >
                  {t('home.recommendedVaccines.viewAllVaccines')}
                </Button>
              </Link>
            </div>
          </FadeIn>
        )}
      </div>
    </section>
  );
};

export default RecommendedVaccinesSection;
