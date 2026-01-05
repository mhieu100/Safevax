import { Tour } from 'antd';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useLocation, useNavigate } from 'react-router-dom';
import modelImage from '@/assets/model.png';
import { completeTour } from '@/services/profile.service';
import useAccountStore from '@/stores/useAccountStore';

const TourContent = ({ title, description, onSkip }) => {
  const { t } = useTranslation(['client']);
  return (
    <div className="flex gap-4">
      <div className="shrink-0">
        <img
          src={modelImage}
          alt="AI Assistant"
          className="w-16 h-16 rounded-full object-cover border-2 border-blue-500 p-0.5"
        />
      </div>
      <div className="flex flex-col">
        <div className="font-bold text-blue-600 mb-1">{title}</div>
        <div className="text-slate-600 text-sm mb-2">{description}</div>
        {onSkip && (
          <button
            type="button"
            onClick={onSkip}
            className="text-xs text-red-500 hover:text-slate-600 self-start hover:underline "
          >
            {t('tour.skip')}
          </button>
        )}
      </div>
    </div>
  );
};

const AppTour = () => {
  const { t } = useTranslation(['client']);
  const location = useLocation();
  const navigate = useNavigate();
  const [openTour, setOpenTour] = useState(false);
  const [currentStep, setCurrentStep] = useState(0);
  const [isLoading, setIsLoading] = useState(true);

  const { user, updateUserInfo } = useAccountStore();

  // Simulate loading delay similar to layout to ensure elements exist
  useEffect(() => {
    const timer = setTimeout(() => {
      setIsLoading(false);
    }, 1000);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    if (location.pathname === '/' && !isLoading) {
      if (user?.isNewUser) {
        setOpenTour(true);
      }
    }
  }, [location.pathname, isLoading, user?.isNewUser]);

  const handleSkip = async () => {
    setOpenTour(false);
    // Call API to mark tour as seen
    try {
      await completeTour();
      // Update local store
      updateUserInfo({ isNewUser: false });
    } catch (error) {
      console.error('Failed to update tour status', error);
    }
  };

  const handleTourChange = (current) => {
    setCurrentStep(current);
    switch (current) {
      case 0:
      case 1:
        if (location.pathname !== '/') navigate('/');
        break;
      case 2:
      case 3:
        navigate('/vaccines');
        break;
      case 4:
        if (location.pathname !== '/vaccines') navigate('/vaccines');
        break;
      case 5:
        navigate('/appointments');
        break;
      case 6:
        // Ensure we are on a page where chatbot is visible (usually all pages)
        break;
    }
  };

  const steps = [
    {
      title: t('tour.welcome.title'),
      description: (
        <TourContent
          title={t('tour.welcome.cardTitle')}
          description={t('tour.welcome.description')}
          onSkip={handleSkip}
        />
      ),
      target: () => document.getElementById('tour-logo'),
    },
    {
      title: t('tour.step1.title'),
      description: (
        <TourContent
          title={t('tour.step1.cardTitle')}
          description={t('tour.step1.description')}
          onSkip={handleSkip}
        />
      ),
      target: () => document.getElementById('tour-menu-vaccine'),
    },
    {
      title: t('tour.step2.title'),
      description: (
        <TourContent
          title={t('tour.step2.cardTitle')}
          description={t('tour.step2.description')}
          onSkip={handleSkip}
        />
      ),
      target: () => document.getElementById('tour-vaccine-filter'),
      placement: 'right',
    },
    {
      title: t('tour.step3.title'),
      description: (
        <TourContent
          title={t('tour.step3.cardTitle')}
          description={t('tour.step3.description')}
          onSkip={handleSkip}
        />
      ),
      target: () => document.getElementById('tour-vaccine-book-btn'),
    },
    {
      title: t('tour.step4.title'),
      description: (
        <TourContent
          title={t('tour.step4.cardTitle')}
          description={t('tour.step4.description')}
          onSkip={handleSkip}
        />
      ),
      target: () => document.getElementById('tour-appointments-nav'),
    },
    {
      title: t('tour.step5.title'),
      description: (
        <TourContent
          title={t('tour.step5.cardTitle')}
          description={t('tour.step5.description')}
          onSkip={handleSkip}
        />
      ),
      target: () => document.getElementById('tour-appointments-list'),
    },
    {
      title: t('tour.chatbot.title'),
      description: (
        <TourContent
          title={t('tour.chatbot.cardTitle')}
          description={t('tour.chatbot.description')}
          onSkip={handleSkip}
        />
      ),
      target: () => document.getElementById('tour-chatbot'),
      placement: 'topRight',
    },
  ];

  if (!openTour) return null;

  return (
    <Tour
      open={openTour}
      onClose={handleSkip}
      steps={steps}
      current={currentStep}
      onChange={handleTourChange}
    />
  );
};

export default AppTour;
