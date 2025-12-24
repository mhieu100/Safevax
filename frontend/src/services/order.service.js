import apiClient from './apiClient';

export async function callCreateOrder(payload) {
  return apiClient.post('/api/orders', payload);
}

export async function getMyOrders() {
  const response = await apiClient.get('/api/orders');
  return response.data;
}

export async function getOrderDetail(orderId) {
  const response = await apiClient.get(`/api/orders/${orderId}`);
  return response.data;
}

export async function getAllOrdersAdmin() {
  const response = await apiClient.get('/api/orders/all');
  return response.data;
}

export async function getOrderDetailAdmin(orderId) {
  const response = await apiClient.get(`/api/orders/admin/${orderId}`);
  return response.data;
}

export async function updateOrderStatus(orderId, status) {
  const response = await apiClient.put(`/api/orders/admin/${orderId}/status`, { status });
  return response.data;
}
