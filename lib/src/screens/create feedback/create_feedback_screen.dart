import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/src/models/feedback.dart' as fb;
import 'package:untitled/src/providers/feedback_provider.dart';
import 'package:untitled/src/providers/profile_provider.dart';
import 'package:untitled/src/screens/create%20feedback/widgets/feedback_input.dart';
import 'package:untitled/src/screens/create%20feedback/widgets/feedback_type_widget.dart';
import 'package:untitled/utils/app_constant/app_colors.dart';
import 'package:untitled/utils/app_constant/app_text_style.dart';
import 'package:untitled/utils/helper/show_snack_bar.dart';
import 'package:untitled/utils/helper/storage_methods.dart';
import 'package:untitled/utils/helper/string_extensions.dart';

class CreateFeedbackScreen extends StatefulWidget {
  const CreateFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<CreateFeedbackScreen> createState() => _CreateFeedbackScreenState();
}

int _selectedIndex = 1;

class _CreateFeedbackScreenState extends State<CreateFeedbackScreen> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool? isEmptyTitle, isEmptyContent;
  XFile? _imageFile;
  String? _imageUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void validateInput() {
    if (_titleController.text.trim().isEmpty) {
      setState(() {
        isEmptyTitle = true;
      });
    } else {
      setState(() {
        isEmptyTitle = false;
      });
    }
    if (_contentController.text.trim().isEmpty) {
      setState(() {
        isEmptyContent = true;
      });
    } else {
      setState(() {
        isEmptyContent = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final feedbackProvider = context.watch<FeedbackProvider>();
    print('isLoading: $isLoading');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDB2F68),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.White,
          ),
        ),
        title: const Text(
          'T???o ?? ki???n',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFCF6F6),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Lo???i ?? ki???n",
                  style: AppTextStyle.lato.copyWith(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: FeedBackType(
                        title: "L???i/s??? c???",
                        colorOntap: const Color(0xFFDB2F68),
                        selectedIndex: _selectedIndex,
                        index: 1,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                      child: FeedBackType(
                        title: "Ph??n n??n",
                        colorOntap: const Color(0xFFDB2F68),
                        selectedIndex: _selectedIndex,
                        index: 2,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                      },
                      child: FeedBackType(
                        title: "Th???c m???c",
                        colorOntap: const Color(0xFFDB2F68),
                        selectedIndex: _selectedIndex,
                        index: 3,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Ti??u ?????",
                    style: AppTextStyle.lato.copyWith(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                FeedbackInput(
                  height: height,
                  width: width,
                  hintText: "Nh???p ti??u ?????",
                  maxLength: 100,
                  controller: _titleController,
                  isError: isEmptyTitle,
                ),
                SizedBox(height: height * 0.01),
                if (isEmptyTitle == true)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Vui l??ng nh???p ti??u ?????",
                      style: AppTextStyle.lato.copyWith(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                SizedBox(height: height * 0.005),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "N???i dung",
                    style: AppTextStyle.lato.copyWith(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                FeedbackInput(
                  height: height,
                  width: width,
                  hintText: "Nh???p n???i dung",
                  maxLength: 300,
                  controller: _contentController,
                  isError: isEmptyContent,
                ),
                SizedBox(height: height * 0.01),
                if (isEmptyContent == true)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Vui l??ng nh???p n???i dung",
                      style: AppTextStyle.lato.copyWith(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                SizedBox(height: height * 0.01),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "H??nh ???nh ????nh k??m",
                    style: AppTextStyle.lato.copyWith(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Container(
                  height: height * 0.2,
                  width: width * 0.9,
                  decoration: const BoxDecoration(
                    color: AppColors.White,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        offset: Offset(0, 2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: _showModalBottomSheet,
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(
                                _imageFile!.path,
                              ),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset('assets/add_image.png'),
                  ),
                ),
                SizedBox(height: height * 0.02),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFDB2F68),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDB2F68),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () async {
                          // setState(() {
                          //   isLoading = true;
                          // });
                          final user = context.read<ProfileProvider>().mdUser;
                          validateInput();
                          if (isEmptyContent != null &&
                              isEmptyContent != true &&
                              isEmptyTitle != null &&
                              isEmptyTitle != true) {
                            // print feedback data

                            fb.Feedback feedback = fb.Feedback(
                              email: user.email,
                              time: DateTime.now().toIso8601String(),
                              image: _imageUrl,
                              type: _selectedIndex == 1
                                  ? "L???i/s??? c???"
                                  : _selectedIndex == 2
                                      ? "Ph??n n??n"
                                      : "Th???c m???c",
                              title: _titleController.text.standardlizeString(),
                              status: "Ch??a ph???n h???i",
                              content:
                                  _contentController.text.standardlizeString(),
                              respond: "",
                            );

                            feedbackProvider.createFeedback(context, feedback);
                            Navigator.pop(context);
                            showSnackBar(
                              context,
                              "???? g???i ?? ki???n!",
                            );
                          }
                        },
                        child: Center(
                          child: Text(
                            'G???i ?????n Ban qu???n l??',
                            style: AppTextStyle.lato.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (builder) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;
        return Container(
          height: height * 0.197,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: height * 0.065,
                width: width,
                decoration: const BoxDecoration(
                  color: AppColors.White,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Ch???n ph????ng th???c",
                    style: AppTextStyle.lato
                        .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.001,
              ),
              Container(
                height: height * 0.065,
                width: width,
                decoration: const BoxDecoration(
                  color: AppColors.White,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 0.1),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 29,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Ch???p ???nh",
                            style: AppTextStyle.lato.copyWith(
                              fontSize: 16,
                              color: const Color(0xFFFE2C6B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      takePhoto(ImageSource.camera);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.001,
              ),
              Container(
                height: height * 0.065,
                width: width,
                decoration: const BoxDecoration(
                  color: AppColors.White,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 0.1),
                            child: const ImageIcon(
                              AssetImage('assets/galery-icon.png'),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Ch???n t??? th?? vi???n ???nh",
                            style: AppTextStyle.lato.copyWith(
                              fontSize: 16,
                              color: const Color(0xFFFE2C6B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      takePhoto(ImageSource.gallery);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void takePhoto(ImageSource source) async {
    final user = context.read<ProfileProvider>().mdUser;
    final _pickedFile = await _picker.pickImage(source: source);
    if (_pickedFile != null) {
      final _image = File(_pickedFile!.path);
      Uint8List feedbackImg = await _image.readAsBytes();
      String imageUrl = await StorageMethods()
          .uploadImageToStorage('feedbacks', feedbackImg, true, user.idNumber);
      print(imageUrl);
      setState(() {
        _imageFile = _pickedFile;
        _imageUrl = imageUrl;
      });
    }

    Navigator.pop(context);
  }
}
