import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mycoupon/widgets/customTextField.dart';
import 'package:http/http.dart' as http;
import 'package:mycoupon/widgets/loading.dart';

class Register extends StatefulWidget {
  final Function visible;
  Register(this.visible);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String err="";
  bool _loading = false;
  CustomTextField emailText = CustomTextField(
    title: "Email",
    placeholder: "Entrer votre email",
  );

  CustomTextField nameText = CustomTextField(
    title: "Nom d'utilisateur",
    placeholder: "Entrer votre nom",
  );
  void register(String? name, String? email, String? pass)async{
    setState(() {
      err = "";
      _loading = true;
    });
    final response = await http.post(Uri.parse("https://baseformatic.000webhostapp.com/coupon/register.php"), 
    body: {
      "name":name ?? "",
      "email":email ?? "",
      "pass":pass ?? "",
    },
    );
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      var result = data["data"];
      int succes = result[1];
      if(succes == 1){
        setState(() {
        err = result[0];
        _loading = false;
        });
      }else{
        setState(() {
          err = result[0];
          _loading = false;
        });
      }
    }
  }
  CustomTextField passText = CustomTextField(
    title: "Mot de passe",
    placeholder: "Entrer votre mot de passe",
    ispass: true,
  );
  CustomTextField confirmPassText = CustomTextField(
    title: "Confirmer le mot de passe",
    placeholder: "Confirmer le mot de passe",
    ispass: true,
  );
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    emailText.err = "Entrer le mail";
    nameText.err = "Entrer le nom";
    passText.err = "Entrer le mot de passe";
    return _loading?Loading():Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Créer votre compte",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                  SizedBox(height: 30,),
                  nameText.textFormField(),
                  SizedBox(height: 10,),
                  emailText.textFormField(),
                  SizedBox(height: 10,),
                  passText.textFormField(),
                  SizedBox(height: 10,),
                  confirmPassText.textFormField(),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {
                      if (_key.currentState?.validate() ?? false) {
                       register(nameText.value, emailText.value, passText.value);
                      }else{
                        print("Les mots de pass sont différents");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary: Colors.greenAccent.withOpacity(.7),
                    ),
                    child: Text(
                      "Enregistrer",
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
                          "Se connecter",
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
