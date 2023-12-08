import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mycoupon/widgets/customTextField.dart';
import 'package:http/http.dart' as http;
import 'package:mycoupon/widgets/loading.dart';

class Login extends StatefulWidget {
  final Function visible, login;
  Login(this.visible, this.login);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String err="";
  bool _loading = false;
  void login(String? email, String? pass) async{
    setState(() {
      err = "";
      _loading = true;
    });
    final response = await http.post(Uri.parse("https://baseformatic.000webhostapp.com/coupon/login.php"), 
    body: {
      "email": email ?? "",
      "pass": pass ?? "",
    },
    );
    if(response.statusCode ==200){
      var data = jsonDecode(response.body);
      var result = data["data"];
      int succes = result[1];
      if(succes == 1){
        setState(() {
        err = result[0];
        _loading = false;
        widget.login.call();
        });
      }else{
        setState(() {
          err = result[0];
          _loading = false;
        });
      }
    }
  }
  CustomTextField emailText = CustomTextField(
    title: "Email",
    placeholder: "Veuillez entrer votre email",
  );
  CustomTextField passText = CustomTextField(
    title: "Mot de pass",
    placeholder: "Veuillez entrer votre mot de pass",
  );
  final _key = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    emailText.err = "Entrer le mail";
    passText.err = "Veuillez entrer le mot de pass";
    return _loading?Loading():Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Se connecter",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                  SizedBox(height: 30,),
                  emailText.textFormField(),
                  SizedBox(height: 10,),
                  passText.textFormField(),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () async{
                      if (_key.currentState?.validate() ?? false) {
                        login(emailText.value, passText.value);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary: Colors.green.withOpacity(.7),
                    ),
                    child: Text(
                      "Valider",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Avez-vous un compte? "),
                      TextButton(
                        onPressed: () => widget.visible(),
                        child: Text(
                          "Créer votre compte",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Text(err, style: TextStyle(color: Colors.red), textAlign: TextAlign.center,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
