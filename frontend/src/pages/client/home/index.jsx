import BookingStepsSection from './components/BookingStepsSection';
import HeroSection from './components/HeroSection';
import MobileAppSection from './components/MobileAppSection';
import NewsSection from './components/NewsSection';
import RecommendedVaccinesSection from './components/RecommendedVaccinesSection';
import ServiceSection from './components/ServiceSection';

const HomePage = () => {
  return (
    <div className="flex flex-col ">
      <HeroSection />
      <RecommendedVaccinesSection />
      <NewsSection />
      <BookingStepsSection />
      <MobileAppSection />
      <ServiceSection />
    </div>
  );
};

export default HomePage;
