import { useEffect, useState } from 'react';
import { Outlet, useLocation } from 'react-router-dom';
import ChatBot from '@/components/common/chatbot/ChatBot';
import Loading from '@/components/common/feedback/Loading';
import AppTour from '@/components/common/tour/AppTour';
import Footer from './client/ClientFooter';
import Navbar from './client/ClientHeader';

const NO_FOOTER_ROUTES = ['/success', '/profile', '/appointments', '/cart'];

const LayoutClient = () => {
  const location = useLocation();
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    setTimeout(() => {
      setIsLoading(false);
    }, 1000);
  }, []);

  if (isLoading) {
    return <Loading />;
  }

  const showFooter = !NO_FOOTER_ROUTES.some(
    (route) => location.pathname === route || location.pathname.startsWith(`${route}/`)
  );

  return (
    <>
      <Navbar />
      <Outlet />
      {showFooter && <Footer />}

      <ChatBot />
      <AppTour />
    </>
  );
};

export default LayoutClient;
