import apiClient from './apiClient';

export const verifyRecord = async (id) => {
  try {
    const response = await apiClient.get(`/api/public/verify-vaccine/${id}`);
    // apiClient interceptors return response.data (the full backend response body)
    // Body format: { statusCode: 200, data: { ... } }
    return response.data;
  } catch (error) {
    console.error('Verification failed:', error);
    throw error;
  }
};

/**
 * Verify if a patient has received a specific vaccine dose
 * @param {string} vaccineSlug - The vaccine slug (e.g., "covid-19-pfizer")
 * @param {number} doseNumber - The dose number to check
 * @param {string} identityHash - The patient's identity hash
 */
export const verifySpecificDose = async (vaccineSlug, doseNumber, identityHash) => {
  try {
    const response = await apiClient.get('/api/public/verify-dose', {
      params: {
        vaccine: vaccineSlug,
        dose: doseNumber,
        identity: identityHash,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Dose verification failed:', error);
    throw error;
  }
};

/**
 * Get all verified vaccination records for a patient by identity hash
 * @param {string} identityHash - The patient's identity hash
 */
export const getRecordsByIdentity = async (identityHash) => {
  try {
    const response = await apiClient.get(`/api/public/verify-identity/${identityHash}`);
    return response.data;
  } catch (error) {
    console.error('Failed to fetch records by identity:', error);
    throw error;
  }
};

/**
 * Get all doses of a specific vaccine for a patient
 * @param {string} vaccineSlug - The vaccine slug
 * @param {string} identityHash - The patient's identity hash
 */
export const getVaccineDosesByIdentity = async (vaccineSlug, identityHash) => {
  try {
    const response = await apiClient.get('/api/public/verify-vaccine-doses', {
      params: {
        vaccine: vaccineSlug,
        identity: identityHash,
      },
    });
    return response.data;
  } catch (error) {
    console.error('Failed to fetch vaccine doses:', error);
    throw error;
  }
};
