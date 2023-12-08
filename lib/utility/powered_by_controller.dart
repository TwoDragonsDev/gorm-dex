import 'package:get/get.dart';

class PoweredByController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    goToSeries();
  }

  void goToSeries() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      Get.offNamed('/Series');
    });
  }
}
