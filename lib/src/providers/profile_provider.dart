import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/src/models/user.dart';
import '../../repository/profile/profileAPI_provider.dart';
import '../../utils/helper/app_preference.dart';
import '../../utils/helper/show_snack_bar.dart';
import '../screens/change phone number screen/widgets/change_phone_number_successful_dialog.dart';

class ProfileProvider extends ChangeNotifier {
  var reponse;
  bool _isSent = false;
  bool get isSent => _isSent;
  void setIsSent(bool isSent) {
    _isSent = isSent;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  bool _changePhoneFail = false;
  bool get changePhoneFail => _changePhoneFail;
  void setChangePhoneFail(bool changePhoneFail) {
    _changePhoneFail = changePhoneFail;
    notifyListeners();
  }

  String? _profilePicture;
  String? get profilePicture => _profilePicture;
  void setProfilePicture(String urlImage) {
    _profilePicture = urlImage;
    notifyListeners();
  }

  MDUser _mdUser = MDUser(
    name: "",
    surname: "",
    userName: "",
    email: "",
    password: "",
    gender: "",
    idNumber: "",
    fullName: "",
    birthDate: "",
    apartmentId: "",
    otp: "",
  );

  MDUser get mdUser => _mdUser;
  void setMdUser(MDUser mdUser) {
    _mdUser = mdUser;
    notifyListeners();
  }

  void setEmptyUser() {
    _mdUser = MDUser(
        name: "",
        surname: "",
        email: "",
        password: "",
        gender: "",
        idNumber: "",
        fullName: "",
        birthDate: "",
        apartmentId: "",
        otp: "");
    _profilePicture = null;
    notifyListeners();
  }

  Future changePassword(BuildContext context, String? newPassword,
      String? newPassword1, String? curentPassword) async {
    String? password = AppPreferences.prefs.getString('password');
    // ki???m tra 2 m???t kh???u m??i h???p l???
    if (newPassword == newPassword1) {
      // ki???m tra nh???p ????ng m???t kh???u hi???n t???i
      if (password == curentPassword) {
        reponse = await ProfilePro().changePassword(
            currentPassword: curentPassword!, newPassword: newPassword!);
        AppPreferences.prefs.setString('password', newPassword);
        reponse == true
            ? ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('C???p nh???t th??nh c??ng')))
            : ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('C???p nh???t th???t b???i')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sai m???t kh???u hi???n t???i')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('M???t kh???u m???i kh??ng h???p l???')));
    }
  }

  Future<void> getCurrentUserProfile() async {
    var response = await ProfilePro().getCurrentUserProfileAPIProvider();
    print(response['result']);
    MDUser user = MDUser.fromMap(response['result']);
    setMdUser(user); // notifyListeners();
  }

  Future<void> getProfilePicture() async {
    var urlImage = await ProfilePro().getProfilePictureAPIProvider();
    print('url image: $urlImage');
    setProfilePicture(urlImage);
  }

  Future sendOTPToChangeEmail(String email, BuildContext context) async {
    print('111');
    var success = await ProfilePro().sendOTPToChangeEmailAPIProvider(email);
    if (success == true) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('G???i OTP th???t b???i, ki???m tra l???i th??ng tin')));
    }
  }

  void showSuccessfulDialog(BuildContext context) => showDialog(
        context: context,
        builder: ((context) => (SuccessfulDialog())),
      );

  Future changePhoneNumber(BuildContext context, MDUser? mdUser,
      String phoneNumber, String otp) async {
    SharedPreferences pref;
    setIsLoading(true);
    print("vao 2");
    var success =
        await ProfilePro().changePhoneNumberAPIProvider(mdUser, phoneNumber);
    pref = await SharedPreferences.getInstance();

    if (success == true) {
      mdUser!.phoneNumber = phoneNumber;
      setMdUser(mdUser);

      setIsLoading(false);
      // pop context
      Navigator.of(context).pop();
    } else if (success == false) {
      setChangePhoneFail(true);
      setIsLoading(false);

      print("3");

      print(pref.getBool("isValidOTP"));
      print('change failed');
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('C???p nh???t th???t b???i, ki???m tra l???i th??ng tin')));
    }
  }

  Future checkOTP(
      BuildContext context, String otp, MDUser mdUser, String email) async {
    setIsLoading(true);

    var result = await ProfilePro().checkOTPAPIProvider(otp, email);

    if (result["isCorrect"] == true) {
      print("dc 1");
      setIsValidOTP(true);
      var successChangeEmail =
          await ProfilePro().changeEmailAPIProvider(mdUser, email);
      if (successChangeEmail == true) {
        print("dc 2");

        setNewEmail(email);
        Navigator.of(context)
          ..pop()
          ..pop();
        showSnackBar(context, "C???p nh???t th??nh c??ng");
      } else {
        showSnackBar(context, "C???p nh???t th???t b???i");
      }
    } else {
      setIsValidOTP(false);
    }
    setIsLoading(false);
  }

  void setNewEmail(String email) {
    _mdUser.email = email;
    notifyListeners();
  }

  String _verificationId = '';
  bool _isValidOTPProvider = true;
  bool get isValidOTPProvider => _isValidOTPProvider;
  void setIsValidOTP(bool isValidOTP) {
    _isValidOTPProvider = isValidOTP;
    notifyListeners();
  }

  // send otp from firebase to phonenumber
  Future<void> sendOTPToPhoneNumber(
      BuildContext context, String phoneNumber) async {
    setIsLoading(true);
    print('+84 ${phoneNumber.substring(1)}');
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: '+84 ${phoneNumber.substring(1)}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        showSnackBar(context, e.toString());
      },
      codeSent: (verificationId, _) async {
        _verificationId = verificationId;
        _isSent = true;
        print("da gui otp");
        // show snack bar
        showSnackBar(context, '???? g???i OTP ?????n s??? ??i???n tho???i b???n mu???n ?????i');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    setIsLoading(false);
  }

  void setNewPhoneNumber(String phoneNumber) {
    _mdUser.phoneNumber = phoneNumber;
    notifyListeners();
  }

  // verify otp
  Future<void> verifyOTP(BuildContext context, String otp, String phoneNumber,
      MDUser mdUser) async {
    try {
      setIsLoading(true);

      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationId, smsCode: otp))
          .then((value) async {
        // on error
        if (value.user != null) {
          // show snack bar

          setIsValidOTP(true);
          print("sdt ne");
          print(phoneNumber);
          var successChange = await ProfilePro()
              .changePhoneNumberAPIProvider(mdUser, phoneNumber);
          if (successChange == true) {
            setNewPhoneNumber(phoneNumber);
            showSnackBar(context, 'Th??nh c??ng');
          } else if (successChange == false) {
            setNewPhoneNumber(phoneNumber);
            showSnackBar(context, 'Vui l??ng th??? l???i sau');
          }
          Navigator.of(context)
            ..pop()
            ..pop();
        }
      }).catchError(
        (e) {
          setIsValidOTP(false);
          setIsLoading(false);
          // show snack bar
          showSnackBar(
              context, 'X??c th???c OTP th???t b???i, vui l??ng ki???m tra l???i OTP');
        },
      );
      setIsLoading(false);
    } catch (e) {
      // show snack bar
      showSnackBar(context, 'C?? l???i x???y ra, vui l??ng th??? l???i sau');

      setIsValidOTP(false);
      setIsLoading(false);
    }
  }
}
