import axios from '@/services/apiClient';

export const globalSearch = async (query) => {
  try {
    const response = await axios.get('/api/search/global', {
      params: { query },
    });
    return response.data;
  } catch (error) {
    console.error('Search error:', error);
    return { vaccines: [], news: [], aiConsultation: null };
  }
};
