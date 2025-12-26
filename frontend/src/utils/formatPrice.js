export const formatPrice = (value, currency = 'VND') => {
  if (typeof value !== 'number') return '0đ';
  if (currency === 'USD') {
    return value.toLocaleString('en-US', {
      style: 'currency',
      currency: 'USD',
    });
  }
  if (currency === 'ETH') {
    return `${value.toLocaleString('en-US', {
      maximumFractionDigits: 6,
    })} ETH`;
  }
  return `${value.toLocaleString('vi-VN')}đ`;
};
