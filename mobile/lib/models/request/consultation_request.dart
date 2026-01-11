class ConsultationRequest {
  final String query;
  final String age;
  final List<String> vaccinationHistory;
  final String healthCondition;

  ConsultationRequest({
    required this.query,
    required this.age,
    required this.vaccinationHistory,
    required this.healthCondition,
  });

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'age': age,
      'vaccinationHistory': vaccinationHistory,
      'healthCondition': healthCondition,
    };
  }
}
