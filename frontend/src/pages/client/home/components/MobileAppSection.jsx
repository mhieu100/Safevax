import {
  AndroidFilled,
  AppleFilled,
  CalendarOutlined,
  HistoryOutlined,
  LineChartOutlined,
  TeamOutlined,
} from '@ant-design/icons';
import { Button } from 'antd';
import { useTranslation } from 'react-i18next';
import mobileMockup from '@/assets/images/mobile_mockup.jpg';
import FadeIn from '@/components/common/animation/FadeIn';

const MobileAppSection = () => {
  const { t } = useTranslation('client');

  return (
    <section className="bg-[#1e1b4b] py-16 md:py-24 overflow-hidden relative">
      {/* Background Circles/Glows */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-blue-600/20 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 relative z-10">
        <div className="text-center mb-16">
          <FadeIn>
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-4 uppercase tracking-wide">
              {t('home.mobileApp.title')}
            </h2>
            <p className="text-slate-300 max-w-2xl mx-auto text-lg leading-relaxed">
              {t('home.mobileApp.description')}
            </p>
          </FadeIn>
        </div>

        <div className="flex flex-col lg:flex-row items-center justify-between gap-12 lg:gap-8">
          {/* Left Column */}
          <div className="flex-1 space-y-12">
            <FadeIn direction="right" delay={100}>
              <div className="bg-white/5 backdrop-blur-md border border-white/10 rounded-2xl p-6 hover:bg-white/10 transition-all duration-300 shadow-lg group cursor-pointer hover:-translate-y-1">
                <div className="flex items-start gap-4">
                  <div className="flex-shrink-0 w-14 h-14 rounded-2xl bg-gradient-to-br from-cyan-400 to-cyan-600 flex items-center justify-center shadow-lg shadow-cyan-400/20 group-hover:scale-110 transition-transform duration-300">
                    <CalendarOutlined className="text-2xl text-white" />
                  </div>
                  <div className="text-left">
                    <h3 className="text-lg font-bold text-white mb-2 group-hover:text-cyan-300 transition-colors">
                      {t('home.mobileApp.features.schedule.title')}
                    </h3>
                    <p className="text-slate-300 text-sm leading-relaxed">
                      {t('home.mobileApp.features.schedule.desc')}
                    </p>
                  </div>
                </div>
              </div>
            </FadeIn>

            <FadeIn direction="right" delay={200}>
              <div className="bg-white/5 backdrop-blur-md border border-white/10 rounded-2xl p-6 hover:bg-white/10 transition-all duration-300 shadow-lg group cursor-pointer hover:-translate-y-1">
                <div className="flex items-start gap-4">
                  <div className="flex-shrink-0 w-14 h-14 rounded-2xl bg-gradient-to-br from-lime-400 to-lime-600 flex items-center justify-center shadow-lg shadow-lime-500/20 group-hover:scale-110 transition-transform duration-300">
                    <LineChartOutlined className="text-2xl text-white" />
                  </div>
                  <div className="text-left">
                    <h3 className="text-lg font-bold text-white mb-2 group-hover:text-lime-300 transition-colors">
                      {t('home.mobileApp.features.growth.title')}
                    </h3>
                    <p className="text-slate-300 text-sm leading-relaxed">
                      {t('home.mobileApp.features.growth.desc')}
                    </p>
                  </div>
                </div>
              </div>
            </FadeIn>

            <FadeIn direction="right" delay={300}>
              <div className="flex flex-col items-end lg:items-end mt-8">
                <div className="flex items-center gap-2 text-yellow-400 font-bold text-xl mb-2 animate-pulse">
                  <span>{t('home.mobileApp.cta.download')}</span>
                  <span>›››</span>
                </div>
                <div className="text-yellow-400 font-bold text-xl">
                  {t('home.mobileApp.cta.book')}
                </div>
              </div>
            </FadeIn>
          </div>

          {/* Center Phone Mockup */}
          {/* Center Phone Mockup */}
          <div className="flex-shrink-0 w-full max-w-[320px] mx-auto">
            <FadeIn direction="up">
              {/* Premium Silver Frame Container */}
              {/* Premium Silver Frame Container - Thinner Border */}
              <div className="relative mx-auto w-[300px] h-[600px] bg-gradient-to-br from-[#e0e0e0] via-[#f8f8f8] to-[#d0d0d0] rounded-[3.2rem] p-1.5 shadow-[0_0_2px_rgba(0,0,0,0.1),0_10px_40px_rgba(0,0,0,0.2),inset_0_0_8px_rgba(255,255,255,0.8)] border border-[#d1d5db]">
                {/* Side Buttons - Thin Silver Style */}
                <div className="absolute top-24 -left-[2px] h-8 w-[2px] bg-[#d1d5db] rounded-l-sm shadow-sm"></div>
                <div className="absolute top-40 -left-[2px] h-12 w-[2px] bg-[#d1d5db] rounded-l-sm shadow-sm"></div>
                <div className="absolute top-56 -left-[2px] h-12 w-[2px] bg-[#d1d5db] rounded-l-sm shadow-sm"></div>
                <div className="absolute top-44 -right-[2px] h-16 w-[2px] bg-[#d1d5db] rounded-r-sm shadow-sm"></div>

                {/* Inner Screen Container - No Black Border */}
                <div className="w-full h-full bg-white rounded-[3rem] overflow-hidden relative shadow-inner">
                  {/* Dynamic Island / Notch Area */}
                  <div className="absolute top-4 left-1/2 -translate-x-1/2 w-28 h-7 bg-black rounded-full z-20 flex items-center justify-center">
                    <div className="w-16 h-4 bg-[#1a1a1a] rounded-full"></div>
                  </div>

                  {/* Image with Scale to crop any edges */}
                  <img
                    src={mobileMockup}
                    alt="SafeVax Mobile App"
                    className="w-full h-full object-cover scale-[1.15]"
                  />

                  {/* Premium Glass Reflection */}
                  <div className="absolute inset-0 bg-gradient-to-tr from-white/0 via-white/5 to-white/20 pointer-events-none rounded-[3rem] z-10"></div>
                </div>
              </div>
            </FadeIn>
          </div>

          {/* Right Column */}
          <div className="flex-1 space-y-12">
            <FadeIn direction="left" delay={100}>
              <div className="bg-white/5 backdrop-blur-md border border-white/10 rounded-2xl p-6 hover:bg-white/10 transition-all duration-300 shadow-lg group cursor-pointer hover:-translate-y-1">
                <div className="flex items-start gap-4">
                  <div className="flex-shrink-0 w-14 h-14 rounded-2xl bg-gradient-to-br from-pink-400 to-pink-600 flex items-center justify-center shadow-lg shadow-pink-500/20 group-hover:scale-110 transition-transform duration-300">
                    <TeamOutlined className="text-2xl text-white" />
                  </div>
                  <div className="text-left">
                    <h3 className="text-lg font-bold text-white mb-2 group-hover:text-pink-300 transition-colors">
                      {t('home.mobileApp.features.family.title')}
                    </h3>
                    <p className="text-slate-300 text-sm leading-relaxed">
                      {t('home.mobileApp.features.family.desc')}
                    </p>
                  </div>
                </div>
              </div>
            </FadeIn>

            <FadeIn direction="left" delay={200}>
              <div className="bg-white/5 backdrop-blur-md border border-white/10 rounded-2xl p-6 hover:bg-white/10 transition-all duration-300 shadow-lg group cursor-pointer hover:-translate-y-1">
                <div className="flex items-start gap-4">
                  <div className="flex-shrink-0 w-14 h-14 rounded-2xl bg-gradient-to-br from-blue-400 to-blue-600 flex items-center justify-center shadow-lg shadow-blue-500/20 group-hover:scale-110 transition-transform duration-300">
                    <HistoryOutlined className="text-2xl text-white" />
                  </div>
                  <div className="text-left">
                    <h3 className="text-lg font-bold text-white mb-2 group-hover:text-blue-300 transition-colors">
                      {t('home.mobileApp.features.history.title')}
                    </h3>
                    <p className="text-slate-300 text-sm leading-relaxed">
                      {t('home.mobileApp.features.history.desc')}
                    </p>
                  </div>
                </div>
              </div>
            </FadeIn>

            <FadeIn direction="left" delay={300}>
              <div className="flex flex-col sm:flex-row gap-4 mt-8">
                <Button
                  size="large"
                  icon={<AppleFilled className="text-2xl" />}
                  className="h-14 px-6 rounded-xl bg-white/10 border-white/20 text-white hover:bg-white/20 hover:border-white/40 flex items-center gap-2"
                >
                  <div className="flex flex-col items-start leading-tight">
                    <span className="text-[10px] font-medium opacity-80">
                      {t('home.mobileApp.buttons.appStore.sub')}
                    </span>
                    <span className="text-lg font-bold">
                      {t('home.mobileApp.buttons.appStore.main')}
                    </span>
                  </div>
                </Button>
                <Button
                  size="large"
                  icon={<AndroidFilled className="text-2xl" />}
                  className="h-14 px-6 rounded-xl bg-white/10 border-white/20 text-white hover:bg-white/20 hover:border-white/40 flex items-center gap-2"
                >
                  <div className="flex flex-col items-start leading-tight">
                    <span className="text-[10px] font-medium opacity-80">
                      {t('home.mobileApp.buttons.googlePlay.sub')}
                    </span>
                    <span className="text-lg font-bold">
                      {t('home.mobileApp.buttons.googlePlay.main')}
                    </span>
                  </div>
                </Button>
              </div>
            </FadeIn>
          </div>
        </div>
      </div>
    </section>
  );
};

export default MobileAppSection;
