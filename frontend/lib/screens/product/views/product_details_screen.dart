import 'package:flutter/material.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/get_profuct.dart';

import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen(this.vehicle);
  final VehicleGetModel vehicle;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = vehicle.toJson();
    return Scaffold(
      bottomNavigationBar: data["available"]
          ? CartButton(
              price: data["pricePerDay"],
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: ProductBuyNowScreen(vehicle),
                );
              },
            )
          :

          /// If profuct is not available then show [NotifyMeCard]
          NotifyMeCard(
              isNotify: false,
              onChanged: (value) {},
            ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              // actions: [
              //   IconButton(
              //     onPressed: () {},
              //     icon: SvgPicture.asset("assets/icons/Bookmark.svg",
              //         color: Theme.of(context).textTheme.bodyLarge!.color),
              //   ),
              // ],
            ),
            ProductImages(
              images: [data["main_photo"],data["second_photo"] , data["third_photo"]],
            ),
            ProductInfo(
              brand: data["name"],
              title: data["model"],
              isAvailable: data["available"],
              description:
                  data["description"],
              rating: 4.4,
              numOfReviews: 126,
            ),
            // ProductListTile(
            //   svgSrc: "assets/icons/Product.svg",
            //   title: "Product Details",
            //   press: () {
            //     customModalBottomSheet(
            //       context,
            //       height: MediaQuery.of(context).size.height * 0.92,
            //       child: Container() 
            //       // const BuyFullKit(
            //       //     images: ["assets/screens/Product detail.png"]),
            //     );
            //   },
            // ),
            // ProductListTile(
            //   svgSrc: "assets/icons/Delivery.svg",
            //   title: "Shipping Information",
            //   press: () {
            //     customModalBottomSheet(
            //       context,
            //       height: MediaQuery.of(context).size.height * 0.92,
            //       child: Container() 
            //       // const BuyFullKit(
            //       //   images: ["assets/screens/Shipping information.png"],
            //       // ),
            //     );
            //   },
            // ),
            // ProductListTile(
            //   svgSrc: "assets/icons/Return.svg",
            //   title: "Returns",
            //   isShowBottomBorder: true,
            //   press: () {
            //     customModalBottomSheet(
            //       context,
            //       height: MediaQuery.of(context).size.height * 0.92,
            //       child: const ProductReturnsScreen(),
            //     );
            //   },
            // ),
            // const SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.all(defaultPadding),
            //     child: ReviewCard(
            //       rating: 4.3,
            //       numOfReviews: 128,
            //       numOfFiveStar: 80,
            //       numOfFourStar: 30,
            //       numOfThreeStar: 5,
            //       numOfTwoStar: 4,
            //       numOfOneStar: 1,
            //     ),
            //   ),
            // ),
            // ProductListTile(
            //   svgSrc: "assets/icons/Chat.svg",
            //   title: "Reviews",
            //   isShowBottomBorder: true,
            //   press: () {
            //     Navigator.pushNamed(context, productReviewsScreenRoute);
            //   },
            // ),
            // SliverPadding(
            //   padding: const EdgeInsets.all(defaultPadding),
            //   sliver: SliverToBoxAdapter(
            //     child: Text(
            //       "You may also like",
            //       style: Theme.of(context).textTheme.titleSmall!,
            //     ),
            //   ),
            // ),
            // SliverToBoxAdapter(
            //   child: SizedBox(
            //     height: 220,
            //     child: ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       itemCount: 5,
            //       itemBuilder: (context, index) => Padding(
            //         padding: EdgeInsets.only(
            //             left: defaultPadding,
            //             right: index == 4 ? defaultPadding : 0),
            //         child: ProductCard(
            //           image: productDemoImg2,
            //           title: "Sleeveless Tiered Dobby Swing Dress",
            //           brandName: "LIPSY LONDON",
            //           price: 24.65,
            //           priceAfetDiscount: index.isEven ? 20.99 : null,
            //           dicountpercent: index.isEven ? 25 : null,
            //           press: () {},
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding),
            )
          ],
        ),
      ),
    );
  }
}
