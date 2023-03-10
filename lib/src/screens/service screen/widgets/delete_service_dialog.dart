import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/repository/service/serviceAPI_provider.dart';
import 'package:untitled/src/models/user_service.dart';
import 'package:untitled/src/providers/feedback_provider.dart';
import 'package:untitled/src/providers/user_service_provider.dart';
import 'package:untitled/utils/app_constant/app_colors.dart';
import 'package:untitled/utils/helper/show_snack_bar.dart';

class DeleteServiceDialog extends StatefulWidget {
  UserService userService;
  int index;
  DeleteServiceDialog({
    Key? key,
    required this.userService,
    required this.index,
  }) : super(key: key);

  @override
  State<DeleteServiceDialog> createState() => _DeleteServiceDialogState();
}

class _DeleteServiceDialogState extends State<DeleteServiceDialog> {
  bool isDelete = false;

  @override
  Widget build(BuildContext context) {
    final feedbackProvider = Provider.of<FeedbackProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: const Color(0xFFFCF6F6),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      title: isDelete
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFE2C6B),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 17, left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Bạn có chắc chắn muốn\nhuỷ dịch vụ này không?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFE2C6B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: height * 0.023,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(
                            width * 0.28,
                            height * 0.035,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "HUỶ",
                            style: TextStyle(
                              color: AppColors.Black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isDelete = true;
                          });
                          await ServicePro().cancelService(widget.userService);
                          context
                              .read<UserServiceProvider>()
                              .cancelService(widget.index);
                          Navigator.pop(context, true);

                          setState(() {
                            isDelete = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDB2F68),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          fixedSize: const Size(120, 30),
                        ),
                        child: const Text(
                          "CHẮC CHẮN",
                          style:
                              TextStyle(color: AppColors.White, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
