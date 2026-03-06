import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/Widgets/FoodCategory.dart';
import 'package:fooddeliveryapp/Widgets/FoodBuilder.dart';
import 'package:fooddeliveryapp/Widgets/MyDivider.dart';
import 'package:fooddeliveryapp/screens/SubScreens/SeeMore.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        surfaceTintColor: Colors.grey[300],
        centerTitle: true,
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
        title: Text(
          'Edit Foods',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 110, 124, 148),
          ),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: FoodsNonActive(),
          ),
          const SizedBox(height: 10),
          const MyContainer(
            childWidget: SizedBox(
              height: 270,
              child: FoodBuilder(
                category: 'Foods    ',
                numberOfCards: 1,
                adminActions: true,
              ),
            ),
          ),
          const MyDivider(dividerHeight: 7, verticalSpace: 25),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: DrinksNonActive(),
          ),
          const SizedBox(height: 10),
          const MyContainer(
            childWidget: SizedBox(
              height: 270,
              child: FoodBuilder(
                category: 'Drinks    ',
                numberOfCards: 1,
                adminActions: true,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const MyDivider(dividerHeight: 7, verticalSpace: 25),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: SnacksNonActive(),
          ),
          const SizedBox(height: 10),
          const MyContainer(
            childWidget: SizedBox(
              height: 270,
              child: FoodBuilder(
                category: 'Snacks    ',
                numberOfCards: 1,
                adminActions: true,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const MyDivider(dividerHeight: 7, verticalSpace: 25),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: DessertsNonActive(),
          ),
          const SizedBox(height: 10),
          const MyContainer(
            childWidget: SizedBox(
              height: 270,
              child: FoodBuilder(
                category: 'Desserts    ',
                numberOfCards: 1,
                adminActions: true,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
