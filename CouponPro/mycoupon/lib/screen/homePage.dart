import 'package:flutter/material.dart';
import 'package:mycoupon/screen/authentification/login.dart';
import 'package:mycoupon/screen/authentification/register.dart';
import 'package:mycoupon/screen/home/home.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool visible = true, login=false;

  void toggle() {
    setState(() {
      visible = !visible;
    });
  }
  isloging(){
    setState(() {
      login =!login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return login?Home():visible? Login(toggle, isloging) : Register(toggle);
  }
}
