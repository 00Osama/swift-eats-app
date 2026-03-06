import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fooddeliveryapp/screens/SubScreens/change_role.dart';

class ManageDrivers extends StatefulWidget {
  const ManageDrivers({super.key});

  @override
  State<ManageDrivers> createState() => _ManageDriversState();
}

class _ManageDriversState extends State<ManageDrivers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        surfaceTintColor: Colors.grey[300],
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Image.asset(
              'assets/icons/back-icon.png',
              width: 15,
            ),
          ),
        ),
        title: const Row(
          children: [
            Spacer(flex: 1),
            Text(
              'Manage Drivers',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 110, 124, 148),
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(color: Colors.grey[700]));
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No Items Found In The Cart',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                  ),
                ),
              );
            }

            List drivers = snapshot.data!.docs
                .where((doc) => doc['role'] == 'driver')
                .toList();

            if (drivers.isEmpty) {
              return Center(
                child: Text(
                  'No Drivers Available 😊',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 110, 124, 148),
                  ),
                ),
              );
            } else {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/flick-to-left.png',
                        width: 18,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Swipe The Item For More Details',
                        style: TextStyle(fontFamily: 'Ubuntu'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Expanded(
                    child: ListView.builder(
                      itemCount: drivers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: Center(
                            child: Column(
                              children: [
                                Slidable(
                                  endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) async {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(drivers[index]['email'])
                                              .update({'orders': 0});
                                        },
                                        backgroundColor: const Color.fromARGB(
                                            166, 54, 219, 13),
                                        icon: Icons.refresh_outlined,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      SlidableAction(
                                        onPressed: (context) async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChangeRole(
                                                  email: drivers[index]
                                                      ['email']),
                                            ),
                                          );
                                        },
                                        backgroundColor: const Color.fromARGB(
                                            166, 13, 143, 219),
                                        icon: Icons.manage_accounts_rounded,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'driver data',
                                              style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              drivers[index]['FullName'],
                                              style: const TextStyle(
                                                fontFamily: 'Ubuntu',
                                              ),
                                            ),
                                            Text(
                                              drivers[index]['email'],
                                              style: const TextStyle(
                                                fontFamily: 'Ubuntu',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Container(
                                            width: 2,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[500],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'driver orders',
                                              style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              drivers[index]['orders']
                                                  .toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Ubuntu',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Container(
                                            width: 2,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[500],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'driver salary',
                                              style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              (drivers[index]['orders'] *
                                                      drivers[index]
                                                          ['salaryPerOrder'])
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
                                ),
                                const SizedBox(height: 7),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
