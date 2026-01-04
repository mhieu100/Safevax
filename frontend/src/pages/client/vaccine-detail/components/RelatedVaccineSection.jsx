import { Spin, Typography } from 'antd';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import Slider from 'react-slick';
import VaccineCard from '@/pages/client/vaccine-list/components/VaccineCard';
import {
  callFetchVaccine,
  getVaccinesByCategory,
  getVaccinesByDisease,
} from '@/services/vaccine.service';
import 'slick-carousel/slick/slick.css';
import 'slick-carousel/slick/slick-theme.css';

const { Title } = Typography;

const RelatedVaccineSection = ({ currentVaccine }) => {
  const { t } = useTranslation('common');
  const [relatedVaccines, setRelatedVaccines] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchRelated = async () => {
      if (!currentVaccine) return;
      setLoading(true);
      try {
        let list = [];

        // Priority 1: Fetch by Disease
        if (currentVaccine.disease) {
          try {
            const resDisease = await getVaccinesByDisease(currentVaccine.disease);
            const diseaseList = resDisease?.data || [];
            list = [...list, ...diseaseList];
          } catch (e) {
            console.warn('Failed fetch by disease', e);
          }
        }

        // Priority 2: Fetch by Category (if needed more)
        if (list.length < 5 && currentVaccine.category) {
          try {
            const resCategory = await getVaccinesByCategory(currentVaccine.category);
            const categoryList = resCategory?.data || [];
            list = [...list, ...categoryList];
          } catch (e) {
            console.warn('Failed fetch by category', e);
          }
        }

        // Fallback: If still empty, general fetch
        if (list.length === 0) {
          const res = await callFetchVaccine(`page=0&size=5`);
          list = res?.data?.content || res?.data || [];
        }

        // Deduplicate and filter out current
        const uniqueList = list.filter(
          (v, index, self) =>
            index === self.findIndex((t) => t.id === v.id) && v.id !== currentVaccine.id
        );

        // Limit to 8 items
        setRelatedVaccines(uniqueList.slice(0, 8));
      } catch (error) {
        console.error('Failed to fetch related vaccines', error);
      } finally {
        setLoading(false);
      }
    };

    fetchRelated();
  }, [currentVaccine]);

  if (!loading && relatedVaccines.length === 0) {
    return null;
  }

  const settings = {
    dots: true,
    infinite: false,
    speed: 500,
    slidesToShow: 4,
    slidesToScroll: 1,
    responsive: [
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 3,
        },
      },
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 2,
        },
      },
      {
        breakpoint: 640,
        settings: {
          slidesToShow: 1,
        },
      },
    ],
  };

  // If few items, don't use slider, just grid
  const useSlider = relatedVaccines.length > 4;

  return (
    <div className="mt-16">
      <Title level={3} className="mb-8 text-slate-800 border-l-4 border-blue-600 pl-4">
        {t('vaccine.relatedVaccines') || 'Vắc xin liên quan'}
      </Title>

      {loading ? (
        <div className="flex justify-center py-10">
          <Spin size="large" />
        </div>
      ) : useSlider ? (
        <div className="mx-[-10px]">
          <Slider {...settings}>
            {relatedVaccines.map((vaccine) => (
              <div key={vaccine.id} className="px-3 py-2 h-full">
                <VaccineCard vaccine={vaccine} />
              </div>
            ))}
          </Slider>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {relatedVaccines.map((vaccine) => (
            <VaccineCard key={vaccine.id} vaccine={vaccine} />
          ))}
        </div>
      )}
    </div>
  );
};

export default RelatedVaccineSection;
