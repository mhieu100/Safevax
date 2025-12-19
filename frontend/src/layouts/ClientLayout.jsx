import { useEffect, useState } from 'react';
import { Outlet, useLocation } from 'react-router-dom';
import ChatBot from '@/components/common/chatbot/ChatBot';
import Loading from '@/components/common/feedback/Loading';
import AppTour from '@/components/common/tour/AppTour';
import useCartStore from '@/stores/useCartStore';
import Footer from './client/ClientFooter';
import Navbar from './client/ClientHeader';

const NO_FOOTER_ROUTES = ['/success', '/cancel', '/profile', '/appointments', '/cart', '/wallet'];

const LayoutClient = () => {
  const location = useLocation();
  const [isLoading, setIsLoading] = useState(true);

  const { fetchCart } = useCartStore();

  useEffect(() => {
    fetchCart();
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
