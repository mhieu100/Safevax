import {
  AndroidFilled,
  AppleFilled,
  CalendarOutlined,
  HistoryOutlined,
  LineChartOutlined,
  TeamOutlined,
} from '@ant-design/icons';
import { Button } from 'antd';
import mobileMockup from '@/assets/images/mobile_mockup.jpg';
import FadeIn from '@/components/common/animation/FadeIn';

const MobileAppSection = () => {
  // Placeholder for the Mobile Screen Image
  // Using the path to the generated image artifact: /home/mhieu/.gemini/antigravity/brain/18673e3a-ab93-4af0-b184-dc3f8ebc1a86/mobile_app_screen_1765714535823.png
  // I will assume for now I can reference it, or I should put it in public.
  // Since I can't easily move files to public without `cp`, I will use a placeholder styling or the absolute path if it works for local dev (it won't for production).
  // Actually, for this environment, I can try to use a representative URL or just a nice CSS placeholder if I can't serve the artifact.
  // But wait, the previous tools allow me to see the path. I can't "serve" it to the frontend unless it's in `public` or `src/assets`.
  // I'll stick to a nice placeholder or a reliable external URL for "App Mockup" if I can't use the generated one properly.
  // Actually, I'll use a CSS-only phone frame with "SafeVax" text inside, mimicking the image I generated. It's safer.

  return (
    <section className="bg-[#1e1b4b] py-16 md:py-24 overflow-hidden relative">
      {/* Background Circles/Glows */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-blue-600/20 rounded-full blur-3xl pointer-events-none" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 relative z-10">
        <div className="text-center mb-16">
          <FadeIn>
            <h2 className="text-3xl md:text-4xl font-bold text-white mb-4 uppercase tracking-wide">
              Ứng dụng SafeVax
            </h2>
            <p className="text-slate-300 max-w-2xl mx-auto text-lg leading-relaxed">
              Ứng dụng di động được xây dựng nhằm mục đích quản lý sổ tiêm chủng, đặt lịch hẹn tiêm,
              tư vấn dinh dưỡng và chăm sóc sức khỏe cho mẹ và bé.
            </p>
          </FadeIn>
        </div>

        <div className="flex flex-col lg:flex-row items-center justify-between gap-12 lg:gap-8">
          {/* Left Column */}
          <div className="flex-1 space-y-12">
            <FadeIn direction="right" delay={100}>
              <div className="flex items-start gap-4 text-right flex-row-reverse lg:flex-row lg:text-right">
                <div className="flex-shrink-0 w-16 h-16 rounded-full bg-cyan-400 flex items-center justify-center shadow-lg shadow-cyan-400/30">
                  <CalendarOutlined className="text-3xl text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="text-xl font-bold text-white mb-2">Đặt lịch khám và hẹn tiêm</h3>
                  <p className="text-slate-400">
                    Đặt trước vắc xin, hẹn lịch tiêm ngay tại nhà trên điện thoại, giúp Khách hàng
                    chủ động về thời gian, tài chính.
                  </p>
                </div>
              </div>
            </FadeIn>

            <FadeIn direction="right" delay={200}>
              <div className="flex items-start gap-4 text-right flex-row-reverse lg:flex-row lg:text-right">
                <div className="flex-shrink-0 w-16 h-16 rounded-full bg-lime-500 flex items-center justify-center shadow-lg shadow-lime-500/30">
                  <LineChartOutlined className="text-3xl text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="text-xl font-bold text-white mb-2">
                    Theo dõi quá trình tăng trưởng
                  </h3>
                  <p className="text-slate-400">
                    Căn cứ vào chiều cao, cân nặng của bé do người dùng nhập vào, ứng dụng giúp theo
                    dõi quá trình phát triển.
                  </p>
                </div>
              </div>
            </FadeIn>

            <FadeIn direction="right" delay={300}>
              <div className="flex flex-col items-end lg:items-end mt-8">
                <div className="flex items-center gap-2 text-yellow-400 font-bold text-xl mb-2 animate-pulse">
                  <span>Tải App liền tay</span>
                  <span>›››</span>
                </div>
                <div className="text-yellow-400 font-bold text-xl">Đặt ngay lịch hẹn</div>
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
              <div className="flex items-start gap-4 text-left">
                <div className="flex-shrink-0 w-16 h-16 rounded-full bg-pink-500 flex items-center justify-center shadow-lg shadow-pink-500/30">
                  <TeamOutlined className="text-3xl text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="text-xl font-bold text-white mb-2">Quản lý lịch tiêm gia đình</h3>
                  <p className="text-slate-400">
                    Giúp Khách hàng quản lý hiệu quả lịch tiêm của tất cả các thành viên trong gia
                    đình, nhắc Khách hàng khi đến ngày hẹn tiêm.
                  </p>
                </div>
              </div>
            </FadeIn>

            <FadeIn direction="left" delay={200}>
              <div className="flex items-start gap-4 text-left">
                <div className="flex-shrink-0 w-16 h-16 rounded-full bg-blue-500 flex items-center justify-center shadow-lg shadow-blue-500/30">
                  <HistoryOutlined className="text-3xl text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="text-xl font-bold text-white mb-2">Theo dõi lịch sử tiêm chủng</h3>
                  <p className="text-slate-400">
                    Tối ưu hóa trải nghiệm của người dùng bằng cách lưu trữ lịch sử tiêm chủng của
                    tất cả thành viên trong gia đình.
                  </p>
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
                    <span className="text-[10px] font-medium opacity-80">Download on the</span>
                    <span className="text-lg font-bold">App Store</span>
                  </div>
                </Button>
                <Button
                  size="large"
                  icon={<AndroidFilled className="text-2xl" />}
                  className="h-14 px-6 rounded-xl bg-white/10 border-white/20 text-white hover:bg-white/20 hover:border-white/40 flex items-center gap-2"
                >
                  <div className="flex flex-col items-start leading-tight">
                    <span className="text-[10px] font-medium opacity-80">Get it on</span>
                    <span className="text-lg font-bold">Google Play</span>
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
