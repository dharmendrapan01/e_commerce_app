import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../consts/consts.dart';
import 'home_controller.dart';

class CartController extends GetxController {
  var totalP = 0.obs;

  // text controller for shipping details
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalCodeController = TextEditingController();
  var phoneController = TextEditingController();

  var paymentIndex = 0.obs;
  late dynamic productSnapshot;
  var products = [];
  var vendors = [];

  var placingOrder = false.obs;

  calculatePrice(price){
    totalP.value = 0;
    for(var i = 0; i < price.length; i++){
      totalP.value = totalP.value + int.parse(price[i]['tPrice'].toString());
    }
  }

  changePaymentIndex(index){
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placingOrder(true);
    await getProductDetails();
    await firestore.collection(ordersCollection).doc().set({
      "order_code": "233665488",
      "order_date": FieldValue.serverTimestamp(),
      "order_by": currentUser!.uid,
      "order_by_name": Get.find<HomeController>().userName,
      "order_by_email": currentUser!.email,
      "order_by_address": addressController.text,
      "order_by_state": stateController.text,
      "order_by_city": cityController.text,
      "order_by_phone": phoneController.text,
      "order_by_postalcode": postalCodeController.text,
      "shipping_method": "Home Delivery",
      "payment_method": orderPaymentMethod,
      "order_placed": true,
      "order_confirmed": false,
      "order_delivered": false,
      "order_on_delivery": false,
      "total_amount": totalAmount,
      "orders": FieldValue.arrayUnion(products),
      "vendors": FieldValue.arrayUnion(vendors),
    });
    placingOrder(false);
  }

  getProductDetails(){
    products.clear();
    vendors.clear();
    for(var i = 0; i < productSnapshot.length; i++){
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'tprice': productSnapshot[i]['tPrice'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
      });
      vendors.add(productSnapshot[i]['vendor_id']);
    }
  }

  clearCart(){
    for(var i = 0; i < productSnapshot.length; i++){
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }

}