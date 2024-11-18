import 'package:pawtrack/pages/home.dart';
import 'package:pawtrack/utils/layouts.dart';
import 'package:pawtrack/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:pawtrack/pages/get_started.dart';

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);

  final TextEditingController textemail = TextEditingController();
  final TextEditingController textusername = TextEditingController();
  final TextEditingController textpassword = TextEditingController();


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
              labelText: "Nama",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            controller: textusername,
          ),
          const SizedBox(height: 20,),
          TextField(
            decoration: InputDecoration(
              fillColor: Styles.bgWithOpacityColor,
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            controller: textemail,
          ),
          const SizedBox(height: 20,),
          TextField(
            decoration: InputDecoration(
              fillColor: Styles.bgWithOpacityColor,
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              )
            ),
            controller: textpassword,
            obscureText: true,
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}