class UserProfileModel {
  final String uuid;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? nationality;
  final String? gender;
  final String? religiousOrientation;
  final String? sexualPreference;
  final List<String>? disabilities;
  final bool isOnboarded;

  UserProfileModel({
    required this.uuid,
    required this.email,
    this.name,
    this.phoneNumber,
    this.nationality,
    this.gender,
    this.religiousOrientation,
    this.sexualPreference,
    this.disabilities,
    this.isOnboarded = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'nationality': nationality,
      'gender': gender,
      'religiousOrientation': religiousOrientation,
      'sexualPreference': sexualPreference,
      'disabilities': disabilities,
      'isOnboarded': isOnboarded,
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      uuid: json['uuid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      nationality: json['nationality'],
      gender: json['gender'],
      religiousOrientation: json['religiousOrientation'],
      sexualPreference: json['sexualPreference'],
      disabilities: json['disabilities'] != null 
          ? List<String>.from(json['disabilities']) 
          : null,
      isOnboarded: json['isOnboarded'] ?? false,
    );
  }
}
