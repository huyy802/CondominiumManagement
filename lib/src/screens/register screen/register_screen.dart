import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/src/models/user.dart';
import 'package:untitled/src/providers/register_provider.dart';
import 'package:intl/intl.dart';
import 'package:untitled/src/screens/register%20screen/confirm_register_screen.dart';
import 'dart:io';
import '../../../utils/app_constant/app_colors.dart';
import '../../widget/register_textfield.dart';

const List<String> genderList = <String>['Nam', 'Nữ', 'Khác'];

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RegisterProvider? provider;
  String? password;
  String dropdownValue = genderList.first;
  File? avatar;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()));

  @override
  void initState() {
    super.initState();
    provider = Provider.of<RegisterProvider>(context, listen: false);
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        dropdownValue = selectedValue;
      });
    }
  }

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      //Crop image
      File? tempImage = File(image.path);
      tempImage = await cropImage(imageFile: tempImage);

      setState(() {
        avatar = tempImage;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 105, ratioY: 106));
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      color: AppColors.White,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 44,
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned(
                          child: Text('ĐĂNG KÝ',
                              style: TextStyle(
                                  fontSize: 31,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: const Offset(0, 4),
                                        blurRadius: 4)
                                  ],
                                  foreground: Paint()
                                    ..shader = const LinearGradient(
                                      colors: <Color>[
                                        Color.fromRGBO(0, 28, 68, 1),
                                        Color.fromRGBO(0, 28, 68, 0.76)
                                      ],
                                    ).createShader(const Rect.fromLTWH(
                                        0.0, 0.0, 114.0, 37.0)))),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(
                              height: 23,
                            ),
                            Image.asset(
                              'assets/register_logo.png',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: RegisterTextField(
                              labelText: 'Email',
                              type: TextFieldType.email,
                              controller: emailController,
                              validator: (value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return 'Vui lòng nhập email';
                                  }
                                  String pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@gmail.com$';
                                  RegExp regExp = RegExp(pattern);
                                  return regExp.hasMatch(value)
                                      ? null
                                      : 'Email phải ở dạng @gmail.com';
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.56)),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: const Offset(0, 4),
                                        blurRadius: 4)
                                  ]),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors.white,
                                ),
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButtonFormField(
                                    borderRadius: BorderRadius.circular(25),
                                    value: dropdownValue,
                                    iconSize: 0,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: Image.asset(
                                        'assets/dropdown.png',
                                        width: 7.18,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          top: 10.5, bottom: 10.5, left: 2),
                                      label: const Padding(
                                        padding: EdgeInsets.only(left: 22),
                                        child: Text('Giới tính'),
                                      ),
                                      labelStyle: const TextStyle(
                                          color: Color.fromRGBO(99, 99, 99, 1),
                                          fontSize: 12),
                                    ),
                                    items: genderList
                                        .map<DropdownMenuItem<String>>(
                                            (value) => DropdownMenuItem(
                                                  child: Text(
                                                    value,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                  value: value,
                                                ))
                                        .toList(),
                                    onChanged: dropdownCallback,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    RegisterTextField(
                        labelText: 'Nhập mật khẩu',
                        type: TextFieldType.password,
                        controller: passwordController,
                        maxLength: 20,
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return 'Vui lòng nhập mật khẩu';
                            }
                            if (value.length < 6) {
                              return 'Tối thiểu 6 ký tự';
                            }
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 22,
                    ),
                    RegisterTextField(
                      labelText: 'Nhập lại mật khẩu',
                      type: TextFieldType.password,
                      controller: confirmPasswordController,
                      autovalidateMode: AutovalidateMode.disabled,
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'Vui lòng xác nhận mật khẩu';
                          }
                          if (value != passwordController.text) {
                            return 'Mật khẩu không trùng khớp';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    RegisterTextField(
                      labelText: 'Nhập Họ và Tên',
                      type: TextFieldType.name,
                      controller: nameController,
                      maxLength: 50,
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'Vui lòng nhập họ tên';
                          }
                          RegExp exp = RegExp(r"[^a-z ]", caseSensitive: false);
                          if (exp.allMatches(value).isNotEmpty) {
                            return 'Chỉ được bao gồm ký tự chữ';
                          } else if (value.split(' ').length < 2) {
                            return 'Tối thiểu 2 từ đơn';
                          }
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RegisterTextField(
                            labelText: 'Ngày sinh',
                            type: TextFieldType.date,
                            controller: dateController,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: RegisterTextField(
                            labelText: 'Số CCCD/CMND',
                            type: TextFieldType.number,
                            maxLength: 12,
                            autovalidateMode: AutovalidateMode.disabled,
                            validator: (value) {
                              if (value != null) {
                                if (value.isNotEmpty &&
                                    (value.length != 9 && value.length != 12)) {
                                  return 'Giá trị không hợp lệ.';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Stack(alignment: Alignment.center, children: [
                      Column(
                        children: [
                          const SizedBox(height: 2),
                          Image.asset('assets/register_avatar.png'),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => pickImage(),
                        child: Container(
                          width: 105,
                          height: 106,
                          color: Colors.white,
                          child: avatar != null
                              ? Image.file(avatar!)
                              : const Center(
                                  child: Text(
                                  'Bấm để chọn ảnh đại diện',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8,
                                      color: Color(0xff636363)),
                                )),
                        ),
                      )
                    ]),
                    const SizedBox(
                      height: 22,
                    )
                  ],
                ),
              ),
              Stack(alignment: Alignment.topCenter, children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/clouds.png',
                          fit: BoxFit.fitWidth,
                        )),
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        String password = passwordController.text;
                        var splittedName = nameController.text.split(' ');
                        String name = splittedName.removeLast();
                        String surname = splittedName.join('');
                        String email = emailController.text;
                        MDUser mdUser = MDUser(
                            name: name,
                            surname: surname,
                            email: email,
                            password: password);
                        //provider!.register(mdUser, context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => ConfirmRegisterScreen(
                                  mdUser: mdUser,
                                ))));
                      }
                    },
                    child: Image.asset('assets/register_otp_button.png'))
              ])
            ],
          ),
        ),
      ),
    )));
  }
}
