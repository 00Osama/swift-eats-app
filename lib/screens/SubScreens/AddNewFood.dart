import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/Widgets/MyTextfield.dart';
import 'package:fooddeliveryapp/auth/services/error_message.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddNewFood extends StatefulWidget {
  const AddNewFood({
    super.key,
  });

  @override
  State<AddNewFood> createState() => _AddNewFoodState();
}

class _AddNewFoodState extends State<AddNewFood> {
  String dropDownValue = 'Foods    ';
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  bool isImagePicked = false;
  String? imageUrl;
  String? imagePath;

  TextEditingController foodName = TextEditingController();
  String? foodNameErrorText;

  TextEditingController foodPrice = TextEditingController();
  String? foodPriceErrorText;

  Widget pickedImage = Image.asset(
    'assets/images/defult food.png',
  );

  imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  imgFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.image, size: 60.0),
                        SizedBox(height: 12.0),
                        Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    onTap: () {
                      imgFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.camera_alt, size: 60.0),
                        SizedBox(height: 12.0),
                        Text(
                          "Camera",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    onTap: () {
                      imgFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      setState(() {
        imageFile = File(croppedFile.path);
        pickedImage = Image.file(
          imageFile!,
          fit: BoxFit.cover,
        );
        isImagePicked = true;
      });
      // reload();
    }
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permission Denied"),
          content: const Text(
              "Please allow permissions in the app settings to continue."),
          actions: [
            TextButton(
              child: const Text("Settings"),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadImage(context) async {
    if (imageFile != null) {
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        String fileName = imageFile!.path.split('/').last;
        Reference ref = storage.ref().child('profile/$fileName');
        UploadTask uploadTask = ref.putFile(imageFile!);

        imageUrl = await (await uploadTask).ref.getDownloadURL();
        imagePath = ref.fullPath;
      } catch (e) {
        message(
          context,
          title: 'error',
          content: e.toString(),
          buttonText: 'failed to upload image, please try again',
          onPressed: () {
            Navigator.pop(context);
          },
        );
      }
    }
  }

  Future<void> uploadFood(context) async {
    await uploadImage(context);
    try {
      await FirebaseFirestore.instance.collection(dropDownValue).add({
        'timeStamp': Timestamp.now(),
        'foodName': foodName.text,
        'foodImage': imageUrl,
        'ImagePath': imagePath,
        'foodPrice': foodPrice.text,
      });
    } catch (e) {
      message(
        context,
        title: 'error',
        content: 'failed to add food, please try again',
        buttonText: 'Ok',
        onPressed: () {
          Navigator.pop(context);
        },
      );
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
              'Add New Food',
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
            const Center(
              child: Text(
                'Choose Food Category',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 110, 124, 148),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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
                  items: const [
                    DropdownMenuItem(
                      value: 'Foods    ',
                      child: Text(
                        'Foods    ',
                        style: TextStyle(fontFamily: 'Ubuntu'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Drinks    ',
                      child: Text(
                        'Drinks    ',
                        style: TextStyle(fontFamily: 'Ubuntu'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Snacks    ',
                      child: Text(
                        'Snacks    ',
                        style: TextStyle(fontFamily: 'Ubuntu'),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Desserts    ',
                      child: Text(
                        'Desserts    ',
                        style: TextStyle(fontFamily: 'Ubuntu'),
                      ),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      dropDownValue = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Choose Food Name',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 110, 124, 148),
                ),
              ),
            ),
            const SizedBox(height: 7),
            MyTextField(
              readOnly: false,
              controller: foodName,
              hintText: 'Food Name',
              obscureText: false,
              errorText: foodNameErrorText,
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Choose Food Price',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 110, 124, 148),
                ),
              ),
            ),
            const SizedBox(height: 7),
            MyTextField(
              readOnly: false,
              controller: foodPrice,
              hintText: 'Food Price',
              obscureText: false,
              errorText: foodPriceErrorText,
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Choose Food Image',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 110, 124, 148),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10000),
                    child: pickedImage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 95),
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(255, 82, 92, 65),
                  ),
                ),
                onPressed: () async {
                  Map<Permission, PermissionStatus> statuses =
                      await [Permission.storage, Permission.camera].request();
                  if (statuses[Permission.storage]!.isGranted &&
                      statuses[Permission.camera]!.isGranted) {
                    showImagePicker(context);
                  } else {
                    _showPermissionDeniedDialog(context);
                  }
                  setState(() {});
                },
                child: const Text(
                  'Choose Image',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(255, 79, 129, 96),
                  ),
                ),
                onPressed: () async {
                  if (foodName.text.isEmpty) {
                    setState(() {
                      foodNameErrorText = 'This field is required';
                    });
                  } else {
                    setState(() {
                      foodNameErrorText = null;
                    });
                  }

                  if (foodPrice.text.isEmpty) {
                    setState(() {
                      foodPriceErrorText = 'This field is required';
                    });
                  } else {
                    setState(() {
                      foodPriceErrorText = null;
                    });
                  }

                  if (foodNameErrorText == null &&
                      foodPriceErrorText == null &&
                      !isImagePicked) {
                    message(
                      context,
                      title: 'Error',
                      content: 'Please Choose Food Image',
                      buttonText: 'OK',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                  }

                  if (foodNameErrorText == null &&
                      foodPriceErrorText == null &&
                      isImagePicked) {
                    showDialog(
                      context: context,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(color: Colors.black),
                      ),
                    );
                    await uploadFood(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'ADD FOOD',
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
