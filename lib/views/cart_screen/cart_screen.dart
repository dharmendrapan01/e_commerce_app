import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts/consts.dart';
import 'package:e_commerce_app/controllers/cart_controller.dart';
import 'package:e_commerce_app/services/firestore_services.dart';
import 'package:e_commerce_app/views/cart_screen/shipping_screen.dart';
import 'package:e_commerce_app/widgets_common/loading_indicator.dart';
import 'package:e_commerce_app/widgets_common/our_button.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: SizedBox(
        height: 50,
        child: ourButton(
            title: "Proceed to shipping",
            color: redColor,
            textColor: whiteColor,
            onPress: (){
              Get.to(() => const ShippingScreen());
            }
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping Cart".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid),
        builder: (BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData){
            return Center(child: loadingIndicator());
          }else if(snapshot.data!.docs.isEmpty){
            return Center(child: "Cart is empty".text.color(darkFontGrey).make());
          }else{
            var data = snapshot.data!.docs;
            controller.calculatePrice(data);
            controller.productSnapshot = data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index){
                          return ListTile(
                            leading: Image.network('${data[index]['img']}', width: 80, fit: BoxFit.cover,),
                            title: "${data[index]['title']} (x${data[index]['qty']})".text.fontFamily(semibold).size(16).make(),
                            subtitle: "${data[index]['tPrice']}".numCurrency.text.color(redColor).fontFamily(semibold).make(),
                            trailing: const Icon(Icons.delete, color: redColor).onTap(() {
                              FirestoreServices.deleteCartItem(data[index].id);
                            }),
                          );
                        }
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Total Price".text.fontFamily(semibold).color(darkFontGrey).make(),
                      Obx(() => "${controller.totalP.value}".numCurrency.text.fontFamily(semibold).color(redColor).make()),
                    ],
                  ).box.padding(const EdgeInsets.all(12)).color(lightGolden).width(context.screenWidth - 60).roundedSM.make(),
                  10.heightBox,
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
