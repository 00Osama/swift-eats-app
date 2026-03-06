import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/Widgets/MyTextfield.dart';
import 'package:fooddeliveryapp/auth/services/error_message.dart';

class ChangeRole extends StatefulWidget {
  const ChangeRole({
    super.key,
    this.email,
  });
  final String? email;

  @override
  State<ChangeRole> createState() => _ChangeRoleState();
}

class _ChangeRoleState extends State<ChangeRole> {
  TextEditingController email = TextEditingController();
  TextEditingController price = TextEditingController();
  String? emailErrorText;
  String? priceErrorText;
  Future<DocumentSnapshot>? futureUserData;

  bool isValidEmail(String email) {
    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailRegex);
    return regExp.hasMatch(email);
  }

  Future<bool> userExists(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  String? dropDownValue;
  List<DropdownMenuItem<String>>? dropItems;

  @override
  void initState() {
    if (widget.email != null) {
      email.text = widget.email!;
    }
    super.initState();
  }

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
              'Change Roles',
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
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 15),
            const Center(
              child: Text(
                'Type member email you want to change his role',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 110, 124, 148),
                ),
              ),
            ),
            const SizedBox(height: 8),
            MyTextField(
              controller: email,
              hintText: 'Email',
              obscureText: false,
              errorText: emailErrorText,
              readOnly: false,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 130),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.grey[700]),
                ),
                onPressed: () async {
                  if (email.text.isEmpty) {
                    setState(() {
                      emailErrorText = 'This field is required';
                    });
                  } else if (!isValidEmail(email.text)) {
                    setState(() {
                      emailErrorText = 'Invalid email address';
                    });
                  } else if (await userExists(email.text) == false) {
                    setState(() {
                      emailErrorText = 'User not found';
                    });
                  } else {
                    setState(() {
                      emailErrorText = null;
                      futureUserData = FirebaseFirestore.instance
                          .collection('users')
                          .doc(email.text)
                          .get();
                    });
                  }
                },
                child: Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<DocumentSnapshot>(
              future: futureUserData,
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
                } else if (snapshot.hasData && snapshot.data != null) {
                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  if (data['role'] == 'user') {
                    dropItems = [
                      const DropdownMenuItem(
                        value: 'driver',
                        child: Text(
                          'driver',
                          style: TextStyle(fontFamily: 'Ubuntu'),
                        ),
                      ),
                      const DropdownMenuItem(
                        value: 'admin',
                        child: Text(
                          'admin',
                          style: TextStyle(fontFamily: 'Ubuntu'),
                        ),
                      ),
                    ];
                  } else if (data['role'] == 'driver') {
                    dropItems = [
                      const DropdownMenuItem(
                        value: 'user',
                        child: Text(
                          'user',
                          style: TextStyle(fontFamily: 'Ubuntu'),
                        ),
                      ),
                      const DropdownMenuItem(
                        value: 'admin',
                        child: Text(
                          'admin',
                          style: TextStyle(fontFamily: 'Ubuntu'),
                        ),
                      ),
                    ];
                  } else {
                    dropItems = [
                      const DropdownMenuItem(
                        value: 'user',
                        child: Text(
                          'user',
                          style: TextStyle(fontFamily: 'Ubuntu'),
                        ),
                      ),
                      const DropdownMenuItem(
                        value: 'driver',
                        child: Text(
                          'driver',
                          style: TextStyle(fontFamily: 'Ubuntu'),
                        ),
                      ),
                    ];
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'name : ' + data['FullName'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'current role is : ' + data['role'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'choose new role here',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const Text(
                                ' 👉',
                                style: TextStyle(fontSize: 20),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Container(
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
                                    value: dropDownValue,
                                    items: dropItems,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropDownValue = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          MyTextField(
                            controller: price,
                            hintText:
                                'price per order (when new role is driver)',
                            obscureText: false,
                            errorText: priceErrorText,
                            readOnly: false,
                            inputType: TextInputType.number,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (dropDownValue == null) {
                                message(
                                  context,
                                  title: 'Error',
                                  content: 'Please select a new role',
                                  buttonText: 'Ok',
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                              } else if (dropDownValue == 'driver' &&
                                  price.text.isEmpty) {
                                setState(() {
                                  priceErrorText =
                                      'This field is required when the new role is driver';
                                });
                              } else if (dropDownValue == 'driver' &&
                                  int.tryParse(price.text) == null) {
                                setState(() {
                                  priceErrorText =
                                      'Please enter a valid number for price per order';
                                });
                              } else {
                                try {
                                  Map<String, dynamic> updates = {
                                    'role': dropDownValue!,
                                  };

                                  if (dropDownValue == 'driver') {
                                    updates['salaryPerOrder'] =
                                        int.parse(price.text);
                                  }

                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(email.text)
                                      .update(updates);

                                  message(
                                    context,
                                    title: 'Success',
                                    content:
                                        'Changes saved successfully, user who become $dropDownValue must restart the app to apply changes',
                                    buttonText: 'Done',
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  );
                                } catch (e) {
                                  message(
                                    context,
                                    title: 'Error',
                                    content: e.toString(),
                                    buttonText: 'Done',
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  );
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.grey[700]),
                            ),
                            child: Text(
                              'Save changes',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
