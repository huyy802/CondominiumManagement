import 'dart:convert';

class MDUser {
  String name;
  String surname;
  String? userName;
  String email;
  String? password;
  String gender;
  String idNumber;
  String? fullName;
  String birthDate;
  String? phoneNumber;
  String? buildingId;
  String? apartmentId;
  String? otp;

  MDUser(
      {required this.name,
      this.userName,
      required this.surname,
      required this.email,
      required this.password,
      required this.gender,
      required this.idNumber,
      this.buildingId,
      this.fullName,
      required this.birthDate,
      this.phoneNumber,
      this.apartmentId,
      this.otp});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "surname": surname,
      "userName": userName,
      "emailAddress": email,
      "password": password,
      "gender": gender,
      "idNumber": idNumber,
      "fullName": fullName,
      "birthDate": birthDate,
      "buildingId": buildingId,
      "apartmentId": apartmentId,
      "otp": otp,
    };
  }

  factory MDUser.fromMap(Map<String, dynamic> map) {
    return MDUser(
      name: map['name'],
      surname: map['surname'],
      userName: map['userName']?.toString(),
      email: map['emailAddress'],
      password: map['password']?.toString(),
      gender: map['gender'],
      idNumber: map['idNumber'],
      fullName: map['fullName']?.toString(),
      birthDate: map['birthDate'],
      phoneNumber: map['phoneNumber']?.toString(),
      buildingId: map['buildingId']?.toString(),
      apartmentId: map['apartmentId']?.toString(),
      otp: map['otp']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MDUser.fromJson(String source) => MDUser.fromMap(json.decode(source));
}
