import 'package:pawtrack/firebase_options.dart';
import 'package:pawtrack/pages/get_started.dart';
import 'package:pawtrack/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Hapus tanda kurung `()`
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AdoptMe',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Styles.blackColor,
        colorScheme:
        ColorScheme.fromSwatch().copyWith(primary: Styles.blackColor),
      ),
      home: const LoginPage(),
    );
  }
}
