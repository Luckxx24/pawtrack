import 'package:firebase_core/firebase_core.dart';
import 'package:pawtrack/pages/get_started.dart';
import 'package:pawtrack/utils/styles.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AdoptMe',
      theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Styles.blackColor,
          colorScheme:
          ColorScheme.fromSwatch().copyWith(primary: Styles.blackColor)),
      home: const GetStarted(),
    );
  }
}
