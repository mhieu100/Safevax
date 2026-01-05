import { SafetyCertificateOutlined } from '@ant-design/icons';
import { Badge } from 'antd';
import { useTranslation } from 'react-i18next';

const BlockchainBadge = ({ verified = false }) => {
  const { t } = useTranslation(['common']);

  if (!verified) return null;

  return (
    <Badge
      count={
        <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-emerald-50 border border-emerald-200">
          <SafetyCertificateOutlined className="text-emerald-600 text-xs" />
          <span className="text-emerald-700 font-medium text-xs">
            {t('common:blockchain.verified')}
          </span>
        </div>
      }
    />
  );
};

export default BlockchainBadge;
