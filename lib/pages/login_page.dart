import 'package:pawtrack/pages/home.dart';
import 'package:pawtrack/utils/layouts.dart';
import 'package:pawtrack/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:pawtrack/pages/get_started.dart';

class LoginPage extends StatefullWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: ListView(
        children: [
          TextField(
            decoration: InputDecoration(
              fillColor: Styles.bgWithOpacityColor,
            ),
            controller: TextEditingController(),
          )
        ],
      ),
    );
  }
}