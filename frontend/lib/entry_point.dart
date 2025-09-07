import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/provider/bottom_nav_provider.dart';
import 'package:shop/route/screen_export.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  final List _pages = [
    const HomeScreen(),
    DiscoverScreen(),
    BookmarkScreen(), 
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = Provider.of<BottomNavProvider>(context);

    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 24,
        colorFilter: ColorFilter.mode(
            color ??
                Theme.of(context).iconTheme.color!.withOpacity(
                    Theme.of(context).brightness == Brightness.dark ? 0.3 : 1),
            BlendMode.srcIn),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: false,
        title: const Text(
          "Velvo Drive",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.pushNamed(context, notificationsScreenRoute);
        //     },
        //     icon: SvgPicture.asset(
        //       "assets/icons/Notification.svg",
        //       height: 24,
        //       colorFilter: ColorFilter.mode(
        //           Theme.of(context).textTheme.bodyLarge!.color!,
        //           BlendMode.srcIn),
        //     ),
        //   ),
        // ],
      ),
      body: PageTransitionSwitcher(
        duration: defaultDuration,
        transitionBuilder: (child, animation, secondAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondAnimation,
            child: child,
          );
        },
        child: _pages[bottomNavProvider.currentIndex],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: defaultPadding / 2),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF101015),
        child: BottomNavigationBar(
          currentIndex: bottomNavProvider.currentIndex,
          onTap: (index) {
              bottomNavProvider.setIndex(index);
          },
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF101015),
          type: BottomNavigationBarType.fixed,
          // selectedLabelStyle: TextStyle(color: primaryColor),
          selectedFontSize: 12,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.transparent,
          items: [
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Man.svg"),
              activeIcon: svgIcon("assets/icons/Man.svg", color: primaryColor),
              label: "Vehicles",
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Category.svg"),
              activeIcon:
                  svgIcon("assets/icons/Category.svg", color: primaryColor),
              label: "Discover",
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Man.svg"),
              activeIcon:
                  svgIcon("assets/icons/Man.svg", color: primaryColor),
              label: "My Vehicles",
            ),
            BottomNavigationBarItem(
              icon: svgIcon("assets/icons/Profile.svg"),
              activeIcon:
                  svgIcon("assets/icons/Profile.svg", color: primaryColor),
              label: "Profile",
            ),
          ],
        ),
      ),
      floatingActionButton: 
      FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, addVehicle);
        },
        backgroundColor: Colors.white,
        child: SvgPicture.asset(
          "assets/icons/Plus1.svg",
          height: 38,
          colorFilter: ColorFilter.mode(
              Theme.of(context).textTheme.bodyLarge!.color!,
              BlendMode.srcIn),
        ),
      ),
      
    );
  }
}
