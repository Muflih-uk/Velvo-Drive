// import 'package:flutter/material.dart';
// import 'package:shop/components/product/product_card.dart';
// import 'package:shop/models/product_model.dart';
// import 'package:shop/route/route_constants.dart';

// import '../../../constants.dart';

// class BookmarkScreen extends StatelessWidget {
//   const BookmarkScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           // While loading use 👇
//           //  BookMarksSlelton(),
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: defaultPadding, vertical: defaultPadding),
//             sliver: SliverGrid(
//               gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                 maxCrossAxisExtent: 200.0,
//                 mainAxisSpacing: defaultPadding,
//                 crossAxisSpacing: defaultPadding,
//                 childAspectRatio: 0.66,
//               ),
//               delegate: SliverChildBuilderDelegate(
//                 (BuildContext context, int index) {
//                   return ProductCard(
//                     image: demoPopularProducts[index].image,
//                     brandName: demoPopularProducts[index].brandName,
//                     title: demoPopularProducts[index].title,
//                     price: demoPopularProducts[index].price,
//                     priceAfetDiscount:
//                         demoPopularProducts[index].priceAfetDiscount,
//                     dicountpercent: demoPopularProducts[index].dicountpercent,
//                     press: () {
//                       Navigator.pushNamed(context, productDetailsScreenRoute);
//                     },
//                   );
//                 },
//                 childCount: demoPopularProducts.length,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/components/skleton/skelton.dart';
import 'package:shop/constants.dart';
import 'package:shop/provider/data_provider.dart';
import 'package:shop/screens/search/views/components/search_form.dart';


class BookmarkScreen extends StatefulWidget {
  @override
  State<BookmarkScreen> createState() => _StateBookmarkScreen();
}

class _StateBookmarkScreen extends State<BookmarkScreen>{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataProvider>(context, listen: false).fetchBookmarkedVehicle();
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
                      return const Skeleton();
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
                      onRefresh: () => provider.fetchBookmarkedVehicle(),
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
                              press: () {}
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

