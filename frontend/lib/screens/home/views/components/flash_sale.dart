import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/skleton/product/products_skelton.dart';
import 'package:shop/provider/data_provider.dart';
import 'package:shop/route/route_constants.dart';

import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../components/product/product_card.dart';
import '../../../../constants.dart';

class FlashSale extends StatefulWidget {
  const FlashSale({
    super.key,
  });

  @override
  State<FlashSale> createState() => _StateFlashSale();
}
class _StateFlashSale extends State<FlashSale>{

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<DataProvider>(context, listen: false).fetchFlashSale();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // While loading show 👇
        // const BannerMWithCounterSkelton(),
        BannerMWithCounter(
          duration: const Duration(hours: 8),
          text: "Super Flash Sale \n50% Off",
          press: () {},
        ),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Flash sale",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading show 👇
        // const ProductsSkelton(),
        SizedBox(
          height: 220,
          child: Consumer<DataProvider>(
            builder: (context, provider, child){
              if(provider.isLoading) {
                return const ProductsSkelton();
              }
              if (provider.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'An Error Occurred:\n${provider.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              }
              if (provider.data.isEmpty) {
                return const Center(child: Text('No vehicles found.'));
              }
              return RefreshIndicator(
                onRefresh: () => provider.fetchFlashSale(),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.data.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: index == provider.data.length - 1
                          ? defaultPadding
                          : 0,
                    ),
                    child: ProductCard(
                      image:  provider.data[index]["main_photo"],
                      brandName: provider.data[index]["name"],
                      title: provider.data[index]["model"],
                      price: provider.data[index]["pricePerDay"],
                      press: () {
                        Navigator.pushNamed(context, productDetailsScreenRoute,);
                      },
                    ),
                  )
                ),
              );
            }
          ),
        )
      ],
    );
  }
}
