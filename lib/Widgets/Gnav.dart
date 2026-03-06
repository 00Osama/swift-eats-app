import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/screens/MainScreens/DriverScreen.dart';
import 'package:fooddeliveryapp/screens/MainScreens/HomeScreen.dart';
import 'package:fooddeliveryapp/screens/MainScreens/OrdersScreen.dart';
import 'package:fooddeliveryapp/screens/MainScreens/ProfileScreen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyGnav extends StatefulWidget {
  const MyGnav({Key? key}) : super(key: key);

  @override
  State<MyGnav> createState() => _MyGnavState();
}

class _MyGnavState extends State<MyGnav> {
  int _selectedIndex = 0;
  late List<Widget> myScreens;
  late List<GButton> tabs;
  String? role;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();
      setState(() {
        role = userData['role'];
        _buildScreensAndTabs();
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        role = null;
      });
    }
  }

  void _buildScreensAndTabs() {
    if (role == 'user') {
      myScreens = [
        ClipRRect(
          child: HomeScreen(),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        ClipRRect(
          child: OrdersScreen(accountType: role!),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: ProFileScrren(accountType: role!),
        ),
      ];
      tabs = [
        const GButton(
          icon: Icons.home_rounded,
          iconSize: 23,
          text: ' Home',
          textStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const GButton(
          icon: Icons.room_service_rounded,
          iconSize: 23,
          text: ' My Orders',
          textStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const GButton(
          icon: Icons.person_rounded,
          iconSize: 23,
          text: ' Profile',
          textStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ];
    } else if (role == 'admin') {
      myScreens = [
        ClipRRect(
          child: HomeScreen(),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        ClipRRect(
          child: DriverScreen(accountType: role!),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        ClipRRect(
          child: ProFileScrren(accountType: role!),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ];
      tabs = [
        const GButton(
          icon: Icons.home_rounded,
          iconSize: 23,
          text: ' Home',
          textStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const GButton(
          icon: Icons.delivery_dining,
          iconSize: 23,
          text: ' Driver',
          textStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const GButton(
          icon: Icons.person_rounded,
          iconSize: 23,
          text: ' Profile',
          textStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ];
    } else if (role == 'driver') {
      myScreens = [
        ClipRRect(
          child: HomeScreen(),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        ClipRRect(
          child: DriverScreen(accountType: role!),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        ClipRRect(
          child: ProFileScrren(accountType: role!),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ];
      tabs = [
        const GButton(
          icon: Icons.home_rounded,
          iconSize: 23,
          text: ' Home',
          textStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const GButton(
          icon: Icons.delivery_dining,
          iconSize: 23,
          text: ' Driver',
          textStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const GButton(
          icon: Icons.person_rounded,
          iconSize: 23,
          text: ' Profile',
          textStyle: TextStyle(
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ];
    } else {
      myScreens = [];
      tabs = [];
    }
  }

  Widget _buildNavItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey[300], size: 30), // Skeleton icon
          SizedBox(height: 4),
          Container(
            width: 60, // Skeleton text width
            height: 8,
            color: Colors.grey[300], // Skeleton text color
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return Scaffold(
        backgroundColor: Colors.grey[300],
        bottomNavigationBar: Skeletonizer(
          enabled: true,
          child: Container(
            color: Colors.grey[300], // Skeleton background color
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem('Home', Icons.home_rounded),
                  _buildNavItem('Orders', Icons.room_service_rounded),
                  _buildNavItem('Profile', Icons.person_rounded),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Skeletonizer(
                    enabled: true,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Skeletonizer(
                enabled: true,
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text('Item number index as title'),
                    subtitle: Text('Subtitle here'),
                    trailing: Icon(Icons.ac_unit),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Skeletonizer(
                      enabled: true,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 150,
                          height: 20,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Skeletonizer(
                      enabled: true,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 150,
                          height: 20,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Skeletonizer(
                      enabled: true,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 150,
                          height: 20,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Skeletonizer(
                      enabled: true,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 150,
                          height: 20,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Skeletonizer(
                    enabled: true,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: 85,
                        height: 20,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Skeletonizer(
                      enabled: true,
                      child: Container(
                        height: 250,
                        width: 220,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Spacer(flex: 1),
                            Skeletonizer(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Spacer(flex: 2),
                            ListTile(
                              title: Text('Item number uyhutle'),
                              subtitle: Text('Subtitle here'),
                            ),
                            Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ),
                    Skeletonizer(
                      enabled: true,
                      child: Container(
                        height: 250,
                        width: 220,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Spacer(flex: 1),
                            Skeletonizer(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Spacer(flex: 2),
                            ListTile(
                              title: Text('Item number uyhutle'),
                              subtitle: Text('Subtitle here'),
                            ),
                            Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ),
                    Skeletonizer(
                      enabled: true,
                      child: Container(
                        height: 250,
                        width: 220,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Spacer(flex: 1),
                            Skeletonizer(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Spacer(flex: 2),
                            ListTile(
                              title: Text('Item number uyhutle'),
                              subtitle: Text('Subtitle here'),
                            ),
                            Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

// Colors
    Color iconColor = isDark ? Colors.grey[400]! : Colors.grey[500]!;
    Color activeColor = isDark ? Colors.grey[100]! : Colors.grey[800]!;
    Color tabBorderColor = isDark ? Colors.grey : Colors.white;

// Responsive sizes
    double navPadding = screenWidth < 600 ? 17 : 30;
    double tabBorderRadius = screenWidth < 600 ? 20 : 35;
    double iconSize = screenWidth < 600 ? 24 : 33;

    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: myScreens.elementAt(_selectedIndex),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          color: iconColor,
          activeColor: activeColor,
          iconSize: iconSize,
          tabActiveBorder: Border.all(color: tabBorderColor),
          tabBorderRadius: tabBorderRadius,
          padding: EdgeInsets.all(navPadding),
          curve: Curves.linear,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: tabs,
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }
}
