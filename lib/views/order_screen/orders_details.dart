import 'package:e_commerce_app/consts/consts.dart';
import 'package:intl/intl.dart' as intl;
import 'components/order_place_detail.dart';
import 'components/order_status.dart';

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Order Details".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            orderStatus(color: redColor, title: "Placed", icon: Icons.done, showDone: data['order_placed']),
            orderStatus(color: Colors.blue, title: "Confirmed", icon: Icons.thumb_up, showDone: data['order_confirmed']),
            orderStatus(color: Colors.red, title: "On Delivery", icon: Icons.car_crash, showDone: data['order_on_delivery']),
            orderStatus(color: Colors.purple, title: "Delivered", icon: Icons.done_all_rounded, showDone: data['order_delivered']),

            const Divider(),
            10.heightBox,
            Column(
              children: [
                orderPlaceDetails(d1: data['order_code'], d2: data['shipping_method'], title1: "Order Code", title2: "Shipping Method"),
                orderPlaceDetails(d1: intl.DateFormat().add_yMd().format(data['order_date'].toDate()), d2: data['payment_method'], title1: "Order Date", title2: "Payment Method"),
                orderPlaceDetails(d1: "Unpaid", d2: "Order Placed", title1: "Payment Status", title2: "Delivery Status"),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Shipping Address".text.fontFamily(semibold).make(),
                          "${data['order_by_name']}".text.make(),
                          "${data['order_by_email']}".text.make(),
                          "${data['order_by_address']}".text.make(),
                          "${data['order_by_city']}".text.make(),
                          "${data['order_by_state']}".text.make(),
                          "${data['order_by_phone']}".text.make(),
                          "${data['order_by_postalcode']}".text.make(),
                        ],
                      ),
                      SizedBox(
                        width: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Total Amount".text.fontFamily(semibold).make(),
                            "${data['total_amount']}".numCurrency.text.color(redColor).fontFamily(bold).make(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ).box.outerShadowMd.white.make(),
            const Divider(),
            10.heightBox,
            "Ordered Product".text.size(16).color(darkFontGrey).fontFamily(semibold).makeCentered(),
            10.heightBox,
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(data['orders'].length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    orderPlaceDetails(
                      title1: data['orders'][index]['title'],
                      title2: "${data['orders'][index]['tprice']}".numCurrency,
                      d1: "${data['orders'][index]['qty']}x",
                      d2: "Refundable",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 30,
                        height: 20,
                        color: Color(data['orders'][index]['color']),
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }).toList(),
            ).box.outerShadowMd.white.margin(const EdgeInsets.only(bottom: 4)).make(),
            20.heightBox,
            // Row(
            //   children: [
            //     "SUB TOTAL:".text.size(16).fontFamily(semibold).color(darkFontGrey).make(),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
