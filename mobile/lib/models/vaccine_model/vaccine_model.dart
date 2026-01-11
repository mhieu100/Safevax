import 'package:flutter_getx_boilerplate/models/vaccine_model/healthcare_facility_model.dart';
import 'package:flutter_getx_boilerplate/models/vaccine_model/vaccine_schedule.dart';

class VaccineModel {
  final String id;
  final String name;
  final String country;
  final String descriptionShort;
  final int dosesRequired;
  final String manufacturer;
  final int duration;
  final double rating;
  final String description;
  final List<String> prevention;
  final int numberOfDoses;
  final String recommendedAge;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final int stock;
  final List<String> sideEffects;
  final List<VaccineSchedule> schedule;
  final List<HealthcareFacility> availableFacilities;
  final List<Duration> doseIntervals;

  VaccineModel({
    required this.id,
    required this.name,
    this.country = '',
    this.descriptionShort = '',
    this.dosesRequired = 1,
    this.manufacturer = '',
    this.duration = 0,
    this.rating = 0.0,
    required this.description,
    required this.prevention,
    this.numberOfDoses = 1,
    required this.recommendedAge,
    required this.price,
    this.originalPrice,
    this.imageUrl = '',
    this.stock = 0,
    this.sideEffects = const [],
    this.schedule = const [],
    this.availableFacilities = const [],
    this.doseIntervals = const [],
  });

  factory VaccineModel.fromJson(Map<String, dynamic> json) {
    // Parse dose intervals from JSON (assuming they're stored as seconds)
    List<Duration> parsedDoseIntervals = [];
    if (json['doseIntervals'] is List) {
      for (var interval in json['doseIntervals']) {
        if (interval is int) {
          parsedDoseIntervals.add(Duration(seconds: interval));
        }
      }
    }

    // If no intervals provided, use default based on numberOfDoses
    if (parsedDoseIntervals.isEmpty && json['numberOfDoses'] is int) {
      int doses = json['numberOfDoses'];
      if (doses > 1) {
        // Default intervals: 4 weeks between dose 1-2, 6 months between dose 2-3
        parsedDoseIntervals.add(const Duration(days: 28)); // 4 weeks
        if (doses > 2) {
          parsedDoseIntervals.add(const Duration(days: 180)); // 6 months
        }
        // Add more defaults for additional doses if needed
      }
    }

    // Handle both old and new API formats
    final id = json['id']?.toString() ?? '';
    final name = json['name']?.toString() ?? '';
    final country = json['country']?.toString() ?? '';
    final descriptionShort = json['descriptionShort']?.toString() ?? '';
    final dosesRequired =
        json['dosesRequired'] is int ? json['dosesRequired'] : 1;
    final manufacturer = json['manufacturer']?.toString() ?? '';
    final duration = json['duration'] is int ? json['duration'] : 0;
    final rating = json['rating'] is num ? json['rating'].toDouble() : 0.0;
    final description = json['description']?.toString() ??
        json['descriptionShort']?.toString() ??
        '';
    final numberOfDoses =
        json['numberOfDoses'] is int ? json['numberOfDoses'] : dosesRequired;
    final price = (json['price'] is num ? json['price'].toDouble() : 0.0);
    final prevention = json['prevention'] != null
        ? List<String>.from(json['prevention'].map((e) => e.toString()))
        : [];
    final recommendedAge = json['recommendedAge']?.toString() ?? '';
    final originalPrice =
        json['originalPrice'] is num ? json['originalPrice'].toDouble() : null;
    final imageUrl =
        json['imageUrl']?.toString() ?? json['image']?.toString() ?? '';
    final stock = json['stock'] is int
        ? json['stock']
        : (json['stock'] != null
            ? int.tryParse(json['stock'].toString()) ?? 20
            : 20);
    final sideEffects = json['sideEffects'] != null
        ? List<String>.from(json['sideEffects'].map((e) => e.toString()))
        : [];
    final schedule = (json['schedule'] as List<dynamic>?)?.map((item) {
          return VaccineSchedule.fromJson(item);
        }).toList() ??
        [];
    final availableFacilities =
        (json['availableFacilities'] as List<dynamic>?)?.map((item) {
              return HealthcareFacility.fromJson(item);
            }).toList() ??
            [];

    return VaccineModel(
      id: id,
      name: name,
      country: country,
      descriptionShort: descriptionShort,
      dosesRequired: dosesRequired,
      manufacturer: manufacturer,
      duration: duration,
      rating: rating,
      description: description,
      numberOfDoses: numberOfDoses,
      price: price,
      prevention: prevention.cast<String>(),
      recommendedAge: recommendedAge,
      originalPrice: originalPrice,
      imageUrl: imageUrl,
      stock: stock,
      sideEffects: sideEffects.cast<String>(),
      schedule: schedule,
      availableFacilities: availableFacilities,
      doseIntervals: parsedDoseIntervals,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'descriptionShort': descriptionShort,
      'dosesRequired': dosesRequired,
      'manufacturer': manufacturer,
      'duration': duration,
      'rating': rating,
      'description': description,
      'prevention': prevention,
      'numberOfDoses': numberOfDoses,
      'recommendedAge': recommendedAge,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'stock': stock,
      'sideEffects': sideEffects,
      'schedule': schedule.map((item) => item.toJson()).toList(),
      'availableFacilities':
          availableFacilities.map((facility) => facility.toJson()).toList(),
      'doseIntervals': doseIntervals.map((d) => d.inSeconds).toList(),
    };
  }

  // Method to calculate recommended dates for subsequent doses
  List<DateTime> calculateRecommendedSchedule(DateTime firstDoseDate) {
    List<DateTime> recommendedDates = [firstDoseDate];

    DateTime currentDate = firstDoseDate;
    for (var interval in doseIntervals) {
      currentDate = currentDate.add(interval);
      recommendedDates.add(currentDate);
    }

    // If we have fewer intervals than needed doses, fill with reasonable defaults
    while (recommendedDates.length < numberOfDoses) {
      // Default: 4 weeks for missing intervals
      currentDate = currentDate.add(const Duration(days: 28));
      recommendedDates.add(currentDate);
    }

    return recommendedDates;
  }

  // Method to get dose interval description
  String getDoseIntervalDescription(int doseNumber) {
    if (doseNumber <= 0 || doseNumber > doseIntervals.length) {
      return 'The interval information is not available';
    }

    Duration interval = doseIntervals[doseNumber - 1];

    if (interval.inDays >= 365) {
      int years = (interval.inDays / 365).floor();
      return '$years ${years > 1 ? 'years' : 'year'} after dose $doseNumber';
    } else if (interval.inDays >= 30) {
      int months = (interval.inDays / 30).floor();
      return '$months ${months > 1 ? 'months' : 'month'} after dose $doseNumber';
    } else if (interval.inDays >= 7) {
      int weeks = (interval.inDays / 7).floor();
      return '$weeks ${weeks > 1 ? 'weeks' : 'week'} after dose $doseNumber';
    } else {
      return '${interval.inDays} ${interval.inDays > 1 ? 'days' : 'day'} after dose $doseNumber';
    }
  }
}
