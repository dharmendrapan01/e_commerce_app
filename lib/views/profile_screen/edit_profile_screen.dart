import 'dart:io';

import 'package:e_commerce_app/consts/consts.dart';
import 'package:e_commerce_app/controllers/profile_controller.dart';
import 'package:e_commerce_app/widgets_common/bg_widget.dart';
import 'package:e_commerce_app/widgets_common/custom_textfield.dart';
import 'package:e_commerce_app/widgets_common/our_button.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;
  const EditProfileScreen({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    // var controller = Get.find<ProfileController>();


    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [


              data['imageUrl'] == '' && controller.profileImagePath.isEmpty ? Image.asset(
                imgProfile2,
                width: 130,
                fit: BoxFit.cover,
              ).box.roundedFull.clip(Clip.antiAlias).make() : data['imageUrl'] != '' && controller.profileImagePath.isEmpty ? Image.network(data['imageUrl'],width: 130,
                fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make() : Image.file(
                File(controller.profileImagePath.value),
                width: 130,
                fit: BoxFit.cover,
              ).box.roundedFull.clip(Clip.antiAlias).make(),


              10.heightBox,
              ourButton(color: redColor, textColor: whiteColor, title: "Change", onPress: (){
                controller.changeImage(context);
              }),
              const Divider(),
              20.heightBox,
              customTextField(hint: nameHint, title: name, isPass: false, controller: controller.nameController),
              10.heightBox,
              customTextField(hint: passwordHint, title: oldPass, isPass: true, controller: controller.oldpassController),
              10.heightBox,
              customTextField(hint: passwordHint, title: newPass, isPass: true, controller: controller.newpassController),
              20.heightBox,
              controller.isLoading.value ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(redColor),) : SizedBox(
                  width: context.screenWidth - 60,
                  child: ourButton(color: redColor, textColor: whiteColor, title: "Save", onPress: () async {


                    controller.isLoading(true);

                    // if image is not selected
                    if(controller.profileImagePath.value.isNotEmpty){
                      await controller.uploadProfileImage();
                    }else{
                      controller.profileImageLink = data['imageUrl'];
                    }

                    // if old password verified from database
                    if(data['password'] == controller.oldpassController.text){
                      await controller.changeAuthPassword(email: data['email'], password: controller.oldpassController.text, newpassword: controller.newpassController.text);
                      await controller.updateProfile(
                          name: controller.nameController.text,
                          password: controller.newpassController.text,
                          imgUrl: controller.profileImageLink
                      );
                      VxToast.show(context, msg: "Updated");
                    }else{
                      VxToast.show(context, msg: "Wrong Old Password");
                    }
                    controller.isLoading(false);
                  })),
            ],
          ).box.shadowSm.padding(const EdgeInsets.all(16)).margin(const EdgeInsets.only(top: 50, left: 12, right: 12)).rounded.white.make(),
        ),
      )
    );
  }
}
