import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/provider/auth_provider.dart';
import 'package:shop/provider/bottom_nav_provider.dart';
import 'package:shop/provider/data_provider.dart';
import 'package:shop/route/screen_export.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _StateProfileScreen();
}

class _StateProfileScreen extends State<ProfileScreen>{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataProvider>(context, listen: false).fetchUserDetail();
    });
  }


  @override
  Widget build(BuildContext context) {

    final bottomProvider = Provider.of<BottomNavProvider>(context);
    return Scaffold(
      body: Consumer<DataProvider>(
        builder: (ctx, provider, child){
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
            return const Center(child: Text('Server Not Reached.'));
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchUserDetail(),
            child: ListView(
              children: [
                ProfileCard(
                  name: provider.user["username"],
                  email: provider.user["email"],
                  imageSrc: provider.user["photo"] == '' ? "https://cdn-icons-png.flaticon.com/128/149/149071.png" : provider.user["photo"],
                  // proLableText: "Sliver",
                  // isPro: true, if the user is pro
                  press: () {
                    Navigator.pushNamed(context, userInfoScreenRoute);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(
                    "Account",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                ProfileMenuListTile(
                  text: "My Vehicles",
                  svgSrc: "assets/icons/Man.svg",
                  press: () {
                    bottomProvider.setIndex(2);
                  },
                ),
                // const SizedBox(height: defaultPadding),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       horizontal: defaultPadding, vertical: defaultPadding / 2),
                //   child: Text(
                //     "Personalization",
                //     style: Theme.of(context).textTheme.titleSmall,
                //   ),
                // ),
                // DividerListTileWithTrilingText(
                //   svgSrc: "assets/icons/Notification.svg",
                //   title: "Notification",
                //   trilingText: "Off",
                //   press: () {
                //     Navigator.pushNamed(context, enableNotificationScreenRoute);
                //   },
                // ),
                // ProfileMenuListTile(
                //   text: "Preferences",
                //   svgSrc: "assets/icons/Preferences.svg",
                //   press: () {
                //     Navigator.pushNamed(context, preferencesScreenRoute);
                //   },
                // ),
                // const SizedBox(height: defaultPadding),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       horizontal: defaultPadding, vertical: defaultPadding / 2),
                //   child: Text(
                //     "Settings",
                //     style: Theme.of(context).textTheme.titleSmall,
                //   ),
                // ),
                // ProfileMenuListTile(
                //   text: "Language",
                //   svgSrc: "assets/icons/Language.svg",
                //   press: () {
                //     Navigator.pushNamed(context, selectLanguageScreenRoute);
                //   },
                // ),
                // ProfileMenuListTile(
                //   text: "Location",
                //   svgSrc: "assets/icons/Location.svg",
                //   press: () {},
                // ),
                const SizedBox(height: defaultPadding),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  child: Text(
                    "Help & Support",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ProfileMenuListTile(
                  text: "Get Help",
                  svgSrc: "assets/icons/Help.svg",
                  press: () {},
                ),
                ProfileMenuListTile(
                  text: "FAQ",
                  svgSrc: "assets/icons/FAQ.svg",
                  press: () {},
                  isShowDivider: false,
                ),
                const SizedBox(height: defaultPadding),

                // Log Out
                Consumer<AuthProvider>(
                  builder: (ctx, auth, child) => auth.isLoading
                  ? const CircularProgressIndicator()
                  : ListTile(
                    onTap: () {
                      auth.logout();
                    },
                    minLeadingWidth: 24,
                    leading: SvgPicture.asset(
                      "assets/icons/Logout.svg",
                      height: 24,
                      width: 24,
                      colorFilter: const ColorFilter.mode(
                        errorColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    title: const Text(
                      "Log Out",
                      style: TextStyle(color: errorColor, fontSize: 14, height: 1),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      )
    );
  }
}









