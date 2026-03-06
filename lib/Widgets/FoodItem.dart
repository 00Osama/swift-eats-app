import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/auth/services/error_message.dart';
import 'package:fooddeliveryapp/screens/SubScreens/EditFood.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class FoodItem extends StatelessWidget {
  const FoodItem({
    super.key,
    required this.food,
    required this.category,
    required this.adminActions,
  });

  final DocumentSnapshot food;
  final String category;
  final bool adminActions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth;
        double cardHeight = cardWidth * 1.25;

        double imageSize = cardWidth * 0.70;
        double nameSize = cardWidth * 0.10;
        double priceSize = cardWidth * 0.090;

        return Container(
          height: cardHeight,
          width: cardWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.4),
                spreadRadius: 1,
                blurRadius: 20,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Spacer(),

              /// IMAGE
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: FancyShimmerImage(
                    imageUrl: food['foodImage'],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// NAME
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  food['foodName'],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: nameSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              /// PRICE
              Text(
                '${food['foodPrice']} \$',
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: priceSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffef3029),
                ),
              ),

              const Spacer(),

              /// ADMIN ACTIONS
              if (adminActions)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /// EDIT
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditFood(
                              food: food,
                              category: category,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: cardWidth * .20,
                        height: cardWidth * .20,
                        decoration: BoxDecoration(
                          color: const Color(0xffac9f2e),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: cardWidth * .13,
                        ),
                      ),
                    ),

                    /// DELETE
                    GestureDetector(
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'Delete Warning',
                          desc: 'Do You Want To Delete ${food['foodName']} ?!',
                          btnCancelOnPress: () {},
                          btnOkColor: Colors.red,
                          btnCancelColor: Colors.green,
                          btnCancelText: 'Cancel',
                          btnOkText: 'Delete',
                          btnOkOnPress: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection(category)
                                  .doc(food.id)
                                  .delete();
                            } catch (e) {
                              message(
                                context,
                                title: 'error',
                                content:
                                    'failed to delete food, please try again',
                                buttonText: 'Ok',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              );
                            }
                          },
                        ).show();
                      },
                      child: Container(
                        width: cardWidth * .20,
                        height: cardWidth * .20,
                        decoration: BoxDecoration(
                          color: const Color(0xffdf4e44),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: cardWidth * .13,
                        ),
                      ),
                    ),
                  ],
                ),

              Spacer(),
            ],
          ),
        );
      },
    );
  }
}
