import 'package:flutter/material.dart';

class CustomTextField {
  final String title;
  final String placeholder;
  final bool ispass;
  String err;
  String? _value; // Utilisation du type nullable String?

  CustomTextField({
    this.title = "",
    this.placeholder = "",
    this.ispass = false,
    this.err = "Veuillez spécifier ce champ!",
  });
  TextEditingController controller = new TextEditingController();

  TextFormField textFormField() {
    return TextFormField(
      controller: controller,
      onChanged: (e) {
        _value = e;
      },
      validator: (e) => e?.isEmpty ?? true ? this.err : null, // Utilisation de ?.
      obscureText: this.ispass,
      decoration: InputDecoration(
        hintText: this.placeholder,
        labelText: this.title,
        labelStyle: TextStyle(color: Colors.redAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  String? get value {
    return _value;
  }
}
