import 'package:get/get.dart';

class MyDropdownController extends GetxController {
  var selectedValue = ''.obs;
  final items = ['Item 1', 'Item 2', 'Item 3'].obs;

  void onChanged(String? newValue) {
    selectedValue.value = newValue!;
  }
}