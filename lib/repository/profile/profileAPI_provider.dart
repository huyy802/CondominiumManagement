import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:untitled/repository/base/base_provider.dart';
import 'package:untitled/repository/profile/profile_repository.dart';
import 'package:untitled/src/models/user.dart';

class ProfilePro extends BaseProvider<ProfileRepository> {
  @override
  ProfileRepository initRepository() {
    return ProfileRepository();
  }

  Future changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final res = await repository.changePassword(
        currentPassword: currentPassword, newPassword: newPassword);

    return res.data['success'];
  }

  Future getProfilePictureAPIProvider() async {
    final res = await repository.getProfilePictureAPIRepository();
    String resBody = res.toString();
    var jsonData = jsonDecode(resBody);
    return jsonData['result'];
  }

  Future getCurrentUserProfileAPIProvider() async {
    final res = await repository.getCurrentUserProfileAPIRepository();

    return res.data;
  }

  Future updateProfilePictureAPIProvider(String imageUrl) async {
    final res = await repository.updateProfilePictureAPIRepository(imageUrl);
    return res.data;
  }

  Future sendOTPToChangeEmailAPIProvider(String email) async {
    final res = await repository.sendOTPToChangeEmailAPIRepository(email);
    print("kq ne:");
    print(res.data);
    return res.data['success'];
  }

  Future changePhoneNumberAPIProvider(
      MDUser? mdUser, String phoneNumber) async {
    final res =
        await repository.changePhoneNumberAPIRepository(mdUser, phoneNumber);
    print("kq neee:");
    print(res.data['success']);
    return res.data['success'];
  }

  Future changeEmailAPIProvider(MDUser? mdUser, String email) async {
    final res = await repository.changeEmailAPIRepository(mdUser, email);
    print("kq neee:");
    print(res.data);
    print(res.data['success']);
    return res.data['success'];
  }

  Future checkOTPAPIProvider(String otp, String email) async {
    final res = await repository.checkOTPAPIRepository(otp, email);
    print("kq neee:");
    print("check otp co thanh cong:");
    print(res.data);
    return res.data['result'];
  }
}
