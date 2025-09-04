import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/provider/data_provider.dart';
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
      Provider.of<DataProvider>(context, listen: false).fetchData();
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
                      onRefresh: () => provider.fetchData(),
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(
                          provider.data.length,
                          (index){
                            return ProductCard(
                              image: provider.data[index]["main_photo"], 
                              brandName: provider.data[index]["name"], 
                              title: provider.data[index]["model"], 
                              price: provider.data[index]["pricePerDay"], 
                              press: (){}
                            );
                          }
                        ),
                      ) 
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

