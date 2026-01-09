import {
  CalendarOutlined,
  HomeOutlined,
  InfoCircleOutlined,
  LogoutOutlined,
  MailOutlined,
  MenuOutlined,
  PhoneOutlined,
  SafetyCertificateOutlined,
  SearchOutlined,
  ShoppingCartOutlined,
  ShoppingOutlined,
  UserOutlined,
  WalletOutlined,
} from '@ant-design/icons';
import { Avatar, Badge, Button, Drawer, message } from 'antd';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import GlobalSearch from '@/components/common/GlobalSearch';
import LanguageSelect from '@/components/common/ui/LanguageSwitcher';
import DropdownUser from '@/components/dropdown/DropdownUser';
import { callLogout } from '@/services/auth.service';
import { useAccountStore } from '@/stores/useAccountStore';
import useCartStore from '@/stores/useCartStore';

const Navbar = () => {
  const { t } = useTranslation('client');
  const itemCount = useCartStore((state) => state.totalQuantity());

  const isAuthenticated = useAccountStore((state) => state.isAuthenticated);
  const user = useAccountStore((state) => state.user);
  const logout = useAccountStore((state) => state.logout);
  const navigate = useNavigate();
  const location = useLocation();

  const [mobileMenuVisible, setMobileMenuVisible] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const [searchOpen, setSearchOpen] = useState(false);

  useEffect(() => {
    const handleKeyDown = (e) => {
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault();
        setSearchOpen(true);
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 20);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  const handleLogout = async () => {
    const res = await callLogout();
    if (res && res && +res.statusCode === 200) {
      localStorage.removeItem('token');
      logout();
      message.success(t('user.logoutSuccess'));
      navigate('/');
    }
  };

  const menuItems = [
    {
      key: '/',
      icon: <HomeOutlined />,
      label: t('layout.navbar.home'),
    },
    {
      key: '/vaccines',
      icon: <ShoppingOutlined />,
      label: t('layout.navbar.vaccines'),
    },
    {
      key: '/news',
      icon: <InfoCircleOutlined />,
      label: t('layout.navbar.news'),
    },
    {
      key: '/about',
      icon: <InfoCircleOutlined />,
      label: t('layout.navbar.about'),
    },
    {
      key: '/contact',
      icon: <PhoneOutlined />,
      label: t('layout.navbar.contact'),
    },
  ];

  const userMenuItems = [
    {
      key: 'profile',
      label: t('user.personalInfo'),
      icon: <UserOutlined />,
      onClick: () => navigate('/profile'),
    },
    {
      type: 'divider',
    },
    {
      key: 'logout',
      label: t('user.logout'),
      icon: <LogoutOutlined />,
      onClick: handleLogout,
      danger: true,
    },
  ];

  const isActive = (path) => {
    if (path === '/' && location.pathname !== '/') return false;
    return location.pathname.startsWith(path);
  };

  return (
    <>
      <header
        className={`sticky top-0 z-50 transition-all duration-300 ${
          scrolled
            ? 'bg-white/90 backdrop-blur-md shadow-sm border-b border-slate-100/50 py-3'
            : 'bg-white/50 backdrop-blur-sm border-none py-4'
        }`}
      >
        <div className="mx-auto flex h-full max-w-[1220px] items-center justify-between px-4 md:px-6">
          {/* Logo Section */}
          <div className="flex items-center flex-1">
            <Link id="tour-logo" to="/" className="group flex cursor-pointer items-center gap-3">
              <div className="relative flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-blue-600 to-indigo-600 text-white shadow-lg shadow-blue-500/30 transition-transform group-hover:scale-105">
                <SafetyCertificateOutlined className="text-xl" />
              </div>
              <span className="hidden text-2xl font-bold text-slate-800 tracking-tight sm:block">
                Safe<span className="text-blue-600">Vax</span>
              </span>
            </Link>
          </div>

          {/* Desktop Navigation */}
          <nav className="hidden lg:flex items-center gap-1 bg-slate-50/50 p-1.5 rounded-full border border-slate-200/50 backdrop-blur-sm">
            {menuItems.map((item) => (
              <Link
                key={item.key}
                to={item.key}
                className={`relative px-5 py-2 rounded-full text-sm font-medium transition-all duration-300 ${
                  isActive(item.key)
                    ? 'bg-white text-blue-600 shadow-sm shadow-slate-200'
                    : 'text-slate-600 hover:text-blue-600 hover:bg-white/50'
                }`}
              >
                {item.label}
              </Link>
            ))}
          </nav>

          {/* Right Section */}
          <div className="flex items-center justify-end gap-3 flex-1">
            <LanguageSelect />

            <Button
              icon={<SearchOutlined className="text-lg" />}
              size="large"
              onClick={() => setSearchOpen(true)}
              type="text"
              shape="circle"
              className="flex items-center justify-center text-slate-600 hover:bg-slate-100 hover:text-blue-600"
              title={t('common.search', 'Tìm kiếm')}
            />

            <Button
              icon={<WalletOutlined className="text-lg" />}
              size="large"
              onClick={() => navigate('/vaccine-passport')}
              type="text"
              shape="circle"
              className="flex items-center justify-center text-slate-600 hover:bg-slate-100 hover:text-blue-600"
              title={t('layout.navbar.wallet')}
            />

            <div className="hidden sm:flex items-center gap-2">
              <div className="h-6 w-px bg-slate-200 mx-1"></div>

              {isAuthenticated && (
                <Button
                  id="tour-appointments-nav"
                  icon={<CalendarOutlined className="text-lg" />}
                  size="large"
                  onClick={() => navigate('/appointments')}
                  type="text"
                  shape="circle"
                  className="flex items-center justify-center text-slate-600 hover:bg-slate-100 hover:text-blue-600"
                  title={t('layout.navbar.appointments')}
                />
              )}

              <Badge count={itemCount} size="small" offset={[-5, 5]}>
                <Button
                  id="tour-cart"
                  icon={<ShoppingCartOutlined className="text-lg" />}
                  size="large"
                  onClick={() => navigate('/cart')}
                  type="text"
                  shape="circle"
                  className="flex items-center justify-center text-slate-600 hover:bg-slate-100 hover:text-blue-600"
                  title={t('layout.navbar.cart')}
                />
              </Badge>
            </div>

            <div className="hidden md:flex items-center gap-3 ml-2">
              {!isAuthenticated ? (
                <>
                  <Button
                    onClick={() => navigate('/login')}
                    type="text"
                    className="text-slate-600 font-medium hover:text-blue-600 hover:bg-slate-50"
                  >
                    {t('layout.navbar.login')}
                  </Button>
                  <Button
                    type="primary"
                    onClick={() => navigate('/register')}
                    className="h-10 px-6 rounded-full font-semibold bg-gradient-to-r from-blue-600 to-indigo-600 border-none shadow-lg shadow-blue-500/25 hover:shadow-blue-500/40 hover:scale-105 transition-all"
                  >
                    {t('layout.navbar.register')}
                  </Button>
                </>
              ) : (
                <div className="pl-2">
                  <DropdownUser />
                </div>
              )}
            </div>

            <Button
              icon={<MenuOutlined />}
              size="large"
              type="text"
              className="flex items-center justify-center lg:hidden ml-2"
              onClick={() => setMobileMenuVisible(true)}
            />
          </div>
        </div>
      </header>

      {/* Mobile Menu Drawer */}
      <Drawer
        title={
          <div className="flex items-center gap-3">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-blue-600 text-white">
              <SafetyCertificateOutlined />
            </div>
            <span className="font-bold text-lg">SafeVax</span>
          </div>
        }
        placement="right"
        onClose={() => setMobileMenuVisible(false)}
        open={mobileMenuVisible}
        width={320}
      >
        <div className="flex h-full flex-col">
          {/* Mobile User Info */}
          <div className="mb-6 bg-slate-50 p-4 rounded-2xl border border-slate-100">
            {isAuthenticated ? (
              <div className="flex items-center gap-3">
                <Avatar
                  src={user?.avatar}
                  icon={<UserOutlined />}
                  size="large"
                  className="border-2 border-white shadow-sm"
                />
                <div className="overflow-hidden">
                  <div className="truncate font-bold text-slate-800">{user?.name || 'User'}</div>
                  <div className="truncate text-xs text-slate-500">{user?.email}</div>
                </div>
              </div>
            ) : (
              <div className="space-y-3">
                <p className="text-sm text-slate-500 mb-2">{t('layout.navbar.welcomeMessage')}</p>
                <Button
                  block
                  type="primary"
                  onClick={() => {
                    navigate('/login');
                    setMobileMenuVisible(false);
                  }}
                  className="bg-blue-600 h-10 rounded-xl font-medium shadow-blue-200 mb-2"
                >
                  {t('layout.navbar.login')}
                </Button>
                <Button
                  block
                  onClick={() => {
                    navigate('/register');
                    setMobileMenuVisible(false);
                  }}
                  className="h-10 rounded-xl font-medium"
                >
                  {t('layout.navbar.register')}
                </Button>
              </div>
            )}
          </div>

          {/* Mobile Navigation */}
          <div className="flex-1 space-y-1 overflow-y-auto">
            {menuItems.map((item) => (
              <div
                key={item.key}
                onClick={() => {
                  navigate(item.key);
                  setMobileMenuVisible(false);
                }}
                className={`flex items-center justify-between p-3 rounded-xl cursor-pointer transition-colors ${
                  isActive(item.key)
                    ? 'bg-blue-50 text-blue-600 font-medium'
                    : 'text-slate-600 hover:bg-slate-50'
                }`}
              >
                <div className="flex items-center gap-3">
                  {item.icon}
                  <span>{item.label}</span>
                </div>
              </div>
            ))}

            {isAuthenticated && (
              <div
                onClick={() => {
                  navigate('/appointments');
                  setMobileMenuVisible(false);
                }}
                className={`flex items-center justify-between p-3 rounded-xl cursor-pointer transition-colors ${
                  isActive('/appointments')
                    ? 'bg-blue-50 text-blue-600 font-medium'
                    : 'text-slate-600 hover:bg-slate-50'
                }`}
              >
                <div className="flex items-center gap-3">
                  <CalendarOutlined />
                  <span>{t('layout.navbar.appointments')}</span>
                </div>
              </div>
            )}

            {isAuthenticated && (
              <>
                <div className="my-4 h-px bg-slate-100" />
                <div className="px-3 py-2 text-xs font-semibold text-slate-400 uppercase tracking-wider">
                  {t('layout.navbar.account')}
                </div>
                {userMenuItems
                  .filter((item) => item.type !== 'divider')
                  .map((item) => (
                    <div
                      key={item.key}
                      onClick={() => {
                        item.onClick();
                        setMobileMenuVisible(false);
                      }}
                      className={`flex items-center gap-3 p-3 rounded-xl cursor-pointer transition-colors ${
                        item.danger
                          ? 'text-red-500 hover:bg-red-50'
                          : 'text-slate-600 hover:bg-slate-50'
                      }`}
                    >
                      {item.icon}
                      <span>{item.label}</span>
                    </div>
                  ))}
              </>
            )}
          </div>

          {/* Mobile Footer */}
          <div className="border-t border-slate-100 pt-4 mt-4">
            <div className="flex gap-3 mb-4">
              <Button
                block
                className="rounded-xl h-10 bg-slate-50 border-slate-200 text-slate-600"
                onClick={() => {
                  setMobileMenuVisible(false);
                  navigate('/cart');
                }}
                icon={<ShoppingCartOutlined />}
              >
                {t('layout.navbar.cart')} ({itemCount})
              </Button>
            </div>

            {/* Contact Info */}
            <div className="mb-4 space-y-3 px-1">
              <div className="flex items-center gap-3 text-slate-500 text-sm">
                <MailOutlined className="text-blue-600" /> <span>contact@safevax.com</span>
              </div>
              <div className="flex items-center gap-3 text-slate-500 text-sm">
                <PhoneOutlined className="text-blue-600" /> <span>+84 123 456 789</span>
              </div>
            </div>

            <div className="text-center text-xs text-slate-400">
              © 2024 SafeVax. All rights reserved.
            </div>
          </div>
        </div>
      </Drawer>
      <GlobalSearch open={searchOpen} onCancel={() => setSearchOpen(false)} />
    </>
  );
};

export default Navbar;
