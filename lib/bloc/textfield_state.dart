part of 'textfield_bloc.dart';

@immutable
abstract class TextfieldState extends Equatable {}

class TextfieldInitial extends TextfieldState {
  @override
  List<Object?> get props => [];
}

class GetTextFieldsState extends TextfieldState {
  final List<String> textFieldList;
  GetTextFieldsState(this.textFieldList);

  @override
  List<Object> get props => [textFieldList];
}
