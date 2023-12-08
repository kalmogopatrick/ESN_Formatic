class UserModel {
  String id;
  String nom;
  String email;

  UserModel({required this.id, required this.nom, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> i) => UserModel(
        id: i["id"],
        nom: i["nom"],
        email: i['email'],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nom": nom,
        "email": email,
      };
}
