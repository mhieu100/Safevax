import {
  BlockOutlined,
  GlobalOutlined,
  SafetyCertificateFilled,
  TeamOutlined,
  ThunderboltOutlined,
} from '@ant-design/icons';
import { Button, Timeline } from 'antd';
import { useTranslation } from 'react-i18next';
import { Link, useNavigate } from 'react-router-dom';

const AboutPage = () => {
  const navigate = useNavigate();
  const { t } = useTranslation(['client']);

  const stats = [
    {
      label: t('client:about.stats.vaccinesTracked'),
      value: '1M+',
      icon: <SafetyCertificateFilled />,
    },
    { label: t('client:about.stats.partnerCenters'), value: '50+', icon: <BlockOutlined /> },
    { label: t('client:about.stats.happyUsers'), value: '100k+', icon: <TeamOutlined /> },
    { label: t('client:about.stats.uptime'), value: '99.9%', icon: <ThunderboltOutlined /> },
  ];

  const features = [
    {
      title: t('client:about.features.blockchainSecurity'),
      description: t('client:about.features.blockchainSecurityDesc'),
      icon: <BlockOutlined className="text-4xl text-blue-500" />,
    },
    {
      title: t('client:about.features.globalAccessibility'),
      description: t('client:about.features.globalAccessibilityDesc'),
      icon: <GlobalOutlined className="text-4xl text-green-500" />,
    },
    {
      title: t('client:about.features.instantVerification'),
      description: t('client:about.features.instantVerificationDesc'),
      icon: <ThunderboltOutlined className="text-4xl text-yellow-500" />,
    },
  ];

  return (
    <div className="min-h-screen bg-slate-50">
      {/* Hero Section */}
      <div className="relative bg-slate-900 overflow-hidden py-24 sm:py-32">
        <div className="absolute inset-0">
          <div className="absolute inset-0 bg-gradient-to-br from-blue-900/90 to-slate-900/90 mix-blend-multiply" />
          <div className="absolute top-[-10%] left-[-10%] w-[500px] h-[500px] bg-blue-500/30 rounded-full blur-[100px] animate-blob" />
          <div className="absolute bottom-[-10%] right-[-10%] w-[500px] h-[500px] bg-indigo-500/30 rounded-full blur-[100px] animate-blob animation-delay-2000" />
        </div>

        <div className="relative mx-auto max-w-7xl px-6 lg:px-8 text-center">
          <div className="mx-auto max-w-2xl">
            <div className="mb-8 flex justify-center">
              <div className="relative rounded-full px-3 py-1 text-sm leading-6 text-slate-400 ring-1 ring-white/10 hover:ring-white/20">
                {t('client:about.hero.revolutionizing')}{' '}
                <Link to="/register" className="font-semibold text-blue-400">
                  <span className="absolute inset-0" aria-hidden="true" />
                  {t('client:about.hero.readMore')} <span aria-hidden="true">&rarr;</span>
                </Link>
              </div>
            </div>
            <h1
              className="text-4xl font-bold tracking-tight text-white sm:text-6xl bg-clip-text text-transparent bg-gradient-to-r from-blue-200 to-indigo-200"
              dangerouslySetInnerHTML={{ __html: t('client:about.hero.trustTitle') }}
            />
            <p className="mt-6 text-lg leading-8 text-slate-300">
              {t('client:about.hero.description')}
            </p>
            <div className="mt-10 flex items-center justify-center gap-x-6">
              <Button
                type="primary"
                size="large"
                className="h-12 px-8 rounded-xl bg-blue-600 hover:bg-blue-50 border-none shadow-lg shadow-blue-500/30 text-base font-semibold"
                onClick={() => navigate('/register')}
              >
                {t('client:about.hero.getStarted')}
              </Button>
              <Button
                type="text"
                size="large"
                className="text-white hover:text-blue-300 font-semibold"
                onClick={() => navigate('/contact')}
              >
                {t('client:about.hero.contactSales')} <span aria-hidden="true">→</span>
              </Button>
            </div>
          </div>
        </div>
      </div>

      {/* Stats Section */}
      <div className="relative -mt-12 mx-auto max-w-7xl px-6 lg:px-8 z-10">
        <div className="grid grid-cols-1 gap-y-16 gap-x-8 sm:grid-cols-2 lg:grid-cols-4 bg-white rounded-2xl shadow-xl p-8 border border-slate-100">
          {stats.map((stat) => (
            <div
              key={stat.label}
              className="flex flex-col gap-y-2 border-l border-slate-100 pl-6 first:border-l-0"
            >
              <dt className="text-sm leading-6 text-slate-500 font-medium">{stat.label}</dt>
              <dd className="order-first text-3xl font-semibold tracking-tight text-slate-900 flex items-center gap-2">
                <span className="text-blue-600">{stat.icon}</span>
                {stat.value}
              </dd>
            </div>
          ))}
        </div>
      </div>

      {/* Mission Section */}
      <div className="mx-auto max-w-7xl px-6 lg:px-8 py-24 sm:py-32">
        <div className="mx-auto max-w-2xl lg:text-center">
          <h2 className="text-base font-semibold leading-7 text-blue-600">
            {t('client:about.mission.title')}
          </h2>
          <p className="mt-2 text-3xl font-bold tracking-tight text-slate-900 sm:text-4xl">
            {t('client:about.mission.heading')}
          </p>
          <p className="mt-6 text-lg leading-8 text-slate-600">
            {t('client:about.mission.description')}
          </p>
        </div>

        <div className="mx-auto mt-16 max-w-2xl sm:mt-20 lg:mt-24 lg:max-w-none">
          <dl className="grid max-w-xl grid-cols-1 gap-x-8 gap-y-16 lg:max-w-none lg:grid-cols-3">
            {features.map((feature) => (
              <div
                key={feature.title}
                className="flex flex-col bg-white p-8 rounded-2xl shadow-sm border border-slate-100 hover:shadow-md transition-shadow"
              >
                <dt className="flex items-center gap-x-3 text-base font-semibold leading-7 text-slate-900 mb-4">
                  {feature.icon}
                  {feature.title}
                </dt>
                <dd className="flex flex-auto flex-col text-base leading-7 text-slate-600">
                  <p className="flex-auto">{feature.description}</p>
                </dd>
              </div>
            ))}
          </dl>
        </div>
      </div>

      {/* Timeline Section */}
      <div className="bg-white py-24 sm:py-32">
        <div className="mx-auto max-w-7xl px-6 lg:px-8">
          <div className="mx-auto max-w-2xl lg:text-center mb-16">
            <h2 className="text-base font-semibold leading-7 text-blue-600">
              {t('client:about.journey.title')}
            </h2>
            <p className="mt-2 text-3xl font-bold tracking-tight text-slate-900 sm:text-4xl">
              {t('client:about.journey.milestones')}
            </p>
          </div>
          <div className="max-w-3xl mx-auto">
            <Timeline
              mode="alternate"
              items={[
                {
                  children: (
                    <div className="mb-8">
                      <h3 className="font-bold text-lg">{t('client:about.journey.2023.title')}</h3>
                      <p className="text-slate-500">{t('client:about.journey.2023.desc')}</p>
                    </div>
                  ),
                  color: 'blue',
                },
                {
                  children: (
                    <div className="mb-8">
                      <h3 className="font-bold text-lg">{t('client:about.journey.2024.title')}</h3>
                      <p className="text-slate-500">{t('client:about.journey.2024.desc')}</p>
                    </div>
                  ),
                  color: 'green',
                },
                {
                  children: (
                    <div className="mb-8">
                      <h3 className="font-bold text-lg">{t('client:about.journey.2025.title')}</h3>
                      <p className="text-slate-500">{t('client:about.journey.2025.desc')}</p>
                    </div>
                  ),
                  color: 'red',
                },
                {
                  children: (
                    <div>
                      <h3 className="font-bold text-lg">
                        {t('client:about.journey.future.title')}
                      </h3>
                      <p className="text-slate-500">{t('client:about.journey.future.desc')}</p>
                    </div>
                  ),
                  color: 'gray',
                },
              ]}
            />
          </div>
        </div>
      </div>

      {/* CTA Section */}
      <div className="bg-blue-600">
        <div className="px-6 py-24 sm:px-6 sm:py-32 lg:px-8">
          <div className="mx-auto max-w-2xl text-center">
            <h2
              className="text-3xl font-bold tracking-tight text-white sm:text-4xl"
              dangerouslySetInnerHTML={{ __html: t('client:about.cta.title') }}
            />
            <p className="mx-auto mt-6 max-w-xl text-lg leading-8 text-blue-100">
              {t('client:about.cta.description')}
            </p>
            <div className="mt-10 flex items-center justify-center gap-x-6">
              <Button
                size="large"
                className="h-12 px-8 rounded-xl bg-white text-blue-600 hover:bg-blue-50 border-none font-semibold shadow-lg"
                onClick={() => navigate('/register')}
              >
                {t('client:about.cta.createAccount')}
              </Button>
              <Button
                type="text"
                size="large"
                className="text-white hover:text-blue-100 font-semibold"
                onClick={() => navigate('/vaccines')}
              >
                {t('client:about.cta.viewVaccines')} <span aria-hidden="true">→</span>
              </Button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AboutPage;
