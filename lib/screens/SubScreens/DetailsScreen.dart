import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/screens/SubScreens/ConfirmOrder.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.foodName,
    required this.foodPrice,
    required this.image,
    this.food,
  }) : super(key: key);

  final String image;
  final String foodName;
  final String foodPrice;
  final DocumentSnapshot? food;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String cartText = 'Add to Cart';

  Future<void> checkDocumentExistence() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('cart')
        .doc(widget.food!.id)
        .get();

    setState(() {
      if (documentSnapshot.exists) {
        cartText = 'Remove From Cart';
      } else {
        cartText = 'Add to Cart';
      }
    });
  }

  Future<void> toggleCart() async {
    DocumentReference cartDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('cart')
        .doc(widget.food!.id);

    DocumentSnapshot documentSnapshot = await cartDocRef.get();

    if (documentSnapshot.exists) {
      // Remove from cart
      await cartDocRef.delete();
    } else {
      // Add to cart
      await cartDocRef.set({
        'image': widget.image,
        'name': widget.foodName,
        'price': widget.foodPrice,
        'timeStamp': Timestamp.now(),
        'quantity': '1',
      });
    }

    checkDocumentExistence(); // Refresh the button text
  }

  String? role;

  Future<void> _fetchUserRole() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    setState(() {
      role = userData['role'];
    });
  }

  @override
  void initState() {
    checkDocumentExistence();
    _fetchUserRole();

    super.initState();
  }

  Future<void> checkOrderTime() async {
    int currentHourTime = DateTime.now().hour;

    // Fetch the 'time' document from Firestore
    DocumentSnapshot timeDoc = await FirebaseFirestore.instance
        .collection('Order Time')
        .doc('time')
        .get();

    if (timeDoc.exists) {
      Map<String, dynamic>? data = timeDoc.data() as Map<String, dynamic>?;
      if (data != null) {
        int startTime = data['start'];
        int endTime = data['end'];

        if (currentHourTime > startTime && currentHourTime < endTime) {
          // Current time is within the allowed order time
          Navigator.push(
            context,
            DialogRoute(
              context: context,
              builder: (context) => ConfirmOrder(
                foodName: widget.foodName,
                foodPrice: int.parse(widget.foodPrice),
                image: widget.image,
              ),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Order is not currently allowed'),
                content:
                    Text('Allowed time is between $startTime and $endTime'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

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
              'Food Details',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            const SizedBox(height: 10),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 8,
                    blurRadius: 9,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.foodName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${widget.foodPrice} \$',
              style: const TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 239, 48, 41),
              ),
            ),
            const Spacer(flex: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Return Policy',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately.',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                      color: Color.fromARGB(255, 143, 142, 142),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 4),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: toggleCart,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            const Color.fromARGB(255, 239, 48, 41),
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        child: Text(
                          cartText,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  role == 'user'
                      ? Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                await checkOrderTime();
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                  const Color.fromARGB(255, 239, 48, 41),
                                ),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Order Now',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
