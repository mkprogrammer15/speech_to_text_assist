import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text_my_app/speech_api.dart';

class TextFieldDataSource {
  final firebaseFirestore = FirebaseFirestore.instance;

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
