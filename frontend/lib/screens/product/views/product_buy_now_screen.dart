import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/models/get_profuct.dart';
import 'package:shop/provider/price_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';
import 'components/product_quantity.dart';
import 'components/unit_price.dart';

class ProductBuyNowScreen extends StatefulWidget {
  const ProductBuyNowScreen(this.vehicle);
  final VehicleGetModel vehicle;

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = widget.vehicle.toJson();
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(data["pricePerDay"]),
      child: Scaffold(
        bottomNavigationBar: CartButton(
          price: data["pricePerDay"],
          title: "Call To Owner",
          subTitle: "Total price",
          press: () {
            showCallDialog(context, data["ownerPhoneNumber"]);
          },
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2, vertical: defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(),
                  Text(
                    "${data["name"]}",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Container(width: 30,)
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                  //       color: Theme.of(context).textTheme.bodyLarge!.color),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                      child: AspectRatio(
                        aspectRatio: 1.05,
                        child: NetworkImageWithLoader(data["main_photo"]),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(defaultPadding),
                    sliver: SliverToBoxAdapter(
                      child: Consumer<ProductProvider>(
                        builder: (context, provider, _) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: UnitPrice(
                                  price: data["pricePerDay"] + 100,
                                  priceAfterDiscount: provider.totalPrice,
                                ),
                              ),
                              ProductQuantity(
                                numOfItem: provider.numOfItem,
                                onIncrement: provider.increment,
                                onDecrement: provider.decrement,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: Divider()),
                  // SliverToBoxAdapter(
                  //   child: SelectedSize(
                  //     sizes: const ["S", "M", "L", "XL", "XXL"],
                  //     selectedIndex: 1,
                  //     press: (value) {},
                  //   ),
                  // ),
                  // SliverPadding(
                  //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  //   sliver: ProductListTile(
                  //     title: "Size guide",
                  //     svgSrc: "assets/icons/Sizeguid.svg",
                  //     isShowBottomBorder: true,
                  //     press: () {
                  //       customModalBottomSheet(
                  //         context,
                  //         height: MediaQuery.of(context).size.height * 0.9,
                  //         child: const SizeGuideScreen(),
                  //       );
                  //     },
                  //   ),
                  // ),
                  // SliverPadding(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: defaultPadding),
                  //   sliver: SliverToBoxAdapter(
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         const SizedBox(height: defaultPadding / 2),
                  //         Text(
                  //           "Store pickup availability",
                  //           style: Theme.of(context).textTheme.titleSmall,
                  //         ),
                  //         const SizedBox(height: defaultPadding / 2),
                  //         const Text(
                  //             "Select a size to check store availability and In-Store pickup options.")
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // SliverPadding(
                  //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  //   sliver: ProductListTile(
                  //     title: "Check stores",
                  //     svgSrc: "assets/icons/Stores.svg",
                  //     isShowBottomBorder: true,
                  //     press: () {
                  //       customModalBottomSheet(
                  //         context,
                  //         height: MediaQuery.of(context).size.height * 0.92,
                  //         child: const LocationPermissonStoreAvailabilityScreen(),
                  //       );
                  //     },
                  //   ),
                  // ),
                  const SliverToBoxAdapter(
                      child: SizedBox(height: defaultPadding))
                ],
              ),
            )
          ],
        ),
      ),
    );

  }

  Future<void> showCallDialog(BuildContext context, String phoneNumber) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Call Number"),
          content: Text("Do you want to call $phoneNumber?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final Uri callUri = Uri.parse('tel:$phoneNumber'); // or 'tel:$phoneNumber'
                try {
                  final bool launched = await launchUrl(
                    callUri,
                    mode: LaunchMode.externalApplication,
                  );
                  if (!launched) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Could not launch dialer for $callUri")),
                    );
                  } else {
                    Navigator.of(context).pop(); // close dialog if launched
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error launching call: $e")),
                  );
                }
              },
              child: const Text("Call"),
            )
          ],
        );
      },
    );
  }

}
