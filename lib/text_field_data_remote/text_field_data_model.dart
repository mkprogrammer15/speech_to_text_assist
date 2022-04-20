// import 'package:cloud_firestore/cloud_firestore.dart';

// class TextFieldDataModel {
//   final String adresse;
//   final String email;
//   final String geburtstag;
//   final String id;
//   final String name;
//   final String summePersonen;
//   final String telefon;

//   TextFieldDataModel({required this.adresse, required this.email, required this.geburtstag, required this.id, required this.name, required this.summePersonen, required this.telefon});

//   factory TextFieldDataModel.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snap) {
//     final textFieldDataModel = TextFieldDataModel(
//         name: snap.data()['name'],
//         adresse: snap.data()['adresse'],
//         email: snap.data()['email'],
//         geburtstag: snap.data()['geburtstag'],
//         id: snap.data()['id'],
//         summePersonen: snap.data()['summe personen'],
//         telefon: snap.data()['telefon']);
//     return textFieldDataModel;
//   }
// }
