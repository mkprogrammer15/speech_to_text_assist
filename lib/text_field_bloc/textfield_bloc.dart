import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:speech_to_text_my_app/speech_api.dart';
import 'package:speech_to_text_my_app/text_field_data_remote/text_field_data_source.dart';
import 'package:speech_to_text_my_app/voice_logic.dart';

part 'textfield_event.dart';
part 'textfield_state.dart';

class TextfieldBloc extends Bloc<TextfieldEvent, TextfieldState> {
  TextfieldBloc({required this.textFieldDataSource}) : super(TextfieldInitial());

  final TextFieldDataSource textFieldDataSource;

  @override
  Stream<TextfieldState> mapEventToState(
    TextfieldEvent event,
  ) async* {
    if (event is GetTextFieldDataEvent) {
      final textFieldList = await textFieldDataSource.getPost(SpeechApi.currentLocaleId == 'de_DE' ? 'SFL4TSIiarAfmCop6jlI' : 'EPqrXKwUmcdKJBguHEP0');
      VoiceLogic.textFieldList = textFieldList;
      VoiceLogic.getAllTextFields();
      yield GetTextFieldsState(textFieldList);
    }
    if (event is GetTextFieldDataEvent2) {
      final textFieldList = await textFieldDataSource.getPost(SpeechApi.currentLocaleId == 'de_DE' ? 'H6aJUfNlgIsmU4IHQIZm' : 'BsrW9b1oFeOqmeBUo28g');
      VoiceLogic.textFieldList = textFieldList;
      VoiceLogic.getAllTextFields();
      yield GetTextFieldsState(textFieldList);
    }
  }
}
