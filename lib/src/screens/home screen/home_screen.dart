import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/repository/feedback/feedbackAPI_Provider.dart';
import 'package:untitled/src/models/apartment_service.dart';
import 'package:untitled/src/models/feedback.dart' as f;
import 'package:untitled/src/models/user_service.dart';
import 'package:untitled/src/providers/apartment_service_provider.dart';
import 'package:untitled/src/providers/bill_provider.dart';
import 'package:untitled/src/providers/feedback_provider.dart';
import 'package:untitled/src/providers/profile_provider.dart';
import 'package:untitled/src/providers/user_service_provider.dart';
import 'package:untitled/src/screens/home%20screen/widgets/home_item.dart';

import '../../../repository/service/serviceAPI_provider.dart';
import '../../../utils/app_constant/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int)? onTapTapped;
  const HomeScreen({Key? key, this.onTapTapped}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime now = DateTime.now();
  final formatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();

    getCurrentUserProfile();
    getProfilePicture();

    getUserFeedback();

    getServices();
    getUsingServices();
  }

  void getUserFeedback() async {
    final feedbackProvider = Provider.of<FeedbackProvider>(
      context,
      listen: false,
    );
    List<f.Feedback> feedbacks =
        await FeedbackAPIProvider().getUserFeedbackAPIProvider();
    feedbackProvider.setFeedbacks(feedbacks);
  }

  void getCurrentUserProfile() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    final billProvider = Provider.of<BillProvider>(
      context,
      listen: false,
    );
    profileProvider.getCurrentUserProfile();
    profileProvider.getProfilePicture();
    billProvider.getAllApartmentBill();
    billProvider.getAllServiceBill();
    billProvider.getTotalUnpaid();
  }

  void getProfilePicture() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    await profileProvider.getProfilePicture();
  }

  void getServices() async {
    final ServicePro servicePro = ServicePro();
    List<ApartmentService> services = await servicePro.getApartmentServices();
    context.read<ApartmentServiceProvider>().setListServices(services);
    print('services : $services');
  }

  void getUsingServices() async {
    final ServicePro servicePro = ServicePro();
    List<UserService> services = await servicePro.getUserServices();
    context.read<UserServiceProvider>().setListServices(services);
    print('services : $services');
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProfileProvider>(context);
    final bill = Provider.of<BillProvider>(context);
    if (user.mdUser.apartmentId == '') {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.DarkPink,
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/home-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 39),
                child: Column(children: [
                  RichText(
                    text: TextSpan(
                      text: 'Xin ch??o, ',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(
                            text: user.mdUser.surname + ' ' + user.mdUser.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  ((user.mdUser.apartmentId == null) ||
                          (user.mdUser.apartmentId!.split('.')[1].length <= 2))
                      ? const Text(
                          'Acc sai m?? c??n h???',
                          style: TextStyle(color: Colors.white),
                        )
                      : RichText(
                          text: TextSpan(
                            text: 'T??a ',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                            children: <TextSpan>[
                              TextSpan(
                                  text: user.mdUser.apartmentId?.split('.')[0],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: AppColors.DarkPink)),
                              const TextSpan(text: ' - T???ng '),
                              TextSpan(
                                  text: user.mdUser.apartmentId
                                      ?.split('.')[1]
                                      .substring(0, 2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: AppColors.DarkPink)),
                              const TextSpan(text: ' - C??n h??? '),
                              TextSpan(
                                  text: user.mdUser.apartmentId
                                      ?.split('.')[1]
                                      .substring(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: AppColors.DarkPink)),
                            ],
                          ),
                        ),
                  const SizedBox(
                    height: 14,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 14,
                      bottom: 12,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        const Text(
                          'C???n thanh to??n trong th??ng n??y',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: formatter
                                      .format(bill.totalUnpaid)
                                      .replaceAll(',', '.'),
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFD4A93A),
                                      shadows: [
                                        Shadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            offset: const Offset(0, 4),
                                            blurRadius: 4)
                                      ])),
                              const TextSpan(
                                  text: ' ??',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                          onPressed: () => widget.onTapTapped!(3),
                          child: const Text(
                            'Chi ti???t',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.DarkPink,
                              shadowColor: Colors.transparent,
                              fixedSize: const Size(198, 37),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)))),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 27),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 19),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        HomeItem(
                          title: 'Ban qu???n l??',
                          iconPath: 'assets/home_icons/office-building.svg',
                        ),
                        HomeItem(
                          title: 'B???ng tin',
                          iconPath: 'assets/home_icons/newspaper.svg',
                        ),
                        HomeItem(
                          title: 'N???i quy',
                          iconPath: 'assets/home_icons/rules.svg',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset('assets/banner.png')),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 11, horizontal: 38),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'C??c d???ch v??? ph??? bi???n',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 19),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        HomeItem(
                          title: '????ng k?? kh??ch',
                          iconPath: 'assets/home_icons/guest-list.svg',
                        ),
                        HomeItem(
                          title: 'Gi???t ???i',
                          iconPath: 'assets/home_icons/laundry-machine.svg',
                        ),
                        HomeItem(
                          title: 'G??p ??',
                          iconPath: 'assets/home_icons/feedback.svg',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 19),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        HomeItem(
                          title: '????ng k?? th??? xe',
                          iconPath: 'assets/home_icons/credit.svg',
                        ),
                        HomeItem(
                          title: '????ng k?? ph??ng gym',
                          iconPath: 'assets/home_icons/gym.svg',
                        ),
                        HomeItem(
                          title: '????ng k?? v??? sinh ph??ng',
                          iconPath: 'assets/home_icons/cleaning.svg',
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
    }
  }
}
