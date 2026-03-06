import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/Widgets/MyTextfield.dart';
import 'package:fooddeliveryapp/auth/services/error_message.dart';

class OrderTime extends StatefulWidget {
  const OrderTime({super.key});

  @override
  State<OrderTime> createState() => _OrderTimeState();
}

class _OrderTimeState extends State<OrderTime> {
  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  String? startTimeValue;
  String? endTimeValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
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
              'Edit Order Time',
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
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Order Time')
            .doc('time')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.grey[700],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(
              child: Text('No data available'),
            );
          }

          var data = snapshot.data!.data();
          start.text = data!['start'].toString();
          end.text = data['end'].toString();
          return Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'CURRENT START TIME',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 110, 124, 148),
                          ),
                        ),
                        MyTextField(
                          controller: start,
                          hintText: 'start time',
                          obscureText: false,
                          errorText: null,
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'CURRENT END TIME',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 110, 124, 148),
                          ),
                        ),
                        MyTextField(
                          controller: end,
                          hintText: 'end time',
                          obscureText: false,
                          errorText: null,
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.blue,
                          iconDisabledColor: Colors.grey,
                          icon: const Icon(Icons.menu_rounded),
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Ubuntu',
                          ),
                          focusColor: Colors.black54,
                          value: startTimeValue,
                          items: const [
                            DropdownMenuItem(
                              value: '1',
                              child: Text(
                                '1',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '2',
                              child: Text(
                                '2',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '3',
                              child: Text(
                                '3',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '4',
                              child: Text(
                                '4',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '5',
                              child: Text(
                                '5',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '6',
                              child: Text(
                                '6',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '7',
                              child: Text(
                                '7',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '8',
                              child: Text(
                                '8',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '9',
                              child: Text(
                                '9',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '10',
                              child: Text(
                                '10',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '11',
                              child: Text(
                                '11',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '12',
                              child: Text(
                                '12',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '13',
                              child: Text(
                                '13',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '14',
                              child: Text(
                                '14',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '15',
                              child: Text(
                                '15',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '16',
                              child: Text(
                                '16',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '17',
                              child: Text(
                                '17',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '18',
                              child: Text(
                                '18',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '19',
                              child: Text(
                                '19',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '20',
                              child: Text(
                                '20',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '21',
                              child: Text(
                                '21',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '22',
                              child: Text(
                                '22',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '23',
                              child: Text(
                                '23',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '24',
                              child: Text(
                                '24',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              startTimeValue = newValue!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'NEW START TIME',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 110, 124, 148),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.blue,
                          iconDisabledColor: Colors.grey,
                          icon: const Icon(Icons.menu_rounded),
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Ubuntu',
                          ),
                          focusColor: Colors.black54,
                          value: endTimeValue,
                          items: const [
                            DropdownMenuItem(
                              value: '1',
                              child: Text(
                                '1',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '2',
                              child: Text(
                                '2',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '3',
                              child: Text(
                                '3',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '4',
                              child: Text(
                                '4',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '5',
                              child: Text(
                                '5',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '6',
                              child: Text(
                                '6',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '7',
                              child: Text(
                                '7',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '8',
                              child: Text(
                                '8',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '9',
                              child: Text(
                                '9',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '10',
                              child: Text(
                                '10',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '11',
                              child: Text(
                                '11',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '12',
                              child: Text(
                                '12',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '13',
                              child: Text(
                                '13',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '14',
                              child: Text(
                                '14',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '15',
                              child: Text(
                                '15',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '16',
                              child: Text(
                                '16',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '17',
                              child: Text(
                                '17',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '18',
                              child: Text(
                                '18',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '19',
                              child: Text(
                                '19',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '20',
                              child: Text(
                                '20',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '21',
                              child: Text(
                                '21',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '22',
                              child: Text(
                                '22',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '23',
                              child: Text(
                                '23',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: '24',
                              child: Text(
                                '24',
                                style: TextStyle(fontFamily: 'Ubuntu'),
                              ),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              endTimeValue = newValue!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'NEW END TIME',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 110, 124, 148),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.grey[700])),
                onPressed: () {
                  try {
                    int start = int.parse(startTimeValue!);
                    int end = int.parse(endTimeValue!);
                    FirebaseFirestore.instance
                        .collection('Order Time')
                        .doc('time')
                        .update({
                      'start': start,
                      'end': end,
                    });
                    message(
                      context,
                      title: 'success',
                      content: 'updating time is done',
                      buttonText: 'ok',
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                  } catch (e) {
                    message(
                      context,
                      title: 'error',
                      content: 'error while updating time, please try again',
                      buttonText: 'ok',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                  }
                },
                child: Text(
                  'update time',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[200],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
