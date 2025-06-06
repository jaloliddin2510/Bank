import 'package:bank/features/screens/bottom_bar/payment/payment_page.dart';
import 'package:bank/features/screens/bottom_bar/profile/profile.dart';
import 'package:bank/features/screens/bottom_bar/statistics/statistics.dart';
import 'package:bank/features/screens/bottom_bar/transactions/send_money.dart';
import 'package:bank/features/utils/generated/extensions.dart';
import 'package:flutter/material.dart';
import '../../utils/generated/assets.dart';
import '../../utils/styles.dart';
import 'home/home.dart';
import 'home/wallet/wallet.dart';

/// This is the stateful widget that the main application instantiates.
class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const SendMoney(),
    const PaymentPage(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor().white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedLabelStyle: TextStyle(fontSize: 20, color: Styles.primaryColor),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              Assets.home,
              height: 25,
              width: 25,
              color: _selectedIndex == 0 ? AppColor().primaryWithOpacityColor : AppColor().grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Assets.transaction,
              height: 25,
              width: 25,
              color: _selectedIndex == 1 ? AppColor().primaryWithOpacityColor :AppColor().grey,
            ),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Assets.wallet,
              height: 25,
              width: 25,
              color: _selectedIndex == 2 ? AppColor().primaryWithOpacityColor :AppColor().grey,
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              Assets.profile,
              height: 25,
              width: 25,
              color: _selectedIndex == 3 ? AppColor().primaryWithOpacityColor :AppColor().grey,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
