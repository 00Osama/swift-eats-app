import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/CustomWidgets/OrderItem.dart';
import 'package:fooddeliveryapp/global_fields.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({
    super.key,
    required this.accountType,
  });

  final String accountType;

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  int? Orders;
  Future<int?> _fetchUserOrders() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    Orders = userData['orders'];
    return Orders;
  }

  Stream<List<DocumentSnapshot>> getAllOrdersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<DocumentSnapshot> allOrders = [];

      for (var userDoc in querySnapshot.docs) {
        var ordersSnapshot = await userDoc.reference.collection('orders').get();
        allOrders.addAll(ordersSnapshot.docs);
      }

      return allOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Center(
          child: Text(
            'Driver Screen',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 110, 124, 148),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        backgroundColor: Colors.grey[600],
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded),
                const SizedBox(width: 10),
                const Text(
                  'make sure to refresh the page to receive updates',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: getAllOrdersStream(),
                builder:
                    (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.grey.shade700,
                    ));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No available orders'));
                  }

                  List<DocumentSnapshot> orders = snapshot.data!;

                  // Sort orders by timestamp in ascending order
                  orders.sort((a, b) {
                    Timestamp aTimestamp = a['timeStamp'];
                    Timestamp bTimestamp = b['timeStamp'];
                    return aTimestamp.compareTo(bTimestamp); // Sort ascending
                  });

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> orderData =
                          orders[index].data() as Map<String, dynamic>;
                      String id = orders[index].id;

                      return Column(
                        children: [
                          OrderItem(
                            address: orderData['address'],
                            image: orderData['foodImage'],
                            name: orderData['name'],
                            order: orderData['foodName'],
                            phoneNumber: orderData['phoneNumber'],
                            quantity: orderData['quantity'],
                            totalPrice: orderData['foodTotalPrice'],
                            orderId: id,
                            driverAction: widget.accountType,
                            email: orderData['email'],
                            securityCode: orderData['securityKey'],
                            showCode: widget.accountType,
                            btnOkOnPress: () async {
                              if (code.text == orderData['securityKey']) {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(orderData['email'])
                                    .collection('orders')
                                    .doc(id)
                                    .delete();

                                await _fetchUserOrders();
                                int o = Orders! + 1;

                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .update({
                                  'orders': o,
                                });
                                DelightToastBar(
                                  builder: (context) {
                                    return ToastCard(
                                      color: Color.fromARGB(255, 113, 201, 113),
                                      leading: Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        'order confirmed successfully',
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.grey.shade100,
                                        ),
                                      ),
                                    );
                                  },
                                  position: DelightSnackbarPosition.top,
                                  autoDismiss: true,
                                ).show(context);
                                code.clear();
                              } else {
                                DelightToastBar(
                                  builder: (context) {
                                    return ToastCard(
                                      color: Color.fromARGB(255, 230, 124, 116),
                                      leading: Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        'order security code is wrong',
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.grey.shade100,
                                        ),
                                      ),
                                    );
                                  },
                                  position: DelightSnackbarPosition.top,
                                  autoDismiss: true,
                                ).show(context);
                                code.clear();
                              }
                            },
                          ),
                          const SizedBox(height: 22),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}