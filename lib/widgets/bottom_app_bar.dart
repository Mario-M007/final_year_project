import 'package:final_year_project/pages/account_page.dart';
import 'package:final_year_project/pages/home_page.dart';
import 'package:final_year_project/pages/orders_page.dart';
import 'package:final_year_project/pages/search_page.dart';
import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatefulWidget {
  const CustomBottomAppBar({super.key});

  @override
  State<StatefulWidget> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<StatefulWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          HomePage(),
          SearchPage(),
          OrderPage(),
          AccountPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.95),
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: const Color(0xFFEA8D1F),
        unselectedFontSize: 14,
        selectedFontSize: 14,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsetsDirectional.only(top: 14.0),
              child: Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsetsDirectional.only(top: 14.0),
              child: Icon(Icons.search),
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsetsDirectional.only(top: 14.0),
              child: Icon(Icons.shopping_basket),
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsetsDirectional.only(top: 14.0),
              child: Icon(Icons.account_circle_outlined),
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
