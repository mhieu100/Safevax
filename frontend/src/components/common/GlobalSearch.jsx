import {
  BookOutlined,
  MedicineBoxOutlined,
  RightOutlined,
  RobotOutlined,
  SearchOutlined,
} from '@ant-design/icons';
import { Empty, Input, Modal, Spin, Tag } from 'antd';
import { debounce } from 'lodash';
import { useEffect, useMemo, useState } from 'react';
import { useTranslation } from 'react-i18next';
import ReactMarkdown from 'react-markdown';
import { useNavigate } from 'react-router-dom';
import remarkGfm from 'remark-gfm';
import { globalSearch } from '@/services/search.service';

const SearchResultItem = ({ icon, title, subtitle, onClick, tag, price }) => (
  <div
    role="button"
    tabIndex={0}
    onClick={onClick}
    onKeyDown={(e) => e.key === 'Enter' && onClick()}
    className="group flex items-start gap-4 p-3 rounded-xl hover:bg-slate-50 cursor-pointer transition-all duration-200 border border-transparent hover:border-slate-100"
  >
    <div className="mt-1 flex-shrink-0 w-10 h-10 rounded-lg bg-slate-50 flex items-center justify-center text-slate-500 group-hover:bg-white group-hover:shadow-sm group-hover:text-blue-600 transition-colors">
      {icon}
    </div>
    <div className="flex-1 min-w-0">
      <div className="flex justify-between items-start">
        <h4 className="font-medium text-slate-700 truncate group-hover:text-blue-600 transition-colors pr-2">
          {title}
        </h4>
        {price && (
          <span className="text-sm font-semibold text-blue-600 whitespace-nowrap">
            {new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(price)}
          </span>
        )}
      </div>
      {subtitle && <p className="text-sm text-slate-500 line-clamp-1 mt-0.5">{subtitle}</p>}
      <div className="flex items-center gap-2 mt-2">
        {tag && (
          <Tag className="m-0 border-none bg-slate-100 text-slate-500 text-xs px-2 py-0.5 hover:bg-slate-200">
            {tag}
          </Tag>
        )}
      </div>
    </div>
    <div className="self-center opacity-0 group-hover:opacity-100 transition-opacity -translate-x-2 group-hover:translate-x-0">
      <RightOutlined className="text-xs text-slate-400" />
    </div>
  </div>
);

