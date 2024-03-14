// import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:visionguard/pages/info.dart';
import 'dart:convert';

class InfoController extends GetxController {
  Rx<List<String>> results = Rx<List<String>>([]);
  late String result;
  var image = null;
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
  }

  addResult(Map<String, dynamic> resultMap) {
    image = null;
    print('*Running addResult rn');
    List<dynamic> resultList = resultMap['msgs'];
    for (dynamic element in resultList) {
      // Add each element to the results list
      var s = element.toString();
      print(s.substring(0, 3));
      if (['Top', 'Rig', 'Bot', 'Lef', 'Tar', 'No ', 'Ful']
          .contains(s.substring(0, 3))) {
        results.value.add(s);
      } else {
        // image = Image.memory(base64Decode(element));
        print('*Attempting decoding');
        // element = element.replaceAll(RegExp(r'\s', ''));
        image = Image.memory(
          base64.decode(element.replaceAll(RegExp(r'\s+'), '')),
        );
      }
      // results.value.add(result);
      itemCount.value = results.value.length;
    }
  }
}
