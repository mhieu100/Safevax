import { CalendarOutlined, EyeOutlined, SearchOutlined } from '@ant-design/icons';
import { Button, Card, Col, Input, Pagination, Row, Select, Skeleton, Tag, Typography } from 'antd';
import dayjs from 'dayjs';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Link } from 'react-router-dom';
import { callFetchNews, callGetNewsCategories } from '@/services/news.service';

const { Title, Paragraph, Text } = Typography;
const { Search } = Input;

const ClientNewsPage = () => {
  const { t } = useTranslation(['client']);
  const [news, setNews] = useState([]);
  const [loading, setLoading] = useState(true);
  const [categories, setCategories] = useState([]);
  const [pagination, setPagination] = useState({
    current: 1,
    pageSize: 9,
    total: 0,
  });
  const [filter, setFilter] = useState({
    category: null,
    search: '',
  });

  useEffect(() => {
    fetchCategories();
  }, []);

  useEffect(() => {
    fetchNews();
  }, [pagination.current, pagination.pageSize, filter]);

  const fetchCategories = async () => {
    try {
      const res = await callGetNewsCategories();
      if (res?.data) {
        setCategories(res.data);
      }
    } catch (error) {
      console.error('Failed to fetch categories:', error);
    }
  };

  const fetchNews = async () => {
    try {
      setLoading(true);
      let query = `page=${pagination.current - 1}&size=${
        pagination.pageSize
      }&sort=publishedAt,desc&filter=isPublished:true`;

      if (filter.category) {
        query += ` and category:'${filter.category}'`;
      }

      if (filter.search) {
        query += ` and title~'*${filter.search}*'`;
      }

      const res = await callFetchNews(query);
      if (res?.data?.result) {
        setNews(res.data.result);
        setPagination({
          ...pagination,
          total: res.data.meta.total,
        });
      }
    } catch (error) {
      console.error('Failed to fetch news:', error);
    } finally {
      setLoading(false);
    }
  };

  const handlePageChange = (page, pageSize) => {
    setPagination({ ...pagination, current: page, pageSize });
  };

  const handleSearch = (value) => {
    setFilter({ ...filter, search: value });
    setPagination({ ...pagination, current: 1 });
  };

  const handleCategoryChange = (value) => {
    setFilter({ ...filter, category: value });
    setPagination({ ...pagination, current: 1 });
  };

  const getCategoryColor = (category) => {
    switch (category) {
      case 'VACCINE_INFO':
        return 'blue';
      case 'CHILDREN_HEALTH':
        return 'green';
      case 'DISEASE_PREVENTION':
        return 'orange';
      case 'HEALTH_GENERAL':
        return 'purple';
      case 'ANNOUNCEMENT':
        return 'red';
      default:
        return 'default';
    }
  };

  const formatCategory = (category) => {
    return category ? t(`client:news.categories.${category}`) : t('client:news.newsDefault');
  };

  // Featured Logic
  const showFeatured =
    !loading && pagination.current === 1 && !filter.search && !filter.category && news.length > 0;
  const displayNews = showFeatured ? news.slice(4) : news;

  return (
    <div className="min-h-screen bg-slate-50 pb-20 pt-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Featured Section */}
        {showFeatured && (
          <Row gutter={[30, 30]} className="mb-12">
            {/* Main Hero Article */}
            <Col xs={24} lg={16}>
              <Link to={`/news/${news[0].slug}`} className="group block h-full">
                <div className="relative h-[500px] rounded-2xl overflow-hidden shadow-sm group-hover:shadow-xl transition-all duration-300">
                  <div className="absolute inset-0">
                    <img
                      src={news[0].thumbnailImage || 'https://placehold.co/800x600?text=Featured'}
                      alt={news[0].title}
                      className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent" />
                  </div>
                  <div className="absolute bottom-0 left-0 p-8 w-full">
                    <Tag
                      color={getCategoryColor(news[0].category)}
                      className="mb-3 border-0 px-3 py-1 text-sm"
                    >
                      {formatCategory(news[0].category)}
                    </Tag>
                    <h1 className="text-3xl md:text-4xl font-bold text-white mb-3 leading-tight group-hover:text-blue-200 transition-colors">
                      {news[0].title}
                    </h1>
                    <div className="flex items-center gap-4 text-gray-300 text-sm">
                      <span className="flex items-center gap-2">
                        <CalendarOutlined /> {dayjs(news[0].publishedAt).format('MMM D, YYYY')}
                      </span>
                      <span className="flex items-center gap-2">
                        <EyeOutlined /> {news[0].viewCount || 0} {t('client:news.views')}
                      </span>
                      <span>
                        {t('client:news.by')} {news[0].author || 'VaxSafe Team'}
                      </span>
                    </div>
                  </div>
                </div>
              </Link>
            </Col>

            {/* Side Articles */}
            <Col xs={24} lg={8}>
              <div className="flex flex-col h-full gap-6">
                {news.slice(1, 4).map((item) => (
                  <Link key={item.id} to={`/news/${item.slug}`} className="group block flex-1">
                    <div className="flex gap-4 h-full bg-white p-4 rounded-xl shadow-sm border border-slate-100 group-hover:shadow-md transition-all duration-300">
                      <div className="w-24 h-24 flex-shrink-0 rounded-lg overflow-hidden">
                        <img
                          src={item.thumbnailImage || 'https://placehold.co/200x200?text=News'}
                          alt={item.title}
                          className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                        />
                      </div>
                      <div className="flex flex-col justify-center flex-1 min-w-0">
                        <Tag
                          color={getCategoryColor(item.category)}
                          className="w-fit mb-2 border-0 text-xs px-2"
                        >
                          {formatCategory(item.category)}
                        </Tag>
                        <h3 className="text-sm font-bold text-slate-800 line-clamp-2 mb-2 group-hover:text-blue-600 transition-colors">
                          {item.title}
                        </h3>
                        <div className="text-xs text-slate-400 flex items-center gap-2">
                          <CalendarOutlined /> {dayjs(item.publishedAt).format('MMM D, YYYY')}
                        </div>
                      </div>
                    </div>
                  </Link>
                ))}
              </div>
            </Col>
          </Row>
        )}

        {/* Filter Section */}
        <div className="bg-white p-6 rounded-xl shadow-sm mb-8 border border-slate-100">
          <Row gutter={[16, 16]} align="middle">
            <Col xs={24} md={12}>
              <Search
                placeholder={t('client:news.searchPlaceholder')}
                allowClear
                enterButton={
                  <Button type="primary" icon={<SearchOutlined />}>
                    {t('client:news.searchButton')}
                  </Button>
                }
                size="large"
                onSearch={handleSearch}
                className="w-full"
              />
            </Col>
            <Col xs={24} md={12} className="flex justify-end gap-4">
              <span className="self-center text-slate-500 font-medium whitespace-nowrap hidden sm:block">
                {t('client:news.filterBy')}
              </span>
              <Select
                placeholder={t('client:news.allCategories')}
                style={{ width: 220 }}
                size="large"
                allowClear
                onChange={handleCategoryChange}
                className="w-full sm:w-auto"
              >
                {categories.map((cat) => (
                  <Select.Option key={cat} value={cat}>
                    {formatCategory(cat)}
                  </Select.Option>
                ))}
              </Select>
            </Col>
          </Row>
        </div>

        {/* News Grid */}
        {loading ? (
          <Row gutter={[24, 24]}>
            {[1, 2, 3, 4, 5, 6].map((i) => (
              <Col xs={24} sm={12} lg={8} key={i}>
                <Card cover={<Skeleton.Image active className="!w-full !h-48" />}>
                  <Skeleton active paragraph={{ rows: 3 }} />
                </Card>
              </Col>
            ))}
          </Row>
        ) : (
          <>
            {displayNews.length > 0 ? (
              <Row gutter={[24, 24]}>
                {displayNews.map((item) => (
                  <Col xs={24} sm={12} lg={8} key={item.id}>
                    <Card
                      hoverable
                      className="h-full flex flex-col rounded-xl overflow-hidden border-0 shadow-sm transition-all duration-300 hover:shadow-xl hover:-translate-y-1"
                      cover={
                        <Link
                          to={`/news/${item.slug}`}
                          className="h-52 overflow-hidden relative group cursor-pointer block"
                        >
                          <img
                            alt={item.title}
                            src={item.thumbnailImage || 'https://placehold.co/600x400?text=News'}
                            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                          />
                          <div className="absolute top-3 left-3">
                            <Tag
                              color={getCategoryColor(item.category)}
                              className="m-0 font-semibold border-0 shadow-sm"
                            >
                              {formatCategory(item.category)}
                            </Tag>
                          </div>
                        </Link>
                      }
                    >
                      <div className="flex flex-col h-full">
                        <div className="flex items-center gap-3 text-xs text-gray-500 mb-3">
                          <span className="flex items-center gap-1">
                            <CalendarOutlined /> {dayjs(item.publishedAt).format('MMM D, YYYY')}
                          </span>
                          <span className="flex items-center gap-1">
                            <EyeOutlined /> {item.viewCount || 0} {t('client:news.views')}
                          </span>
                        </div>

                        <Title level={4} className="mb-3 line-clamp-2 min-h-[3.5rem]">
                          <Link
                            to={`/news/${item.slug}`}
                            className="text-gray-800 hover:text-blue-600 transition-colors"
                          >
                            {item.title}
                          </Link>
                        </Title>

                        <Paragraph className="text-gray-600 line-clamp-3 mb-4 flex-grow">
                          {item.shortDescription}
                        </Paragraph>

                        <div className="mt-auto pt-4 border-t border-gray-100">
                          <div className="flex items-center gap-2">
                            <Text type="secondary" className="text-xs">
                              {t('client:news.by')}
                            </Text>
                            <Text strong className="text-xs">
                              {item.author || 'VaxSafe Team'}
                            </Text>
                          </div>
                        </div>
                      </div>
                    </Card>
                  </Col>
                ))}
              </Row>
            ) : (
              <div className="text-center py-20 bg-white rounded-xl shadow-sm border border-slate-100">
                <div className="text-6xl mb-4">📰</div>
                <Title level={4} className="text-slate-600">
                  {t('client:news.noNewsTitle')}
                </Title>
                <Paragraph className="text-slate-500 max-w-md mx-auto">
                  {t('client:news.noNewsDesc')}
                </Paragraph>
                <Button
                  onClick={() => {
                    setFilter({ category: null, search: '' });
                    setPagination({ ...pagination, current: 1 });
                  }}
                >
                  {t('client:news.clearFilters')}
                </Button>
              </div>
            )}

            {news.length > 0 && (
              <div className="flex justify-center mt-12">
                <Pagination
                  current={pagination.current}
                  pageSize={pagination.pageSize}
                  total={pagination.total}
                  onChange={handlePageChange}
                  showSizeChanger={false}
                />
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
};

export default ClientNewsPage;