const GlobalSearch = ({ open, onCancel }) => {
  const { t } = useTranslation('client');
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState('');
  const [results, setResults] = useState({ vaccines: [], news: [], aiConsultation: null });
  const [loading, setLoading] = useState(false);

  const handleSearch = async (value) => {
    if (!value || value.trim().length < 2) {
      setResults({ vaccines: [], news: [], aiConsultation: null });
      return;
    }
    setLoading(true);
    try {
      const data = await globalSearch(value);
      if (data.aiConsultation && typeof data.aiConsultation === 'string') {
        data.aiConsultation = data.aiConsultation.replace(/\/vaccine\//g, '/vaccines/');
      }
      setResults(data);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  const debouncedSearch = useMemo(() => debounce(handleSearch, 500), []);

  useEffect(() => {
    debouncedSearch(searchTerm);
    return () => debouncedSearch.cancel();
  }, [searchTerm, debouncedSearch]);

  const handleClose = () => {
    setSearchTerm('');
    setResults({ vaccines: [], news: [], aiConsultation: null });
    onCancel();
  };

  const hasResults =
    results.vaccines?.length > 0 || results.news?.length > 0 || results.aiConsultation;

  return (
    <Modal
      open={open}
      onCancel={handleClose}
      footer={null}
      closable={false}
      destroyOnHidden
      width={700}
      className="global-search-modal top-20"
      styles={{
        content: {
          padding: 0,
          borderRadius: '1.5rem',
          overflow: 'hidden',
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          backdropFilter: 'blur(10px)',
          boxShadow: '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
        },
        mask: {
          backdropFilter: 'blur(4px)',
          backgroundColor: 'rgba(15, 23, 42, 0.4)',
        },
      }}
    >
      <div className="flex flex-col max-h-[80vh]">
        {/* Search Input Header */}
        <div className="p-4 border-b border-slate-100">
          <Input
            prefix={<SearchOutlined className="text-slate-400 text-xl mr-3" />}
            placeholder={t('search.placeholder')}
            size="large"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="border-none shadow-none text-lg !bg-transparent focus:shadow-none placeholder:text-slate-400"
            autoFocus
            allowClear
          />
        </div>

        {/* Results Area */}
        <div className="flex-1 overflow-y-auto min-h-[300px] p-2">
          {loading ? (
            <div className="flex flex-col items-center justify-center h-60 gap-4">
              <Spin size="large" />
              <p className="text-slate-500 animate-pulse">{t('search.loading')}</p>
            </div>
          ) : !searchTerm ? (
            <div className="flex flex-col items-center justify-center h-60 text-slate-400">
              <SearchOutlined className="text-5xl mb-4 opacity-20" />
              <p>{t('search.emptyState')}</p>
              <div className="flex gap-2 mt-4">
                <Tag
                  className="cursor-pointer hover:border-blue-500"
                  onClick={() => setSearchTerm(t('search.tags.flu'))}
                >
                  {t('search.tags.flu')}
                </Tag>
                <Tag
                  className="cursor-pointer hover:border-blue-500"
                  onClick={() => setSearchTerm(t('search.tags.schedule'))}
                >
                  {t('search.tags.schedule')}
                </Tag>
                <Tag
                  className="cursor-pointer hover:border-blue-500"
                  onClick={() => setSearchTerm(t('search.tags.covid'))}
                >
                  {t('search.tags.covid')}
                </Tag>
                <Tag
                  className="cursor-pointer hover:border-blue-500"
                  onClick={() => setSearchTerm(t('search.tags.baby'))}
                >
                  {t('search.tags.baby')}
                </Tag>
              </div>
            </div>
          ) : !hasResults ? (
            <Empty
              image={Empty.PRESENTED_IMAGE_SIMPLE}
              description={t('search.noResults')}
              className="my-10"
            />
          ) : (
            <div className="space-y-6 p-2">
              {/* AI Consultation Section */}

              {results.aiConsultation && (
                <div className="bg-gradient-to-br from-indigo-50 to-blue-50 rounded-2xl p-5 border border-indigo-100">
                  <div className="flex items-center gap-3 mb-3">
                    <div className="p-2 bg-white rounded-lg shadow-sm text-indigo-600">
                      <RobotOutlined className="text-xl" />
                    </div>
                    <span className="font-bold text-indigo-900">{t('search.ai.title')}</span>
                    <Tag color="blue" className="ml-auto border-none bg-white/50">
                      {t('search.ai.beta')}
                    </Tag>
                  </div>
                  <div className="prose prose-sm prose-indigo max-w-none text-slate-700 bg-transparent">
                    <ReactMarkdown
                      remarkPlugins={[remarkGfm]}
                      components={{
                        p: ({ node, ...props }) => (
                          <p className="mb-2 leading-relaxed" {...props} />
                        ),
                        ul: ({ node, ...props }) => (
                          <ul className="list-disc pl-5 mb-2 space-y-1" {...props} />
                        ),
                        li: ({ node, ...props }) => <li className="pl-1" {...props} />,
                        strong: ({ node, ...props }) => (
                          <strong className="font-bold text-indigo-900" {...props} />
                        ),
                        a: ({ node, ...props }) => (
                          <a
                            className="text-blue-600 hover:underline font-medium"
                            target="_blank"
                            rel="noopener noreferrer"
                            {...props}
                          />
                        ),
                      }}
                    >
                      {results.aiConsultation}
                    </ReactMarkdown>
                  </div>
                </div>
              )}

              {/* Vaccines Section */}
              {results.vaccines?.length > 0 && (
                <div>
                  <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3 px-3">
                    {t('search.sections.vaccines')} ({results.vaccines.length})
                  </h3>
                  <div className="space-y-1">
                    {results.vaccines.map((item) => (
                      <SearchResultItem
                        key={item.id}
                        icon={<MedicineBoxOutlined />}
                        title={item.name}
                        subtitle={item.description}
                        price={item.price}
                        tag={item.country} // Assuming country is a good tag
                        onClick={() => {
                          handleClose();
                          navigate(`/vaccines/${item.slug}`);
                        }}
                      />
                    ))}
                  </div>
                </div>
              )}

              {/* News Section */}
              {results.news?.length > 0 && (
                <div>
                  <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider mb-3 px-3">
                    {t('search.sections.news')} ({results.news.length})
                  </h3>
                  <div className="space-y-1">
                    {results.news.map((item) => (
                      <SearchResultItem
                        key={item.id}
                        icon={<BookOutlined />}
                        title={item.title}
                        subtitle={item.shortDescription}
                        tag={item.category} // Or use a category map
                        onClick={() => {
                          handleClose();
                          navigate(`/news/${item.slug}`);
                        }}
                      />
                    ))}
                  </div>
                </div>
              )}
            </div>
          )}
        </div>

        {/* Footer Hint */}
        <div className="p-3 bg-slate-50 border-t border-slate-100 text-xs text-slate-400 flex justify-between items-center px-5">
          <span>{t('search.footer.hint')}</span>
          <div className="flex gap-4">
            <span className="flex items-center gap-1">
              <kbd className="font-sans bg-white border border-slate-200 rounded px-1 min-w-[20px] text-center shadow-sm">
                esc
              </kbd>{' '}
              {t('search.footer.esc')}
            </span>
          </div>
        </div>
      </div>
    </Modal>
  );
};

export default GlobalSearch;
