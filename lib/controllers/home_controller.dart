import 'dart:developer';

import 'package:e_commerce_app/consts/consts.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    getUserName();
    super.onInit();
  }
  var currentNavIndex = 0.obs;
  var userName = '';
  var featuredList = [];
  var searchController = TextEditingController();

  getUserName() async {
    var nResult = await firestore.collection(usersCollection).where('id', isEqualTo: currentUser!.uid).get().then((value) {
      if(value.docs.isNotEmpty){
        return value.docs.single['name'];
      }
    });
    userName = nResult;
  }
}