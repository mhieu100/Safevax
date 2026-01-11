class HealthcareFacility {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String hours;
  final String image;
  final int capacity;
  final double distance; // in km
  final double rating;
  double? latitude;
  double? longitude;
  HealthcareFacility({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.hours,
    required this.image,
    required this.capacity,
    this.distance = 0,
    this.rating = 0,
    this.latitude,
    this.longitude,
  });

  factory HealthcareFacility.fromJson(Map<String, dynamic> json) {
    return HealthcareFacility(
      id: json['centerId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phone: json['phoneNumber']?.toString() ?? '',
      hours: json['workingHours']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      capacity: (json['capacity'] is int ? json['capacity'] : 0),
      distance: (json['distance'] is num ? json['distance'].toDouble() : 0.0),
      rating: (json['rating'] is num ? json['rating'].toDouble() : 0.0),
      latitude: (json['latitude'] is num ? json['latitude'].toDouble() : null),
      longitude:
          (json['longitude'] is num ? json['longitude'].toDouble() : null),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'centerId': id,
      'name': name,
      'address': address,
      'phoneNumber': phone,
      'workingHours': hours,
      'image': image,
      'capacity': capacity,
      'distance': distance,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
