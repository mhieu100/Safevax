import BookingStepsSection from './components/BookingStepsSection';
import HeroSection from './components/HeroSection';
import MobileAppSection from './components/MobileAppSection';
import NewsSection from './components/NewsSection';
import ServiceSection from './components/ServiceSection';

const HomePage = () => {
  return (
    <div className="flex flex-col ">
      <HeroSection />
      <BookingStepsSection />
      <ServiceSection />
      <MobileAppSection />
      <NewsSection />
    </div>
  );
};

export default HomePage;
