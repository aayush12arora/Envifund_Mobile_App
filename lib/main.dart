import 'dart:convert';
import 'package:envifund_moblie_application/DashBoard/dashBoard.dart';
import 'package:envifund_moblie_application/MakeNewProject/newProject.dart';
import 'package:envifund_moblie_application/Navigator/bottomNavigationBar.dart';
import 'package:envifund_moblie_application/Services/w3webServices.dart';
import 'package:envifund_moblie_application/auth/google_sign.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://mvqaptgoblyycfsjzfly.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im12cWFwdGdvYmx5eWNmc2p6Zmx5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTI0MDk3MDAsImV4cCI6MjAyNzk4NTcwMH0.8cZrvJ1QNvCrWiCd46-hlzN6vhGNUKZ1g6FLQSZqdtw'
  );
  runApp(const MyApp());
}

// Define the global linear gradient
final linearGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color.fromRGBO(6, 8, 9, 1),
    Color.fromRGBO(2, 57, 92, 1),
    Color.fromRGBO(2, 70, 104, 1),
    Color.fromRGBO(2, 85, 104, 1),
    Color.fromRGBO(2, 76, 111, 1),
    Color.fromRGBO(2, 110, 151, 1),
  ],
  stops: [0.0, 0.35, 0.70, 1.0, 1.0, 1.0],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color myHexColor = Color.fromRGBO(2, 57, 92, 1);
    MaterialColor myMaterialColor = MaterialColor(
      myHexColor.value,
      <int, Color>{
        50: myHexColor.withOpacity(1),
        100: myHexColor.withOpacity(1),
        200: myHexColor.withOpacity(1),
        300: myHexColor.withOpacity(1),
        400: myHexColor.withOpacity(1),
        500: myHexColor.withOpacity(1),
        600: myHexColor.withOpacity(1),
        700: myHexColor.withOpacity(1),
        800: myHexColor.withOpacity(1),
        900: myHexColor.withOpacity(1),
      },
    );

    return FutureBuilder(
      future: Web3Services().initializeModalAndContract(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Envifund',
            theme: ThemeData(
              primarySwatch: myMaterialColor,
              useMaterial3: true,
            ),
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Envifund',
            theme: ThemeData(
              primarySwatch: myMaterialColor,
              useMaterial3: true,
            ),
            home: Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Envifund',
            theme: ThemeData(
              primarySwatch: myMaterialColor,
              useMaterial3: true,
            ),
            home: const BottomNavigation(0),
          );
        }
      },
    );
  }
}
