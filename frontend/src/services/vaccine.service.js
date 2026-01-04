import apiClient from './apiClient';

export async function getCountries() {
  return apiClient.get('/api/vaccines/countries');
}

export async function getManufacturers() {
  return apiClient.get('/api/vaccines/manufacturers');
}

export async function getDosesRequired() {
  return apiClient.get('/api/vaccines/doses-required');
}

export async function getDiseases() {
  return apiClient.get('/api/vaccines/diseases');
}

export async function getBySlug(slug) {
  return apiClient.get(`/api/vaccines/${slug}`);
}

export async function callCreateVaccine(data) {
  return apiClient.post('/api/vaccines', data);
}

export async function callUpdateVaccine(vaccineId, data) {
  return apiClient.put(`/api/vaccines/${vaccineId}`, data);
}

export async function callFetchVaccine(query) {
  return apiClient.get(`/api/vaccines?${query}`);
}

export async function callDeleteVaccine(id) {
  return apiClient.delete(`/api/vaccines/${id}`);
}

// === APIs cho vaccine recommendation theo đối tượng ===

/**
 * Lấy danh sách vaccine phù hợp với tuổi và giới tính
 * @param {number} ageInMonths - Tuổi tính theo tháng
 * @param {string} gender - Giới tính (MALE, FEMALE, ALL)
 */
export async function getRecommendedVaccines(ageInMonths, gender = 'ALL') {
  return apiClient.get(`/api/vaccines/recommended?ageInMonths=${ageInMonths}&gender=${gender}`);
}

/**
 * Lấy danh sách vaccine thiết yếu theo độ tuổi
 * @param {number} ageInMonths - Tuổi tính theo tháng
 */
export async function getEssentialVaccines(ageInMonths) {
  return apiClient.get(`/api/vaccines/essential?ageInMonths=${ageInMonths}`);
}

/**
 * Lấy vaccine theo nhóm đối tượng
 * @param {string} targetGroup - NEWBORN, INFANT, TODDLER, CHILD, TEEN, ADULT, ELDERLY, PREGNANT, ALL
 */
export async function getVaccinesByTargetGroup(targetGroup) {
  return apiClient.get(`/api/vaccines/target-group/${targetGroup}`);
}

/**
 * Lấy vaccine theo danh mục
 * @param {string} category - BASIC_CHILDHOOD, SCHOOL_AGE, ADULT_ROUTINE, PREGNANCY, ELDERLY_CARE, TRAVEL, COVID19
 */
export async function getVaccinesByCategory(category) {
  return apiClient.get(`/api/vaccines/category/${category}`);
}

/**
 * Lấy vaccine theo loại bệnh
 * @param {string} disease
 */
export async function getVaccinesByDisease(disease) {
  return apiClient.get(`/api/vaccines/disease/${disease}`);
}

/**
 * Lấy danh sách tất cả categories
 */
export async function getVaccineCategories() {
  return apiClient.get('/api/vaccines/categories');
}

/**
 * Lấy danh sách tất cả target groups
 */
export async function getTargetGroups() {
  return apiClient.get('/api/vaccines/target-groups');
}

// === APIs cho vaccine cho phụ nữ mang thai ===

/**
 * Lấy vaccine an toàn cho phụ nữ mang thai
 */
export async function getPregnancySafeVaccines() {
  return apiClient.get('/api/vaccines/pregnancy/safe');
}

/**
 * Lấy vaccine nên tiêm trước khi mang thai
 */
export async function getPrePregnancyVaccines() {
  return apiClient.get('/api/vaccines/pregnancy/pre');
}

/**
 * Lấy vaccine nên tiêm sau sinh
 */
export async function getPostPregnancyVaccines() {
  return apiClient.get('/api/vaccines/pregnancy/post');
}

export const callFetchCountry = getCountries;
export const callGetAllCountries = getCountries;
export const callGetAllManufacturers = getManufacturers;
export const callGetAllDosesRequired = getDosesRequired;
export const callGetAllDiseases = getDiseases;
export const callGetAllTargetGroups = getTargetGroups;
export const callGetBySlug = getBySlug;
export const callGetBySku = getBySlug;
export const callFetchVaccineBySlug = getBySlug;
