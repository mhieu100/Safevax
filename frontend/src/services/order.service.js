import apiClient from './apiClient';

export async function callCreateOrder(payload) {
  return apiClient.post('/api/orders', payload);
}

export async function getMyOrders() {
  const response = await apiClient.get('/api/orders');
  return response.data;
}

export async function getAllOrdersAdmin() {
  const response = await apiClient.get('/api/orders/all');
  return response.data;
}
