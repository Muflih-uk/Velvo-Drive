import 'package:flutter/material.dart';

import 'offers_carousel.dart';

class OffersCarouselAndCategories extends StatelessWidget {
  const OffersCarouselAndCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const OffersCarousel(); 
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     // While loading use 👇
    //     // const OffersSkelton(),
    //     // Padding(
    //     //   padding: const EdgeInsets.all(defaultPadding),
    //     //   child: Text(
    //     //     "Categories",
    //     //     style: Theme.of(context).textTheme.titleSmall,
    //     //   ),
    //     // ),
    //     // While loading use 👇
    //     // const CategoriesSkelton(),
    //     //const Categories(),
    //   ],
    // );
  }
}
