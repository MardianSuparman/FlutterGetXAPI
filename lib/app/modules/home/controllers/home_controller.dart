import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/app/modules/dashboard/views/dashboard_view.dart';
import 'package:myapp/app/modules/login/views/login_view.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  late Timer _pindah;

  final authToken = GetStorage();

  @override
  void onInit() {
    _pindah = Timer.periodic(
      const Duration(seconds: 4),
      (timer) => authToken.read('token') == null
          ? Get.off(
              () => const LoginView(),
              transition: Transition.leftToRight,
            )
          : Get.off(() => const DashboardView()),
    );

    super.onInit();
  }


  @override
  void onClose() {
    super.onClose();

    _pindah.cancel();
  }
}
