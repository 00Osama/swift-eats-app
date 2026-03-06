import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fooddeliveryapp/auth/services/auth_gate.dart';
import 'package:fooddeliveryapp/firebase_options.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.grey[400],
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    DevicePreview(
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.grey[400],
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }

  Future<void> _navigateToMainScreen() async {
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthGate(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/appSplash.png',
              width: screenSize.width * 0.6,
              height: screenSize.height * 0.25,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 35),
            LoadingAnimationWidget.inkDrop(
              color: Colors.redAccent.shade100,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
