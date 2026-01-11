class FamilyMember {
  final int? id;
  final String name;
  final String relation;
  final String dob;
  final String nextVaccine;
  final String avatar;
  final String healthStatus;
  final String lastCheckup;
  final String? phone;
  final String? gender;
  final int? parentId;
  final String? identityNumber;

  FamilyMember({
    this.id,
    required this.name,
    required this.relation,
    required this.dob,
    required this.nextVaccine,
    required this.avatar,
    required this.healthStatus,
    required this.lastCheckup,
    this.phone,
    this.gender,
    this.parentId,
    this.identityNumber,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'],
      name: json['fullName'] ?? json['name'] ?? '',
      relation: json['relationship'] ?? json['relation'] ?? '',
      dob: json['dateOfBirth'] ?? json['dob'] ?? '',
      nextVaccine: json['nextVaccine'] ?? '',
      avatar:
          json['avatar'] ?? 'assets/images/circle_avatar.png', // Default avatar
      healthStatus: json['healthStatus'] ?? '',
      lastCheckup: json['lastCheckup'] ?? '',
      phone: json['phone'],
      gender: json['gender'],
      parentId: json['parentId'],
      identityNumber: json['identityNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': name,
      'relationship': relation,
      'dateOfBirth': dob,
      'nextVaccine': nextVaccine,
      'avatar': avatar,
      'healthStatus': healthStatus,
      'lastCheckup': lastCheckup,
      'phone': phone,
      'gender': gender,
      'parentId': parentId,
      'identityNumber': identityNumber,
    };
  }
}
