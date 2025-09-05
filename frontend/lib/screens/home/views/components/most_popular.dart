import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product/secondary_product_card.dart';
import 'package:shop/components/skleton/product/products_skelton.dart';
import 'package:shop/provider/data_provider.dart';
import 'package:shop/route/screen_export.dart';

import '../../../../constants.dart';


class MostPopular extends StatefulWidget {
  @override
  State<MostPopular> createState() => _StateMostPopular();
}

class _StateMostPopular extends State<MostPopular>{

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<DataProvider>(context, listen: false).fetchPopularVehicle();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Most Popular",
            style: Theme.of(context).textTheme.titleSmall
          ),
        ),

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
                onRefresh: () => provider.fetchPopularVehicle(),
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
                    child: SecondaryProductCard(
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
      ]
    );
  }
}
