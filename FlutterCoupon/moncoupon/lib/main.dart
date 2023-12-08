import 'package:flutter/material.dart';
import 'package:moncoupon/page_coupon.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: PageCoupon(),
    );
  }
}
