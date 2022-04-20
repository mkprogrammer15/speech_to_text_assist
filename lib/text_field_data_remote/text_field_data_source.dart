import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text_my_app/speech_api.dart';
import 'package:speech_to_text_my_app/text_field_data_remote/text_field_data_model.dart';

class TextFieldDataSource {
  final firebaseFirestore = FirebaseFirestore.instance;

  // Future<List<TextFieldDataModel>> getPost() async {
  //   final qn = await firebaseFirestore.collection('textFieldCollection').doc('SFL4TSIiarAfmCop6jlI').get();

  //   final data = qn.docs;

  //   final textFields = <TextFieldDataModel>[];
  //   for (final item in data) {
  //     final request = TextFieldDataModel.fromSnapshot(item);
  //     textFields.add(request);
  //   }
  //   print(textFields);
  //   return textFields;
  // }

  Future<List<String>> getPost(String docId) async {
    final qn = await firebaseFirestore.collection(SpeechApi.currentLocaleId == 'de_DE' ? 'textFieldCollection' : 'newTextFieldCollection').doc(docId).get();

    final docMap = qn.data();
    final textFields = <String>[];
    for (final item in docMap!.keys) {
      textFields.add(item);
    }
    print(textFields);
    return textFields;
  }
}

// 'H6aJUfNlgIsmU4IHQIZm'
// 'SFL4TSIiarAfmCop6jlI'
