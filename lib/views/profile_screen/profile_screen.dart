import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/consts/consts.dart';
import 'package:e_commerce_app/consts/list.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';
import 'package:e_commerce_app/services/firestore_services.dart';
import 'package:e_commerce_app/views/auth_screen/login_screen.dart';
import 'package:e_commerce_app/views/chat_screen/messaging_screen.dart';
import 'package:e_commerce_app/views/order_screen/order_screen.dart';
import 'package:e_commerce_app/views/profile_screen/edit_profile_screen.dart';
import 'package:e_commerce_app/views/wishlist_screen/wishlist_screen.dart';
import 'package:e_commerce_app/widgets_common/bg_widget.dart';
import 'package:e_commerce_app/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';
import 'components/details_cart.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    FirestoreServices.getCounts();

    return bgWidget(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(redColor),));
            }else if(snapshot.hasError){
              return const Text('Some Error');
            }else{
              var data = snapshot.data!.docs[0];
              // log('Data : $data');
              return SafeArea(
                child: Column(
                  children: [
                    // edit profile button
                    const Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, right: 10),
                        child: Icon(Icons.edit, color: whiteColor,),
                      ),
                    ).onTap(() {
                      controller.nameController.text = data['name'];
                      Get.to(() => EditProfileScreen(data: data));
                    }),

                    // user profile section
                    Row(
                      children: [
                        10.widthBox,
                        data['imageUrl'] == '' ?
                        Image.asset(
                          imgProfile2,
                          width: 130,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make() : Image.network(
                          data['imageUrl'],
                          width: 80,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
                        10.widthBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data['name']}".text.white.make(),
                              "${data['email']}".text.white.make(),
                            ],
                          ),
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: whiteColor,
                                )
                            ),
                            onPressed: () async {
                              await Get.put(AuthController()).signoutMethod(context);
                              Get.offAll(() => const LoginScreen());
                            },
                            child: logout.text.fontFamily(semibold).white.make()),
                        10.widthBox,
                      ],
                    ),

                    20.heightBox,

                    FutureBuilder(
                      future: FirestoreServices.getCounts(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if(!snapshot.hasData){
                          return Center(child: loadingIndicator());
                        }else{
                          var countData = snapshot.data;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              detailsCart(count: countData[0].toString(), title: "in your cart", width: context.screenWidth/3.4),
                              detailsCart(count: countData[1].toString(), title: "in your wishlist", width: context.screenWidth/3.4),
                              detailsCart(count: countData[2].toString(), title: "your orders", width: context.screenWidth/3.4),
                            ],
                          );
                        }
                      }
                    ),



                    // button section
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index){
                        return const Divider(
                          color: lightGrey,
                        );
                      },
                      itemCount: profileButtonList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Get.to(() => const OrderScreen());
                                break;
                              case 1:
                                Get.to(() => const WishlistScreen());
                                break;
                              case 2:
                                Get.to(() => const MessagesScreen());
                                break;
                            }
                          },
                          leading: Image.asset(profileButtonIcon[index], width: 22,),
                          title: profileButtonList[index].text.fontFamily(semibold).color(darkFontGrey).make(),
                        );
                      },
                    ).box.white.margin(const EdgeInsets.all(12)).rounded.padding(const EdgeInsets.symmetric(horizontal: 16)).shadowSm.make().box.color(redColor).make(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
