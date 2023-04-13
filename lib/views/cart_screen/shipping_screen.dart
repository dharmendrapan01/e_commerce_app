import 'package:e_commerce_app/consts/consts.dart';
import 'package:e_commerce_app/controllers/cart_controller.dart';
import 'package:e_commerce_app/views/cart_screen/payment_method.dart';
import 'package:e_commerce_app/widgets_common/custom_textfield.dart';
import 'package:get/get.dart';

import '../../widgets_common/our_button.dart';

class ShippingScreen extends StatelessWidget {
  const ShippingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: ourButton(
            title: "Continue",
            color: redColor,
            textColor: whiteColor,
            onPress: (){
              if(controller.addressController.text.length > 10){
                Get.to(() => const PaymentMethod());
              }else{
                VxToast.show(context, msg: "Please fill the form");
              }
            }
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(hint: "Address", isPass: false, title: "Address", controller: controller.addressController),
            customTextField(hint: "City", isPass: false, title: "City", controller: controller.cityController),
            customTextField(hint: "State", isPass: false, title: "State", controller: controller.stateController),
            customTextField(hint: "Postal Code", isPass: false, title: "Postal Code", controller: controller.postalCodeController),
            customTextField(hint: "Phone", isPass: false, title: "Phone", controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}
