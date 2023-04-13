import 'package:e_commerce_app/consts/consts.dart';
import 'package:e_commerce_app/widgets_common/our_button.dart';
import 'package:flutter/services.dart';

Widget exitDialog(context){
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      "Confirm".text.fontFamily(bold).size(18).color(darkFontGrey).make(),
      const Divider(),
      10.heightBox,
      "Are you sure you want to exit?".text.size(16).color(darkFontGrey).make(),
      10.heightBox,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ourButton(title: "Yes", onPress: (){
            SystemNavigator.pop();
          }, textColor: whiteColor, color: redColor),
          ourButton(title: "No", onPress: (){
            Navigator.pop(context);
          }, textColor: whiteColor, color: redColor),
        ],
      ),
    ],).box.color(lightGrey).padding(const EdgeInsets.all(12)).roundedSM.make(),
  );
}