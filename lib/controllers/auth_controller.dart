
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../views/home_screen/home.dart';

class AuthController extends GetxController{
  var isLoading = false.obs;

  // login text controller
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void loginMethod({context}) {
    isLoading(true);
    auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) {
      isLoading(false);
      Get.to(() => const Home());
      VxToast.show(context, msg: "Logged in successfully");
    }).onError((error, stackTrace) {
      isLoading(false);
      VxToast.show(context, msg: error.toString());
    });
  }



  // signup method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;

    try{
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
      VxToast.show(context, msg: e.toString());
    }
  }

  // store user data
  storeUserData({name, password, email}) async {
    DocumentReference store = firestore.collection(usersCollection).doc(currentUser!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid,
      'cart_count': "00",
      'order_count': "00",
      'wishlist_count': "00",
    });
  }

  // signout method
  signoutMethod(context) async {
    try{
      await auth.signOut();
    }catch(e){
      VxToast.show(context, msg: e.toString());
    }
  }
}