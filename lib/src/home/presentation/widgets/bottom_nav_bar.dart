// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:house_rental_admin/assets/svgs/svg_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:house_rental_admin/core/theme/colors.dart';
import 'package:house_rental_admin/src/home/presentation/pages/add_home.dart';
import 'package:house_rental_admin/src/home/presentation/pages/home_page.dart';
import 'package:house_rental_admin/src/home/presentation/pages/profile.dart';
import 'package:house_rental_admin/src/home/presentation/provider/bottom_nav_provider.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final int? index;

  const BottomNavigationBarWidget({
    super.key,
    this.index,
  });

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int currentIndex = 0;
  late BottomNavBarProvider navProvider;
  List<Widget> pages = [
    const HomePage(),
    const AddHomePage(),
    const ProfilePage()
  ];
  @override
  void initState() {
    super.initState();
    currentIndex = widget.index ?? navProvider.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    navProvider = context.watch<BottomNavBarProvider>();
    return Scaffold(
      body: pages.elementAt(navProvider.currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navProvider.currentIndex,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(color: blueOceanColor2),
        selectedItemColor: blueOceanColor2,
        unselectedLabelStyle: const TextStyle(color: searchTextColor2),
        onTap: (value) {
          navProvider.getCurrentIndex(value);
         
        },
        items: [
          buildNav(homeSVG, "Home"),
          buildNav(plusSVG, "Add"),
          buildNav(userSVG, "Profile"),
        ],
      ),
    );
  }
}

//Function()

BottomNavigationBarItem buildNav(String svg, String? label) {
  return BottomNavigationBarItem(
    icon: SvgPicture.asset(
      svg,
      colorFilter: const ColorFilter.mode(
        searchTextColor2,
        BlendMode.srcIn,
      ),
    ),
    activeIcon: SvgPicture.asset(
      svg,
      colorFilter: const ColorFilter.mode(
        blueOceanColor2,
        BlendMode.srcIn,
      ),
    ),
    label: label,
  );
}
