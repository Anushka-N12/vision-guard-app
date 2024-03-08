// import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class InfoController extends GetxController {
  Rx<List<String>> results = Rx<List<String>>([]);
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  late String result;
  var itemCount = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    nameTextEditingController.dispose();
    addressTextEditingController.dispose();
  }

  addResult(String result) {
    // employeeModel = EmployeeModel(name: name, address: address);
    // print("addResult is running");
    // print(results);
    const stars =
        "\n******************************************************************";
    results.value.add(result + stars);
    // print(results);
    itemCount.value = results.value.length;
  }
}
