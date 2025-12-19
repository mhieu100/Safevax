import apiClient from './apiClient';

export const getTransactionResult = async (paymentId) => {
  const response = await apiClient.get(`/api/payments/${paymentId}/result`);
  return response.data;
};

export const updatePaymentMetaMask = async (data) => {
  const response = await apiClient.post('/api/payments/meta-mask', data);
  return response.data;
};

export const getMyPaymentHistory = async () => {
  const response = await apiClient.get('/api/payments/my-history');
  return response.data;
};
