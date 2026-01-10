import {
  CalendarOutlined,
  EnvironmentOutlined,
  IdcardOutlined,
  InfoCircleOutlined,
  MedicineBoxOutlined,
  PhoneOutlined,
  SafetyCertificateFilled,
  UserOutlined,
} from '@ant-design/icons';
import { Button, Card, DatePicker, Form, Input, message, Select, Typography } from 'antd';
import { useEffect, useState } from 'react';
import { Trans, useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import { callCompleteProfile } from '@/services/auth.service';
import useAccountStore from '@/stores/useAccountStore';
import { birthdayValidation } from '@/utils/birthdayValidation';

const { Title, Text } = Typography;

const CompleteProfilePage = () => {
  const { t } = useTranslation(['client']);
  const navigate = useNavigate();
  const [form] = Form.useForm();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isReady, setIsReady] = useState(false);
  const { setUserLoginInfo, isActive, isAuthenticated, user } = useAccountStore();

  useEffect(() => {
    const timer = setTimeout(() => {
      setIsReady(true);
    }, 100);

    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    if (!isReady) return;

    if (!isAuthenticated) {
      navigate('/login');
      return;
    }

    if (user?.role && user.role !== 'PATIENT') {
      navigate('/');
      return;
    }

    if (isActive) {
      navigate('/');
    }
  }, [isReady, isAuthenticated, isActive, user, navigate]);

  const onSubmit = async (values) => {
    try {
      setIsSubmitting(true);

      const payload = {
        phone: values.phone,
        address: values.address,
        birthday: values.birthday.format('YYYY-MM-DD'),
        gender: values.gender,
        identityNumber: values.identityNumber,
        bloodType: values.bloodType,
        heightCm: values.heightCm || null,
        weightKg: values.weightKg || null,
        occupation: values.occupation || null,
        lifestyleNotes: values.lifestyleNotes || null,
        insuranceNumber: values.insuranceNumber || null,
        consentForAIAnalysis: values.consentForAIAnalysis || false,
      };

      const response = await callCompleteProfile(payload);

      if (response?.data) {
        setUserLoginInfo(response.data);
        message.success(t('client:profile.completeProfile.successMessage'));
        navigate('/');
      } else {
        message.error(response?.error || t('client:profile.completeProfile.failureMessage'));
      }
    } catch (error) {
      message.error(error?.message || t('client:profile.completeProfile.errorMessage'));
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-50 py-12 px-4 sm:px-6 lg:px-8 flex flex-col items-center justify-center">
      {/* Header */}
      <div className="text-center mb-10 max-w-2xl">
        <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-blue-600 text-white mb-6 shadow-lg shadow-blue-500/30">
          <SafetyCertificateFilled className="text-3xl" />
        </div>
        <Title
          level={1}
          className="!mb-3 !text-3xl lg:!text-4xl !font-bold text-slate-900 tracking-tight"
        >
          {t('client:profile.completeProfile.title')}
        </Title>
        <Text className="text-slate-500 text-lg">
          <Trans
            i18nKey="client:profile.completeProfile.subtitle"
            components={{
              bold: <span className="font-semibold text-blue-600" />,
            }}
          />
        </Text>
      </div>

      <Card className="w-full max-w-4xl shadow-xl shadow-slate-200/60 border-0 rounded-3xl overflow-hidden">
        <div className="p-6 md:p-10">
          <Form
            form={form}
            name="complete-profile"
            onFinish={onSubmit}
            layout="vertical"
            requiredMark={false}
            size="large"
            className="space-y-8"
          >
            {/* Personal Information */}
            <div>
              <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-100">
                <div className="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center text-blue-600">
                  <UserOutlined className="text-lg" />
                </div>
                <div>
                  <h3 className="text-lg font-bold text-slate-800 m-0">
                    {t('client:profile.personalInfo')}
                  </h3>
                  <p className="text-slate-500 text-sm m-0">
                    {t('client:profile.completeProfile.personalInfoDesc')}
                  </p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <Form.Item
                  name="identityNumber"
                  label={
                    <span className="font-medium text-slate-700">
                      {t('client:profile.completeProfile.identityNumber')}{' '}
                      <span className="text-red-500">*</span>
                    </span>
                  }
                  tooltip={{
                    title: t('client:profile.completeProfile.identityNumberTooltip'),
                    icon: <InfoCircleOutlined className="text-slate-400" />,
                  }}
                  rules={[
                    {
                      required: true,
                      message: t('client:profile.completeProfile.identityNumberRequired'),
                    },
                    {
                      pattern: /^[0-9]{9,12}$/,
                      message: t('client:profile.completeProfile.identityNumberInvalid'),
                    },
                  ]}
                >
                  <Input
                    prefix={<IdcardOutlined className="text-slate-400 px-1" />}
                    placeholder="123456789"
                    className="rounded-xl"
                  />
                </Form.Item>

                <Form.Item
                  name="birthday"
                  label={
                    <span className="font-medium text-slate-700">
                      {t('client:profile.dateOfBirth')} <span className="text-red-500">*</span>
                    </span>
                  }
                  rules={birthdayValidation.getFormRules(true, t)}
                >
                  <DatePicker
                    className="w-full rounded-xl"
                    format="DD/MM/YYYY"
                    placeholder={t('client:profile.dateOfBirth')}
                    disabledDate={birthdayValidation.disabledDate}
                    suffixIcon={<CalendarOutlined className="text-slate-400" />}
                  />
                </Form.Item>

                <Form.Item
                  name="gender"
                  label={
                    <span className="font-medium text-slate-700">
                      {t('client:profile.gender')} <span className="text-red-500">*</span>
                    </span>
                  }
                  rules={[{ required: true, message: t('client:profile.selectGender') }]}
                >
                  <Select placeholder={t('client:profile.selectGender')} className="rounded-xl">
                    <Select.Option value="MALE">{t('client:profile.male')}</Select.Option>
                    <Select.Option value="FEMALE">{t('client:profile.female')}</Select.Option>
                    <Select.Option value="OTHER">{t('client:profile.other')}</Select.Option>
                  </Select>
                </Form.Item>
              </div>
            </div>

            {/* Contact Details */}
            <div>
              <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-100">
                <div className="w-10 h-10 rounded-full bg-emerald-50 flex items-center justify-center text-emerald-600">
                  <EnvironmentOutlined className="text-lg" />
                </div>
                <div>
                  <h3 className="text-lg font-bold text-slate-800 m-0">
                    {t('client:profile.completeProfile.contactDetails')}
                  </h3>
                  <p className="text-slate-500 text-sm m-0">
                    {t('client:profile.completeProfile.contactDetailsDesc')}
                  </p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <Form.Item
                  name="phone"
                  label={
                    <span className="font-medium text-slate-700">
                      {t('client:profile.completeProfile.phoneNumber')}{' '}
                      <span className="text-red-500">*</span>
                    </span>
                  }
                  rules={[
                    {
                      required: true,
                      message: t('client:profile.completeProfile.phoneNumberRequired'),
                    },
                    {
                      pattern: /^[0-9]{10,11}$/,
                      message: t('client:profile.completeProfile.phoneNumberInvalid'),
                    },
                  ]}
                >
                  <Input
                    prefix={<PhoneOutlined className="text-slate-400 px-1" />}
                    placeholder="0123456789"
                    className="rounded-xl"
                  />
                </Form.Item>

                <Form.Item
                  name="address"
                  label={
                    <span className="font-medium text-slate-700">
                      {t('client:profile.address')} <span className="text-red-500">*</span>
                    </span>
                  }
                  rules={[
                    {
                      required: true,
                      message: t('client:profile.completeProfile.addressRequired'),
                    },
                  ]}
                >
                  <Input
                    prefix={<EnvironmentOutlined className="text-slate-400 px-1" />}
                    placeholder={t('client:profile.completeProfile.addressPlaceholder')}
                    className="rounded-xl"
                  />
                </Form.Item>
              </div>
            </div>

            {/* Medical Information */}
            <div>
              <div className="flex items-center gap-3 mb-6 pb-4 border-b border-slate-100">
                <div className="w-10 h-10 rounded-full bg-red-50 flex items-center justify-center text-red-600">
                  <MedicineBoxOutlined className="text-lg" />
                </div>
                <div>
                  <h3 className="text-lg font-bold text-slate-800 m-0">
                    {t('client:profile.medicalInfo')}
                  </h3>
                  <p className="text-slate-500 text-sm m-0">
                    {t('client:profile.completeProfile.medicalInfoDesc')}
                  </p>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <Form.Item
                  name="bloodType"
                  label={
                    <span className="font-medium text-slate-700">
                      {t('client:profile.bloodType')} <span className="text-red-500">*</span>
                    </span>
                  }
                  rules={[
                    {
                      required: true,
                      message: t('client:profile.completeProfile.bloodTypeRequired'),
                    },
                  ]}
                >
                  <Select placeholder={t('client:profile.selectBloodType')} className="rounded-xl">
                    <Select.Option value="A">A</Select.Option>
                    <Select.Option value="B">B</Select.Option>
                    <Select.Option value="AB">AB</Select.Option>
                    <Select.Option value="O">O</Select.Option>
                  </Select>
                </Form.Item>

                <Form.Item
                  name="heightCm"
                  label={
                    <span className="font-medium text-slate-700">
                      {t('client:profile.completeProfile.heightLabel')}
                    </span>
                  }
                >
                  <Input
                    type="number"
                    placeholder={t('client:profile.completeProfile.heightPlaceholder')}
                    className="rounded-xl"
                  />
                </Form.Item>

                <Form.Item
                  name="weightKg"
                  label={
                    <span className="font-medium text-slate-700">
                      {t('client:profile.completeProfile.weightLabel')}
                    </span>
                  }
                >
                  <Input
                    type="number"
                    placeholder={t('client:profile.completeProfile.weightPlaceholder')}
                    className="rounded-xl"
                  />
                </Form.Item>
              </div>
            </div>

            <div className="pt-6 border-t border-slate-100">
              <Button
                type="primary"
                htmlType="submit"
                loading={isSubmitting}
                className="w-full h-14 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 font-bold text-lg shadow-lg shadow-blue-500/30 border-0"
              >
                {isSubmitting
                  ? t('client:profile.completeProfile.submitLoading')
                  : t('client:profile.completeProfile.submit')}
              </Button>
              <p className="text-center text-slate-400 text-sm mt-4">
                {t('client:profile.completeProfile.termsText')}
              </p>
            </div>
          </Form>
        </div>
      </Card>
    </div>
  );
};

export default CompleteProfilePage;
