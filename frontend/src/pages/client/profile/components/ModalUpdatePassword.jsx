import { CheckCircleOutlined } from '@ant-design/icons';
import { Button, Form, Input, Modal, message, Typography } from 'antd';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { callChangePassword } from '@/services/auth.service';
import { useAccountStore } from '@/stores/useAccountStore';

const { Text } = Typography;

const ModalUpdatePassword = ({ open, setOpen }) => {
  const { t } = useTranslation('client');
  const [securityForm] = Form.useForm();
  const [loading, setLoading] = useState(false);
  const user = useAccountStore((state) => state.user);

  const handleUpdatePassword = async (values) => {
    if (!user?.email) {
      message.error(t('profile.security.userEmailNotFound'));
      return;
    }

    if (values.newPassword !== values.confirmPassword) {
      message.error(t('profile.security.passwordMismatch'));
      return;
    }

    setLoading(true);
    try {
      const response = await callChangePassword({
        email: user.email,
        oldPassword: values.currentPassword,
        newPassword: values.newPassword,
      });

      if (response && typeof response === 'object' && 'data' in response) {
        if (response.data === true) {
          message.success(response.message || t('profile.security.passwordUpdatedSuccess'));
          securityForm.resetFields();
          setOpen(false);
        } else {
          message.error(t('profile.security.passwordUpdateFailed'));
        }
      } else {
        message.error(t('profile.security.unexpectedError'));
      }
    } catch (error) {
      const errorMessage = error?.message || t('profile.security.unexpectedError');
      message.error(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const handleCancel = () => {
    securityForm.resetFields();
    setOpen(false);
  };

  return (
    <Modal
      title={t('profile.security.title')}
      open={open}
      onCancel={handleCancel}
      footer={null}
      width={600}
    >
      <div className="py-4">
        <div className="space-y-6">
          <div className="bg-green-50 border border-green-200 rounded-lg p-4">
            <div className="flex items-center gap-3">
              <CheckCircleOutlined className="text-green-600 text-lg" />
              <div>
                <Text strong className="text-green-800">
                  {t('profile.security.accountSecure')}
                </Text>
                <Text className="block text-sm text-green-600">
                  {t('profile.security.accountSecureDesc')}
                </Text>
              </div>
            </div>
          </div>

          <Form form={securityForm} layout="vertical" onFinish={handleUpdatePassword}>
            <Form.Item
              label={t('profile.security.currentPassword')}
              name="currentPassword"
              rules={[
                { required: true, message: t('profile.security.pleaseEnterCurrentPassword') },
                { min: 6, message: t('profile.security.passwordMinLength') },
              ]}
            >
              <Input.Password placeholder={t('profile.security.enterCurrentPassword')} />
            </Form.Item>

            <Form.Item
              label={t('profile.security.newPassword')}
              name="newPassword"
              rules={[
                { required: true, message: t('profile.security.pleaseEnterNewPassword') },
                { min: 6, message: t('profile.security.passwordMinLength') },
              ]}
            >
              <Input.Password placeholder={t('profile.security.enterNewPassword')} />
            </Form.Item>

            <Form.Item
              label={t('profile.security.confirmNewPassword')}
              name="confirmPassword"
              rules={[
                { required: true, message: t('profile.security.pleaseConfirmPassword') },
                { min: 6, message: t('profile.security.passwordMinLength') },
              ]}
            >
              <Input.Password placeholder={t('profile.security.confirmPassword')} />
            </Form.Item>

            <div className="flex gap-3">
              <Button type="primary" htmlType="submit" loading={loading}>
                {t('profile.security.updatePassword')}
              </Button>
              <Button onClick={handleCancel}>{t('profile.cancel')}</Button>
            </div>
          </Form>
        </div>
      </div>
    </Modal>
  );
};

export default ModalUpdatePassword;
