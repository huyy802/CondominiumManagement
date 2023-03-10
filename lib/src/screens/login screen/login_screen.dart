// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:untitled/src/providers/login_provider.dart';
import 'package:untitled/src/screens/forget%20password%20screen/forget_password_screen.dart';
import 'package:untitled/src/screens/login%20screen/widget/custom_button.dart';
import 'package:untitled/src/screens/login%20screen/widget/custom_textfield.dart';
import 'package:untitled/src/screens/register%20screen/register_screen.dart';
import 'package:untitled/utils/helper/app_preference.dart';

import '../../../utils/app_constant/app_colors.dart';
import '../../../utils/helper/show_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool checkSave = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LoginProvider? loginProvider;
  @override
  void initState() {
    super.initState();
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    loginProvider!.checkSave();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.White,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Form(
            key: _formKey,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 35, vertical: height * 0.047),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/apato-logo-light-blue.png',
                      width: width * 0.34,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                            controller: emailController,
                            labelText: 'Email/ S??? ??i???n tho???i',
                            type: TextFieldType.email,
                            maxLength: 50,
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          CustomTextField(
                            controller: passwordController,
                            labelText: 'M???t kh???u',
                            type: TextFieldType.password,
                            maxLength: 20,
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          CustomButton(
                            label: '????ng nh???p',
                            onPressed: () {
                              setState(() {});
                              if (_formKey.currentState!.validate()) {
                                AppPreferences.prefs.setBool('save',
                                    checkSave); //l??u tr???ng th??i c???a n??t l??u th??ng tin

                                //Hi???n th??? tr???ng th??i loading
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.DarkPink,
                                        ),
                                      );
                                    });

                                loginProvider!.checkAccount(
                                    // ki???m tra ????ng nh???p
                                    emailController.text,
                                    passwordController.text,
                                    checkSave,
                                    context);
                              }
                            },
                          ),
                          SizedBox(height: height * 0.03),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) =>
                                      ForgetPasswordScreen())));
                            },
                            child: Text(
                              "Qu??n m???t kh???u?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ch??a c?? t??i kho???n? ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16),
                            ),
                            SizedBox(width: 7),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: ((context) => RegisterScreen())));
                              },
                              child: Text(
                                '????ng k??',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.DarkPink,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        const Text(
                          'Ho???c ti???p t???c v???i',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color(0xFF7D8387)),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () => showSnackBar(context,
                                    'Ch???c n??ng ??ang ???????c ph??t tri???n, vui l??ng truy c???p l???i sau!'),
                                child: SvgPicture.asset(
                                    'assets/facebook-btn.svg')),
                            SizedBox(
                              width: width * 0.07,
                            ),
                            InkWell(
                                onTap: () => showSnackBar(context,
                                    'Ch???c n??ng ??ang ???????c ph??t tri???n, vui l??ng truy c???p l???i sau!'),
                                child: SvgPicture.asset('assets/google.svg')),
                            SizedBox(
                              width: width * 0.07,
                            ),
                            InkWell(
                                onTap: () => showSnackBar(context,
                                    'Ch???c n??ng ??ang ???????c ph??t tri???n, vui l??ng truy c???p l???i sau!'),
                                child: SvgPicture.asset(
                                    'assets/apple.svg')), /*  */
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
