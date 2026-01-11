import 'package:flutter_getx_boilerplate/modules/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/vaccine_info_repository.dart';
import 'package:get/get.dart';

class VaccineInfoController extends BaseController<VaccineInfoRepository> {
  VaccineInfoController(super.repository);

  // Observable list of vaccine data
  final vaccines = <Map<String, dynamic>>[].obs;

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVaccineData();
  }

  // Fake data fetch
  void fetchVaccineData() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1)); // simulate API delay

    vaccines.value = [
      {
        "name": "Pfizer-BioNTech",
        "manufacturer": "Pfizer, Inc.",
        "lotNumber": "AB1234",
        "expiryDate": "2025-12-31",
        "ingredients": "mRNA, Lipid nanoparticles, Salts, Sugars",
        "origin": "USA",
        "blockchainTrace":
            "Manufactured in USA → Shipped to Vietnam → Distributed to Centers"
      },
      {
        "name": "Moderna",
        "manufacturer": "Moderna, Inc.",
        "lotNumber": "CD5678",
        "expiryDate": "2025-08-15",
        "ingredients": "mRNA, Lipid nanoparticles, Tromethamine, Acetic acid",
        "origin": "USA",
        "blockchainTrace":
            "Manufactured in USA → Shipped to Singapore → Distributed to Centers"
      },
      {
        "name": "AstraZeneca",
        "manufacturer": "AstraZeneca plc",
        "lotNumber": "EF9101",
        "expiryDate": "2026-02-28",
        "ingredients": "Adenovirus vector, L-Histidine, Ethanol, Sucrose",
        "origin": "UK",
        "blockchainTrace":
            "Manufactured in UK → Shipped to Thailand → Distributed to Centers"
      }
    ];

    isLoading.value = false;
  }
}
