import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatefulWidget {
  const CustomBottomAppBar({Key? key});

  @override
  State<StatefulWidget> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<StatefulWidget> {
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the current route and set the selected index accordingly
    String currentRoute = ModalRoute.of(context)!.settings.name!;
    switch (currentRoute) {
      case '/home':
        _selectedIndex = 0;
        break;
      case '/search':
        _selectedIndex = 1;
        break;
      case '/orders':
        _selectedIndex = 2;
        break;
      case '/account':
        _selectedIndex = 3;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 0.95,
      shape: CircularNotchedRectangle(),
      notchMargin: 5.0,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIconButton(0, Icons.home, 'Home', '/home'),
            _buildIconButton(1, Icons.search, 'Search', '/search'),
            _buildIconButton(2, Icons.shopping_basket, 'Orders', '/orders'),
            _buildIconButton(
                3, Icons.account_circle_outlined, 'Account', '/account'),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
      int index, IconData icon, String label, String route) {
    return IconButton(
      iconSize: 20,
      onPressed: () {
        if (_selectedIndex != index) {
          setState(() {
            _selectedIndex = index;
          });
          Navigator.of(context).pushNamed(route);
        }
      },
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? Color(0xFFEA8D1F) : null,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Color(0xFFEA8D1F) : null,
            ),
          ),
        ],
      ),
    );
  }
}
