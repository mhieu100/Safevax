import apiClient from './apiClient';

export const getMyCart = () => apiClient.get('/api/cart');
export const addToCart = (data) => apiClient.post('/api/cart', data);
export const updateCartItem = (id, quantity) =>
  apiClient.put(`/api/cart/${id}?quantity=${quantity}`);
export const removeCartItem = (id) => apiClient.delete(`/api/cart/${id}`);
export const clearBackendCart = () => apiClient.delete('/api/cart');
