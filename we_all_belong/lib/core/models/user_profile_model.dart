import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String? uuid;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String? nationality;
  final String? gender;
  final String? pronouns;
  final String? religiousOrientation;
  final String? sexualPreference;
  final List<String>? disabilities;
  final bool isOnboarded;
  final String? bio;
  final int? age;
  final bool? isVegan;
  final bool? isHalal;
  final bool? isKosher;

  UserProfileModel({
    required this.uuid,
    required this.email,
    this.name,
    this.phoneNumber,
    this.nationality,
    this.gender,
    this.pronouns,
    this.religiousOrientation,
    this.sexualPreference,
    this.disabilities,
    this.isOnboarded = false,
    this.bio,
    this.age,
    this.isVegan = false,
    this.isHalal = false,
    this.isKosher = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'nationality': nationality,
      'gender': gender,
      'pronouns': pronouns,
      'religiousOrientation': religiousOrientation,
      'sexualPreference': sexualPreference,
      'disabilities': disabilities,
      'isOnboarded': isOnboarded,
      'bio': bio,
      'age': age,
      'isVegan': isVegan,
      'isHalal': isHalal,
      'isKosher': isKosher,
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
      pronouns: json['pronouns'],
      religiousOrientation: json['religiousOrientation'],
      sexualPreference: json['sexualPreference'],
      disabilities: json['disabilities'] != null
          ? List<String>.from(json['disabilities'])
          : null,
      isOnboarded: json['isOnboarded'] ?? false,
      bio: json['bio'],
      age: json['age'],
      isVegan: json['isVegan'] ?? false,
      isHalal: json['isHalal'] ?? false,
      isKosher: json['isKosher'] ?? false,
    );
  }
  factory UserProfileModel.fromFirebase(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return UserProfileModel(
      uuid: data?['uuid'] ?? '',
      email: data?['email'] ?? '',
      name: data?['name'],
      phoneNumber: data?['phoneNumber'],
      nationality: data?['nationality'],
      gender: data?['gender'],
      pronouns: data?['pronouns'],
      religiousOrientation: data?['religiousOrientation'],
      sexualPreference: data?['sexualPreference'],
      disabilities: data?['disabilities'] != null
          ? List<String>.from(data!['disabilities'])
          : null,
      isOnboarded: data?['isOnboarded'] ?? false,
      bio: data?['bio'],
      age: data?['age'],
      isVegan: data?['isVegan'] ?? false,
      isHalal: data?['isHalal'] ?? false,
      isKosher: data?['isKosher'] ?? false,
    );
  }
}
