import apiClient from './apiClient';

export const getTransactionResult = async (paymentId) => {
  const response = await apiClient.get(`/payments/${paymentId}/result`);
  return response.data;
};

export const updatePaymentMetaMask = async (data) => {
  const response = await apiClient.post('/payments/meta-mask', data);
  return response.data;
};
