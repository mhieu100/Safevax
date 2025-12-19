import {
  BankOutlined,
  CreditCardOutlined,
  DollarOutlined,
  SafetyCertificateOutlined,
  WalletOutlined,
} from '@ant-design/icons';
import { Button, Card, Col, Divider, message, Radio, Row, Typography } from 'antd';
import { ethers } from 'ethers';
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { callCreateOrder } from '@/services/order.service';
import { updatePaymentMetaMask } from '@/services/payment.service';
import useCartStore from '@/stores/useCartStore';

const { Title, Text } = Typography;

const CheckoutPage = () => {
  const navigate = useNavigate();
  const { items, totalPrice, clearCart } = useCartStore();
  const [paymentMethod, setPaymentMethod] = useState('BANK');
  const [loading, setLoading] = useState(false);

  const handleCheckout = async () => {
    if (items.length === 0) {
      message.error('Giỏ hàng trống');
      return;
    }

    try {
      setLoading(true);

      if (paymentMethod === 'METAMASK') {
        await handleMetaMaskPayment();
        return;
      }

      const payload = {
        items: items.map((item) => ({
          id: item.vaccine.id,
          quantity: item.quantity,
        })),
        itemCount: items.reduce((acc, item) => acc + item.quantity, 0),
        totalAmount: totalPrice(),
        paymentMethod: paymentMethod,
      };

      const res = await callCreateOrder(payload);

      if (res && res.data.paymentURL) {
        // Redirect to PayPal / VNPAY
        window.location.href = res.data.paymentURL;
      } else if (paymentMethod === 'CASH') {
        message.success('Đặt hàng thành công!');
        clearCart();
        navigate('/success'); // Create this page specifically for Order success if needed
      }
    } catch (error) {
      console.error(error);
      message.error(error?.response?.data?.message || 'Có lỗi xảy ra khi tạo đơn hàng');
    } finally {
      if (paymentMethod !== 'METAMASK') setLoading(false);
    }
  };

  const handleMetaMaskPayment = async () => {
    if (!window.ethereum) {
      message.error('Vui lòng cài đặt MetaMask!');
      setLoading(false);
      return;
    }

    try {
      // 1. Create Order first to get Reference ID
      const payload = {
        items: items.map((item) => ({
          id: item.vaccine.id,
          quantity: item.quantity,
        })),
        itemCount: items.reduce((acc, item) => acc + item.quantity, 0),
        totalAmount: totalPrice(),
        paymentMethod: 'METAMASK',
      };

      const res = await callCreateOrder(payload);

      const paymentData = res?.data;

      if (!paymentData || !paymentData.amount || !paymentData.referenceId) {
        throw new Error('Invalid order response');
      }

      await window.ethereum.request({ method: 'eth_requestAccounts' });
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();

      const receiverAddress = import.meta.env.VITE_RECEIVER_ADDRESS;

      const tx = await signer.sendTransaction({
        to: receiverAddress,
        value: ethers.parseEther(paymentData.amount.toString()),
      });

      message.loading('Đang xử lý thanh toán...');
      await tx.wait();

      await updatePaymentMetaMask({
        paymentId: paymentData.paymentId,
        referenceId: paymentData.referenceId,
        type: 'ORDER',
      });

      message.success('Thanh toán thành công!');
      clearCart();
      navigate('/success');
    } catch (error) {
      console.error('MetaMask Error:', error);
      message.error('Thanh toán thất bại hoặc bị hủy');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-50 py-12 animate-fade-in">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <Title level={2} className="mb-8 flex items-center gap-3">
          <SafetyCertificateOutlined className="text-blue-600" />
          Xác nhận đơn hàng
        </Title>

        <Row gutter={24}>
          <Col xs={24} lg={16}>
            <Card className="rounded-2xl shadow-sm border border-slate-100 mb-6">
              <Title level={4}>Danh sách sản phẩm</Title>
              <Divider />
              {items.map((item) => (
                <div
                  key={item.vaccine.id}
                  className="flex justify-between items-center py-4 border-b last:border-0 border-slate-50"
                >
                  <div className="flex items-center gap-4">
                    <img
                      src={item.vaccine.image || 'https://placehold.co/600x400'}
                      alt={item.vaccine.name}
                      className="w-16 h-16 object-cover rounded-lg"
                    />
                    <div>
                      <Text strong className="text-lg block">
                        {item.vaccine.name}
                      </Text>
                      <Text type="secondary">Số lượng: {item.quantity}</Text>
                    </div>
                  </div>
                  <Text strong>
                    {new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(
                      item.vaccine.price * item.quantity
                    )}
                  </Text>
                </div>
              ))}
            </Card>

            <Card className="rounded-2xl shadow-sm border border-slate-100 mb-6">
              <Title level={4}>Phương thức thanh toán</Title>
              <Divider />
              <Radio.Group
                onChange={(e) => setPaymentMethod(e.target.value)}
                value={paymentMethod}
                className="w-full flex flex-col gap-4"
              >
                <Radio
                  value="BANK"
                  className="p-4 border rounded-xl hover:border-blue-500 transition-colors [&.ant-radio-wrapper-checked]:border-blue-500 [&.ant-radio-wrapper-checked]:bg-blue-50"
                >
                  <div className="flex items-center gap-3 w-full">
                    <BankOutlined className="text-2xl text-green-600" />
                    <div>
                      <div className="font-medium">Chuyển khoản VNPAY</div>
                      <div className="text-xs text-slate-500">
                        Thanh toán qua thẻ ATM/Internet Banking
                      </div>
                    </div>
                  </div>
                </Radio>

                <Radio
                  value="PAYPAL"
                  className="p-4 border rounded-xl hover:border-blue-500 transition-colors [&.ant-radio-wrapper-checked]:border-blue-500 [&.ant-radio-wrapper-checked]:bg-blue-50"
                >
                  <div className="flex items-center gap-3">
                    <CreditCardOutlined className="text-2xl text-blue-600" />
                    <div>
                      <div className="font-medium">PayPal</div>
                      <div className="text-xs text-slate-500">Thanh toán quốc tế an toàn</div>
                    </div>
                  </div>
                </Radio>

                <Radio
                  value="METAMASK"
                  className="p-4 border rounded-xl hover:border-blue-500 transition-colors [&.ant-radio-wrapper-checked]:border-blue-500 [&.ant-radio-wrapper-checked]:bg-blue-50"
                >
                  <div className="flex items-center gap-3">
                    <WalletOutlined className="text-2xl text-orange-500" />
                    <div>
                      <div className="font-medium">Ví MetaMask</div>
                      <div className="text-xs text-slate-500">
                        Thanh toán bằng tiền điện tử (ETH)
                      </div>
                    </div>
                  </div>
                </Radio>

                <Radio
                  value="CASH"
                  className="p-4 border rounded-xl hover:border-blue-500 transition-colors [&.ant-radio-wrapper-checked]:border-blue-500 [&.ant-radio-wrapper-checked]:bg-blue-50"
                >
                  <div className="flex items-center gap-3">
                    <DollarOutlined className="text-2xl text-slate-600" />
                    <div>
                      <div className="font-medium">Tiền mặt</div>
                      <div className="text-xs text-slate-500">Thanh toán tại trung tâm</div>
                    </div>
                  </div>
                </Radio>
              </Radio.Group>
            </Card>
          </Col>

          <Col xs={24} lg={8}>
            <Card className="rounded-2xl shadow-sm border border-slate-100 sticky top-24">
              <Title level={4}>Tổng quan đơn hàng</Title>
              <Divider className="my-4" />
              <div className="flex justify-between mb-2">
                <Text>Tạm tính:</Text>
                <Text>
                  {new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(
                    totalPrice()
                  )}
                </Text>
              </div>
              <div className="flex justify-between mb-4">
                <Text>Giảm giá:</Text>
                <Text type="success">-0 ₫</Text>
              </div>
              <Divider className="my-4" />
              <div className="flex justify-between items-center mb-6">
                <Text strong className="text-lg">
                  Tổng cộng:
                </Text>
                <Text strong className="text-xl text-blue-600">
                  {new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(
                    totalPrice()
                  )}
                </Text>
              </div>

              <Button
                type="primary"
                size="large"
                block
                className="h-12 rounded-xl text-lg font-semibold bg-gradient-to-r from-blue-600 to-indigo-600 border-0 shadow-lg shadow-blue-500/30 hover:shadow-blue-500/50 hover:scale-[1.02] transition-all"
                onClick={handleCheckout}
                loading={loading}
              >
                {loading ? 'Đang xử lý...' : 'Thanh toán ngay'}
              </Button>

              <div className="mt-4 flex items-center justify-center gap-2 text-slate-400 text-xs">
                <SafetyCertificateOutlined /> Bảo mật thanh toán an toàn 100%
              </div>
            </Card>
          </Col>
        </Row>
      </div>
    </div>
  );
};

export default CheckoutPage;
