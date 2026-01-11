import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_consultation_repository.dart';
import 'package:flutter_getx_boilerplate/models/request/consultation_request.dart';
import 'package:get/get.dart';

class VaccineConsultationController
    extends BaseController<VaccineConsultationRepository> {
  VaccineConsultationController(super.repository);

  final TextEditingController messageController = TextEditingController();
  final RxList<Map<String, String>> chatMessages = <Map<String, String>>[].obs;
  var consultResponse = ''.obs;

  void sendMessage() {
    final query = messageController.text.trim();
    if (query.isNotEmpty) {
      chatMessages.add({'sender': 'user', 'text': query});
      messageController.clear();
      sendChatMessage(query);
    }
  }

  Future<void> sendChatMessage(String query) async {
    try {
      setLoading(true);
      final response = await repository.chat(query);
      chatMessages.add({'sender': 'ai', 'text': response});
    } catch (e) {
      showError('Error', 'Failed to get chat response');
      chatMessages.add(
          {'sender': 'ai', 'text': 'Sorry, I couldn\'t process your message.'});
    } finally {
      setLoading(false);
    }
  }

  Future<void> sendConsultationRequest(ConsultationRequest request) async {
    try {
      setLoading(true);
      final response = await repository.consult(request);
      consultResponse.value = response;
    } catch (e) {
      showError('Error', 'Failed to get consultation response');
    } finally {
      setLoading(false);
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
