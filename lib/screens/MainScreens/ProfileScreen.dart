import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/Widgets/OrderItem.dart';
import 'package:fooddeliveryapp/Widgets/ProfileCategory.dart';
import 'package:fooddeliveryapp/screens/MainScreens/AdminScreen.dart';
import 'package:fooddeliveryapp/screens/SubScreens/AccountInfo.dart';
import 'package:fooddeliveryapp/screens/SubScreens/AddNewFood.dart';
import 'package:fooddeliveryapp/screens/SubScreens/EditFood.dart';
import 'package:fooddeliveryapp/screens/SubScreens/ManageDrivers.dart';
import 'package:fooddeliveryapp/screens/SubScreens/OrderTime.dart';
import 'package:fooddeliveryapp/screens/SubScreens/Settings.dart';
import 'package:fooddeliveryapp/screens/SubScreens/change_role.dart';
import 'package:shimmer/shimmer.dart';

class ProFileScrren extends StatelessWidget {
  const ProFileScrren({
    super.key,
    required this.accountType,
  });

  final String? accountType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Center(
          child: Text(
            '$accountType profile',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 110, 124, 148),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                        SizedBox(height: 20),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 20,
                            width: 150,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(height: 40),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Container(
                                    height: 20,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                SizedBox(width: 16),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10000),
                        child: FancyShimmerImage(
                          imageUrl: userData['profileImage'],
                          shimmerBaseColor: Colors.grey[400],
                          shimmerHighlightColor: Colors.white,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userData['FullName'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 63, 72, 87),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //////////////////////////////////////////////////////////////////////
                    accountType == 'driver'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'driver orders',
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        userData['orders'].toString(),
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Container(
                                      width: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[500],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'driver salary',
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        ((userData['orders'] *
                                                    userData['salaryPerOrder'])
                                                .toString())
                                            .toString(),
                                        style: const TextStyle(
                                          fontFamily: 'Ubuntu',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    //////////////////////////////////////////////////////////////////////
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            ProfileCategory(
              category: 'Account Info',
              icon: Icon(Icons.person_rounded, color: Colors.grey[100]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountInfo(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ProfileCategory(
              category: 'Settings',
              icon: Icon(Icons.settings_rounded, color: Colors.grey[100]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => settings(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            //////////////////////////////////////////////////////////////////////
            accountType == 'admin'
                ? ProfileCategory(
                    category: 'Manage Drivers',
                    icon: Icon(Icons.delivery_dining, color: Colors.grey[100]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageDrivers(),
                        ),
                      );
                    },
                  )
                : SizedBox(),

            const SizedBox(height: 10),

            accountType == 'admin'
                ? ProfileCategory(
                    category: 'Edit Foods',
                    icon: Icon(Icons.admin_panel_settings_rounded,
                        color: Colors.grey[100]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminScreen(),
                        ),
                      );
                    },
                  )
                : SizedBox(),

            const SizedBox(height: 10),

            accountType == 'admin'
                ? ProfileCategory(
                    category: 'Add New Food',
                    icon: Icon(Icons.add_rounded, color: Colors.grey[100]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewFood(),
                        ),
                      );
                    },
                  )
                : SizedBox(),

            const SizedBox(height: 10),

            accountType == 'admin'
                ? ProfileCategory(
                    category: 'Change Role',
                    icon: Icon(Icons.edit_rounded, color: Colors.grey[100]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeRole(),
                        ),
                      );
                    },
                  )
                : SizedBox(),

            const SizedBox(height: 10),

            accountType == 'admin'
                ? ProfileCategory(
                    category: 'Edit Order Time',
                    icon: Icon(Icons.access_time_rounded,
                        color: Colors.grey[100]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderTime(),
                        ),
                      );
                    },
                  )
                : SizedBox(),
            //////////////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
