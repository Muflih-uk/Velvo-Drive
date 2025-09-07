import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/get_profuct.dart';
import 'package:shop/provider/data_provider.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/screens/search/views/components/search_form.dart';


class DiscoverScreen extends StatefulWidget {
  @override
  State<DiscoverScreen> createState() => _StateDiscoverScreen();
}

class _StateDiscoverScreen extends State<DiscoverScreen>{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataProvider>(context, listen: false).fetchVehicle();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: SearchForm(),
              ),

              Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Consumer<DataProvider>(
                  builder: (context, provider, child) {
                    if(provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
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
                      onRefresh: () => provider.fetchVehicle(),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: defaultPadding,
                        crossAxisSpacing: defaultPadding,
                        childAspectRatio: 0.7, 
                        children: List.generate(
                          provider.data.length,
                          (index) {
                            return ProductCard(
                              image: provider.data[index]["main_photo"],
                              brandName: provider.data[index]["name"],
                              title: provider.data[index]["model"],
                              price: provider.data[index]["pricePerDay"],
                              press: () {
                                VehicleGetModel vehicleGetModel = VehicleGetModel(
                                  id: provider.data[index]["id"], 
                                  name: provider.data[index]["name"], 
                                  description: provider.data[index]["description"], 
                                  model: provider.data[index]["model"], 
                                  pricePerDay: provider.data[index]["pricePerDay"], 
                                  mainPhoto: provider.data[index]["main_photo"], 
                                  secondPhoto: provider.data[index]["second_photo"], 
                                  thirdPhoto: provider.data[index]["third_photo"], 
                                  ownerPhoneNumber: provider.data[index]["ownerPhoneNumber"], 
                                  createdAt: provider.data[index]["createdAt"], 
                                  rentalCount: provider.data[index]["rentalCount"], 
                                  owner: Owner(
                                    id: provider.data[index]["owner"]["id"], 
                                    username: provider.data[index]["owner"]["username"], 
                                    email: provider.data[index]["owner"]["email"],
                                    photo: provider.data[index]["owner"]["photo"],
                                    aboutYou: provider.data[index]["owner"]["aboutYou"],
                                    number: provider.data[index]["owner"]["number"],
                                  ), 
                                  flashSale: provider.data[index]["flashSale"],
                                  available: provider.data[index]["available"]
                                );
                                Navigator.pushNamed(context, productDetailsScreenRoute,arguments: vehicleGetModel);
                              }
                            );
                          }
                        ),
                      ),
                    );
                  }
                ),
              ) 
            ],
          ),
        ),
      ),
    );
  }
}

