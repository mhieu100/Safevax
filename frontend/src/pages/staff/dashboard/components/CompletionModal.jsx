import {
  CheckCircleOutlined,
  DashboardOutlined,
  ExperimentOutlined,
  MedicineBoxOutlined,
  WarningOutlined,
} from '@ant-design/icons';
import {
  Alert,
  Button,
  Card,
  Col,
  Divider,
  Form,
  Input,
  InputNumber,
  Modal,
  message,
  Row,
  Select,
  Steps,
  Typography,
} from 'antd';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { callCompleteAppointment } from '@/services/appointment.service';

const { Title, Text } = Typography;
const { Step } = Steps;
const { TextArea } = Input;
const { Option } = Select;

const CompletionModal = ({ open, onCancel, appointment, onSuccess }) => {
  const { t } = useTranslation(['staff']);
  const [currentStep, setCurrentStep] = useState(0);
  const [loading, setLoading] = useState(false);
  const [form] = Form.useForm();

  useEffect(() => {
    if (open) {
      setCurrentStep(0);
      form.resetFields();
    }
  }, [open, form]);

  const handleFinish = async () => {
    try {
      setLoading(true);
      const values = form.getFieldsValue(true);

      const payload = {
        height: values.height,
        weight: values.weight,
        temperature: values.temperature,
        pulse: values.heartRate,

        site: values.site || 'LEFT_ARM',
        notes: values.temperatureNote,

        adverseReactions: values.reaction ? `${values.reactionType}: ${values.reaction}` : null,
      };

      await callCompleteAppointment(appointment.id, payload);

      message.success(t('staff:appointments.completion.success'));
      onSuccess();
      onCancel();
    } catch (error) {
      message.error(`${t('staff:dashboard.error.generic')}: ${error.message}`);
    } finally {
      setLoading(false);
    }
  };

  const next = async () => {
    try {
      await form.validateFields();
      setCurrentStep(currentStep + 1);
    } catch (_err) {}
  };

  const prev = () => setCurrentStep(currentStep - 1);

  const steps = [
    {
      title: t('staff:appointments.completion.steps.vitals'),
      icon: <DashboardOutlined />,
      content: (
        <Row gutter={16}>
          <Col span={24}>
            <Alert
              message={t('staff:appointments.completion.alerts.vitalsUpdate.message')}
              description={t('staff:appointments.completion.alerts.vitalsUpdate.description')}
              type="info"
              showIcon
              style={{ marginBottom: 24 }}
            />
          </Col>
          <Col span={12}>
            <Form.Item
              name="weight"
              label={t('staff:appointments.completion.fields.weight')}
              rules={[
                { required: true, message: t('staff:appointments.completion.fields.weightReq') },
              ]}
            >
              <InputNumber style={{ width: '100%' }} placeholder="VD: 60.5" step={0.1} min={0} />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              name="height"
              label={t('staff:appointments.completion.fields.height')}
              rules={[
                { required: true, message: t('staff:appointments.completion.fields.heightReq') },
              ]}
            >
              <InputNumber style={{ width: '100%' }} placeholder="VD: 170" step={1} min={0} />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              name="temperature"
              label={t('staff:appointments.completion.fields.temperature')}
            >
              <InputNumber style={{ width: '100%' }} placeholder="VD: 36.5" step={0.1} />
            </Form.Item>
          </Col>
          <Col span={12}>
            <Form.Item
              name="bloodPressure"
              label={t('staff:appointments.completion.fields.bloodPressure')}
            >
              <Input placeholder="VD: 120/80" />
            </Form.Item>
          </Col>
        </Row>
      ),
    },
    {
      title: t('staff:appointments.completion.steps.info'),
      icon: <ExperimentOutlined />,
      content: (
        <>
          <Row gutter={16}>
            <Col span={12}>
              <Form.Item
                name="heartRate"
                label={t('staff:appointments.completion.fields.heartRate')}
              >
                <InputNumber style={{ width: '100%' }} placeholder="VD: 80" />
              </Form.Item>
            </Col>
            <Col span={12}>
              <Form.Item
                name="site"
                label={t('staff:appointments.completion.fields.site')}
                initialValue="LEFT_ARM"
              >
                <Select>
                  <Option value="LEFT_ARM">
                    {t('staff:appointments.completion.options.leftArm')}
                  </Option>
                  <Option value="RIGHT_ARM">
                    {t('staff:appointments.completion.options.rightArm')}
                  </Option>
                  <Option value="LEFT_THIGH">
                    {t('staff:appointments.completion.options.leftThigh')}
                  </Option>
                  <Option value="RIGHT_THIGH">
                    {t('staff:appointments.completion.options.rightThigh')}
                  </Option>
                </Select>
              </Form.Item>
            </Col>
          </Row>

          <Divider orientation="left">{t('staff:appointments.completion.fields.site')}</Divider>

          <Form.Item
            name="reactionType"
            label={t('staff:appointments.completion.fields.reactionType')}
          >
            <Select placeholder={t('staff:appointments.completion.fields.reactionTypePlaceholder')}>
              <Option value="Không có">{t('staff:appointments.completion.options.none')}</Option>
              <Option value="Sốt nhẹ">{t('staff:appointments.completion.options.fever')}</Option>
              <Option value="Đau tại chỗ tiêm">
                {t('staff:appointments.completion.options.pain')}
              </Option>
              <Option value="Dị ứng">{t('staff:appointments.completion.options.allergy')}</Option>
              <Option value="Sốc phản vệ">
                {t('staff:appointments.completion.options.shock')}
              </Option>
            </Select>
          </Form.Item>
          <Form.Item
            name="reaction"
            label={t('staff:appointments.completion.fields.reactionDetail')}
          >
            <TextArea
              rows={3}
              placeholder={t('staff:appointments.completion.fields.reactionPlaceholder')}
            />
          </Form.Item>
          <Form.Item name="temperatureNote" label={t('staff:appointments.completion.fields.notes')}>
            <TextArea
              rows={2}
              placeholder={t('staff:appointments.completion.fields.notesPlaceholder')}
            />
          </Form.Item>
        </>
      ),
    },
    {
      title: t('staff:appointments.completion.steps.confirm'),
      icon: <CheckCircleOutlined />,
      content: (
        <Card bordered={false} style={{ textAlign: 'center' }}>
          <MedicineBoxOutlined style={{ fontSize: 48, color: '#52c41a', marginBottom: 16 }} />
          <Title level={4}>{t('staff:appointments.completion.confirm.title')}</Title>
          <Text>
            {t('staff:appointments.completion.confirm.text', {
              vaccine: appointment?.vaccine,
              patient: appointment?.patient,
            })}
          </Text>
          <Divider />
          <Alert
            type="warning"
            showIcon
            icon={<WarningOutlined />}
            message={t('staff:appointments.completion.alerts.irreversible.message')}
            description={t('staff:appointments.completion.alerts.irreversible.description')}
          />
        </Card>
      ),
    },
  ];

  return (
    <Modal
      open={open}
      onCancel={onCancel}
      title={t('staff:appointments.completion.title')}
      width={700}
      footer={null}
      destroyOnClose
    >
      <Steps current={currentStep} style={{ marginBottom: 24 }}>
        {steps.map((item) => (
          <Step key={item.title} title={item.title} icon={item.icon} />
        ))}
      </Steps>

      <Form form={form} layout="vertical">
        <div style={{ minHeight: '200px' }}>{steps[currentStep].content}</div>

        <div style={{ marginTop: 24, textAlign: 'right' }}>
          {currentStep > 0 && (
            <Button style={{ margin: '0 8px' }} onClick={prev}>
              {t('staff:common.prev')}
            </Button>
          )}
          {currentStep < steps.length - 1 && (
            <Button type="primary" onClick={next}>
              {t('staff:common.next')}
            </Button>
          )}
          {currentStep === steps.length - 1 && (
            <Button
              type="primary"
              onClick={handleFinish}
              loading={loading}
              style={{ background: '#52c41a', borderColor: '#52c41a' }}
            >
              {t('staff:appointments.completion.confirm.button')}
            </Button>
          )}
        </div>
      </Form>
    </Modal>
  );
};

export default CompletionModal;
